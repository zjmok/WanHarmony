export class ApiException extends Error {
  errorCode: number

  constructor(errorCode: number, errorMsg: string) {
    super(errorMsg);
    this.errorCode = errorCode
  }
}
