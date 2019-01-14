Return-Path: <SRS0=NmFT=PW=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36078 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726449AbfANMuU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 14 Jan 2019 07:50:20 -0500
Date: Mon, 14 Jan 2019 13:50:17 +0100
From: Jan Kara <jack@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.com>,
        Theodore Tso <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Preserving a rev 0.0 ext2 filesystem
Message-ID: <20190114125017.GI13316@quack2.suse.cz>
References: <CAMuHMdULrGHfgF+RRGf5gXAc=V3KaB4549NezxEc3CvfsKWOyA@mail.gmail.com>
 <3A06C183-19FF-48B3-9C49-60353BEC9DB8@dilger.ca>
 <CAMuHMdWt+6Aeius=PFr9vQgF7LGde78f9nyai4m1P8QL+oqY0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWt+6Aeius=PFr9vQgF7LGde78f9nyai4m1P8QL+oqY0A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 14-01-19 11:23:30, Geert Uytterhoeven wrote:
> Thanks, since ext2 also has the ext2_update_dynamic_rev() function, I
> assumed it would be called as well.  But indeed, mounting the old file
> system using the real ext2 driver retains its revision.

Thanks for trying that out and I'm glad that it still works ;)

> JFYI, this is what was changed by mounting and unmounting it using the
> ext2 driver:
> 
> --- ramdisk.orig 2019-01-14 09:23:15.578434706 +0100
> +++ ramdisk.mounted-by-ext2 2019-01-14 09:23:16.362434253 +0100
> @@ -3,7 +3,7 @@
>  00000400  f8 00 00 00 78 05 00 00  00 00 00 00 20 00 00 00  |....x....... ...|
>  00000410  09 00 00 00 01 00 00 00  00 00 00 00 00 00 00 00  |................|
>  00000420  00 20 00 00 00 20 00 00  f8 00 00 00 f7 5e a3 32  |. ... .......^.2|
> -00000430  9e 5e a3 32 03 00 14 00  53 ef 01 00 01 00 00 00  |.^.2....S.......|
> +00000430  84 46 3c 5c 04 00 14 00  53 ef 01 00 01 00 00 00  |.F<\....S.......|
>  00000440  53 5d a3 32 00 4e ed 00  00 00 00 00 00 00 00 00  |S].2.N..........|
>  00000450  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>  00000460  00 00 00 00 00 00 00 00  87 6b 6d 86 4c 96 11 d0  |.........km.L...|
> 
> Which is just the last write time, and mount count, as expected.
> Interestingly, the last mount time was not updated.

Yeah, that looks like a bug that got introduced in 269c8db30cf5b6 "ext2:
Set the write time in ext2_sync_fs()" in 2010. I'll fix it. Thanks for
report.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
