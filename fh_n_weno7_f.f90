subroutine fh_n_weno7_f(f_3,f_2,f_1,f0,f1,f2,f3,fhn)    ! negatively biased
  implicit none
  integer ::  i
  real*8  ::  f_3,f_2,f_1,f0,f1,f2,f3,fhn 
  real*8  ::  w(0:3),beta(0:3),alfa(0:3),sumalfa
  real*8  ::  fh(0:3)
  real*8  ::  d(0:3)
  real*8  ::  TV(0:3),TVR,TV_MAX,TV_MIN
  real*8,parameter :: epsilon=1e-6

  d(0)=1.0/35.0
  d(1)=12.0/35.0
  d(2)=18.0/35.0
  d(3)=4.0/35.0

  fh(0)= -1.0/4.0*f3 + 13.0/12.0*f2 - 23.0/12.0*f1 + 25.0/12.0*f0
  fh(1)= 1.0/12.0*f2 - 5.0/12.0*f1  + 13.0/12.0*f0  + 1.0/4.0*f_1
  fh(2)=-1.0/12.0*f1 + 7.0/12.0*f0   + 7.0/12.0*f_1   - 1.0/12.0*f_2
  fh(3)= 1.0/4.0*f0   + 13.0/12.0*f_1  - 5.0/12.0*f_2   + 1.0/12.0*f_3

  TV(0)=abs(f0 -f1 )+abs(f1 -f2 )+abs(f2 -f3)
  TV(1)=abs(f_1-f0 )+abs(f0 -f1 )+abs(f1 -f2)
  TV(2)=abs(f_2-f_1)+abs(f_1-f0 )+abs(f0 -f1)
  TV(3)=abs(f_3-f_2)+abs(f_2-f_1)+abs(f_1-f0)

  TV_MAX=MaxVal(TV)
  TV_MIN=MinVal(TV)
  TVR=TV_MAX/(TV_MIN+epsilon)

  if( TV_MAX<0.2d0 .and. TVR<5.0d0) then
      do i=0,3
        w(i)=d(i)
      end do
  else
  beta(0)=f3*(547.0*f3-3882.0*f2+4642.0*f1-1854.0*f0)+f2*(7043.0*f2-17246.0*f1+7042.0*f0)&
  &+f1*(11003.0*f1-9402.0*f0)+2107.0*f0**2
  beta(1)=f2*(267.0*f2-1642.0*f1+1602.0*f0 -494.0*f_1 )+f1*(2843.0*f1-5966.0*f0  +1922.0*f_1)&
  &+f0*(3443.0*f0   -2522.0*f_1)+547.0*f_1**2
  beta(2)=f1*(547.0*f1-2522.0*f0 +1922.0*f_1 -494.0*f_2 )+f0*(3443.0*f0  -5966.0*f_1  +1602.0*f_2)&
  &+f_1*(2843.0*f_1   -1642.0*f_2)+267.0*f_2**2
  beta(3)=f0*(2107.0*f0 -9402.0*f_1 +7042.0*f_2 -1854.0*f_3)+f_1*(11003.0*f_1 -17246.0*f_2 +4642.0*f_3)&
  &+f_2*(7043.0*f_2   -3882.0*f_3)+547.0*f_3**2

  do i=0,3
    alfa(i)=d(i)/(epsilon+beta(i))**2
  end do

  sumalfa=alfa(0)+alfa(1)+alfa(2)+alfa(3)

  do i=0,3
  w(i)=alfa(i)/sumalfa
  end do
  endif

  fhn=0.0d0
  do i=0,3
    fhn=fhn+w(i)*fh(i)
  end do
 
 return
end