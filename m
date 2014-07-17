From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: After unlinking a large file on ext4, the process stalls for a
 long time
Date: Thu, 17 Jul 2014 12:40:16 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1407171238060.2312@localhost.localdomain>
References: <53C687B1.30809@free.fr> <21446.38705.190786.631403@quad.stoffel.home> <53C6B38A.3000100@free.fr> <59C3F41A-6AFD-418E-BCE6-2361B8140D9A@dilger.ca> <53C7A5CA.4050903@free.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Mason <mpeg.blue@free.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbaGQKkY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jul 2014 06:40:24 -0400
In-Reply-To: <53C7A5CA.4050903@free.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 17 Jul 2014, Mason wrote:

> Date: Thu, 17 Jul 2014 12:30:34 +0200
> From: Mason <mpeg.blue@free.fr>
> To: Andreas Dilger <adilger@dilger.ca>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
>     linux-fsdevel <linux-fsdevel@vger.kernel.org>
> Subject: Re: After unlinking a large file on ext4,
>     the process stalls for a long time
> 
> Hello,
> 
> Andreas Dilger wrote:
> 
> > Mason wrote:
> > 
> >> The use case is
> >> - allocate a large file
> >> - stick a file system on it
> >> - store stuff (typically video files) inside this "private" FS
> >> - when the user decides he doesn't need it anymore, unmount and unlink
> >> (I also have a resize operation in there, but I wanted to get the
> >> basics before taking the hard stuff head on.)
> >> 
> >> So, in the limit, we don't store anything at all: just create and
> >> immediately delete. This was my test.
> > 
> > I would agree that LVM is the real solution that you want to use.
> > It is specifically designed for this, and has much less overhead than
> > a filesystem on a loopback device on a file on another filesystem.
> > The amount of space overhead is tuneable, but typically the volumes
> > are allocated in multiples of 4MB chunks.
> 
> I'll take a look at LVM. (But, at this point, it's too late to change
> the architecture of the system.)
> 
> > That said, I think you've found some kind of strange performance problem,
> > and it is worthwhile to figure this out.
> > 
> >>>> /tmp # time ./foo /mnt/hdd/xxx 5
> >>>> posix_fallocate(fd, 0, size_in_GiB << 30): 0 [68 ms]
> >>>> unlink(filename): 0 [0 ms]
> >>>> 0.00user 1.86system 0:01.92elapsed 97%CPU (0avgtext+0avgdata 528maxresident)k
> >>>> 0inputs+0outputs (0major+168minor)pagefaults 0swaps
> >>>>
> >>>> /tmp # time ./foo /mnt/hdd/xxx 10
> >>>> posix_fallocate(fd, 0, size_in_GiB << 30): 0 [141 ms]
> >>>> unlink(filename): 0 [0 ms]
> >>>> 0.00user 3.71system 0:03.83elapsed 96%CPU (0avgtext+0avgdata 528maxresident)k
> >>>> 0inputs+0outputs (0major+168minor)pagefaults 0swaps
> >>>>
> >>>> /tmp # time ./foo /mnt/hdd/xxx 100
> >>>> posix_fallocate(fd, 0, size_in_GiB << 30): 0 [1882 ms]
> >>>> unlink(filename): 0 [0 ms]
> >>>> 0.00user 37.12system 0:38.93elapsed 95%CPU (0avgtext+0avgdata 528maxresident)k
> >>>> 0inputs+0outputs (0major+168minor)pagefaults 0swaps
> >>>>
> >>>> /tmp # time ./foo /mnt/hdd/xxx 300
> >>>> posix_fallocate(fd, 0, size_in_GiB << 30): 0 [3883 ms]
> >>>> unlink(filename): 0 [0 ms]
> >>>> 0.00user 111.38system 1:55.04elapsed 96%CPU (0avgtext+0avgdata 528maxresident)k
> >>>> 0inputs+0outputs (0major+168minor)pagefaults 0swaps
> 
> Preliminary info:
> 
> The partition was created/mounted with
> $ mkfs.ext4 -m 0 -i 1024000 -L ZOZO -O ^has_journal,^huge_file /dev/sda1
> $ mount -t ext4 /dev/sda1 /mnt/hdd -o noexec,noatime
> (mount is busybox, in case it matters)
> 
> mke2fs 1.42.10 (18-May-2014)
> /dev/sda1 contains a ext4 file system labelled 'ZOZO'
>         last mounted on /mnt/hdd on Wed Jul 16 15:40:40 2014
> Proceed anyway? (y,n) y
> Creating filesystem with 104857600 4k blocks and 460800 inodes
> Filesystem UUID: 8c12c8fe-6ab8-4888-b9a3-6f28c86020eb
> Superblock backups stored on blocks:
>         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
>         4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
>         102400000
> 
> Allocating group tables: done
> Writing inode tables: done
> Writing superblocks and filesystem accounting information: done
> 
> /dev/sda1 on /mnt/hdd type ext4 (rw,noexec,noatime,barrier=1)
> /* No support for xattr in this kernel */
> 
> # dumpe2fs -h /dev/sda1
> dumpe2fs 1.42.10 (18-May-2014)
> Filesystem volume name:   ZOZO
> Last mounted on:          <not available>
> Filesystem UUID:          8c12c8fe-6ab8-4888-b9a3-6f28c86020eb
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file uninit_bg dir_nlink extra_isize
> Filesystem flags:         signed_directory_hash
> Default mount options:    user_xattr acl
> Filesystem state:         not clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              460800
> Block count:              104857600
> Reserved block count:     0
> Free blocks:              104803944
> Free inodes:              460789
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Reserved GDT blocks:      999
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         144
> Inode blocks per group:   9
> Flex block group size:    16
> Filesystem created:       Thu Jul 17 11:14:27 2014
> Last mount time:          Thu Jul 17 11:14:29 2014
> Last write time:          Thu Jul 17 11:14:29 2014
> Mount count:              1
> Maximum mount count:      -1
> Last checked:             Thu Jul 17 11:14:27 2014
> Check interval:           0 (<none>)
> Lifetime writes:          4883 kB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group unknown)
> First inode:              11
> Inode size:               256
> Required extra isize:     28
> Desired extra isize:      28
> Default directory hash:   half_md4
> Directory Hash Seed:      157f2107-76fc-417b-9a07-491951c873b7
> 
> > Firstly, have you tried using "fallocate()" directly, instead of
> > posix_fallocate()?  It may be (depending on your userspace) that
> > posix_fallocate() is writing zeroes to the file instead of using
> > the fallocate() syscall, and the kernel is busy cleaning up all
> > of the dirty pages when the file is unlinked.  You could try using
> > strace to see what system calls are actually being used.
> 
> Unfortunately, I'm using a prehistoric version of glibc (2.8)
> that doesn't support the fallocate wrapper (imported in 2.10).
> 
> I'm 70% sure that posix_fallocate() is not actually writing zeros
> to the file, because when I tested it on ext2, creating a 300-GB
> file took hours, literally (approx. 3 hours). The same operation
> on ext4 takes a few seconds. (Although, now that I think of it,
> it could be working asynchronously, or defer some operation, that
> I eventually have to pay for on deletion.)
> 
> # time strace -tt -T ./foo /mnt/hdd/xxx 300 2> strace.out
> posix_fallocate(fd, 0, size_in_GiB << 30): 0 [414 ms]
> unlink(filename): 0 [1 ms]
> 
> 
> 12:23:27.218838 open("/mnt/hdd/xxx", O_WRONLY|O_CREAT|O_EXCL|O_LARGEFILE, 0600) = 3 <0.000486>
> 12:23:27.220121 clock_gettime(CLOCK_MONOTONIC, {79879, 926227018}) = 0 <0.000105>
> 12:23:27.221029 SYS_4320()              = 0 <0.412013>
> 12:23:27.633673 clock_gettime(CLOCK_MONOTONIC, {79880, 339646593}) = 0 <0.000104>
> 12:23:27.634657 fstat64(1, {st_mode=S_IFCHR|0755, st_rdev=makedev(4, 64), ...}) = 0 <0.000116>
> 12:23:27.636187 ioctl(1, TIOCNXCL, {B115200 opost isig icanon echo ...}) = 0 <0.000146>
> 12:23:27.637509 old_mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77248000 <0.000143>
> 12:23:27.638306 write(1, "posix_fallocate(fd, 0, size_in_G"..., 54) = 54 <0.000237>
> 12:23:27.639496 clock_gettime(CLOCK_MONOTONIC, {79880, 345448452}) = 0 <0.000102>
> 12:23:27.640168 unlink("/mnt/hdd/xxx")  = 0 <0.000231>
> 12:23:27.641174 clock_gettime(CLOCK_MONOTONIC, {79880, 347202581}) = 0 <0.000100>
> 12:23:27.641984 write(1, "unlink(filename): 0 [1 ms]\n", 27) = 27 <0.000157>
> 12:23:27.643056 exit_group(0)           = ?
> 0.02user 111.51system 1:51.99elapsed 99%CPU (0avgtext+0avgdata 864maxresident)k
> 0inputs+0outputs (0major+459minor)pagefaults 0swaps

So it really does not seem to be stalling in fallocate, nor unlink.
Can you add close() before unlink, just to be sure what's happening
there ?

Thanks!
-Lukas


> 
> 
> AFAICT, SYS_4320() is fallocate.
> 
> /*
>  * Linux o32 style syscalls are in the range from 4000 to 4999.
>  */
> #define __NR_Linux  4000
> #define __NR_fallocate  (__NR_Linux + 320)
> 
> 
> Where is the process stalling? That is a mystery. Seems it's stuck
> in exit_group(), waiting for the kernel to clean up on its behalf?
> Maybe I need ftrace, or something to profile the kernel?
> 
> > Secondly, where is the process actually stuck?  From your output
> > above, the unlink() call takes no measurable time before returning,
> > so I don't see where it is actually stuck.  Again, running your
> > test with "strace -tt -T ./foo /mnt/hdd/xxx 300" will show which
> > syscall is actually taking so much time to complete.  I don't
> > think it is unlink().
> 
> See above, the process is stalled, but I don't know where!
> 
> 
