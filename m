From: Jan Kara <jack@suse.cz>
Subject: Re: Possible ext3 corruption with 1K block size
Date: Thu, 18 Dec 2008 19:12:49 +0100
Message-ID: <20081218181249.GD6797@atrey.karlin.mff.cuni.cz>
References: <200810150724.42180.arvidjaar@mail.ru> <48F5E6D4.8080603@redhat.com> <200810151824.36119.arvidjaar@mail.ru> <48F601A5.1050405@redhat.com> <1224164860.11578.14.camel@plop> <48F751E9.8070705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pascal Terjan <pterjan@mandriva.com>,
	Andrey Borzenkov <arvidjaar@mail.ru>, pterjan@mandriva.org,
	linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40694 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYLRSMv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Dec 2008 13:12:51 -0500
Content-Disposition: inline
In-Reply-To: <48F751E9.8070705@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Eric,

> Pascal Terjan wrote:
> > Le mercredi 15 octobre 2008 =C3=A0 09:43 -0500, Eric Sandeen a =C3=A9=
crit :
> >> Andrey Borzenkov wrote:
> >>> On Wednesday 15 October 2008, Eric Sandeen wrote:
> >>
> >>>> My kingdom for a testcase... does anyone have simple steps to re=
produce
> >>>> this?  Or do they all start with "install mandriva on a 1k block=
 size
> >>>> system?"  :)
> >>>>
> >>> May be RH will do? :)
> >> I did try a 1k-block root fs Fedora install, and didn't see any pr=
oblems...
> >>
> >>> As indicated by last comment, Pascal has some ways to trigger it;=
 I
> >>> forgot to Cc to him initially; doing it now.
> >> Ok, good deal.
> >>
> >=20
> > On my test machine I reproduce it easily : rpm --rebuilddb and if t=
he db
> > is not detected to be corrupted yet it will be after installing a f=
ew
> > packages (tested again with 2.6.27).
> >=20
> > If I do the rebuilddb on a 2.6.17 and then reboot on a recent kerne=
l,
> > then I can install/uninstall thousands of packages without any
> > corruption.
>=20
> so it seems to be the database rebuilding, under a recent kernel, whi=
ch
> causes the problem?  installing under a recent kernel is ok, as long =
as
> the db was created on an older kernel?
>=20
> Ok that's a good clue...
  Have you been able to track this down? Anything interesting?

								Honza
--=20
Jan Kara <jack@suse.cz>
SuSE CR Labs
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
