From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] mke2fs: check for a partition table and warn if
 present
Date: Mon, 5 May 2014 09:58:04 -0400
Message-ID: <20140505135804.GC22287@thunk.org>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu>
 <1399295044-24489-3-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1405051549310.2223@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49771 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932739AbaEEN6H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 09:58:07 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405051549310.2223@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 05, 2014 at 03:52:05PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > +	ret =3D check_partition_table(device);
>=20
> This can be actually used to check more than just partitions. So we
> can use this approach to check for all rather than having separate
> checks for file system signatures and partitions.

The issue is that e2fsprogs gets compiled for systems other than just
Linux.  I don't want to be like the assholes who work on systemd and
GNOME that simply screw over *BSD systems.  This is why I keep our
internal version of blkid in e2fsprogs, even if I do plan to use the
system blkid by default for 1.43.

If I had infinite amounts of free time, I'd backport the the new
blkid_probe interfaces to our internal version of blkid, but since I
don't, I prefer use the old interfaces for blkid as much as possible,
since that's the path of least resistance in terms of continuing to
support non-Linux users of e2fsprogs.

> Also in your check_partition_table() you do not disable probing for
> supeblocks even though you do not look to them afterwards so it's
> not a big deal. But again I think that we can use it to check for
> all signatures.

How do you disable probing for superblocks with the new blkid interface=
?

Cheers,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
