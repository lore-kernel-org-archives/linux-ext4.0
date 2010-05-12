From: Jan Kara <jack@suse.cz>
Subject: Re: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell
	88f5182)
Date: Wed, 12 May 2010 17:00:57 +0200
Message-ID: <20100512150057.GA29867@atrey.karlin.mff.cuni.cz>
References: <1273569821.21352.19.camel@pasglop> <1273575478.21352.29.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Saeed Bishara <saeed@marvell.com>,
	Nicolas Pitre <nico@marvell.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"James E.J. Bottomley" <jejb@parisc-linux.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38959 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751845Ab0ELPA6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 May 2010 11:00:58 -0400
Content-Disposition: inline
In-Reply-To: <1273575478.21352.29.camel@pasglop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Tue, 2010-05-11 at 19:23 +1000, Benjamin Herrenschmidt wrote:
> 
> > Since I doubt ext3 is busted so dramatically in mainline for "normal" machines,
> > I tend to suspect things could be related to the infamous vivt caches. On the
> > other hand, it's pretty clearly metadata or journal corruption and I'm not
> > sure we ever do things that could cause aliases (such as vmap etc..) on
> > these things, and they shouldn't be mapped into userspace... unless it's fsck
> > itself that causes aliases to occur at the block device level ? (I do unmount
> > though before I run fsck).
> > 
> > On the other hand, it could also be a busticated marvell SATA driver :-)
> > 
> > I have no problem with the vendor kernel, but it's ancient (2.6.12) and based
> > on an out of tree variant of a Marvell originated BSP, so everything is
> > completely different, especially in the area of drivers for the chipset.
> > 
> > Anyways, I'll see if I can gather more data tomorrow as time, viruses and sick
> > kids permits.
> > 
> > In the meantime, any hint appreciated.
> 
> A quick other test which brings more infos, using a smaller (about 5GB)
> partition and no md or raid involved:
> 
>  - Boot with NFS root
>  - mkfs /dev/sdb2 (no md or raid involved)
>  - mount /dev/sdb2 /mnt/test
>  - rsync -avx /test-stuff /mnt/test
>  - cd /mnt/test
>  - md5sum -c ~/test-stuff-sums.txt
> 
> That gives me a whole bunch of:
> 
> md5sum: ./usr/bin/debconf-escape: No such file or directory
> ./usr/bin/debconf-escape: FAILED open or read
> ./usr/bin/stat: OK
> md5sum: ./usr/bin/chrt: No such file or directory
> ./usr/bin/chrt: FAILED open or read
  Could you get the filesystem image with: e2image -r /dev/sdb2 buggy-image
bzip2 it and make it available somewhere? Maybe I could guess something
from the way the filesystem gets corrupted.
  Oh, and also overwrite the partition with zeros before calling mkfs to make
the analysis simpler.

> In fact, if I do ls /mnt/test/usr/bin/ I see debconf but if I do
> ls /mnt/test/usr/bin/chrt then I get No such file or directory.
> 
> So something is badly wrong :-)
> 
> Now, trying without the dir_index feature (mkfs.ext3 -O ^dir_index)
> and it works fine. All my md5sum's are correct and fsck passes.
  Funny. Not sure how that could happen...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
