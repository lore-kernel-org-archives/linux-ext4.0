From: "Alexander V. Lukyanov" <lav@netis.ru>
Subject: Re: [PATCH] ext4: allow inode_readahead_blks=0 (linux-2.6.37)
Date: Thu, 24 Feb 2011 11:18:06 +0300
Message-ID: <20110224081806.GA14787@lw.yar.ru>
References: <20110208063925.GA13619@lw.yar.ru>
 <20110222023211.GF2924@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lav-w.yar.ru ([193.233.48.101]:55694 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755357Ab1BXIS3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Feb 2011 03:18:29 -0500
Content-Disposition: inline
In-Reply-To: <20110222023211.GF2924@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 21, 2011 at 09:32:11PM -0500, Ted Ts'o wrote:
> On Tue, Feb 08, 2011 at 09:39:25AM +0300, Alexander V. Lukyanov wrote:
> > Hello!
> >
> > I cannot disable inode-read-ahead feature of ext4 (on 2.6.37):
> >
> > # echo 0 > /sys/fs/ext4/sda2/inode_readahead_blks
> > bash: echo: write error: Invalid argument
> >
> > On a server with lots of small files and random access this read-ahead makes
> > performance worse, and I'd like to disable it. I work around this problem
> > by using value of 1, but it still reads an extra block.
>
> So I'm curious --- have you actually benchmarked a performance
> decrease?  What sort of hardware are you using?

Yes, with the default value of inode_readahead_blks LA went from 4 to 30
(if I remember correctly). The problem was the increased load on HDD.

The hardware is: Core2duo CPU, 4GB RAM, 4x80GB SATA disks without NCQ,
the load is evenly distributed on the disks. At that time each disk
contained 1 million files, randomly accessed for read/create-write,
10MB/s read and 10MB/s write (rate sum of 4 disks).

> The readahead should be changing a 4k read to a 8k read with a value
> of 1, which shouldn't take a much of a difference to a HDD.

Sure, with inode_readahead_blks=1 it works acceptably. But I'd like
to disable the inode read-ahead completely.

> I can apply this patch, but is it really making a difference for you?

I think it is logical to be able to disable an unneeded feature.
Besides, there is a code already to check s_inode_readahead_blks!=0
(fs/ext4/inode.c:4737):

                /*
                 * If we need to do any I/O, try to pre-readahead extra
                 * blocks from the inode table.
                 */
                if (EXT4_SB(sb)->s_inode_readahead_blks) {

--
   Alexander.
