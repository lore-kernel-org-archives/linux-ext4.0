From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Wed, 5 Mar 2008 10:59:50 -0600
Message-ID: <20080305105950.41510584@gara>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org>
	<20071217171100.GA7070@thunk.org>
	<20080211045107.GB25089@mit.edu>
	<20080219050945.GU25098@mit.edu>
	<20080229154333.GC8968@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>, Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42881 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756781AbYCERAF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Mar 2008 12:00:05 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m25H22JO013240
	for <linux-ext4@vger.kernel.org>; Wed, 5 Mar 2008 12:02:02 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m25H02IW270966
	for <linux-ext4@vger.kernel.org>; Wed, 5 Mar 2008 12:00:03 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m25H023L015301
	for <linux-ext4@vger.kernel.org>; Wed, 5 Mar 2008 12:00:02 -0500
In-Reply-To: <20080229154333.GC8968@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 29 Feb 2008 10:43:33 -0500
Theodore Tso <tytso@MIT.EDU> wrote:
> Block bitmap differences:  +8195Group 3 block(s) in use but group is marked BLO
> CK_UNINIT
> Fix? yes
> 
> 	This mangling is happening because error reporting for
> 	PR_5_INODE_UNINIT is getting intermingled with the
> 	PR_5_INODE_USED/PR_5_INODE_UNUSED reporting, which isn't a
> 	good idea.  The comment around the code says:
> 
> 		/* 
> 		 * We should never hit this, because it means that
> 		 * inodes were marked in use that weren't noticed
> 		 * in pass1 or pass 2. It is easier to fix the problem
> 		 * than to kill e2fsck and leave the user stuck.
> 		 */
> 
> 	So I'm guessing there's something else wrong going on here....

After looking at the misc/mke2fs.c a second time, I notice that there
is one chunk missing in setup_lazy_bg from the 6270612c commit:

+
+                       /* Skip groups with GDT backups because the resize
+                        * inode has blocks allocated in them, and the last
+                        * group because it needs block bitmap padding. */
+                       if ((ext2fs_bg_has_super(fs, i) &&
+                            sb->s_reserved_gdt_blocks) ||
+                           i == fs->group_desc_count - 1)
+                               continue;
+

This should fix the problem you see above.  Now, I wonder if you would
see a similar problem if the filesystems is created with the meta_bg
option since we don't check to see if the block groups has a bgd.

-JRS
