# 🔐 Double Encryption on FPGA with S-DES and LFSR Hashing

This project implements a **double encryption system** using:
- 🔒 **Simplified Data Encryption Standard (S-DES)** for lightweight encryption
- 🌀 **32-bit Linear Feedback Shift Register (LFSR)** for hashing
- 🧱 Built using **Verilog** and simulated using **ModelSim**
- 💡 Targeted for deployment on **Altera Cyclone IV FPGA**

---

## ⚙️ How It Works

1. **S-DES Module (`sdes.v`)**  
   Encrypts an 8-bit input using a 10-bit key. This simplified DES version includes permutation, key scheduling, Feistel structure, and substitution logic.

2. **LFSR Module (`lfsr.v`)**  
   Takes the encrypted output and runs it through a 32-bit LFSR based on the polynomial `x^32 + x^22 + x^2 + x + 1`, producing a pseudo-random 32-bit hash.

3. **Top Module (`top_module.v`)**  
   Connects S-DES and LFSR in sequence. Takes plaintext and key as input and outputs the hashed result.

4. **Testbench (`testbench.v`)**  
   Provides clock, reset, inputs, and monitors output. Used for simulation in ModelSim.

---

## 🧪 How to Run (ModelSim)

1. **Manual run**
    ```tcl
    vlog sdes.v lfsr.v top_module.v testbench.v
    vsim work.testbench
    add wave -recursive *
    run 300ns
    ```

2. **Using `.do` script**
    ```tcl
    do compile_and_run.do
    ```

---

## 🔍 Example I/O

| Signal       | Description               | Example       |
|--------------|---------------------------|---------------|
| `data_in`    | Plaintext input (8-bit)   | `11100011`    |
| `key`        | Encryption key (10-bit)   | `1110000011`  |
| `enc_data`   | Output of S-DES           | `00011100`    |
| `final_hash` | Output of LFSR (32-bit)   | Changes every clock tick |

---

## 🎯 Objectives

- ✅ Implement and simulate S-DES encryption using Verilog
- ✅ Add post-encryption hashing with 32-bit LFSR
- ✅ Simulate and validate the design using ModelSim
- ✅ Prepare for FPGA implementation on Altera Cyclone IV

---

## 📚 References

- Mohammed, S. Qadir. *Implementation of Simplified Data Encryption Standard on FPGA using VHDL*  
- Hathwalia, Shruti, and Meenakshi Yadav. *Design and Analysis of a 32 Bit Linear Feedback Shift Register Using VHDL*  
- Krawczyk, Hugo. *LFSR-based Hashing and Authentication*

---

## 👥 Contributors

- Muhammad Ahsan Zaki Wiryawan  
- Bayu Putra Ibana  
- **Yusuf Imantaka Bastari**  
- Excel Fathan Breviano Taim  
- Arya Jason Ramadhanto  
- Muhammad Javier  
- Muhamad Harfi Ibadurahman

---

## 🚀 Project Status

- ✅ Simulation successful (ModelSim)
- 🔧 FPGA implementation in progress
- 🧠 Open to improvement and future optimization
