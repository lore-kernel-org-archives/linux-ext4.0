From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196677] New: fsck.ext4: unable to set superblock flags, even
 after mounting ok
Date: Wed, 16 Aug 2017 08:14:26 +0000
Message-ID: <bug-196677-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53082 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751678AbdHPIO2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 16 Aug 2017 04:14:28 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B0D51289A1
        for <linux-ext4@vger.kernel.org>; Wed, 16 Aug 2017 08:14:27 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196677

            Bug ID: 196677
           Summary: fsck.ext4: unable to set superblock flags, even after
                    mounting ok
           Product: File System
           Version: 2.5
    Kernel Version: 4.12.4
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: a.nielsen@shikadi.net
        Regression: No

Just had a Raspberry Pi crash, and upon reboot fsck.ext4 was unable to repair
the filesystem.  Moving the SD card to a PC and running fsck there showed the
same behaviour.  I am not sure what exactly you need to know so please advise
if you need anything else.

The reason for logging this bug is that I can't work out why fsck.ext4 is
telling me "unable to set superblock" when I can successfully mount the
filesystem and write to it without problem, however I can't boot the Raspberry
Pi from it because it tries to run fsck on every boot which fails, falling back
to single user mode instead of booting properly.  I also don't understand why
the old journal apparently remains even after cleanly unmounting the
filesystem, making it look like there are still errors and causing fsck to keep
failing.

$ fsck.ext4 /dev/sdb2
e2fsck 1.43.4 (31-Jan-2017)
/dev/sdb2: recovering journal
Superblock needs_recovery flag is clear, but journal has data.
Run journal anyway<y>? yes
fsck.ext4: unable to set superblock flags on /dev/sdb2


/dev/sdb2: ********** WARNING: Filesystem still has errors **********

$ fsck.ext4 /dev/sdb2
e2fsck 1.43.4 (31-Jan-2017)
/dev/sdb2: recovering journal
Superblock needs_recovery flag is clear, but journal has data.
Run journal anyway<y>? no
Clear journal<y>? yes
fsck.ext4: unable to set superblock flags on /dev/sdb2


/dev/sdb2: ********** WARNING: Filesystem still has errors **********

$ fsck.ext4 /dev/sdb2
e2fsck 1.43.4 (31-Jan-2017)
/dev/sdb2: recovering journal
Superblock needs_recovery flag is clear, but journal has data.
Run journal anyway<y>? no
Clear journal<y>? no
fsck.ext4: unable to set superblock flags on /dev/sdb2


/dev/sdb2: ********** WARNING: Filesystem still has errors **********


$ mkfs.ext4 -n /dev/sdb2
mke2fs 1.43.4 (31-Jan-2017)
/dev/sdb2 contains a ext4 file system
        last mounted on / on Sun Aug 13 19:58:40 2017
Proceed anyway? (y,N) y
Creating filesystem with 3885568 4k blocks and 972944 inodes
Filesystem UUID: b0aabda8-ecd4-49a7-8d49-847fdf66b795
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208

$ fsck.ext4 -b 98304 /dev/sdb2
e2fsck 1.43.4 (31-Jan-2017)
Superblock needs_recovery flag is clear, but journal has data.
Recovery flag not set in backup superblock, so running journal anyway.
/dev/sdb2: recovering journal
Superblock needs_recovery flag is clear, but journal has data.
Recovery flag not set in backup superblock, so running journal anyway.
Superblock needs_recovery flag is clear, but journal has data.
Recovery flag not set in backup superblock, so running journal anyway.
fsck.ext4: unable to set superblock flags on /dev/sdb2


/dev/sdb2: ***** FILE SYSTEM WAS MODIFIED *****

/dev/sdb2: ********** WARNING: Filesystem still has errors **********

$ fsck.ext4 -b 163840 /dev/sdb2
e2fsck 1.43.4 (31-Jan-2017)
Superblock needs_recovery flag is clear, but journal has data.
Recovery flag not set in backup superblock, so running journal anyway.
/dev/sdb2: recovering journal
Superblock needs_recovery flag is clear, but journal has data.
Recovery flag not set in backup superblock, so running journal anyway.
Superblock needs_recovery flag is clear, but journal has data.
Recovery flag not set in backup superblock, so running journal anyway.
fsck.ext4: unable to set superblock flags on /dev/sdb2


/dev/sdb2: ***** FILE SYSTEM WAS MODIFIED *****

/dev/sdb2: ********** WARNING: Filesystem still has errors **********

$ mkdir temp
$ mount /dev/sdb2 temp
$ ls temp
total 80K
drwxr-xr-x 17 root root 4.0K Jul 26 11:29 .
drwxr-x--- 29 root root 4.0K Aug 16 18:05 ..
lrwxrwxrwx  1 root root    7 Apr  1 11:34 bin -> usr/bin
drwxr-xr-x  2 root root 4.0K Mar 11  2016 boot
drwxr-xr-x  2 root root 4.0K Mar  1  2016 dev
drwxr-xr-x 45 root root 4.0K Aug 16 15:44 etc
drwxr-xr-x  3 root root 4.0K Mar 11  2016 home
lrwxrwxrwx  1 root root    7 Apr  1 11:34 lib -> usr/lib
drwx------  2 root root  16K Mar 11  2016 lost+found
drwxr-xr-x  2 root root 4.0K Oct  6  2015 mnt
drwxr-xr-x  3 root root 4.0K Mar  1  2016 opt
dr-xr-xr-x  2 root root 4.0K Mar  1  2016 proc
drwxr-x---  8 root root 4.0K Aug 16 15:44 root
drwxr-xr-x  2 root root 4.0K Mar  1  2016 run
lrwxrwxrwx  1 root root    7 Apr  1 11:34 sbin -> usr/bin
drwxr-xr-x  4 root root 4.0K Oct  6  2015 srv
dr-xr-xr-x  2 root root 4.0K Mar  1  2016 sys
drwxrwxrwt  2 root root 4.0K Mar  1  2016 tmp
drwxr-xr-x  8 root root 4.0K Aug 16 15:44 usr
drwxr-xr-x 12 root root 4.0K Jul 26 11:29 var

