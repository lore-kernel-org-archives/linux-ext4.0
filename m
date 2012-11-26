From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/6] libext2fs: optimize rb_get_bmap_range() for mostly
 allocated bmaps
Date: Mon, 26 Nov 2012 09:17:33 -0500
Message-ID: <20121126141733.GD31891@thunk.org>
References: <1353803794-11593-1-git-send-email-tytso@mit.edu>
 <1353803794-11593-6-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1211261152260.18234@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34825 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab2KZORh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Nov 2012 09:17:37 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1211261152260.18234@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 26, 2012 at 12:22:42PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > +		if (pos > start+num)
>=20
> Missing spacing around '+'.

I'll fix all of the spacing comments, thanks.

> Also I think that the condition should rather be:
>=20
> 		if (pos >=3D start + num)

Yes.  I believe the case where pos =3D start + num gets caught later on
when we check the count variable, but it's cleaner/faster to bail out
here.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
