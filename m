From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] ext4: add a line break for proc mb_groups display
Date: Wed, 03 Feb 2016 10:30:32 -0800
Message-ID: <1454524232.7291.105.camel@perches.com>
References: <1454505546-4875-1-git-send-email-huaitong.han@intel.com>
	 <20160203181356.GA5842@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Huaitong Han <huaitong.han@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160203181356.GA5842@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2016-02-03 at 10:13 -0800, Darrick J. Wong wrote:
> On Wed, Feb 03, 2016 at 09:19:06PM +0800, Huaitong Han wrote:
> > This patch adds a line break for proc mb_groups display.

Using 2 lines for output might break any existing users.

Are there any?

> >=20
> > Signed-off-by: Huaitong Han <huaitong.han@intel.com>
> > ---
> > =A0fs/ext4/mballoc.c | 2 +-
> > =A01 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > index 61eaf74..4424b7b 100644
> > --- a/fs/ext4/mballoc.c
> > +++ b/fs/ext4/mballoc.c
> > @@ -2285,7 +2285,7 @@ static int ext4_mb_seq_groups_show(struct seq=
_file *seq, void *v)
> > =A0	if (group =3D=3D 0)
> > =A0		seq_puts(seq, "#group: free=A0=A0frags first ["
> > =A0			=A0=A0=A0=A0=A0=A0" 2^0=A0=A0=A02^1=A0=A0=A02^2=A0=A0=A02^3=A0=
=A0=A02^4=A0=A0=A02^5=A0=A0=A02^6=A0=A0"
> > -			=A0=A0=A0=A0=A0=A0" 2^7=A0=A0=A02^8=A0=A0=A02^9=A0=A0=A02^10=A0=
=A02^11=A0=A02^12=A0=A02^13=A0=A0]");
> > +			=A0=A0=A0=A0=A0=A0" 2^7=A0=A0=A02^8=A0=A0=A02^9=A0=A0=A02^10=A0=
=A02^11=A0=A02^12=A0=A02^13=A0=A0]\n");
>=20
> Oh, heh.
>=20
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> --D
>=20
> > =A0
> > =A0	i =3D (sb->s_blocksize_bits + 2) * sizeof(sg.info.bb_counters[0=
]) +
> > =A0		sizeof(struct ext4_group_info);
