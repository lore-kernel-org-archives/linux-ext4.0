From: Coly Li <colyli@gmail.com>
Subject: Re: [PATCH 1/2] ext4: Fix compilation with -DDX_DEBUG
Date: Sat, 18 Jun 2011 02:29:12 +0800
Message-ID: <4DFB9CF8.60208@gmail.com>
References: <20110617160055.2062012.47590.stgit@localhost.localdomain>
Reply-To: colyli@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:34803 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755220Ab1FQS1V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jun 2011 14:27:21 -0400
In-Reply-To: <20110617160055.2062012.47590.stgit@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011=E5=B9=B406=E6=9C=8818=E6=97=A5 00:00, Bernd Schubert Wrote:
> From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
>=20
> Compilation of ext4/namei.c brought up an error and warning messages
> when compiled with -DDX_DEBUG
>=20
>=20
> Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
> ---
>  fs/ext4/namei.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index b754b77..6f32da4 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -288,8 +288,8 @@ static struct stats dx_show_leaf(struct dx_hash_i=
nfo *hinfo, struct ext4_dir_ent
>  				char *name =3D de->name;
>  				while (len--) printk("%c", *name++);
>  				ext4fs_dirhash(de->name, de->name_len, &h);
> -				printk(":%x.%u ", h.hash,
> -				       ((char *) de - base));
> +				printk(":%x.%ld ", h.hash,
> +				       (long) ((char *) de - base));
>  			}

How about use %p in printk like
> +				printk(":%x.%p ", h.hash,
> +				       ((char *) de - base));



>  			space +=3D EXT4_DIR_REC_LEN(de->name_len);
>  			names++;
> @@ -1013,7 +1013,7 @@ static struct buffer_head * ext4_dx_find_entry(=
struct inode *dir, const struct q
> =20
>  	*err =3D -ENOENT;
>  errout:
> -	dxtrace(printk(KERN_DEBUG "%s not found\n", name));
> +	dxtrace(printk(KERN_DEBUG "%s not found\n", d_name->name));

Nice catch :-)

[snip]
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
