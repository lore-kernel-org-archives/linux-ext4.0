From: Jan Kara <jack@suse.cz>
Subject: Re: [Ext4 punch hole 1/6 v5] Ext4 Punch Hole Support: Add flag to
 ext4_has_free_blocks
Date: Thu, 28 Apr 2011 14:08:59 +0200
Message-ID: <20110428120859.GA1696@quack.suse.cz>
References: <4DAD3C98.3050308@linux.vnet.ibm.com>
 <BANLkTi=1PEcextZ03RXXHixzHtav1m2tfQ@mail.gmail.com>
 <BANLkTi=kX8Roeq1oDUqqYp76ihNfsrLKSg@mail.gmail.com>
 <BANLkTinPejmzuWukBLFj__NDdAoq+uwphg@mail.gmail.com>
 <4DB88012.8010305@linux.vnet.ibm.com>
 <BANLkTinb9MpjMRAoOhUi-TG1zJVJKkm19g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39508 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab1D1MJC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Apr 2011 08:09:02 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTinb9MpjMRAoOhUi-TG1zJVJKkm19g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 28-04-11 09:28:53, Amir Goldstein wrote:
> On Wed, Apr 27, 2011 at 11:44 PM, Allison Henderson
> <achender@linux.vnet.ibm.com> wrote:
> > On 4/25/2011 10:44 AM, Amir Goldstein wrote:
> > Hi All,
> >
> > I did some looking around with the idea of using an allocation_requ=
est
> > instead of a flags parameter, but I noticed that ext4_new_meta_bloc=
ks is
> > already setting up an allocation_request to pass to ext4_mb_new_blo=
cks.
> > =A0Would it make sense then that we add an "ar_flags" parameter ins=
tead of a
> > "flag" or another "ar" parameter? =A0That way, ext4_new_meta_blocks=
 can just
> > add the flags to the ar that it already has, and we wouldn't have t=
o change
> > the ext4_mb_new_blocks parameters. =A0And then USE_ROOTBLKS can be =
added on to
> > the EXT4_MB_HINT scheme instead of starting a new scheme. =A0That w=
ould avoid
> > the extra ar initializing. What does everybody think? =A0Would this=
 work for
> > the HINT_COWING flag?
>=20
> I think this would be perfect.
> ext4_new_meta_blocks() is not much more than a helper to setup the ar=
 struct,
> so passing 'flags' (in that context I see no reason to call it
> ar_flags) to it makes sense.
> The important thing is that USE_ROOTBLKS is added to the EXT4_MB_HINT=
 scheme
> and passed all the way down to has_free_blocks with the 'ar' struct.
>=20
> This discussion makes me wonder (CC'ing Jan and Eric for that), wasn'=
t
> there ever an intention
> to allow the use of reserved space for allocation of any metadata blo=
cks?
  Not that I know of.

> The use case is delayed allocation combined with async mmap writes.
> Do we always account for enough metadata blocks when doing delayed al=
location?
> Both for extent and indirect mapped files?
  Yes, both should make appropriate upper estimates on the number of ne=
eded
blocks and reserve that amount. With indirect blocks it's kind of trick=
y
but the code should be correct.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