$ umount temp
$ fsck.ext4 /dev/sdb2
e2fsck 1.43.4 (31-Jan-2017)
/dev/sdb2: recovering journal
Superblock needs_recovery flag is clear, but journal has data.
Run journal anyway<y>? no
Clear journal<y>? yes
fsck.ext4: unable to set superblock flags on /dev/sdb2


/dev/sdb2: ********** WARNING: Filesystem still has errors **********

$ dmesg | tail
[881102.628229] scsi host7: usb-storage 3-1:1.0
[881103.655218] scsi 7:0:0:0: Direct-Access     Generic  STORAGE DEVICE   0821
PQ: 0 ANSI: 6
[881103.655493] sd 7:0:0:0: Attached scsi generic sg2 type 0
[881104.004041] sd 7:0:0:0: [sdb] 31291392 512-byte logical blocks: (16.0
GB/14.9 GiB)
[881104.004576] sd 7:0:0:0: [sdb] Write Protect is off
[881104.004579] sd 7:0:0:0: [sdb] Mode Sense: 23 00 00 00
[881104.005161] sd 7:0:0:0: [sdb] Write cache: disabled, read cache: enabled,
doesn't support DPO or FUA
[881104.008549]  sdb: sdb1 sdb2
[881104.010750] sd 7:0:0:0: [sdb] Attached SCSI removable disk
[881151.920150] EXT4-fs (sdb2): recovery complete
[881151.920669] EXT4-fs (sdb2): mounted filesystem with ordered data mode.
Opts: (null)
[881178.944509] EXT4-fs (sdb2): recovery complete
[881178.944973] EXT4-fs (sdb2): mounted filesystem with ordered data mode.
Opts: (null)
[881658.714126] EXT4-fs (sdb2): recovery complete
[881658.714609] EXT4-fs (sdb2): mounted filesystem with ordered data mode.
Opts: (null)
[882732.745664] EXT4-fs (sdb2): recovery complete
[882732.746169] EXT4-fs (sdb2): mounted filesystem with ordered data mode.
Opts: (null)

$ strace fsck.ext4 -y /dev/sdb2
...
write(1, "Run ", 4Run )                     = 4
write(1, "journal", 7journal)                  = 7
write(1, " anyway", 7 anyway)                  = 7
write(1, "? yes\n\n", 7? yes

)                = 7
pwrite64(4,
"\266\3\0\0\306\3\0\0\326\3\0\0\21#\227\24$\1\4\0\0\0\0\0\0\0\0\0R\v\343\273"...,
4096, 4096) = 4096
pwrite64(4,
"\300;9\230\0\0\0\4\0\0\0\0\0\0\20\0\0\0\200\0\0\0\0\1\0\0\221o\0\0@,"...,
4096, 6580559872) = 4096
fsync(4)                                = 0
lseek(4, 1072, SEEK_SET)                = 1072
write(4, "\247\375\223Y", 4)            = 4
lseek(4, 1400, SEEK_SET)                = 1400
write(4, "E\321", 2)                    = 2
fsync(4)                                = 0
close(4)                                = 0
open("/dev/sdb2", O_RDWR|O_EXCL)        = 4
getuid()                                = 0
geteuid()                               = 0
getgid()                                = 0
getegid()                               = 0
prctl(PR_GET_DUMPABLE)                  = 1 (SUID_DUMP_USER)
fstat(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 18), ...}) = 0
ioctl(4, BLKDISCARDZEROES, [0])         = 0
ioctl(4, BLKROGET, [0])                 = 0
uname({sysname="Linux", nodename="korath.teln.shikadi.net", ...}) = 0
pread64(4,
"\220\330\16\0\0J;\0\346\366\2\0\233\217,\0\312\311\r\0\0\0\0\0\2\0\0\0\2\0\0\0"...,
1024, 1024) = 1024
pread64(4,
"\266\3\0\0\306\3\0\0\326\3\0\0\21#\227\24$\1\4\0\0\0\0\0\0\0\0\0R\v\343\273"...,
4096, 4096) = 4096
pread64(4,
"\0\0\0\0\0\0\0\0\330\241\342V\330\241\342V\330\241\342V\0\0\0\0\0\0\0\0\0\0\0\0"...,
4096, 4022272) = 4096
pread64(4,
"\300;9\230\0\0\0\4\0\0\0\0\0\0\20\0\0\0\200\0\0\0\0\1\0\0\221o\0\0@,"...,
4096, 6580559872) = 4096
write(2, "fsck.ext4", 9fsck.ext4)                = 9
write(2, ": ", 2: )                       = 2
write(2, "unable to set superblock flags o"..., 44unable to set superblock
flags on /dev/sdb2
) = 44
...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
