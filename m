From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: fix return values on parse_options() failure
Date: Tue, 9 Oct 2012 23:24:20 +0200
Message-ID: <20121009212420.GB27882@quack.suse.cz>
References: <5073BABF.8090206@gmail.com>
 <alpine.LFD.2.00.1210090814420.11244@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Zhao Hongjiang <zhaohongjiang37@gmail.com>, jack@suse.cz,
	akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	serge.hallyn@canonical.com, containers@lists.linux-foundation.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756823Ab2JIVYW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Oct 2012 17:24:22 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1210090814420.11244@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 09-10-12 08:19:42, Luk=C3=A1=C5=A1 Czerner wrote:
> On Tue, 9 Oct 2012, Zhao Hongjiang wrote:
>=20
> > Date: Tue, 09 Oct 2012 13:48:47 +0800
> > From: Zhao Hongjiang <zhaohongjiang37@gmail.com>
> > To: jack@suse.cz
> > Cc: akpm@linux-foundation.org, adilger.kernel@dilger.ca,
> >     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
> >     Eric W. Biederman <ebiederm@xmission.com>, serge.hallyn@canonic=
al.com,
> >     containers@lists.linux-foundation.org
> > Subject: [PATCH] ext3: fix return values on parse_options() failure
> >=20
> > From: Zhao Hongjiang <zhaohongjiang@huawei.com>
> >=20
> > parse_options() in ext3 should return 0 when parse the mount option=
s fails.
> >=20
>=20
> Ah, it really is a joy to read the parse_options() :). But this fix
> makes sense, thanks for catching it.
>=20
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
  Thanks, added to my tree.

									Honza
>=20
> -Lukas
>=20
> > Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
> > ---
> >  fs/ext3/super.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> > index 17ae5c8..ebf8312 100644
> > --- a/fs/ext3/super.c
> > +++ b/fs/ext3/super.c
> > @@ -1001,7 +1001,7 @@ static int parse_options (char *options, stru=
ct super_block *sb,
> >  			uid =3D make_kuid(current_user_ns(), option);
> >  			if (!uid_valid(uid)) {
> >  				ext3_msg(sb, KERN_ERR, "Invalid uid value %d", option);
> > -				return -1;
> > +				return 0;
> >=20
> >  			}
> >  			sbi->s_resuid =3D uid;
> > @@ -1012,7 +1012,7 @@ static int parse_options (char *options, stru=
ct super_block *sb,
> >  			gid =3D make_kgid(current_user_ns(), option);
> >  			if (!gid_valid(gid)) {
> >  				ext3_msg(sb, KERN_ERR, "Invalid gid value %d", option);
> > -				return -1;
> > +				return 0;
> >  			}
> >  			sbi->s_resgid =3D gid;
> >  			break;
> > -- 1.7.1
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
