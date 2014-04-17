From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH 2/3] ext4: fix ZERO_RANGE test failure in data journalling
 mode
Date: Thu, 17 Apr 2014 19:52:09 +0900
Message-ID: <008501cf5a2b$14b6c690$3e2453b0$@samsung.com>
References: <002a01cf59c3$4eaf7490$ec0e5db0$@samsung.com>
 <alpine.LFD.2.00.1404171051040.2143@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: 'Theodore Ts'o' <tytso@mit.edu>,
	'linux-ext4' <linux-ext4@vger.kernel.org>
To: =?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:29947 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbaDQKwL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Apr 2014 06:52:11 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N4600D878UXIL30@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Thu, 17 Apr 2014 19:52:09 +0900 (KST)
In-reply-to: <alpine.LFD.2.00.1404171051040.2143@localhost.localdomain>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>=20
> On Thu, 17 Apr 2014, Namjae Jeon wrote:
>=20
> > Date: Thu, 17 Apr 2014 07:29:18 +0900
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> > To: Theodore Ts'o <tytso@mit.edu>
> > Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
> >     Luk=E1=B9 Czerner <lczerner@redhat.com>
> > Subject: [PATCH 2/3] ext4: fix ZERO_RANGE test failure in data jour=
nalling
> >     mode
> >
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> >
> > xfstests generic/091 is failing when mounting ext4 with data=3Djour=
nal.
> > I think that this regression is same problem that occurred prior to=
 collapse
> > range issue. So ZERO RANGE also need to call ext4_force_commit as
> > collapse range.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > ---
> >  fs/ext4/extents.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index f386dd6..a64242f 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -4742,6 +4742,13 @@ static long ext4_zero_range(struct file *fil=
e, loff_t offset,
> >
> >  	trace_ext4_zero_range(inode, offset, len, mode);
> >
> > +	/* Call ext4_force_commit to flush all data in case of data=3Djou=
rnal. */
> > +	if (ext4_should_journal_data(inode)) {
> > +		ret =3D ext4_force_commit(inode->i_sb);
> > +		if (ret)
> > +			return ret;
> > +	}
>=20
> Hi,
Hi Lukas.
>=20
> it makes sense. But I have a question, maybe I do not understand it
> correctly but what protect us from other writes coming in after we
> force the commit ?
Yes, Currently new write can come between ext4_force_commit and till
we acquire mutex_lock. But this window is already present even
without patch. Its just that in case of data=3Djournal mode, this
window will become slightly bigger. one possible solution coming to
my mind is one more time calling ext4_force_commit followed by a call
to filemap_write_and_wait_range inside mutex_lock which would sync
data that has dirtied after 1st call.

Thanks!
>=20
> -Lukas
>=20
> > +
> >  	/*
> >  	 * Write out all dirty pages to avoid race conditions
> >  	 * Then release them.
> >

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
