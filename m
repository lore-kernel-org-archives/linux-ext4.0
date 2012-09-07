From: Marc MERLIN <marc@merlins.org>
Subject: Re: ext4 crash with 3.5.2 in ext4_ext_remove_space
Date: Fri, 7 Sep 2012 08:51:09 -0700
Message-ID: <20120907155109.GB16562@merlins.org>
References: <20120726065412.GB20315@merlins.org> <20120801053042.GG12695@merlins.org> <20120816075004.GE8802@merlins.org> <502CC2A2.4010506@shiftmail.org> <20120816175540.GH8802@merlins.org> <20120905165210.GD6955@merlins.org> <alpine.LFD.2.00.1209051349470.509@new-host-2> <20120906042426.GC26051@merlins.org> <20120907151942.GA16562@merlins.org> <alpine.LFD.2.00.1209071139320.18459@new-host-2>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48492 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2IGPvK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Sep 2012 11:51:10 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1209071139320.18459@new-host-2>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 07, 2012 at 11:39:53AM -0400, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > Would you happen to have a link to the patch, I had this crash agai=
n, I'd
> > like to check if it's in 3.5.3 or apply it myself to stop further c=
rashes.
> >=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dco=
mmit;h=3D89a4e48f8479f8145eca9698f39fe188c982212f

Cool, I just confirmed it's in 3.5.3 already.

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
