program aoc
    use, intrinsic :: iso_fortran_env
    implicit none
    integer, parameter :: SIZE = 130

    character(len=SIZE), dimension(SIZE) :: input
    integer, dimension(4) :: start
    integer :: out

    input = get_input()

    start = find_start(input)
    out = part1(input, start(1), start(2), start(3), start(4))
    print *, "Part 1: ", out
    out = part2(input, start(1), start(2), start(3), start(4))
    print *, "Part 2: ", out
contains
    function get_input() result (output)
        implicit none
        character(len=SIZE), dimension(SIZE) :: output

        integer :: i
        do i = 1, SIZE
            read(*, '(A)') output(i)
        end do
    end function get_input

    function find_start(input) result (output)
        implicit none
        character(len=SIZE), dimension(SIZE), intent(in) :: input(:)
        integer, dimension(4) :: output(4)

        integer :: i, j, diri, dirj
        character :: c
        diri = 0
        dirj = 0
        outer: do i = 1, SIZE
            do j = 1, SIZE
                select case (input(i)(j:j))
                case ('^')
                    c = '^'
                    diri = -1
                    exit outer
                case ('v')
                    c = 'v'
                    diri = 1
                    exit outer
                case ('<')
                    c = '<'
                    dirj = -1
                    exit outer
                case ('>')
                    c = '>'
                    dirj = 1
                    exit outer
                end select
            end do
        end do outer

        output = [i, j, diri, dirj]
    end function find_start

    function part1(input, i, j, diri, dirj) result (output)
        implicit none
        character(len=SIZE), dimension(SIZE), intent(in) :: input(:)
        integer, value :: i, j, diri, dirj
        integer :: output, old, tmp, count

        character(len=SIZE), dimension(SIZE) :: map
        map = input

        output = 0
        count = 0
        do while (i >= 1 .and. i <= SIZE .and. j >= 1 .and. j <= SIZE)
            old = output
            if (map(i)(j:j) /= 'X') then
                output = output + 1
            end if
            map(i)(j:j) = 'X'

            ! Why no short-circuiting :(
            do while (i + diri >= 1 .and. i + diri <= SIZE .and. j + dirj >= 1 .and. j + dirj <= SIZE)
                if (map(i+diri)(j+dirj:j+dirj) == '#') then
                    tmp = diri
                    diri = dirj
                    dirj = -tmp
                else
                    exit
                end if
            end do

            i = i + diri
            j = j + dirj

            if (old == output) then
                count = count + 1
            else
                count = 0
            end if

            if (count > SIZE*SIZE) then
                output = -1
                exit
            end if
        end do
    end function part1

    function part2(input, i, j, diri, dirj) result (output)
        implicit none
        character(len=SIZE), dimension(SIZE), intent(in) :: input(:)
        integer, intent(in) :: i, j, diri, dirj
        integer :: output, x, y

        character(len=SIZE), dimension(SIZE) :: map

        output = 0
        do x = 1, SIZE
            inner: do y = 1, SIZE
                if (input(x)(y:y) /= '.') then
                    cycle inner
                end if
                
                map = input
                map(x)(y:y) = '#'

                if (part1(map, i, j, diri, dirj) == -1) then
                    output = output + 1
                end if
            end do inner
        end do
    end function part2
end program aoc
