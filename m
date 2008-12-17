From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: FPE error on e2fsck (ext3 fs)
Date: Wed, 17 Dec 2008 23:04:59 +0100
Message-ID: <m3k59ye9v8.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:56987 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbYLQWFB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Dec 2008 17:05:01 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

FYI: I've spotted a report about an e2fsck exiting with SIGFPE on
a damaged (by a power loss) ext3 fs.

e2image works (though I'm not sure the image is still available),
e2image -r aborts with FPE.

dumpe2fs 1.41.3 (12-Oct-2008) - Gentoo.
Filesystem volume name:   d!ne4
Last mounted on:          <not available>
Filesystem UUID:          71ab8e2a-8f1a-4189-a09d-fc27eca31c97
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal resize_inode dir_index filetype 
sparse_super large_file
Filesystem flags:         signed_directory_hash 
Default mount options:    journal_data_ordered bsdgroups user_xattr acl
Filesystem state:         clean
Errors behavior:          Remount read-only
Filesystem OS type:       Linux
Inode count:              9928704
Block count:              19825891
Reserved block count:     0
Free blocks:              3151047
Free inodes:              9911645
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1024
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         0
Inode blocks per group:   0
Filesystem created:       Fri Oct 27 03:08:12 1972
Last mount time:          Mon Dec 15 09:52:11 2008
Last write time:          Mon Dec 15 14:37:05 2008
Mount count:              9
Maximum mount count:      35
Last checked:             Wed Dec 10 10:20:51 2008
Check interval:           2592000 (1 month)
Next check after:         Fri Jan  9 10:20:51 2009
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          128
Journal inode:            8
Default directory hash:   tea
Directory Hash Seed:      5aad87aa-32bd-4603-8901-2c8bdf020e5e
Journal backup:           inode blocks
(SIGFPE)

strace log (tail only):
write(1, "Reserved blocks gid:      0 (grou"..., 41) = 41
write(1, "First inode:              11\n"..., 29) = 29
write(1, "Inode size:\t          128\n"..., 26) = 26
write(1, "Journal inode:            8\n"..., 28) = 28
write(1, "Default directory hash:   tea\n"..., 30) = 30
write(1, "Directory Hash Seed:      5aad87a"..., 63) = 63
write(1, "Journal backup:           inode b"..., 39) = 39
--- SIGFPE (Floating point exception) @ 0 (0) --- 
+++ killed by SIGFPE +++

# e2fsck -n -v /dev/sdb1
e2fsck 1.41.3 (12-Oct-2008)
Floating point exception

If required I can contact the person in question and ask for more
info.
Please Cc: me if needed, I'm not subscribed to linux-ext4.
-- 
Krzysztof Halasa
