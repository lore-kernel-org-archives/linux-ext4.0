From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/6 v5] ext4: fix fsx truncate failure
Date: Mon, 22 Aug 2011 22:36:18 -0400
Message-ID: <20110823023618.GA6544@thunk.org>
References: <1313893787-25460-1-git-send-email-achender@linux.vnet.ibm.com>
 <1313893787-25460-6-git-send-email-achender@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54625 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab1HWCgY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Aug 2011 22:36:24 -0400
Content-Disposition: inline
In-Reply-To: <1313893787-25460-6-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 20, 2011 at 07:29:46PM -0700, Allison Henderson wrote:
> This patch corrects a bug found during extended fsx
> testing for the first two patches.
> 
> This bug is caused because the truncate routine only zeros
> the unblock aligned portion of the last page.  This means
> that the block aligned portions of the page appearing after
> i_size are left unzeroed, and the buffer heads still mapped.
> 
> This bug is corrected by using ext4_discard_partial_page_buffers
> in the truncate routine to zero the partial page and unmap
> the buffer headers
> 
> Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>

This patch is causing a failure in xfstests #130.  When I bisected it,
the "git bisect finger of blame" pointed to this commit.  (This is
commit 83eb170d4 on the "dev" branch on the ext4.git tree at the moment).

       		    	      	     	    	     - Ted


Running local boot scripts (/etc/rc.local)
FSTESTCFG is "all"
FSTESTSET is "130"
umount: /dev/vdb: not mounted
umount: /dev/vdd: not mounted
e2fsck 1.42-WIP (02-Jul-2011)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/vdb: 6030/327680 files (3.1% non-contiguous), 77032/1310720 blocks
BEGIN TEST: Ext4 4k block Mon Aug 22 22:27:54 EDT 2011
Device: /dev/vdb
mke2fs options: -q
mount options: -o block_validity
000 - unknown test, ignored
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 candygram 3.1.0-gcg-DEV
MKFS_OPTIONS  -- -q /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc

130 11s ... - output mismatch (see 130.out.bad)
--- 130.out	2011-08-12 00:06:32.000000000 -0400
+++ 130.out.bad	2011-08-22 22:27:57.550000003 -0400
@@ -4,8 +4,9 @@
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 65536/65536 bytes at offset 65536
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-00000000:  63 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  c...............
-00000010:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+00000000:  63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63  cccccccccccccccc
+*
+00001000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 *
 00010000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
 *
Ran: 130
Failures: 130
Failed 1 of 1 tests
END TEST: Ext4 4k block Mon Aug 22 22:27:57 EDT 2011
e2fsck 1.42-WIP (02-Jul-2011)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/vdb: 6030/327680 files (3.1% non-contiguous), 77032/1310720 blocks
BEGIN TEST: Ext4 4k block w/nodelalloc and no extents Mon Aug 22 22:27:58 EDT 2011
Device: /dev/vdd
mke2fs options: -q -O ^extents
mount options: -o block_validity,nodelalloc
000 - unknown test, ignored
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 candygram 3.1.0-gcg-DEV
MKFS_OPTIONS  -- -q -O ^extents /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,nodelalloc /dev/vdc /vdc

130 11s ... 3s
Ran: 130
Passed all 1 tests
END TEST: Ext4 4k block w/nodelalloc and no extents Mon Aug 22 22:28:01 EDT 2011
e2fsck 1.42-WIP (02-Jul-2011)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/vdd: 11/327680 files (0.0% non-contiguous), 55935/1310720 blocks
BEGIN TEST: Ext4 4k block w/ no journal Mon Aug 22 22:28:01 EDT 2011
Device: /dev/vdb
mke2fs options: -q -O ^has_journal
mount options: -o block_validity,noload
000 - unknown test, ignored
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 candygram 3.1.0-gcg-DEV
MKFS_OPTIONS  -- -q -O ^has_journal /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,noload /dev/vdc /vdc

130 3s ... - output mismatch (see 130.out.bad)
--- 130.out	2011-08-12 00:06:32.000000000 -0400
+++ 130.out.bad	2011-08-22 22:28:04.490000003 -0400
@@ -4,8 +4,9 @@
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 65536/65536 bytes at offset 65536
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-00000000:  63 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  c...............
-00000010:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+00000000:  63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63  cccccccccccccccc
+*
+00001000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 *
 00010000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
 *
Ran: 130
Failures: 130
Failed 1 of 1 tests
END TEST: Ext4 4k block w/ no journal Mon Aug 22 22:28:04 EDT 2011
e2fsck 1.42-WIP (02-Jul-2011)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/vdb: 6030/327680 files (3.1% non-contiguous), 77032/1310720 blocks
BEGIN TEST: Ext4 1k block Mon Aug 22 22:28:05 EDT 2011
Device: /dev/vdd
mke2fs options: -q -b 1024
mount options: -o block_validity
000 - unknown test, ignored
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 candygram 3.1.0-gcg-DEV
MKFS_OPTIONS  -- -q -b 1024 /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc

