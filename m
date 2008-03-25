From: Andreas Dilger <adilger@sun.com>
Subject: Re: Respin of the uninit_group patches
Date: Tue, 25 Mar 2008 03:15:45 -0600
Message-ID: <20080325091545.GA10906@webber.adilger.int>
References: <1205760527-14858-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57080 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbYCYJQF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Mar 2008 05:16:05 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2P9G3be011565
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 02:16:03 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JYA00M01480EO00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 25 Mar 2008 02:16:03 -0700 (PDT)
In-reply-to: <1205760527-14858-1-git-send-email-tytso@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 17, 2008  09:28 -0400, Theodore Ts'o wrote:
> I've reworked this patch series to clean them up a bit.  In
> particular, an unused ext2fs_scan_inode flag (EXT2_SF_DO_CSUM) was
> removed, and I made ext2fs_group_desc_csum() static, and added
> ext2fs_group_desc_csum_set().  In addition, ext2fs_group_desc_set()
> and ext2fs_group_desc_verify() take an ext2_filsys argument instead of
> a superblock and a pointer to a group descriptor, in order to simplify
> the calling code.
> 
> If this looks good, this should be the next set of patches to move
> into the 'next' branch.

I note in our bugzilla that we still have an open bug against the
uninit_groups patch related to resize2fs, related to the fact that
resize2fs allocating new inodes or blocks will likely not clear
the UNINIT flags from the groups it is working on:

https://bugzilla.lustre.org/show_bug.cgi?id=12002

I verified that the code to disable resize2fs is still in the "next"
branch, so there is no immediate danger, but it also means that
filesystems with uninit_groups enabled can not be resized.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

