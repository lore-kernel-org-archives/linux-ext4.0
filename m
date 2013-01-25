From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: call WARN_ON after the debug message
Date: Fri, 25 Jan 2013 10:09:48 -0500
Message-ID: <20130125150948.GK28908@thunk.org>
References: <1359045044-31435-1-git-send-email-lczerner@redhat.com>
 <20130124195458.GD9477@thunk.org>
 <alpine.LFD.2.00.1301251012200.20753@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45471 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932453Ab3AYPJv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jan 2013 10:09:51 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1301251012200.20753@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 25, 2013 at 10:22:44AM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> we can get the EIO error from ext4_map_blocks not only in the case
> of hardware error. The extent tree might not be in consistent state,
> or we could even ask for blocks outside the file system itself (I
> believe I've seen this before) and I think that in those cases it
> might be worth to all WARN_ON.

Sure, but in those cases, the file system is corrupt, and we should
have thrown an ext4_error() in ext4_map_blocks().  The point is that a
WARN_ON is only useful if there is a potential programming bug.  If we
know for sure that it's caused by a file system corruption, then we
don't want to throw a WARN_ON.

Even if there is a kerneloops.org replacement --- in fact, especially
if there is kerneloops.org replacement --- we only want to throw
WARN_ON's in cases where it's just a pedestrian file system
corruption.  Otherwise we'll end up wasting a lot of time chasing down
something which was caused by a hardware error, and needing to calm
down users (and breathless, spectacularizing, irresponsible journalism
from web sites such as Phoronix).

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
