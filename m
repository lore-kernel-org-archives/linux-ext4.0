From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure
 FITRIM.
Date: Tue, 17 Jun 2014 09:54:05 -0400
Message-ID: <20140617135405.GA5054@thunk.org>
References: <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com>
 <20140613050703.GT4453@dastard>
 <20140613142054.GA23180@thunk.org>
 <20140613143157.GB23180@thunk.org>
 <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com>
 <20140613234134.GC5036@thunk.org>
 <20140617024953.GG9508@dastard>
 <alpine.LFD.2.00.1406171346570.2148@localhost.localdomain>
 <20140617124629.GA13868@thunk.org>
 <alpine.LFD.2.00.1406171449000.2148@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chinner <david@fromorbit.com>, JP Abgrall <jpa@google.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42915 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133AbaFQNyJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jun 2014 09:54:09 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1406171449000.2148@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 17, 2014 at 03:00:40PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> What is the difference between -o discard mount option ? I guess
> that this way you can do it selectively on certain files, but I
> wonder how useful it is going to be anyway ?

Well, it will reduce the amount of flash wear, since a SECDISCARD
requires an immediate copy of the remaining data in the erase block
followed by a erase.  This increases write magnification.

> Nevertheless, I think that there is a conclusion that there is no
> "security" to be had with file system and SECDISCARD. And no secure
> erase with this type of interface would be "secure" enough.

There's an assumption here that the eMMC SECDISCARD functionality is
more competently spec'ed out compared to the ATA/SCSI interface.  I'm
not sure whether or not that's true, but perhaps JP and Geremy can
confirm that.  And even if it isn't guaranteed by the MMC spec, a
mobile handset manufacturer is buying in sufficently large quantities
that they can probably negotiate with their suppliers and demand a
custom firmware which doesn't drop the discard command if the flash
device doesn't feel like it. =20

(There's nothing new about this, by the way.  Very large buyers of
hard drives such as EMC, Amazon, Facebook, etc. do their own
performance and quality control testing, and then have demanded custom
firmware if necessary for a very long time.)

So at least in some specific use cases, it should be possible to make
this to be secure.  And the reason why to call it secure is SECDISCARD
is the term used in the spec.  And if the spec doesn't guarantee it,
we can mock the spec.  :-)

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
