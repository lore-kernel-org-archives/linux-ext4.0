From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: Fix the wrong error detection for non-extent
 file
Date: Fri, 25 Nov 2011 21:31:24 -0500
Message-ID: <20111126023124.GG5167@thunk.org>
References: <4ECF433C.4030604@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36497 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab1KZCbe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Nov 2011 21:31:34 -0500
Content-Disposition: inline
In-Reply-To: <4ECF433C.4030604@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 25, 2011 at 04:26:52PM +0900, Kazuya Mio wrote:
> When I create a non-extent file with the maximum size in ext4,
> e2fsck detects the following error:
> 
> Pass 1: Checking inodes, blocks, and sizes
> Inode 12, i_size is 4402345721856, should be 4402345721856. Fix?
> 
> As we know, e2fsck checks the size field of the inode in pass 1.
> However, in case of the ext4 with the feature of ^extent and huge_file,
> the maximum file size calculated in e2fsck is less than the real one.
> The patch fixes this problem.
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>

Thanks, applied.

					- Ted
