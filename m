From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/2] ext4: Explicitly inform user about orphan list cleanup.
Date: Thu, 18 Sep 2014 13:30:36 +0400
Message-ID: <87egv9tgw3.fsf@openvz.org>
References: <1410698337-27454-1-git-send-email-dmonakhov@openvz.org> <1410698337-27454-2-git-send-email-dmonakhov@openvz.org> <20140918042907.GD24887@thunk.org> <alpine.LFD.2.00.1409181048460.3870@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:60294 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230AbaIRJal convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Sep 2014 05:30:41 -0400
Received: by mail-la0-f44.google.com with SMTP id q1so752519lam.17
        for <linux-ext4@vger.kernel.org>; Thu, 18 Sep 2014 02:30:39 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1409181048460.3870@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 18 Sep 2014 10:49:56 +0200 (CEST), Luk=C3=A1=C5=A1 Czerner <lcz=
erner@redhat.com> wrote:
> On Thu, 18 Sep 2014, Theodore Ts'o wrote:
>=20
> > Date: Thu, 18 Sep 2014 00:29:07 -0400
> > From: Theodore Ts'o <tytso@mit.edu>
> > To: Dmitry Monakhov <dmonakhov@openvz.org>
> > Cc: linux-ext4@vger.kernel.org
> > Subject: Re: [PATCH 2/2] ext4: Explicitly inform user about orphan =
list
> >     cleanup.
> >=20
> > On Sun, Sep 14, 2014 at 04:38:57PM +0400, Dmitry Monakhov wrote:
> > > Production fs likely compiled/mounted w/o jbd debugging, so orpha=
n list clearing
> > > will be silent.
> > >=20
> > > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> >=20
> > Thanks, applied.
>=20
> Hmm did not we just take this out recently with
>=20
> 566370a2e56837be98bc62d012fc2d2d11851db4 ext4: suppress ext4 orphan
> messages on mount
The message I want to change appears only if file system contains
errors. So IMHO this is reasonable to make this message louder.
This is important because after orphan list will be directly cleared
later fsck will complain about incorrect dtime and corrupted orphan lis=
t.
Sane administrator should investigate why this happen. So leaving
precise message in /var/log/messages is good practice from our side.
>=20
> and TBH I like it that way.
>=20
> Thanks!
> -Lukas
>=20
> >=20
> > 					- Ted
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
