From: Jan Kara <jack@suse.cz>
Subject: Re: Failure in quotaon with kernel 2.6.39 (Was: Regression with
 ext4 in kernel 2.6.39-rc7?)
Date: Thu, 26 May 2011 16:58:46 +0200
Message-ID: <20110526145845.GD5123@quack.suse.cz>
References: <BANLkTinumSvCD8PJPaC5XK24RMSAbm7WXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39964 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757385Ab1EZO6r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 May 2011 10:58:47 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTinumSvCD8PJPaC5XK24RMSAbm7WXg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 26-05-11 16:01:00, Amir Goldstein wrote:
> On Mon, May 16, 2011 at 12:59 PM, Amir Goldstein <amir73il@gmail.com>=
 wrote:
> > On Mon, May 16, 2011 at 12:43 PM, Jan Kara <jack@suse.cz> wrote:
> >>
> >> =A0Exactly, that is it. I cannot trigger the problem anymore with =
the patch.
> >> I just wonder how come you've spotted the problem because test 232=
 does not
> >> trigger the problem for me -
> >
> > It does not surprise me.
> > As I wrote earlier, my system (Ubuntu 11.4) is behaving strange.
> > Some tests fail the fsck at the end, because the filesystem fails t=
o umount
> > immediately after the test (lsof shows nothing and manual umount su=
cceeds).
> > It's probably the cause for 232 test to fail (even after the crash =
was fixed)
> > and the cause for quotaoff to be called without quotaon in test 232=
 on
> > my system.
> >
> >> it is triggered when you run quotaoff without
> >> running quotaon and that does not happen with test 232.. Anyway, w=
ith the
> >> attached patch running quotaoff on filesystem without quotas turne=
d on
> >> works fine whereas previously it oopsed.
>=20
> So my quota tests (219 and 232) still fail (zero output from repquota=
)
> and I realized 2 things:
>=20
> 1. they don't fail with kernel 2.6.38 (Ubuntu 11.4 shipped kernel)
>=20
> 2. what seems to fail is quotaon:
>=20
> amir@qalab:~/xfstests$ sudo quotaon /mnt/test/scratch
> quotaon: using /mnt/test/scratch/aquota.user on /dev/sda8
> [/mnt/test/scratch]: No such process
> quotaon: Quota format not supported in kernel.
  Hum, how about that you forgot to configure kernel with quota support=
 as
the message suggests? Or that you forgot to enable appropriate quota fo=
rmat
or forgot to load the module (if compiled as such)?

> Which also explains why quotaoff was called without quotaon in my
> original bug report.
>=20
> amir@qalab:~/xfstests$ quotaon -V
> Quota utilities version 4.00-pre1.
> Compiled with: USE_LDAP_MAIL_LOOKUP EXT2_DIRECT HOSTS_ACCESS
> ALT_FORMAT RPC RPC_SETQUOTA BSD_BEHAVIOUR
> Bugs to jack@suse.cz

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
