From: Andreas Dilger <adilger@Sun.COM>
Subject: Re: Respin of the uninit_group patches
Date: Wed, 19 Mar 2008 07:33:54 +0800
Message-ID: <20080318233354.GD2971@webber.adilger.int>
References: <1205760527-14858-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:62549 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340AbYCSTjY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Mar 2008 15:39:24 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2INY5aY026090
	for <linux-ext4@vger.kernel.org>; Tue, 18 Mar 2008 16:34:05 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JXY0040197ZQU00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 18 Mar 2008 16:34:05 -0700 (PDT)
In-reply-to: <1205760527-14858-1-git-send-email-tytso@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 17, 2008  09:28 -0400, Theodore Ts'o wrote:
> I've reworked this patch series to clean them up a bit.  In
> particular, an unused ext2fs_scan_inode flag (EXT2_SF_DO_CSUM) was
> removed

Sure.

> In addition, ext2fs_group_desc_set()
> and ext2fs_group_desc_verify() take an ext2_filsys argument instead of
> a superblock and a pointer to a group descriptor, in order to simplify
> the calling code.

Yeah, I did it that way to keep the kernel and e2fsprogs code the same.

> If this looks good, this should be the next set of patches to move
> into the 'next' branch.

Look good to me, though I didn't do a line-by-line analysis I thought
I'd let you know I gave them a once-over.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

