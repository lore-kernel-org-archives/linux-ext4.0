From: Alexey Fisher <bug-track@fisher-privat.net>
Subject: Re: one way to dmesg
Date: Thu, 05 Nov 2009 16:51:17 +0100
Message-ID: <1257436277.2343.25.camel@mini>
References: <1257344804.2852.11.camel@zwerg>
	 <87f94c370911040718k766d910fr23342c82d4632faa@mail.gmail.com>
	 <1257348551.2091.1.camel@mini>
	 <87f94c370911040746k49dce1f6ge8591f7714b8b19d@mail.gmail.com>
	 <1257350354.2091.9.camel@mini>  <20091105150250.GL6510@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Greg Freemyer <greg.freemyer@gmail.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54647 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756333AbZKEPvP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Nov 2009 10:51:15 -0500
In-Reply-To: <20091105150250.GL6510@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Donnerstag, den 05.11.2009, 10:02 -0500 schrieb Theodore Tso:
> On Wed, Nov 04, 2009 at 04:59:14PM +0100, Alexey Fisher wrote:
> > 
> > Great, look really nice :)
> > but this is not all what i mean.
> > For example fs specific messages: EXT4-fs blabla, if you look to source
> > you'll see "EXT3 FS" "EXT II FS" (fat is worse), if you need to grep it
> > will be nightmare. It seems like ext4 is mostly up to date, ext2/3 need
> > some work. Are there any work on this?
> 
> What problem are you trying to solve?
> 
> Is it just an aesthetics thing?  Is there a specific scenario where
> you need some kind of extra functionality?  If so, what is it?

1. reduce information flow if you need to do some critical work with fs.
Easy way to filter it, some thing like 'grep -- "-fs"' (not 'grep --
[EXT,FAT,XFS...]').
2. fs should notify if some opposite to default options are used (or
default options disabled).
3. fs should be silent if default options used
4. fs should say for what bdev this message. 
example: you will 'mount -o ro,xip,reservation -t ext2 /dev/sda[2,4,5]'

in dmesg you'll get:
[ 4893.684892] reservations ON
[ 4893.684896] xip option not supported
[ 4893.684961] EXT2-fs warning: mounting ext3 filesystem as ext2
[ 4893.684964] EXT2-fs warning: maximal mount count reached, running
e2fsck is recommended
[ 4893.684990] EXT II FS: 0.5b, 95/08/09, bs=1024, fs=1024, gc=2,
bpg=8192, ipg=1280, mo=80010]

the question is how to filter it? for what bdev was this message? This
is not only about ext* this is about all fs, i just begun with ext2.

> There's some question about whether parsing dmesg is the best way to
> get information about error/event reporting.  See the following
> presentation from this year's Plumber's conference for a set of
> ruminations on this issue:
> 
> http://linuxplumbersconf.org/2009/slides/Andi-Kleen-plumbers-error.pdf

Thank you for the link, this is god food for brain :)
Please take a look to my initial "[PATCH] Unify log messages in ext2" on
linux-ext4.

