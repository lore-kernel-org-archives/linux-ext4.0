From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: fix online resize with mballoc
Date: Fri, 27 Jun 2008 17:54:28 -0600
Message-ID: <20080627235428.GF6239@webber.adilger.int>
References: <20080626143704.642665893@bull.net>
 <1214492283.10187.17.camel@localhost>
 <20080626232659.GY6239@webber.adilger.int> <1214577410.3257.24.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:44253 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758242AbYF0Xyi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Jun 2008 19:54:38 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m5RNsaan017061
	for <linux-ext4@vger.kernel.org>; Fri, 27 Jun 2008 16:54:37 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K3500I01BDCI200@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 27 Jun 2008 16:54:36 -0700 (PDT)
In-reply-to: <1214577410.3257.24.camel@localhost>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 27, 2008  16:36 +0200, Fr=EF=BF=BDd=EF=BF=BDric Boh=EF=BF=BD wro=
te:
> Le jeudi 26 juin 2008 =C3=A0 17:26 -0600, Andreas Dilger a =C3=A9crit=
 :
> > On Jun 26, 2008  16:58 +0200, Fr=EF=BF=BDd=EF=BF=BDric Boh=EF=BF=BD=
 wrote:
> > > From: Frederic Bohe <frederic.bohe@bull.net>
> > > +	num_meta_group_infos_max =3D num_meta_group_infos +
> > > +				le16_to_cpu(es->s_reserved_gdt_blocks);
> >=20
> > The only drawback of NOT handling this properly is that once (event=
ually)
> > we allow resizing with META_BG this code will be broken again.  It =
at
> > least deserves a comment like "Need to handle this properly when ME=
TA_BG
> > resizing is allowed" so that it will show up on any grep for META_B=
G.
> >=20
> > It probably also makes sense to round this up to the next power-of-=
two
> > value, since kmalloc will do that internally anyways, and it gives =
us
> > some resizing headroom for no cost.
>=20
> Do you have any idea of how this headroom could be used in the future=
 ?

=46or e.g. resize with META_BG, which does not need new reserved blocks
to be added.  Since the space is already allocated because of kmalloc
use of 2^n slab size, we may as well make it "available" even if it isn=
't
used.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
