From: "Pavel Mironchik" <tibor0@gmail.com>
Subject: Re: ext2/3 create large filesystem takes too much time; solutions
Date: Sat, 16 Sep 2006 17:56:02 +0300
Message-ID: <401f4f10609160756jc8c6a3eu9925b3678d0f6793@mail.gmail.com>
References: <401f4f10609120407j6816372mfdfea392dcae9e00@mail.gmail.com>
	 <20060915212034.GB11237@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:63151 "EHLO
	py-out-1112.google.com") by vger.kernel.org with ESMTP
	id S1751756AbWIPO4D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Sep 2006 10:56:03 -0400
Received: by py-out-1112.google.com with SMTP id n25so4549023pyg
        for <linux-ext4@vger.kernel.org>; Sat, 16 Sep 2006 07:56:02 -0700 (PDT)
To: "Theodore Tso" <tytso@mit.edu>
In-Reply-To: <20060915212034.GB11237@thunk.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

Thanks for the responce...
I agree with you and I would prefer to send something more
serious on that list than those previous patches - I like your
idea with counters. Btw I assume crc is more preferable than
just control sum for block group descriptors....

Pavel
p.mironchik@velesys.com
tibor@altlinux.org

On 9/16/06, Theodore Tso <tytso@mit.edu> wrote:
> On Tue, Sep 12, 2006 at 02:07:34PM +0300, Pavel Mironchik wrote:
> >
> > Ext2/3 does erase of inode tables, when do creation of new systems.
> > This is very very long operation when the target file system volume is more
> > than
> > 2Tb. Other filesystem are not affected by such huge delay on creation of
> > filesystem. My concern was to improve design of ext3 to decrease time
> > consuption of creation large ext3 volumes on storage servers.
> > In general to solve problem, we should defer job of cleaning nodes to
> > kernel. In e2fsprogs there is LAZY_BG options but it  just avoids doing
> > erase of inodes only.
>
> Hi Pavel,
>
>         Apologies that no one responded right away; I think a lot of
> people have been incredibly busy.  I've been doing a huge amount of
> travel myself personally, and so my e-mail latency has been larger
> than normal.
>
>         The problem of long mke2fs problems is one that we've
> considered, and we do want to do something with it, but it's not been
> as high priority as some of the other problems on our hit list.
> Certainly, given that inode space is very precious, I'm not convinced
> that breaking backwards compatibility and burning an extra 16 bytes
> per inode is worth the net gain --- although there are other solutions
> that don't have that particular cost.  Yes, they take more lines of
> code to support, but given the hopefully large number of people that
> will be using ext4, I'd must rather spend an extra amount of
> development time getting it right, than doing something fast and dirty
> which then everyone pays for, over and over, again and again and again
> across millions and millions of machines!
>
>
> > I see several solutions for that problem:
> > 1) Add special bitmaps into fs header (inode groups descriptors?).
> > By looking at those bitmaps kernel could determine if inode is not cleaned,
> > and that inode will be propertly initialized.
>
> Actually, you don't need a bitmap; a much simpler solution is to have
> an integer field in the block group descriptors which indicates the
> number of inods that have been initialized in that block group.  The
> problem though is that what if the block group descriptors (or the
> bitmaps) get corrupted?  So what we also want to do is to add support
> for checksums in the individual inodes and in the block group
> descriptors themselves, as a double-check.
>
> These are useful features in and of themselves, and there are some
> sample implementations of them (for example, in the Iron ext2 paper).
> So my thinking is that we should get that work into ext4, and then
> it's not hard to add the support for fields in the block group
> descriptors that would allow for fast mke2fs support.
>
> Regards,
>
>                                                 - Ted
