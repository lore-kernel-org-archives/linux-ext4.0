From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ext4_has_free_blocks always checks cap_sys_resource and makes
	SELinux unhappy
Date: Fri, 24 Oct 2008 12:00:36 -0700
Message-ID: <1224874836.6379.3.camel@mingming-laptop>
References: <1224860735.3404.74.camel@localhost.localdomain>
	 <4901FE29.3090600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Paris <eparis@redhat.com>, linux-ext4@vger.kernel.org,
	selinux@tycho.nsa.gov, sds@tycho.nsa.gov, esandeen@redhat.com,
	tytso@mit.edu, dwalsh@redhat.com,
	linux-security-module@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:56911 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbYJXTAw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Oct 2008 15:00:52 -0400
In-Reply-To: <4901FE29.3090600@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-10-24=E4=BA=94=E7=9A=84 11:56 -0500=EF=BC=8CEric Sandeen=
=E5=86=99=E9=81=93=EF=BC=9A
> Eric Paris wrote:
> > I'm running an ext4 root filesystem and regularly get SELinux denia=
ls
> > like:
> >=20
> > Oct 16 08:32:55 localhost kernel: type=3D1400 audit(1224160369.076:=
5):
> > avc: denied  { sys_resource } for  pid=3D1624 comm=3D"dbus-daemon"
> > capability=3D24 scontext=3Dsystem_u:system_r:system_dbusd_t:s0
> > tcontext=3Dsystem_u:system_r:system_dbusd_t:s0 tclass=3Dcapability
> >=20
> > https://bugzilla.redhat.com/show_bug.cgi?id=3D467216
> >=20
> > Since this doesn't happen with people who have ext3 filesystems but
> > everything else the same it lead me to look at ext4.  I see that
> > ext?_has_free_blocks() has changed since ext3 and now we always che=
ck
> > for capable(CAP_SYS_RESOUCE).  If a process actually has the capabi=
lity
> > in pE (as many root processes would) but doesn't have the capabilit=
y in
> > SELinux policy we will get a denial.
> >=20
> > I can think of a couple ways to fix this:
> >=20
> > the first (and one I like) is to change ext4 to stop checking
> > CAP_SYS_RESOURCE all the time.  It's not really 'pretty' but I thin=
k you
> > would actually get a better performing function.  Just always calcu=
late
> > root_blocks and if we don't have enough room then then do the whole
> > check to see if are root and recalculate without root_blocks.  I'd =
guess
> > that a great majority of the time operations will succeed even with=
 a
> > non-zero root_blocks and I would guess that most process aren't goi=
ng to
> > be root processes and so we would be calculating root_blocks anyway=
=2E
> > This would (like ext3) only cause these denials when it was filled =
up.
> > We've been living with that forever, so I don't see a problem there=
=2E..
>=20
> Thanks Eric, I'll look into this.  It seems that ext4_has_free_blocks=
 is
> now overly complex; it used to return how many blocks are available, =
if
> that number is < nblocks, but the single caller now only checks
> success/failure for having nblocks free.  I'll see if I can simplify =
it
> and delay the cap check as you suggest.
>=20

Most functionality in ext4_has_free_blocks()  is duplicated in
ext4_claim_free_blocks(). I guess the ext4_has_free_blocks() could be
simplified a bit, or the two functional merge into one.

The delay cap check sounds right thing to me.

Mingming

> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
