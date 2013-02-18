From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Large buffer cache in EXT4
Date: Mon, 18 Feb 2013 14:16:24 +0100
Message-ID: <201302181416.24599.Martin@lichtvoll.de>
References: <CAEUQcegw=gq9ndo=Zd4xC2gJDZrRzNpS2hAZW9x5Lh=KL_YDHQ@mail.gmail.com> <201302171125.40116.Martin@lichtvoll.de> <20130218043517.GB10361@thunk.org> (sfid-20130218_094303_618638_F73771F3)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Subranshu Patel <spatel.ml@gmail.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34150 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab3BRNQ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Feb 2013 08:16:28 -0500
In-Reply-To: <20130218043517.GB10361@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Montag, 18. Februar 2013 schrieb Theodore Ts'o:
> On Sun, Feb 17, 2013 at 11:25:39AM +0100, Martin Steigerwald wrote:
> > What I never really understand was what is the clear distinction
> > between dirty pages and disk block buffers. Why isn=B4t anything th=
at is
> > about to be written to disk in one cache?
>=20
> The buffer cache is indexed by physical block number, and each buffer
> in the buffer cache is the size of the block size used for I/O to the
> device.
>=20
> The page cache is indexed by <inode, page frame number>, and each pag=
e
> is the size of a VM page (i.e.4k for x86 systems, 16k for Power
> systems, etc.)
>=20
> Certain file systems, including ext3, ext4, and ocfs2, use the jbd or
> jbd2 layer to handle their physical block journalling, and this layer
> fundamentally uses the buffer cache, since it is concerned with
> controlling when specific file system blocks are allowed to ben
> written back to the hard drive.

Thank you for the explanation, Ted.

--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
