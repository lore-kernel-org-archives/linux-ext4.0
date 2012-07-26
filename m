From: Ted Ts'o <tytso@mit.edu>
Subject: Re: du -s src is a lot slower on SSD than spinning disk in the
 same laptop
Date: Wed, 25 Jul 2012 23:32:23 -0400
Message-ID: <20120726033223.GA5884@thunk.org>
References: <20120725154521.GA3398@merlins.org>
 <alpine.LFD.2.00.1207252023080.4340@(none)>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Marc MERLIN <marc@merlins.org>, linux-ext4@vger.kernel.org,
	axboe@kernel.dk, Milan Broz <mbroz@redhat.com>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41321 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab2GZDc3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Jul 2012 23:32:29 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1207252023080.4340@(none)>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 25, 2012 at 08:40:28PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > First, I had he problem with btrfs (details below), and then I noti=
ced that
> > while ext4 is actually twice as fast as btrfs, it's still a lot slo=
wer at
> > stat on my fast Samsung 830 512G SSD than my 1TB laptop hard drive =
(both
> > drives being in the same thinkpad T530 with 3.4.4 kernel).
> >=20
> > How can things be so slow? 12-13 seconds to scan 15K inodes on a fr=
eshly
> > made filesystem (and 22 secs with btrfs, so at least ext4 wins). Th=
e same
> > thing on my spinning drive takes fewer than 4 seconds, and SSD shou=
ld be
> > several times faster than that.
> > SSD throughput was measured over 400MB/s on the raw device and 268M=
B/s
> > through the filesystem:

Was this an identical file system image on HDD and SSD?

The obvious thing to do is to get a blktrace of du -sh w/ a cold cache
for both the HDD and SSD.  Regardless of whether it's something we can
address at the fs level, or in the block device layer, the blktrace
should make it really clear what is going on.

       	       	      	    	    - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
