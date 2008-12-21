From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: linux ext3 partition hosed, is this hardware of software error?
Date: Sun, 21 Dec 2008 15:57:20 +0000
Message-ID: <20081221155720.36b700f7@lxorguk.ukuu.org.uk>
References: <20081221143640.GF1509@gamma.logic.tuwien.ac.at>
	<20081221144913.76ca53d3@lxorguk.ukuu.org.uk>
	<20081221150302.GA3457@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Norbert Preining <preining@logic.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33281 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752239AbYLUP5Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Dec 2008 10:57:16 -0500
In-Reply-To: <20081221150302.GA3457@gamma.logic.tuwien.ac.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> > > Buffer I/O error on device sda3, logical block 12
> > > Buffer I/O error on device sda3, logical block 13
> > 
> > Right near the start of the disk.
> 
> Ah, that is the reason why grub is gone.

To be accurate - start of partition but the effect is the same yes.

> > Make a copy of the partition with a recovery tool and write it somewhere
> 
> ddrescue? partimage? Any other suggestion?

ddrescue should do the trick - anything which will copy all the valid
sectors and write out the lost ones as zero or similar preserving what is
left of the file.

> 
> > (file on another disk whatever) and keep it safe. Make a copy of that and
> > fsck the copy. You may need to use the alternate superblock option on
> > fsck for this.
> 
> Thanks, good hint, didn't know about that.

It's there for exactly this kind of situation.

Alan
