From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 on SSD Intel X25-M
Date: Thu, 12 Nov 2009 10:30:17 -0500
Message-ID: <20091112153017.GA32122@mit.edu>
References: <4AFC14D6.7080700@diamondcut.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56557 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbZKLPaO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Nov 2009 10:30:14 -0500
Content-Disposition: inline
In-Reply-To: <4AFC14D6.7080700@diamondcut.com.br>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 12, 2009 at 11:59:50AM -0200, Renato S. Yamane wrote:
> Hi,
>
> [please, leave me on cc because I'm not subscribed on this ML]
>
> I'm using Intel SSD X25-M on my laptop, and I always hear that is not a  
> good idea use journal on SSD (it decrease the life time).
>
> I ask Intel about this, but I don't receive any answer.
>
> So, I would like to know if is possible disable Journal on EXT4.

It is possible to create an ext4 file system without a journal.  It
would mean that unclean shutdowns would require a full fsck, which on
a freshly created file system on an SSD isn't _that_ bad.  Depending
on how full/fragmented your filesystem happens to be, it will probably
be under 10 seconds.  

That being said, though, it shouldn't be necessary to avoid using a
journal on the Intel SSD.  Intel says that laptop will last at least 5
years with 10GB worth of writes per day, and that's a huge amount.  I
have an X25-M SSD in my laptop, using an ext4 file system and with the
journal enabled, and since the file system was created 266 days ago,
when I put my X25-M into service, the drive has seen 570GB worth of
writes, so I'm averaging 2.14 GB writes per day.  That's well under
the 20GB of writes/per day upon which Intel based its 5 year lifetime
(and most hard drives, and heck, most laptops generally aren't in
service for that long before they are replaced.)

I have done a few things to reduce needless disk utilization, such as
using tmpfs for /tmp and configuring firefox to place its cache in
/tmp, but the bottom line is I wouldn't really worry that much about
the journal.  If you really want to run without a journal, you can use
"mke2fs -t ext4 -O ^has_journal /dev/XXX" to format an ext4 filesystem
without a journal.  But there will be some distinct tradeoffs with
omitting the journal, including possibility that sometimes on an
unclean shutdown you will need to do a manual e2fsck pass.

Best regards,

					- Ted

