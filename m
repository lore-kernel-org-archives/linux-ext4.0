From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Review of ext4-online-defrag-for-relevant-files.patch
Date: Sat, 13 Sep 2008 20:50:24 -0400
Message-ID: <20080914005024.GH26128@mit.edu>
References: <E1KeahC-0004UU-2B@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, linux-ext4@vger.kernel.org
To: a-fujita@rs.jp.nec.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:40392 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752890AbYINAua (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Sep 2008 20:50:30 -0400
Content-Disposition: inline
In-Reply-To: <E1KeahC-0004UU-2B@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 13, 2008 at 03:22:14PM -0400, Theodore Ts'o wrote:
> There is also no mention if this new ioctl anywhere in the patch
> commit.  Was this intentional?  If so, what is the justification for the
> new ioctl, and is it safe to simply remove the ioctl and change the
> userspace program to use the FIBMAP ioctl?

Ah, I see one potential reason.  FIBMAP only allows 32-bit block
numbers, and EXT4_IOC_FIBMAP allows 64-bit block numbers.  Still, it's
only used in one place, to get the physical block number of the first
block of the file to use as the "goal" block.  This could be retrieved
using either FIEMAP or the EXT4_IOC_EXTENTS_INFO ioctl (not
surprising, since the two are equivalent.  :-)

Of course, the fact that the defrag code is using the first block of
the inode is the goal block, while other places get_free_extents()
assumes that the only free extents which are interesting are the ones
in the block group of the inode seems funny....  but I haven't had the
time to thoroughly understand the algorithms used by the defrag
program.

Still, it seems clear to me that step one is getting the helper ioctls
designed correctly and merged into ext4, and then we can gradually
work to get the rest of the defrag patches merged.

Best regards,

						- Ted
