From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: add a line break for proc mb_groups display
Date: Wed, 3 Feb 2016 11:32:33 -0800
Message-ID: <20160203193233.GB5842@birch.djwong.org>
References: <1454505546-4875-1-git-send-email-huaitong.han@intel.com>
 <20160203181356.GA5842@birch.djwong.org>
 <1454524232.7291.105.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Huaitong Han <huaitong.han@intel.com>, tytso@mit.edu,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454524232.7291.105.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 03, 2016 at 10:30:32AM -0800, Joe Perches wrote:
> On Wed, 2016-02-03 at 10:13 -0800, Darrick J. Wong wrote:
> > On Wed, Feb 03, 2016 at 09:19:06PM +0800, Huaitong Han wrote:
> > > This patch adds a line break for proc mb_groups display.
>=20
> Using 2 lines for output might break any existing users.
>=20
> Are there any?

It's a multiline file if you have more than one blockgroup; this just m=
akes it
so that you don't have to special-case BG 0.

IOW: mb_groups scripts already had to parse multiple lines, and most li=
kely any
script parsing it would inject a newline after the header.

--D

>=20
> > >=20
> > > Signed-off-by: Huaitong Han <huaitong.han@intel.com>
> > > ---
> > > =A0fs/ext4/mballoc.c | 2 +-
> > > =A01 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > > index 61eaf74..4424b7b 100644
> > > --- a/fs/ext4/mballoc.c
> > > +++ b/fs/ext4/mballoc.c
> > > @@ -2285,7 +2285,7 @@ static int ext4_mb_seq_groups_show(struct s=
eq_file *seq, void *v)
> > > =A0	if (group =3D=3D 0)
> > > =A0		seq_puts(seq, "#group: free=A0=A0frags first ["
> > > =A0			=A0=A0=A0=A0=A0=A0" 2^0=A0=A0=A02^1=A0=A0=A02^2=A0=A0=A02^3=
=A0=A0=A02^4=A0=A0=A02^5=A0=A0=A02^6=A0=A0"
> > > -			=A0=A0=A0=A0=A0=A0" 2^7=A0=A0=A02^8=A0=A0=A02^9=A0=A0=A02^10=A0=
=A02^11=A0=A02^12=A0=A02^13=A0=A0]");
> > > +			=A0=A0=A0=A0=A0=A0" 2^7=A0=A0=A02^8=A0=A0=A02^9=A0=A0=A02^10=A0=
=A02^11=A0=A02^12=A0=A02^13=A0=A0]\n");
> >=20
> > Oh, heh.
> >=20
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> >=20
> > --D
> >=20
> > > =A0
> > > =A0	i =3D (sb->s_blocksize_bits + 2) * sizeof(sg.info.bb_counters=
[0]) +
> > > =A0		sizeof(struct ext4_group_info);
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
