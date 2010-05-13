From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell
 88f5182)
Date: Thu, 13 May 2010 10:15:14 +1000
Message-ID: <1273709714.21352.138.camel@pasglop>
References: <1273569821.21352.19.camel@pasglop>
	 <1273575478.21352.29.camel@pasglop>
	 <20100512150057.GA29867@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Saeed Bishara <saeed@marvell.com>,
	Nicolas Pitre <nico@marvell.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"James E.J. Bottomley" <jejb@parisc-linux.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:55569 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab0EMARN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 May 2010 20:17:13 -0400
In-Reply-To: <20100512150057.GA29867@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2010-05-12 at 17:00 +0200, Jan Kara wrote:

>  Could you get the filesystem image with: e2image -r /dev/sdb2 buggy-image
> bzip2 it and make it available somewhere? Maybe I could guess something
> from the way the filesystem gets corrupted.
>  Oh, and also overwrite the partition with zeros before calling mkfs to make
> the analysis simpler.

Here we go.

Created a smaller partition (100MB). dd'ed /dev/zero to it, dd'ed it off
to NFS host to locally cmp it with /dev/zero to make sure it's nice and
clean. It is. Then mkfs.ext3, mount, rsync over /usr/lib of my test
root, unmount, and dd it off to the NFS host again.

The result shows the same errors with fsck.ext3 -n -f ./test.img

I uploaded it at:

http://gate.crashing.org/~benh/test.img.bz2

Cheers,
Ben.

> > In fact, if I do ls /mnt/test/usr/bin/ I see debconf but if I do
> > ls /mnt/test/usr/bin/chrt then I get No such file or directory.
> > 
> > So something is badly wrong :-)
> > 
> > Now, trying without the dir_index feature (mkfs.ext3 -O ^dir_index)
> > and it works fine. All my md5sum's are correct and fsck passes.
>   Funny. Not sure how that could happen...
> 
> 								Honza


