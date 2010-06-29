From: tytso@mit.edu
Subject: Re: Ext4 on SSD Intel X25-M
Date: Tue, 29 Jun 2010 09:56:44 -0400
Message-ID: <20100629135644.GE6094@thunk.org>
References: <4C278EC2.1080903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Nebojsa Trpkovic <trx.lists@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39558 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047Ab0F2N4q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jun 2010 09:56:46 -0400
Content-Disposition: inline
In-Reply-To: <4C278EC2.1080903@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 27, 2010 at 07:47:46PM +0200, Nebojsa Trpkovic wrote:
> I've noticed that there is a difference between
> /sys/fs/ext4/sdXX/lifetime_write_kbytes
> and host writes read from SSD itself.
> 
> In normal desktop operation "host writes" counter on SSD increases at
> roughly ~2/3 compared to lifetime_write_kbytes.

How are you measuring the "host writes" counter from the SSD?

> My best guess is that host itself uses a lot of optimisation to reduce
> writing to NAND itself.

Possible, although if the counter is defined as "host writes", that
should be before the NAND writes, since "host writes" would expect
means the actual write commands coming from the host -- i.e., coming
incoming SATA write commands.

> Besides that, I've noticed that my commit=100 mount option helps also.
> Changing (just for testing) to something realy big, like commit=9000,
> gave even further improvement, but not worth staying with risk of losing
> (that much) data. It seems that ext4 writes a lot to filesystem, but
> many of those writes are overwrites. If we flush them to host just once
> in 100 seconds, we're getting a lot of saving.

What metric are you using when you say that this "helps"?  The ext4
measurement, the SSD counter which you are using, or both?

> As I wanted to make even my swap TRIMable, I've put it in the file on
> ext4 instead of separate partition. I've made it using dd with seek=500
> bs=1M options. ext4's lifetime_write_kbytes increased by 500MB, and host
> writes did not incrase at all, even after 100 seconds. Ok, I know that
> ext4 did not write 500MB of data to filesystem, but this is one more
> thing why one should not trust lifetime_write_kbytes.

> So, the moral of my story would be not to trust lifetime_write_kbytes,
> but to read host writes from SSD.

If you wrote 500MB to a swap file in ext4 using dd, why are you sure
ext4 didn't write 500MB of data to the disk?  In fact, this would
imply to me that that your "host writes" shouldn't be trusted.

> I noticed that Intel's Solid State Drive Toolbox software (running in
> Windows) gives the amount of Host Lifetime Writes that equales to
> S.M.A.R.T attribute 225 (Load_Cycle_Count) multiplied with 32MB.
> That's the way I track it in Linux.

According to the S.M.A.R.T startd, Load_cycle_count is supposed to
mean the number of times the platter has spun up and spin down.  It's
not clear what it means for SDD's, so it may be that they have reused
it for some other purpose.  However, it would be surprising to me that
it was just host lifetime writes divided by 32MB.  It may be that you
have noticed this correlation in Windows because Windows is very
"chunky" in how it does its writes.

However, if you write 500MB to a file in ext4 using dd, and ext4's
lifetime_write_kbytes in /sysfs went up by 500MB, but the
Load_Cycle_Count attribute did not go up, then I would deduce from
that that your interpretation of Load_Cycle_Count is probably not
correct...

					- Ted
