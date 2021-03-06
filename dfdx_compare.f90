program dfdx_compare
    implicit none

    integer :: case_lb=2,case_ub=2
    integer :: jj=1,nn=8
    real*8,allocatable :: fp(:,:),fpx(:,:),c_fpx(:,:)
    real*8  :: dx=1.6
    integer :: i,j
    real*8  :: x
    real :: loss, start, finish ,ft, ct

    allocate(fp(1-6:nn+6,5),fpx(nn,5),c_fpx(nn,5))

    do i=1-6,nn+6
        do j=1,5
            call random_number(x)
            fp(i,j) = x*100
        end do
    end do
    
    write(*,*)"dfdx function" 
    ! fortran test
    call cpu_time(start)
    do i=0,10000
    call dfdx_n(case_lb,case_ub,jj,nn,dx,fp,fpx)
    end do
    call cpu_time(finish)
    ft=finish-start
    write(*,*)"fortran running time(s) =",ft  

    ! c test
    call cpu_time(start)
    do i=0,10000
    call dfdx_n_c(case_lb,case_ub,jj,nn,dx,fp,c_fpx)
    end do
    call cpu_time(finish)
    ct=finish-start
    write(*,*)"c running time(s) =",ct 

    ! running time comparision 
    write(*,*)"(ctime-ftime)/ftime (%) =",(ct-ft)/ft * 100

    write(*,*)"-----------------------------------" 
    ! do i=jj,nn
    !     do j=1,5
    !         write(*,*)i,j,fpx(i,j),c_fpx(i,j)
    !     end do
    ! end do
    loss = 0.0
    do i=jj,nn
        do j=1,5
            loss = loss + abs(fpx(i,j)-c_fpx(i,j))
        end do
    end do
    write(*,*)"loss=",loss
    deallocate(fp,fpx,c_fpx)

end program dfdx_compare


