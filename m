From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Remove useless condition in if statement.
Date: Wed, 1 Apr 2015 09:40:18 +0200
Message-ID: <20150401074018.GA26339@quack.suse.cz>
References: <1426820950-4720-1-git-send-email-weiyuan.wei@huawei.com>
 <alpine.LFD.2.00.1503231130060.1578@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Wei Yuan <weiyuan.wei@huawei.com>, jack@suse.cz,
	akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	lizefan@huawei.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1503231130060.1578@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 23-03-15 11:30:44, Luk=C3=A1=C5=A1 Czerner wrote:
> On Fri, 20 Mar 2015, Wei Yuan wrote:
>=20
> > Date: Fri, 20 Mar 2015 11:09:10 +0800
> > From: Wei Yuan <weiyuan.wei@huawei.com>
> > To: jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.=
ca
> > Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
> >     lczerner@redhat.com, lizefan@huawei.com
> > Subject: [PATCH] ext3: Remove useless condition in if statement.
> >=20
> > In this if statement, the previous condition is useless, the later =
one has covered it.
>=20
> Nice that you've send this ext3 counterpart for ext4 patch. Thanks!
>=20
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
  Thanks. I've added the patch to my tree.

								Honza

>=20
> >=20
> > Signed-off-by: Weiyuan <weiyuan.wei@huawei.com>
> > ---
> >  fs/ext3/xattr.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >=20
> > diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
> > index c6874be..24215dc 100644
> > --- a/fs/ext3/xattr.c
> > +++ b/fs/ext3/xattr.c
> > @@ -546,8 +546,7 @@ ext3_xattr_set_entry(struct ext3_xattr_info *i,=
 struct ext3_xattr_search *s)
> >  		free +=3D EXT3_XATTR_LEN(name_len);
> >  	}
> >  	if (i->value) {
> > -		if (free < EXT3_XATTR_SIZE(i->value_len) ||
> > -		    free < EXT3_XATTR_LEN(name_len) +
> > +		if (free < EXT3_XATTR_LEN(name_len) +
> >  			   EXT3_XATTR_SIZE(i->value_len))
> >  			return -ENOSPC;
> >  	}
> >=20
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
