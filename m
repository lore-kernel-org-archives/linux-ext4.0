From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 goes into read only mode on using discard with
 htree_dirblock_to_tree ... bad entry in directory
Date: Thu, 2 Jan 2014 13:55:07 -0500
Message-ID: <20140102185507.GD10870@thunk.org>
References: <CAHy4Ox1fjTbOxiTqcqyhihYkRs2po7Xs4EWxsFVP+HHyJWpSfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Ritesh Khadgaray <khadgaray@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45456 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbaABSzK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jan 2014 13:55:10 -0500
Content-Disposition: inline
In-Reply-To: <CAHy4Ox1fjTbOxiTqcqyhihYkRs2po7Xs4EWxsFVP+HHyJWpSfg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 02, 2014 at 10:49:56AM +0530, Ritesh Khadgaray wrote:
> 
> description:
> ext4 goes into read-only mode, when building libreoffice or doing a large
> amount of IO (rsync of over ~250gb ) with discard option enabled. Worst
> case, partition table corruption.
> 
> from dmesg
> [11822.935891] EXT4-fs error (device dm-1): htree_dirblock_to_tree:920:
> inode #53629599: block 214443464: comm rm: bad entry in directory: rec_len
> % 4 != 0 - offset=0(0), inode=1667681412, rec_len=45654, name_len=39
> [11822.935896] Aborting journal on device dm-1-8.
> [11822.935998] EXT4-fs (dm-1): Remounting filesystem read-only
> 
> $ uname -a
> Linux K43SA.local 3.13.0-999-generic #201312200414 SMP Fri Dec 20 09:16:44
> UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
> 
> 
> WORKAROUND: Disable discard option - /dev/mapper/volumegroup-root / ext4
> discard,noatime,nodiratime,errors=remount-ro 0 1

This is a hardware bug, unfortunately.  And it's also the reason why
discard is not on by default.

These days, what I normally tell people is to not use the discard
mount option at all, and instead use the fstrim program, run out of
cron maybe once a week or even every night if you are anal.  (But for
most workloads, once a week is plenty.)  The main place where the
discard option makes sense is if you are using a very expensive PCIe
attached flash device.  Those devices are much more likely to have a
competently implemented DISCARD command, and they generally don't
destroy performance forcing a queue flush for every single DISCARD
request.

However, in your case, if discard commands are causing on-disk
corruption, I'm not sure I can even in good conscience recommend using
fstrim.

> Device Model: Crucial_CT960M500SSD1
> Serial Number: 1335094BE7CA
> LU WWN Device Id: 5 00a075 1094be7ca
> Firmware Version: MU03

Instead, all I can do is suggest that you consider whether you should
replace your SSD.  Historically, I've stuck with Intel SSD's because
they are the ones that have tended to be the most reliable.  Intel has
unfortunately, been slow to market because they insist on testing
their products extensively and only releasing them when they are
solid, which has cost them market share.  Unfortuantely, the market
doesn't always reward quality.  More recently, I've started using
Samsung SSD's.  I have a Samsung 840 PRO and the Intel 525 240GB mSATA
SSD's in my laptop, and so far, I've not had any problems with either.
They are definitely not the cheapest nor the most performant devices
in head-to-head testing, but that's not the only dimension that I care
about....

More (somewhat depressing) investigations about the quality of SSD's
these days:

https://plus.google.com/+MarcMERLIN/posts/Us8yjK9SPs6
http://lkcl.net/reports/ssd_analysis.html
https://www.usenix.org/conference/fast13/understanding-robustness-ssds-under-power-fault

						- Ted

P.S.  Some really crappy SSD devices have brick'ed themselves when
they are given a heavy discard load, particularly one which is mixed
with other traffic, and this is what the "discard" mount option
provides.  Note that if the fstrim command is executed while you are
also trying to put the device under heavy read/write workloads, it
could also result in the same kind of corruption and/or brick'ing of
the SSD.  Which is why I hesitate to recommend switching to fstrim for
a device which is known to mishandle the DISCARD command, and to
suggest simply not using the DISCARD feature at all --- and if this
results in increased performance lost or increased write wear, to just
replace the SSD as an inferior quality product before it does any
further damage to your data.
