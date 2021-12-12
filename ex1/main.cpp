#include <iostream>
#include <fstream>

using namespace std;

void inputMtx(int &rowA, int &colA, int &rowB, int &colB) {
  cout << "Input number row of matrix A: ";
  cin >> rowA;
  cout << "Input number colum of matrix A: ";
  cin >> colA;

  cout << "Input number row of matrix B: ";
  cin >> rowB;
  cout << "Input number colum of matrix B: ";
  cin >> colB;
}

int main(int argc, char **argv) {
  ifstream mtxA{"A.txt"};
  ifstream mtxB{"B.txt"};
  ifstream mtxRel{"result.txt"};

  int rowA, rowB;
  int colA, colB;
  inputMtx(rowA, colA, rowB, colB);
  float arrA[rowA][colA];
  float arrB[rowB][colB];
  float golden_result[rowA][colB];
  float arrRel[rowA][colB];
  int diff = 0, total = 0;

  if (!mtxA.is_open() || !mtxB.is_open()) {
    cout << "Can't open file!" << endl;
    return -1;
  }

  // Matrix A
  for (int i = 0; i < rowA; ++i) {
    for (int j = 0; j < colA; ++j) {
      mtxA >> arrA[i][j];
    }
  }

  // Matrix B
  for (int i = 0; i < rowB; ++i) {
    for (int j = 0; j < colB; ++j) {
      mtxB >> arrB[i][j];
    }
  }

  // Matrix result
  for (int i = 0; i < rowA; ++i) {
    for (int j = 0; j < colB; ++j) {
      mtxRel >> arrRel[i][j];
    }
  }

  // Golden matrix
  if (colA == rowB) {
    for (int i = 0; i < rowA; ++i) {
      for (int k = 0; k < colB; ++k) {
        golden_result[i][k] = 0;
        for (int j = 0; j < colA; ++j) {
          golden_result[i][k] += arrA[i][j] * arrB[j][k];
        }
      }
    }
  } else {
    cout << "Can't multiply!!" << endl;
  }

  // Compare different
  if (colA == rowB) {
    for (int i = 0; i < rowA; ++i) {
      for (int j = 0; j < colB; ++j) {
        if (arrRel[i][j] != golden_result[i][j]) {
          diff += 1;
        }
        total += 1;
      }
    }
    cout << endl
         << "The rate different: " << (float)((float)diff / (float)total) * 100
         << "%" << endl;
  }

  //-------print result matrix------//
  if (colA == rowB) {
    for (int i = 0; i < rowA; ++i) {
      for (int j = 0; j < colB; ++j) {
        cout << golden_result[i][j] << " ";
      }
      cout << endl;
    }
  }

  return 0;
}