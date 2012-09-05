From: Marc MERLIN <marc@merlins.org>
Subject: Re: ext4 crash with 3.5.2 in ext4_ext_remove_space
Date: Wed, 5 Sep 2012 10:53:02 -0700
Message-ID: <20120905175302.GH6955@merlins.org>
References: <20120725154521.GA3398@merlins.org> <alpine.LFD.2.00.1207252023080.4340@(none)> <20120726033223.GA5884@thunk.org> <20120726065412.GB20315@merlins.org> <20120801053042.GG12695@merlins.org> <20120816075004.GE8802@merlins.org> <502CC2A2.4010506@shiftmail.org> <20120816175540.GH8802@merlins.org> <20120905165210.GD6955@merlins.org> <alpine.LFD.2.00.1209051349470.509@new-host-2>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52864 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab2IERxE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Sep 2012 13:53:04 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1209051349470.509@new-host-2>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 05, 2012 at 01:50:54PM -0400, Luk=C3=A1=C5=A1 Czerner wrote=
:
> Hi,
>=20
> I believe that this has been fixed with v3.6-rc1-5-g89a4e48 and it
> was marked for stable release as well.

Cool, thanks for letting me know.

I'll keep the e2image on hand just in case, and just fsck the filesyste=
m
before mounting it.

Thanks,
Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - =
A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet=
 cooking
Home page: http://marc.merlins.org/ =20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
