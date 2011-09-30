From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: Always swab MMP block on BE machines
Date: Fri, 30 Sep 2011 19:03:22 -0400
Message-ID: <20110930230322.GO12440@thunk.org>
References: <20110930194126.GU12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60655 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab1I3XDY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Sep 2011 19:03:24 -0400
Content-Disposition: inline
In-Reply-To: <20110930194126.GU12086@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 30, 2011 at 12:41:26PM -0700, Darrick J. Wong wrote:
> The MMP code in libext2fs tries to gate MMP block swab'ing with this test:
> 
> #ifdef EXT2FS_ENABLE_SWAPFS
> if (fs->super->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))
> 
> However, EXT2FS_ENABLE_SWAPFS never seems to be defined anywhere (all possible
> #define's were cleaned out of e2fsprogs ages ago), and even if any still
> existed, the field fs->super->s_magic is always in host byteorder, so the test
> always fails.  So, we can change the #ifdef to WORDS_BIGENDIAN (which is
> conditionally defined on BE platforms) and get rid of the broken if test.
> 
> (This fix came up while testing the metadata checksumming patchset)
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Applied, thanks.

						- Ted
