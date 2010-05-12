From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell
 88f5182)
Date: Thu, 13 May 2010 08:13:59 +1000
Message-ID: <1273702439.21352.128.camel@pasglop>
References: <1273569821.21352.19.camel@pasglop>
	 <1273575478.21352.29.camel@pasglop>
	 <20100512150057.GA29867@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Nicolas Pitre <nico@marvell.com>, linux-kernel@vger.kernel.org,
	Saeed Bishara <saeed@marvell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	"James E.J. Bottomley" <jejb@parisc-linux.org>,
	linux-arm-kernel@lists.infradead.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:42266 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab0ELWRn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 May 2010 18:17:43 -0400
In-Reply-To: <20100512150057.GA29867@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


>   Could you get the filesystem image with: e2image -r /dev/sdb2 buggy-image
> bzip2 it and make it available somewhere? Maybe I could guess something
> from the way the filesystem gets corrupted.
>   Oh, and also overwrite the partition with zeros before calling mkfs to make
> the analysis simpler.

Will do asap.

> > In fact, if I do ls /mnt/test/usr/bin/ I see debconf but if I do
> > ls /mnt/test/usr/bin/chrt then I get No such file or directory.
> > 
> > So something is badly wrong :-)
> > 
> > Now, trying without the dir_index feature (mkfs.ext3 -O ^dir_index)
> > and it works fine. All my md5sum's are correct and fsck passes.
>   Funny. Not sure how that could happen...

Yeah, strange. I looked at the code a bit and I don't see anything
obvious, ext3 seems to be using the same standard buffer head access
methods for the htree as for the rest of the metadata, and I see no
fancy playing with virtual addresses that could explain a VIVT problem.

I could be an issue with the SATA controller that gets more easily
triggered by the access patterns caused by htree, though that's a bit
strange.

I'll let you know when I have something to look at.

Cheers,
Ben.


