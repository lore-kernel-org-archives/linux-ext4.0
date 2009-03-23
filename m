From: Theodore Tso <tytso@mit.edu>
Subject: Re: Severe data corruption with ext4
Date: Mon, 23 Mar 2009 08:17:09 -0400
Message-ID: <20090323121709.GD13368@mit.edu>
References: <20090320030121.1fa8e6d3.akpm@linux-foundation.org> <b2080d80903220626s5fffdbf3i907cb4b215670ce6@mail.gmail.com> <b2080d80903200244u7fbcc150g6724a84c9b3b2054@mail.gmail.com> <20090323020522.GF29466@mit.edu> <b2080d80903230210w60d48530n9b98fdf71cf6fd18@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Richard <richard@r-selected.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:41405 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229AbZCWMRO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Mar 2009 08:17:14 -0400
Content-Disposition: inline
In-Reply-To: <b2080d80903230210w60d48530n9b98fdf71cf6fd18@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 23, 2009 at 10:10:43AM +0100, Richard wrote:
> > That's another indication of data corruption in inode 1022. =A0This
> > could be hardware induced corruption; or it could be a software
> > induced error. =A0There's been one other user with a RAID that had
> > reported a strange corruption near the beginning of the filesystem,=
 in
> > the inode table. =A0How big is your filesystem, exactly?
>=20
> 5,158,556 K.

OK, so about 5 gigs; not all that big at all.  I was starting to worry
that maybe we had some 32-bit signed/unsigned problem, but that would
be showing up in the 8+ TB range.

> Attached, as well as the itable image.

I've analyzed the itable image, and it looks valid; in particular, I
didn't see any evidence of corruption in inode 1022.

>=20
> By the way, yesterday's fsck on another file system (/home) placed
> almost 8,500 (!) files and directories in lost+found. I have not a
> single error message regarding this device in my log files. All
> files/directories were originally placed in the same parent directory=
=2E

There is something very wrong going on here, and I'm at a loss why no
one else is reporting anything like what you are seeing.

Are you able to run a stock, unmodified mainline kernel on your
system?  At this point I'd really like to see if the problems you are
seeing can be replicated with a stock 2.6.29-rc8 kernel.

       	      		      	      - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