130 3s ... - output mismatch (see 130.out.bad)
--- 130.out	2011-08-12 00:06:32.000000000 -0400
+++ 130.out.bad	2011-08-22 22:28:08.160000004 -0400
@@ -4,8 +4,9 @@
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 65536/65536 bytes at offset 65536
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-00000000:  63 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  c...............
-00000010:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+00000000:  63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63  cccccccccccccccc
+*
+00000400:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 *
 00010000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
 *
Ran: 130
Failures: 130
Failed 1 of 1 tests
END TEST: Ext4 1k block Mon Aug 22 22:28:08 EDT 2011
e2fsck 1.42-WIP (02-Jul-2011)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/vdd: 11/327680 files (0.0% non-contiguous), 119861/5242880 blocks
BEGIN TEST: Ext4 4k block w/bigalloc Mon Aug 22 22:28:08 EDT 2011
Device: /dev/vdd
mke2fs options: -q -O bigalloc
mount options: -o block_validity
000 - unknown test, ignored
[1825745.459201] EXT4-fs (vdd): couldn't mount RDWR because of unsupported optional features (200)
mount: wrong fs type, bad option, bad superblock on /dev/vdd,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

common.rc: retrying test device mount with external set
[1825745.488666] EXT4-fs (vdd): couldn't mount RDWR because of unsupported optional features (200)
mount: wrong fs type, bad option, bad superblock on /dev/vdd,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

common.rc: could not mount /dev/vdd on /vdd
END TEST: Ext4 4k block w/bigalloc Mon Aug 22 22:28:08 EDT 2011
umount: /dev/vdd: not mounted
e2fsck 1.42-WIP (02-Jul-2011)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/vdd: 11/81936 files (0.0% non-contiguous), 38032/1310720 blocks
BEGIN TEST: Ext4 4k block w/data=journal Mon Aug 22 22:28:08 EDT 2011
Device: /dev/vdb
mke2fs options: -q
mount options: -o block_validity,data=journal
000 - unknown test, ignored
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 candygram 3.1.0-gcg-DEV
MKFS_OPTIONS  -- -q /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,data=journal /dev/vdc /vdc

[1825745.927937] EXT4-fs: Warning: mounting with data=journal disables delayed allocation and O_DIRECT support!
130 3s ... 2s
Ran: 130
Passed all 1 tests
END TEST: Ext4 4k block w/data=journal Mon Aug 22 22:28:12 EDT 2011
e2fsck 1.42-WIP (02-Jul-2011)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/vdb: 6030/327680 files (3.1% non-contiguous), 77032/1310720 blocks
BEGIN TEST: Ext4 4k block w/dioread_nolock Mon Aug 22 22:28:12 EDT 2011
Device: /dev/vdb
mke2fs options: -q
mount options: -o block_validity,dioread_nolock
000 - unknown test, ignored
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 candygram 3.1.0-gcg-DEV
MKFS_OPTIONS  -- -q /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,dioread_nolock /dev/vdc /vdc

[1825749.476751] EXT4-fs (vdc): can't mount with dioread_nolock if block size != PAGE_SIZE
our local mount routine ...
mount: wrong fs type, bad option, bad superblock on /dev/vdc,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

check: failed to mount $SCRATCH_DEV using specified options
Passed all 0 tests
END TEST: Ext4 4k block w/dioread_nolock Mon Aug 22 22:28:12 EDT 2011
e2fsck 1.42-WIP (02-Jul-2011)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/vdb: 6030/327680 files (3.1% non-contiguous), 77032/1310720 blocks
INIT: Switching to runlevel: 0
INIT: Sending processes the TERM signal
error: 'stop-bootlogd' exited outside the expected code flow.
Using makefile-style concurrent boot in runlevel 0.
Saving random seed...done.
Stopping quota service: rpc.rquotad.
Turning off quotas...quotaoff: Warning: No quota format detected in the kernel.
done.
Asking all remaining processes to terminate...done.
All processes ended within 1 seconds....done.
Deconfiguring network interfaces...done.
Cleaning up ifupdown....
Saving the system clock.
Hardware Clock updated to Mon Aug 22 22:28:15 EDT 2011.
Will now unmount temporary filesystems:tmpfs has been unmounted
.
Will now deactivate swap:.
Mounting root filesystem read-only...done.
Will now halt.
[1825755.423049] Power down.
EXIT_SUCCESS
