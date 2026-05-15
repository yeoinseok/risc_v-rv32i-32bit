# RV32I Single-Cycle CPU Design

> RISC-V RV32I ISA 기반 32비트 싱글사이클 CPU 코어 직접 설계 및 검증

## 📌 프로젝트 개요

오픈 소스 ISA인 RISC-V(RV32I) 규격을 바탕으로 하드웨어와 소프트웨어의 가교 역할을 하는 싱글사이클 CPU를 직접 설계하고 구현한 프로젝트입니다. CPU의 핵심 구성 요소인 ALU, 레지스터 파일, 제어 유닛(Control Unit) 및 데이터패스를 설계하여 R, I, S, B, U, J 등 다양한 명령어 타입을 처리할 수 있는 구조를 완성했습니다. 시뮬레이션을 통해 각 명령어 타입별 데이터 흐름을 정밀하게 분석하고, 산술 연산부터 메모리 접근 및 분기 제어까지 하드웨어 로직이 설계 의도대로 정확히 동작함을 검증했습니다.

**개발 기간:** 2026.03.09 ~ 2026.03.18 (10일)  
**팀 구성:** 1인 개인 프로젝트  
**담당 업무:** CPU Core Design, Type별 Simulation 및 검증

## 🎯 주요 기능

### 싱글사이클 CPU 아키텍처
- **단일 클럭 실행**: 모든 명령어가 1 클럭 사이클에 완료
- **데이터패스 설계**: ALU, Register File, PC, Memory 유기적 연결
- **제어 유닛**: Opcode 및 Funct 필드 기반 제어 신호 생성

### RV32I 명령어 셋 지원
- **R-Type**: 레지스터 간 산술/논리 연산
- **I-Type**: 즉치값 연산 및 Load 명령어
- **S-Type**: Store 명령어
- **B-Type**: 조건부 분기
- **U-Type**: 상위 즉치값 처리
- **J-Type**: 무조건 분기

### Sign Extension 유닛
- **부호 확장 처리**: 음수 오프셋 정확한 처리
- **타입별 비트 재배치**: 명령어 규격에 맞는 즉치값 추출
- **32비트 확장**: MSB 유지를 통한 부호 보존

## 🛠 기술 스택

- **HDL**: SystemVerilog (100%)
- **FPGA 툴**: Xilinx Vivado
- **ISA**: RISC-V RV32I Base Integer Instruction Set
- **데이터 폭**: 32-bit

## 📁 프로젝트 구조

```
risc_v-rv32i-32bit/
├── sim_1/                          # 시뮬레이션 테스트벤치
│   └── (testbench files)
└── sources_1/
    └── imports/
        └── pr0313/                 # CPU RTL 소스
            ├── (datapath modules)
            ├── (control unit)
            ├── (ALU & register file)
            └── (memory modules)
```

## 🏗 시스템 아키텍처

### 싱글사이클 CPU 데이터패스

<img width="1055" height="859" alt="image" src="https://github.com/user-attachments/assets/a2f0f14c-de55-4a37-b5df-9da576debe8a" />


**주요 구성 요소:**
- **PC (Program Counter)**: 현재 실행 중인 명령어 주소
- **Instruction Memory**: 명령어 저장소
- **Register File**: 32개 32-bit 범용 레지스터
- **ALU**: 산술/논리 연산 유닛
- **Control Unit**: Opcode/Funct 기반 제어 신호 생성
- **Data Memory**: Load/Store용 데이터 저장소
- **Sign Extend**: 즉치값 부호 확장 유닛

### 명령어 실행 흐름

**모든 명령어가 1 사이클에 완료:**
```
Fetch → Decode → Execute → Memory → WriteBack
   │       │        │         │          │
   └───────┴────────┴─────────┴──────────┘
              한 사이클 (1 Clock)
```

## 📊 RV32I 명령어 타입별 구현

### R-Type (Register-Register 연산)
```
[funct7][rs2][rs1][funct3][rd][opcode]
```
- **구현 명령어**: ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU
- **동작**: rd ← rs1 OP rs2

### I-Type (Immediate 연산 및 Load)
```
[imm[11:0]][rs1][funct3][rd][opcode]
```
- **구현 명령어**: ADDI, ANDI, ORI, XORI, SLLI, SRLI, SRAI, LW, LH, LB, JALR
- **동작**: rd ← rs1 OP imm (Sign Extended)

### S-Type (Store)
```
[imm[11:5]][rs2][rs1][funct3][imm[4:0]][opcode]
```
- **구현 명령어**: SW, SH, SB
- **동작**: Memory[rs1 + imm] ← rs2

