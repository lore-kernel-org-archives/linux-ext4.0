From: Andreas Dilger <adilger@sun.com>
Subject: Re: strange ext{3,4}_settattr logic
Date: Sun, 16 Mar 2008 07:54:27 +0800
Message-ID: <20080315235427.GA26939@webber.adilger.int>
References: <20080315160731.GA4186@dmon-lap.sw.ru>
 <20080315230544.GV3542@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Dmitri Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:36245 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbYCOXzF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Mar 2008 19:55:05 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2FNt3Ux009526
	for <linux-ext4@vger.kernel.org>; Sat, 15 Mar 2008 16:55:04 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JXS00B01Q6JEV00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 15 Mar 2008 16:55:03 -0700 (PDT)
In-reply-to: <20080315230544.GV3542@webber.adilger.int>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 16, 2008  07:05 +0800, Andreas Dilger wrote:
> On Mar 15, 2008  19:07 +0300, Dmitri Monakhov wrote:
> > I've found what ext3_setattr() code has some strange logic. I'm talking
> > about truncate path. 
> > 
> > int ext3_setattr(struct dentry *dentry, struct iattr *attr)
> > {
> > ...
> > 	if (S_ISREG(inode->i_mode) &&
> >             attr->ia_valid & ATTR_SIZE && attr->ia_size < inode->i_size) {
> >                 handle_t *handle;
> > <<< This is shrinking case, and according to function comments:
> > <<< "In particular, we want to make sure that when the VFS
> > <<< * shrinks i_size, we put the inode on the orphan list and modify
> > <<< * i_disksize immediately"
> > <<< we about to write i_disksize. But WHY do we have to do it explicitly?
> > <<< Later inode_setattr() will call ext3_truncate() which will do it
> > <<< this work for us.
> 
> The reason that i_disksize is written to disk here immediately is that the
> journal is stopped.  Once that is done then in case of a crash the orphan
> recovery code will detect the unfinished truncate and complete it before
> mounting the filesystem.
> 
> >         rc = inode_setattr(inode, attr);
> > <<< Now the most interesting question. What we have to do now in 
> > <<< case of error? We are in tricky situation. Truncate not happened,
> > <<< and blocks visible to the user, but i_disksize was already written,
> > <<< so later memory reclaiming/ read_inode will result in unexpected
> > <<< updating i_size.
> 
> The only ways inode_setattr() can fail are:
> - expanding vmtruncate hits EFBIG, but we checked that above
> - shrinking vmtruncate on a swapfile returns ETXTBUSY.  This was added
>   after the ext3_setattr() code was written.

I forgot to add that we need to handle the IS_SWAPFILE() case properly.
Granted, it probably isn't a very common problem, but the IS_SWAPFILE()
check was added explicitly because of clueless users.  Also, very few
users run with a swapfile in any case, most use a swap partition.

It would seem that if you have a swapfile, try to truncate it to 0 (which
will fail with -ETXTBUSY) and then unmount the filesystem the size will
be truncated to 0:

[root@lin-cli1 tests]# dd if=/dev/zero of=/tmp/foo bs=4k count=100
100+0 records in
100+0 records out
[root@lin-cli1 tests]# mkswap /tmp/foo
Setting up swapspace version 1, size = 405 kB
[root@lin-cli1 tests]# swapon /tmp/foo
[root@lin-cli1 tests]# swapon -s
Filename                                Type            Size    Used
Priority
/dev/hda5                               partition       1052216 136     -1
/tmp/foo                                file            392     0       -2
[root@lin-cli1 tests]# dd if=/dev/zero of=/tmp/foo bs=4k count=1 seek=99
dd: advancing past 405504 bytes in output file `/tmp/foo': Text file busy
[root@lin-cli1 tests]# > /tmp/foo
bash: /tmp/foo: Text file busy
[root@lin-cli1 tests]# ls -l /tmp/foo
404 -rw-r--r--  1 root root 409600 Mar 15 17:12 /tmp/foo
[root@lin-cli1 tests]# swapoff /tmp/foo
[root@lin-cli1 tests]# df /tmp
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/hda1             20641788   8997964  10595184  46% /
[root@lin-cli1 tests]# debugfs /dev/hda1
debugfs 1.40.2.cfs4 (12-Jul-2007)
debugfs:  stat /tmp/foo
Inode: 1346639   Type: regular    Mode:  0644   Flags: 0x0   Generation:
2276953
732
User:     0   Group:     0   Size: 0 <<< *** oops ***
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 808
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x47dc57fb -- Sat Mar 15 17:12:59 2008
atime: 0x47dc57fb -- Sat Mar 15 17:12:59 2008
mtime: 0x47dc57fb -- Sat Mar 15 17:12:59 2008
BLOCKS:
(0):2689410, (1-11):2689460-2689470, (IND):2689471, (12-54):2689472-2689514,
(55 -59):2689516-2689520, (60-63):2689532-2689535, (64-87):2689544-2689567,
(88-96): 2689592-2689600, (97-99):2689619-2689621
TOTAL: 101
debugfs: quit
[root@lin-cli1 tests]# e2fsck -fn /dev/hda1
e2fsck 1.40.2.cfs4 (12-Jul-2007)
Warning!  /dev/hda1 is mounted.
Warning: skipping journal recovery because doing a read-only filesystem check.
Pass 1: Checking inodes, blocks, and sizes
Inode 1346639, i_size is 0, should be 409600.  Fix? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/: ********** WARNING: Filesystem still has errors **********

/: 337862/2626560 files (6.9% non-contiguous), 2354290/5242880 blocks


Until e2fsck was actually run on the filesystem (which would do the right
thing and fix the file size) the swap file would have 0 length and fail
to start.  It probably isn't fatal for most systems to run without swap
these days, but let's see if this would cause a boot-time failure or if it
is silently ignored (on a RHEL4 system):

[root@lin-cli1 tests]# > /tmp/foo
[root@lin-cli1 tests]# debugfs /dev/hda1
debugfs 1.40.2.cfs4 (12-Jul-2007)
debugfs:  stat /tmp/foo
Inode: 1346639   Type: regular    Mode:  0644   Flags: 0x0   Generation:
2276953
732
User:     0   Group:     0   Size: 0
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x47dc5a45 -- Sat Mar 15 17:22:45 2008
atime: 0x47dc57fb -- Sat Mar 15 17:12:59 2008
mtime: 0x47dc5a45 -- Sat Mar 15 17:22:45 2008
BLOCKS:

debugfs:  quit
[root@lin-cli1 tests]# swapon /tmp/foo
swapon: /tmp/foo: Invalid argument
[root@lin-cli1 tests]# echo $?
255
[root@lin-cli1 tests]# grep -C 3 swapon /etc/rc.sysinit

# Start up swapping.
update_boot_stage RCswap
action $"Enabling swap space: " swapon -a -e

# Set up binfmt_misc
/bin/mount -t binfmt_misc none /proc/sys/fs/binfmt_misc > /dev/null 2>&1


So it appears the error would be ignored, and eventually (because e2fsck
will run periodically on filesystems, unless the user turns this off) it
would be repaired properly.  Still, it should be fixed.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

