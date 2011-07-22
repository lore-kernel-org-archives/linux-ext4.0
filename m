From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 39732] New: JBD: Spotted dirty metadata buffer (dev = dm-2,
 blocknr = 2512725). There's a risk of filesystem corruption in case of system
 crash.
Date: Fri, 22 Jul 2011 04:22:58 GMT
Message-ID: <bug-39732-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:36532 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab1GVEW7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Jul 2011 00:22:59 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p6M4Mxno015683
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jul 2011 04:22:59 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=39732

           Summary: JBD: Spotted dirty metadata buffer (dev = dm-2,
                    blocknr = 2512725). There's a risk of filesystem
                    corruption in case of system crash.
           Product: File System
           Version: 2.5
    Kernel Version: 3.0.0-rc7
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: baryluk@smp.if.uj.edu.pl
        Regression: Yes


I was just updating some packages in 32-bit Debian unstable, under highload on
my Thinkpad T43 (uniprocessor pentium-m). And spoted this thing in log:

[79324.133130] JBD: Spotted dirty metadata buffer (dev = dm-2, blocknr =
2512725). There's a risk of filesystem corruption in case of system crash.

dm-2 is block device (on LVM on luksCrypt) with /usr on ext4, with
journal=data.

I never ever seen such thing.

# cat /proc/mounts  | grep -v fuse
rootfs / rootfs rw 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
udev /dev devtmpfs rw,relatime,size=1031676k,nr_inodes=220204,mode=755 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0
0
tmpfs /run tmpfs rw,nosuid,noexec,relatime,size=207032k,mode=755 0 0
/dev/mapper/sredniczarny-root / ext4
rw,relatime,user_xattr,acl,barrier=1,nodelalloc,data=journal 0 0
tmpfs /lib/init/rw tmpfs rw,nosuid,relatime,size=5120k,mode=755 0 0
tmpfs /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
tmpfs /run/shm tmpfs rw,nosuid,nodev,relatime,size=414060k 0 0
/dev/sda1 /boot ext3
rw,relatime,errors=continue,commit=5,barrier=1,data=ordered 0 0
/dev/mapper/sredniczarny-tmp /tmp ext4
rw,relatime,user_xattr,acl,barrier=1,data=ordered 0 0
/dev/mapper/sredniczarny-usr /usr ext4
rw,relatime,user_xattr,acl,barrier=1,nodelalloc,data=journal 0 0
/dev/mapper/sredniczarny-var /var ext4
rw,relatime,user_xattr,acl,barrier=1,nodelalloc,data=journal 0 0
/dev/mapper/sredniczarny-home /home ext4
rw,relatime,user_xattr,acl,barrier=1,nodelalloc,data=journal 0 0
rpc_pipefs /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0
sctank2 /sctank2 fuse rw,relatime,user_id=0,group_id=0,allow_other 0 0
binfmt_misc /proc/sys/fs/binfmt_misc binfmt_misc
rw,nosuid,nodev,noexec,relatime 0 0
nfsd /proc/fs/nfsd nfsd rw,relatime 0 0
/home/baryluk/.Private /home/baryluk/Private ecryptfs
rw,relatime,ecryptfs_fnek_sig=caxxxxxx,ecryptfs_sig=e47xxxxx,ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_unlink_sigs
0 0
/dev/sr0 /media/cdrom0 iso9660 ro,nosuid,nodev,noexec,relatime 0 0
#


Kenrel config attached.

I found two separate bug in Red Hat bugzilla which are similar, and occurs when
usrquota is used, and some quota releated configuration is changed. I have
hovewer no quota here (it is just laptop) enabled, configured, or even
supported by my custom kernel.

Any ideas?


exact kernel version 3.0.0-rc7-t43-prod-00159-ge6625fa-dirty

(dirty only because -march=pentium-m added to the build). gcc 4.6.1-4 used.
32bit i386.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