### B-Type (Branch)
```
[imm[12|10:5]][rs2][rs1][funct3][imm[4:1|11]][opcode]
```
- **구현 명령어**: BEQ, BNE, BLT, BGE, BLTU, BGEU
- **동작**: if (rs1 OP rs2) PC ← PC + imm

### U-Type (Upper Immediate)
```
[imm[31:12]][rd][opcode]
```
- **구현 명령어**: LUI, AUIPC
- **동작**: rd ← imm << 12

### J-Type (Jump)
```
[imm[20|10:1|11|19:12]][rd][opcode]
```
- **구현 명령어**: JAL
- **동작**: rd ← PC + 4; PC ← PC + imm

## 🚀 빌드 및 실행

### 1. Vivado 프로젝트 생성

```tcl
# Vivado GUI에서
File → Open Project
sources_1/imports/pr0313 폴더 추가
Run Synthesis
Run Simulation
```

### 2. 시뮬레이션 실행

```
sim_1 폴더의 테스트벤치 선택
Run Simulation → Run Behavioral Simulation
Waveform 확인
```

## 📊 검증 결과

### R-Type 명령어 검증
```assembly
# ADD x3, x1, x2  (x3 = x1 + x2)
add x3, x1, x2

# SUB x4, x1, x2  (x4 = x1 - x2)
sub x4, x1, x2

# SLT x5, x1, x2  (x5 = (x1 < x2) ? 1 : 0)
slt x5, x1, x2
```

**결과:** ✅ 모든 R-Type 연산 정상 동작

### I-Type 명령어 검증
```assembly
# ADDI x1, x0, 100   (x1 = 0 + 100)
addi x1, x0, 100

# LW x2, 0(x1)       (x2 = Memory[x1 + 0])
lw x2, 0(x1)

# JALR x3, x1, 4     (x3 = PC+4; PC = x1 + 4)
jalr x3, x1, 4
```

**결과:** ✅ 즉치값 연산 및 Load 정상 동작

### Branch 명령어 검증
```assembly
# BEQ x1, x2, label  (if x1 == x2, branch)
beq x1, x2, target

# BNE x1, x2, label  (if x1 != x2, branch)
bne x1, x2, target
```

**결과:** ✅ 분기 조건 및 PC 업데이트 정확

### U-Type 검증
```assembly
# LUI x1, 0x12345    (x1 = 0x12345000)
lui x1, 0x12345

# AUIPC x2, 0x10     (x2 = PC + 0x10000)
auipc x2, 0x10
```

**결과:** ✅ 상위 비트 즉치값 정상 처리

## 🔧 Troubleshooting

### 1. Sign Extension 오류

**문제 현상:**  
B-type이나 I-type 명령어 처리 시, 명령어 내에 분산된 즉치값 비트들을 재구성하는 과정에서 부호 확장(Sign Extension)이 정확히 이루어지지 않아 음수 오프셋을 가진 분기나 메모리 접근 시 엉뚱한 주소로 접근하는 오류가 발생했습니다.

**원인 분석:**
- RISC-V 명령어는 즉치값 비트가 명령어 내에 분산되어 있음
- B-type: imm[12|10:5|4:1|11] 형태로 비트 재배치 필요
- 단순히 0으로 패딩하면 음수가 양수로 잘못 해석됨

**해결 방안:**
명령어 규격에 맞게 비트들을 재배치하고, 최상위 비트(MSB)를 유지한 채 32비트로 확장하는 전용 'Extend' 유닛을 설계했습니다.

```systemverilog
// Sign Extension 유닛 예시
module sign_extend (
    input  logic [31:0] instruction,
    input  logic [2:0]  imm_type,    // I, S, B, U, J 타입 선택
    output logic [31:0] imm_extended
);
    always_comb begin
        case (imm_type)
            3'b000:  // I-type
                imm_extended = {{20{instruction[31]}}, instruction[31:20]};
            3'b001:  // S-type
                imm_extended = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            3'b010:  // B-type
                imm_extended = {{19{instruction[31]}}, instruction[31], instruction[7], 
                               instruction[30:25], instruction[11:8], 1'b0};
            3'b011:  // U-type
                imm_extended = {instruction[31:12], 12'b0};
            3'b100:  // J-type
                imm_extended = {{11{instruction[31]}}, instruction[31], instruction[19:12],
                               instruction[20], instruction[30:21], 1'b0};
            default: imm_extended = 32'b0;
        endcase
    end
endmodule
```

