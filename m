From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext2/3 create large filesystem takes too much time; solutions
Date: Sat, 16 Sep 2006 16:06:18 -0400
Message-ID: <20060916200617.GA14999@thunk.org>
References: <401f4f10609120407j6816372mfdfea392dcae9e00@mail.gmail.com> <20060915212034.GB11237@thunk.org> <401f4f10609160756jc8c6a3eu9925b3678d0f6793@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:6831 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1750737AbWIPUG0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Sep 2006 16:06:26 -0400
To: Pavel Mironchik <tibor0@gmail.com>
Content-Disposition: inline
In-Reply-To: <401f4f10609160756jc8c6a3eu9925b3678d0f6793@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Sep 16, 2006 at 05:56:02PM +0300, Pavel Mironchik wrote:
> Hi Ted,
> 
> Thanks for the responce...
> I agree with you and I would prefer to send something more
> serious on that list than those previous patches - I like your
> idea with counters. Btw I assume crc is more preferable than
> just control sum for block group descriptors....

Yes, when I said checksum I meant a cyclic redundancy checksum, and
not an additive checksum...  (and one of the things we can do is to
build in the superblock UUID into the CRC, so that if the filesystem
gets recreated we can distinguish an old inode from a new one).

						- Ted
