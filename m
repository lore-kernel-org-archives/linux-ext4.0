From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 dev branch: mutex not locked in ext4_truncate()
Date: Wed, 3 Apr 2013 13:58:18 -0400
Message-ID: <20130403175818.GA18661@thunk.org>
References: <alpine.LFD.2.00.1304031503470.10110@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58994 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760080Ab3DCR6W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Apr 2013 13:58:22 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1304031503470.10110@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 03, 2013 at 04:41:01PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> Hi Ted,
>=20
> there is a problem with your patch:
>=20
> 32d90a241a44d22ebc5289d2a2561691fc2d1351
>=20
> because there is one more case where we might call ext4_truncate()
> without i_mutex locked - from ext4_symlink(). Because we might be
> calling __page_symlink() and it will call ext4_write_begin(). In
> possible error case (ENOSPC for example) we might want to truncate
> everything which might have been instantiated past i_size, however
> at that point we're not holding i_mutex because there is no point in
> doing so - the inode can not be possibly held by anyone else.
>=20
> My proposal is to only check whether the mutex is locked if the
> inode is _not_ new or is _not_ being freed.
>=20
> There is a quick&dirty patch and it seems to be working well so
> far. Let me know if you prefer standalone patch, or if you'll
> include it into your commit.

I really like your approach.  We've been trying a number of other
approaches, including

      http://patchwork.ozlabs.org/patch/232914/
and
      http://patchwork.ozlabs.org/patch/231679/

but I think your suggestion is the best.

Thanks!!

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
