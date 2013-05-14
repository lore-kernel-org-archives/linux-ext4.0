From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: v3.10: unmount won't work
Date: Tue, 14 May 2013 21:12:53 +0200
Message-ID: <51928CB5.2050406@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

At a stable 32 bit stable Gentoo with kernel v3.10-rc1-113-ga2c7a54 I c=
annot umount an (EXT4) fs
which was created in a file located in a tmpfs partition and loop mount=
ed  :

That file system was used to hold victims files shared via NFSv4 to an =
user mode linux=20
on which trinity was used to fuzz testing a patched UML guest kernel.

n22 ~ # mount
=2E..
nfsd on /proc/fs/nfsd type nfsd (rw,nodev,noexec,nosuid)
/mnt/ramdisk/disk0 on /mnt/trinity type ext4 (rw)

n22 ~ # umount /mnt/trinity
umount: /mnt/trinity: not mounted

n22 ~ # lsof | grep loop
loop0      7028             root  cwd       DIR       8,19         4096=
          2 /
loop0      7028             root  rtd       DIR       8,19         4096=
          2 /
loop0      7028             root  txt   unknown                        =
            /proc/7028/exe

n22 ~ # ps axf | grep 7028 | grep -v grep
 7028 ?        S<     0:00  \_ [loop0]

n22 ~ # kill -9 7028

n22 ~ # ps axf | grep 7028 | grep -v grep
 7028 ?        S<     0:00  \_ [loop0]

n22 ~ # umount /mnt/trinity
umount: /mnt/trinity: not mounted

n22 ~ # strace umount /mnt/trinity
execve("/bin/umount", ["umount", "/mnt/trinity"], [/* 40 vars */]) =3D =
0
brk(0)                                  =3D 0x8b1a000
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, =
0) =3D 0xb777d000
access("/etc/ld.so.preload", R_OK)      =3D -1 ENOENT (No such file or =
directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) =3D 3
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D148191, ...}) =3D 0
mmap2(NULL, 148191, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0xb7758000
close(3)                                =3D 0
open("/lib/libmount.so.1", O_RDONLY|O_CLOEXEC) =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0p~\0\0004\0\0\0=
"..., 512) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D236364, ...}) =3D 0
mmap2(NULL, 243340, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, =
0) =3D 0xb771c000
mprotect(0xb7754000, 4096, PROT_NONE)   =3D 0
mmap2(0xb7755000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP=
_DENYWRITE, 3, 0x38) =3D 0xb7755000
mmap2(0xb7757000, 1676, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP=
_ANONYMOUS, -1, 0) =3D 0xb7757000
close(3)                                =3D 0
open("/lib/libc.so.6", O_RDONLY|O_CLOEXEC) =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\240\212\231F4\=
0\0\0"..., 512) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D1715512, ...}) =3D 0
mmap2(0x4697c000, 1727228, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRI=
TE, 3, 0) =3D 0x4697c000
mprotect(0x46b1b000, 4096, PROT_NONE)   =3D 0
mmap2(0x46b1c000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MA=
P_DENYWRITE, 3, 0x19f) =3D 0x46b1c000
mmap2(0x46b1f000, 11004, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MA=
P_ANONYMOUS, -1, 0) =3D 0x46b1f000
close(3)                                =3D 0
open("/lib/libblkid.so.1", O_RDONLY|O_CLOEXEC) =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\0W\0\0004\0\0\=
0"..., 512) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D219808, ...}) =3D 0
mmap2(NULL, 226800, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, =
0) =3D 0xb76e4000
mmap2(0xb7718000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MA=
P_DENYWRITE, 3, 0x33) =3D 0xb7718000
mmap2(0xb771b000, 1520, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP=
_ANONYMOUS, -1, 0) =3D 0xb771b000
close(3)                                =3D 0
open("/lib/libuuid.so.1", O_RDONLY|O_CLOEXEC) =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\340\20\0\0004\=
0\0\0"..., 512) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D17892, ...}) =3D 0
mmap2(NULL, 20672, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0=
) =3D 0xb76de000
mmap2(0xb76e2000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP=
_DENYWRITE, 3, 0x3) =3D 0xb76e2000
close(3)                                =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, =
0) =3D 0xb76dd000
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, =
0) =3D 0xb76dc000
set_thread_area({entry_number:-1 -> 6, base_addr:0xb76dc740, limit:1048=
575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_n=
ot_present:0, useable:1}) =3D 0
mprotect(0x46b1c000, 8192, PROT_READ)   =3D 0
mprotect(0xb76e2000, 4096, PROT_READ)   =3D 0
mprotect(0xb7718000, 8192, PROT_READ)   =3D 0
mprotect(0xb7755000, 4096, PROT_READ)   =3D 0
mprotect(0x804d000, 4096, PROT_READ)    =3D 0
mprotect(0x46954000, 4096, PROT_READ)   =3D 0
munmap(0xb7758000, 148191)              =3D 0
brk(0)                                  =3D 0x8b1a000
brk(0x8b3b000)                          =3D 0x8b3b000
open("/usr/lib/locale/locale-archive", O_RDONLY|O_LARGEFILE|O_CLOEXEC) =
=3D 3
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D4072928, ...}) =3D 0
mmap2(NULL, 2097152, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0xb74dc000
mmap2(NULL, 8192, PROT_READ, MAP_PRIVATE, 3, 0x1ff) =3D 0xb777b000
close(3)                                =3D 0
getuid32()                              =3D 0
geteuid32()                             =3D 0
getuid32()                              =3D 0
geteuid32()                             =3D 0
getgid32()                              =3D 0
getegid32()                             =3D 0
prctl(PR_GET_DUMPABLE)                  =3D 1
lstat64("/etc/mtab", {st_mode=3DS_IFREG|0644, st_size=3D1604, ...}) =3D=
 0
open("/etc/mtab", O_RDWR|O_CREAT|O_LARGEFILE, 0644) =3D 3
close(3)                                =3D 0
lstat64("/etc/mtab", {st_mode=3DS_IFREG|0644, st_size=3D1604, ...}) =3D=
 0
open("/etc/mtab", O_RDONLY|O_LARGEFILE) =3D 3
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D1604, ...}) =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, =
0) =3D 0xb777a000
read(3, "rootfs / rootfs rw 0 0\n/dev/root"..., 4096) =3D 1604
read(3, "", 4096)                       =3D 0
close(3)                                =3D 0
munmap(0xb777a000, 4096)                =3D 0
stat64("/sbin/umount.ext4", 0xbf8263cc) =3D -1 ENOENT (No such file or =
directory)
stat64("/sbin/fs.d/umount.ext4", 0xbf8263cc) =3D -1 ENOENT (No such fil=
e or directory)
stat64("/sbin/fs/umount.ext4", 0xbf8263cc) =3D -1 ENOENT (No such file =
or directory)
stat64("/usr/sbin/umount.ext4", 0xbf8263cc) =3D -1 ENOENT (No such file=
 or directory)
