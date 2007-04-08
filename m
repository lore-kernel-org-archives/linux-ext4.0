From: Theodore Tso <tytso@mit.edu>
Subject: Re: confused on different inode size
Date: Sun, 8 Apr 2007 13:52:18 -0400
Message-ID: <20070408175218.GB29180@thunk.org>
References: <1176014343.20429.6.camel@colyT43.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: coly <colyli@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55709 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbXDHRwT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Apr 2007 13:52:19 -0400
Content-Disposition: inline
In-Reply-To: <1176014343.20429.6.camel@colyT43.site>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Apr 08, 2007 at 02:39:03PM +0800, coly wrote:
> Hi, list:
> 
> I find size of struct ext4_inode is 152 bytes, but from the dumpe2fs, it
> tells me the inode size is 128 bytes.
> 
> I am confused that, the ext4_inode is the on-disk inode format, so how
> can dumpe2fs tells the inode size is 128 bytes.
> 
> Further more, when I use sb_bread() to read inode from inode table (with
> 152 bytes inode size), I can not read proper data from the bh->b_data.
> Once I use 128 bytes inode size, I can read what I want from the
> bh->b_data.

The inode size for ext4 filesystems can be multiple sizes; the
traditional ext2/ext3 inode size is 128 bytes.  If so, then you won't
have any of the features that require inode fields starting at
i_extra_isize.  If you use an inode size of 256 bytes, then you will
be able to use nanosecond granularity timestamps, and the extra space
(256-152 bytes) can be used for fast access to extended attributes.
If there is an expectation that the filesystem will need a larger
amount of space for extended attributes, the filesystem can be
formatted with 512, 1024, or even larger sizes (so long as it is a
power of two >= 128 bytes).

					- Ted
