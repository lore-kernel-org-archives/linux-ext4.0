From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Max blocks per group?
Date: Thu, 28 Jun 2012 15:23:03 -0400
Message-ID: <20120628192303.GA9054@thunk.org>
References: <4FEC754F.5000907@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53346 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab2F1TXG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Jun 2012 15:23:06 -0400
Content-Disposition: inline
In-Reply-To: <4FEC754F.5000907@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 28, 2012 at 11:16:31AM -0400, Phillip Susi wrote:
> 
> I notice that mke2fs refuses to allow more than 8 * block size blocks
> per group.  Why is this?  Is it not permissible to have more than one
> block for the block allocation bitmap?

No, it's not permissible; it's been a fundamental design constraint in
ext2/3/4 since the very beginning.  You can, however, get the moral
equivalent by using flex_bg which moves the metadata blocks to the
beginning of an aggregated of (for example) 16 block groups of a
flex_bg.  The block allocation bitmaps are allocated contiguously, so
between that and locating all of the metadata blocks of the bg's at
the beginning of a flex_bg, that should get most of what you'd want
with a larger number of blocks in a block group.

And BTW, this is already the default in ext4 (using 16 block groups in
each flex_bg).

						- Ted