stat64("/bin/umount.ext4", 0xbf8263cc)  =3D -1 ENOENT (No such file or =
directory)
stat64("/usr/bin/umount.ext4", 0xbf8263cc) =3D -1 ENOENT (No such file =
or directory)
oldumount("/mnt/trinity")               =3D -1 EINVAL (Invalid argument=
)
open("/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) =3D 3
fcntl64(3, F_GETFD)                     =3D 0x1 (flags FD_CLOEXEC)
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D2570, ...}) =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, =
0) =3D 0xb777a000
read(3, "# Locale name alias data base.\n#"..., 4096) =3D 2570
read(3, "", 4096)                       =3D 0
close(3)                                =3D 0
munmap(0xb777a000, 4096)                =3D 0
open("/usr/share/locale/en_US.utf8/LC_MESSAGES/util-linux.mo", O_RDONLY=
) =3D -1 ENOENT (No such file or directory)
open("/usr/share/locale/en_US/LC_MESSAGES/util-linux.mo", O_RDONLY) =3D=
 -1 ENOENT (No such file or directory)
open("/usr/share/locale/en.utf8/LC_MESSAGES/util-linux.mo", O_RDONLY) =3D=
 -1 ENOENT (No such file or directory)
open("/usr/share/locale/en/LC_MESSAGES/util-linux.mo", O_RDONLY) =3D -1=
 ENOENT (No such file or directory)
write(2, "umount: ", 8umount: )                 =3D 8
write(2, "/mnt/trinity: not mounted", 25/mnt/trinity: not mounted) =3D =
25
write(2, "\n", 1
)                       =3D 1
close(1)                                =3D 0
close(2)                                =3D 0
exit_group(32)                          =3D ?
+++ exited with 32 +++

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
