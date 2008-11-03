From: Theodore Tso <tytso@mit.edu>
Subject: Re: JBD2/ext4 error
Date: Sun, 2 Nov 2008 22:39:20 -0500
Message-ID: <20081103033920.GC29102@mit.edu>
References: <20081103004827.GA2766@nineveh.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:56523 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754430AbYKCDjW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Nov 2008 22:39:22 -0500
Content-Disposition: inline
In-Reply-To: <20081103004827.GA2766@nineveh.local>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 02, 2008 at 07:48:27PM -0500, Joseph Fannin wrote:
> Hi,
> 
> I'm hitting what's probably a bug in ext4 on one of my boxes. It
> always happens on the boot partition, which is extentless, since it
> seems likely GRUB will choke on extents.

Yeah, this looks like a 2.6.27 regression, introduced by commit a02908f1.

Mingming, can you check this:  I think in the function (in fs/ext4/inode.c):

static int ext4_index_trans_blocks(struct inode *inode, int nrblocks, int chunk)
{
	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
		return ext4_indirect_trans_blocks(inode, nrblocks, 0);
	return ext4_ext_index_trans_blocks(inode, nrblocks, 0);
}

... the last argument to ext4_indirect_trans_blocks and
ext4_ext_index_trans_blocks should be chunk, not 0.  

As result of this bug, we are massively overestimately the amount of
credits needed in the non-extent case, and with small journals, this
causes a failure.

We probably should do more testing with minimally sized journals to
make sure there aren't other problems which only show up with small
journals.

						- Ted