**결과:**
- ✅ 음수 오프셋을 가진 Branch 정상 동작
- ✅ Load/Store 명령어의 음수 offset 정확한 처리
- ✅ JAL의 음수 점프 거리 정상 동작

### 2. LUI + ADDI 조합 시 Carry 처리

**문제:**  
32비트 주소 생성 시 LUI(상위 20비트)와 ADDI(하위 12비트)를 조합하는 과정에서 ADDI의 부호 확장으로 인해 Carry가 발생하면 LUI 값이 변경되어 잘못된 주소가 생성되는 문제가 있었습니다.

**해결:**
ADDI의 즉치값이 음수일 때 LUI 결과에 +1을 더해 보상하는 어셈블러 관례를 하드웨어 레벨에서 정확히 구현했습니다.

### 3. Load 명령어 MSB Padding

**문제:**  
LB(Load Byte), LH(Load Halfword) 명령어에서 부호 있는/없는 로드 구분이 정확하지 않아 데이터 무결성 문제 발생

**해결:**
```systemverilog
// Load 데이터 부호 확장
case (funct3)
    3'b000: rd_data = {{24{mem_data[7]}}, mem_data[7:0]};      // LB (signed)
    3'b001: rd_data = {{16{mem_data[15]}}, mem_data[15:0]};    // LH (signed)
    3'b010: rd_data = mem_data;                                 // LW
    3'b100: rd_data = {24'b0, mem_data[7:0]};                  // LBU (unsigned)
    3'b101: rd_data = {16'b0, mem_data[15:0]};                 // LHU (unsigned)
endcase
```

## 📚 배운 점

### 1. ISA와 마이크로아키텍처의 관계
RISC-V RV32I 명령어 셋의 구조와 각 명령어 타입(R, I, S, B, U, J)별 인코딩 방식을 학습하고, 이를 하드웨어로 구현하기 위한 요구사항을 분석하면서 **ISA가 하드웨어 설계에 미치는 영향**을 깊이 이해하게 되었습니다.

### 2. 데이터패스와 제어 유닛의 협조
ALU, Register File, Program Counter, Instruction/Data Memory를 유기적으로 연결하는 데이터패스를 설계하고, Opcode 및 Funct 필드에 따라 정확한 제어 신호를 생성하는 로직을 구축하면서, **데이터 흐름과 제어 흐름의 분리**가 왜 중요한지 체득했습니다.

### 3. 싱글사이클 구조의 트레이드오프
싱글 사이클 구조의 특성상 가장 긴 경로(Critical Path)에 의해 전체 시스템의 클럭 속도가 제한되는 **성능적 한계**를 경험했습니다. 이를 통해 단순한 기능 구현을 넘어 **하드웨어 자원의 제약과 명령어 사이클 간의 상관관계**를 깊이 이해하게 되었고, 다음 프로젝트에서 멀티사이클로 발전시키는 동기가 되었습니다.

### 4. 검증의 중요성
부호 확장 오류는 단순 기능 테스트로는 발견하기 어려웠지만, 음수 오프셋을 사용하는 시나리오에서 명확히 드러났습니다. **다양한 코너 케이스를 고려한 검증**이 얼마나 중요한지 배웠습니다.

## 🎓 향후 개선 방향

- [ ] **멀티사이클 구조**: 자원 공유를 통한 면적 절감 (→ [멀티사이클 프로젝트](https://github.com/yeoinseok/RV32I-Multicycle-APB-BUS-Design)로 발전)
- [ ] **파이프라인 구조**: 5단 파이프라인으로 처리량 향상
- [ ] **Hazard 처리**: Data/Control Hazard 해결 로직 추가
- [ ] **분기 예측**: Branch Prediction 추가로 분기 페널티 감소
- [ ] **RV32M 확장**: 곱셈/나눗셈 명령어 추가

## 🔗 관련 레포지토리

- **멀티사이클 + APB 버스**: [RV32I-Multicycle-APB-BUS-Design](https://github.com/yeoinseok/RV32I-Multicycle-APB-BUS-Design)

## 📄 참고 자료

- [RISC-V ISA Specification](https://riscv.org/technical/specifications/)
- [The RISC-V Instruction Set Manual Volume I](https://github.com/riscv/riscv-isa-manual)
- [Computer Organization and Design RISC-V Edition](https://www.elsevier.com/books/computer-organization-and-design-risc-v-edition/patterson/978-0-12-820331-6) (Patterson & Hennessy)

## 📄 라이선스

이 프로젝트는 개인 학습 목적으로 작성되었습니다.

---

**Contact**: [GitHub](https://github.com/yeoinseok)
