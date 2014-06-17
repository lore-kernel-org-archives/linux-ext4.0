From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure
 FITRIM.
Date: Tue, 17 Jun 2014 08:46:29 -0400
Message-ID: <20140617124629.GA13868@thunk.org>
References: <20140613031538.GR4453@dastard>
 <20140613033029.GS4453@dastard>
 <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com>
 <20140613050703.GT4453@dastard>
 <20140613142054.GA23180@thunk.org>
 <20140613143157.GB23180@thunk.org>
 <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com>
 <20140613234134.GC5036@thunk.org>
 <20140617024953.GG9508@dastard>
 <alpine.LFD.2.00.1406171346570.2148@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chinner <david@fromorbit.com>, JP Abgrall <jpa@google.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42815 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbaFQMqg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jun 2014 08:46:36 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1406171346570.2148@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 17, 2014 at 01:55:26PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> I definitely agree with Dave here it is an ugly API hack. Fallocate
> seems much more suitable for this.
>=20
> New flag FALLOC_FL_ISSUE_DISCARD which would work with
> FALLOC_FL_PUNCH_HOLE, FALLOC_FL_ZERO_RANGE and possibly
> FALLOC_FL_COLLAPSE_RANGE might actually be useful.

I agree it would be useful to have an FL_ISSUE_DISCARD (and while
we're at it, FL_ISSUE_SECDISCARD) as an fallocate flag.  That doesn't
obviate the usefulness of a BLKDISCARD ioctl for ext4 files, though.

Something else that might be useful, and perhaps more appropriate for
the Android use case, is to add a SECDISCARD flag to the unlinkat(2)
system call.  That way, people who want to do a "discard and then
unlink" don't have to be forced to do an open(2), fallocate(2),
close(2), and only *then* the unlink(2) system call.

Cheers,

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
