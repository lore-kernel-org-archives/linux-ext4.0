From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: fix build failure if DX_DEBUG
Date: Wed, 11 Jun 2008 11:03:39 -0500
Message-ID: <484FF75B.8090403@redhat.com>
References: <484F9030.2020800@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbYFKQKJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jun 2008 12:10:09 -0400
In-Reply-To: <484F9030.2020800@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Li Zefan wrote:
> I got build failure when I turned on DX_DEBUG.
>=20
> fs/ext4/namei.c: In function =E2=80=98dx_show_leaf=E2=80=99:
> fs/ext4/namei.c:291: error: implicit declaration of function =E2=80=98=
ext4_next_entry=E2=80=99
> fs/ext4/namei.c:291: warning: assignment makes pointer from integer w=
ithout a cast
>=20
> Move the definition of ext4_next_entry() upwards just as ext3 code.
>=20
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks,  I added this to the bugfix portion of the ext4 patch queue.

-Eric

> ---
>  fs/ext4/namei.c |   19 ++++++++++---------
>  1 files changed, 10 insertions(+), 9 deletions(-)
>=20
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index ab16bea..4315fd7 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -183,6 +183,16 @@ static int ext4_dx_add_entry(handle_t *handle, s=
truct dentry *dentry,
>  			     struct inode *inode);
> =20
>  /*
> + * p is at least 6 bytes before the end of page
> + */
> +static inline struct ext4_dir_entry_2 *
> +ext4_next_entry(struct ext4_dir_entry_2 *p)
> +{
> +	return (struct ext4_dir_entry_2 *)((char *)p +
> +		ext4_rec_len_from_disk(p->rec_len));
> +}
> +
> +/*
>   * Future: use high four bits of block for coalesce-on-delete flags
>   * Mask them off for now.
>   */
> @@ -554,15 +564,6 @@ static int ext4_htree_next_block(struct inode *d=
ir, __u32 hash,
> =20
> =20
>  /*
> - * p is at least 6 bytes before the end of page
> - */
> -static inline struct ext4_dir_entry_2 *ext4_next_entry(struct ext4_d=
ir_entry_2 *p)
> -{
> -	return (struct ext4_dir_entry_2 *)((char *)p +
> -		ext4_rec_len_from_disk(p->rec_len));
> -}
> -
> -/*
>   * This function fills a red-black tree with information from a
>   * directory block.  It returns the number directory entries loaded
>   * into the tree.  If there is an error it is returned in err.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
