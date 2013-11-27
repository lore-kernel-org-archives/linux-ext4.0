From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: CONFIG_EXT4_USE_FOR_EXT23 no space left on device
Date: Wed, 27 Nov 2013 16:50:14 +0100
Message-ID: <CAMuHMdWgMrNQqq84AK+CGF6VFnLs38O-vyye4MFKNUO7b8iFMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

To reduce kernel size, I disabled both CONFIG_EXT2_FS and
CONFIG_EXT3_FS, and enabled CONFIG_EXT4_USE_FOR_EXT23.

Unfortunately the system behaves badly afterwards. It seems the file system
is considered full: new files can be created, but no data can be written.
Note that the file system is almost full, but root can still write more data
using the real ext3 filesystem driver.

This is a v3.13-rc1-ish kernel.

Diff of dmesg and output of a few operations below:

--- /tmp/good 2013-11-27 16:47:28.000000000 +0100
+++ /tmp/bad 2013-11-27 16:47:31.000000000 +0100
@@ -1,11 +1,13 @@
-kjournald starting.  Commit interval 5 seconds
-EXT3-fs (hda1): mounted filesystem with writeback data mode
+
+EXT4-fs (hda1): mounting ext3 file system using the ext4 subsystem
+EXT4-fs (hda1): mounted filesystem with ordered data mode. Opts: (null)
 VFS: Mounted root (ext3 filesystem) readonly on device 3:1.
-Freeing unused kernel memory: 152K (0039d000 - 003c3000)
+Freeing unused kernel memory: 152K (0037f000 - 003a5000)
 random: nonblocking pool is initialized
 Adding 137800k swap on /dev/hda2.  Priority:-1 extents:1 across:137800k
-EXT3-fs (hda1): using internal journal
-Unknown key: scancode = 0 ($00), keycode = 'numlock' ($12c)
+EXT4-fs (hda1): re-mounted. Opts:
+EXT4-fs (hda1): re-mounted. Opts: errors=remount-ro
+EXT4-fs (hda1): re-mounted. Opts:
 write cmd 0xE0 (STANDBY IMMEDIATE) not supported
 hda: task_no_data_intr: status=0x41 { DriveReady Error }
 hda: task_no_data_intr: error=0x04 { DriveStatusError }
@@ -22,16 +24,9 @@ hda: possibly failed opcode: 0xe0
 reboot: Power down

 atari:~# mount
-/dev/hda1 on / type ext3 (rw,errors=remount-ro)
-tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
-proc on /proc type proc (rw,noexec,nosuid,nodev)
-sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
-tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
-devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
-rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
-atari:~# cat /proc/mounts
+atari:~# cat /proc/mounts
 rootfs / rootfs rw 0 0
-/dev/root / ext3 rw,relatime,errors=remount-ro,barrier=1,data=writeback 0 0
+/dev/root / ext3 rw,relatime,errors=remount-ro,data=ordered 0 0
 tmpfs /lib/init/rw tmpfs rw,nosuid,relatime,mode=755 0 0
 proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
 sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
@@ -40,13 +35,9 @@ devpts /dev/pts devpts rw,nosuid,noexec,
 rpc_pipefs /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
 atari:~# touch /tmp/x
 atari:~# echo hello > /tmp/x
-atari:~# cat /tmp/x
-hello
+-bash: echo: write error: No space left on device
 atari:~# df -h
-Filesystem            Size  Used Avail Use% Mounted on
-/dev/hda1             870M  862M     0 100% /
-tmpfs                 132M     0  132M   0% /lib/init/rw
-tmpfs                 132M  4.0K  132M   1% /dev/shm
+df: cannot read table of mounted file systems
 atari:~# ls -l /etc/mtab
--rw-r--r-- 1 root root 331 Nov 27 16:35 /etc/mtab
+-rw-r--r-- 1 root root 0 Oct 27 15:32 /etc/mtab
 atari:~# poweroff

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
