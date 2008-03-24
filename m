From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: e2fsprogs and fast symlink
Date: Mon, 24 Mar 2008 17:26:39 -0400
Message-ID: <20080324212639.GC30110@mit.edu>
References: <20080321114234.GB6542@skywalker> <20080324113747.GA18042@skywalker> <20080324204510.GH2691@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63375 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752825AbYCXV2m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Mar 2008 17:28:42 -0400
Content-Disposition: inline
In-Reply-To: <20080324204510.GH2691@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 24, 2008 at 02:45:10PM -0600, Andreas Dilger wrote:
> Instead I propose that we just use the i_size itself to determine if
> there is a fast symlink, because there has never (AFAIK) been a kernel
> that created slow symlinks for files < 60 bytes in length.

I have a vague memory that at one point (along time ago, over ten
years ago) there were slow symlinks where the target was < 60 bytes.
And the kernel has always determined whether or not a symlink was fast
or slow by looking i_blocks.  (See ext3_inode_is_fast_symlink() in
fs/ext3/inode.c).

In retrospect, the true clean way to do this would have been an
explicit i_flags bitfield.  One thing we could do is make a change
into ext4 (and ext3) so that we silently set an EXT3_SLOW_LINK_FL and
EXT3_FAST_LINK_FL, and if neither is set, we fall back to a hueristic
involving i_blocks.  This gives e2fsck one more bit of redundancy to
make sure it notices problems and to make sure it gets things right.
I'm not sure it's worth it, but eventually it would allow us to clean
things up.

					- Ted
