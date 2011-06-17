From: Coly Li <colyli@gmail.com>
Subject: Re: [PATCH 2/2] ext4 directory index: read-ahead blocks
Date: Sat, 18 Jun 2011 02:44:11 +0800
Message-ID: <4DFBA07B.6090001@gmail.com>
References: <20110617160055.2062012.47590.stgit@localhost.localdomain> <20110617160100.2062012.50927.stgit@localhost.localdomain>
Reply-To: colyli@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:59707 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932141Ab1FQSmM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jun 2011 14:42:12 -0400
In-Reply-To: <20110617160100.2062012.50927.stgit@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011=E5=B9=B406=E6=9C=8818=E6=97=A5 00:01, Bernd Schubert Wrote:
> While creating files in large directories we noticed an endless numbe=
r
> of 4K reads. And those reads very much reduced file creation numbers
> as shown by bonnie. While we would expect about 2000 creates/s, we
> only got about 25 creates/s. Running the benchmarks for a long time
> improved the numbers, but not above 200 creates/s.
> It turned out those reads came from directory index block reads
> and probably the bh cache never cached all dx blocks. Given by
> the high number of directories we have (8192) and number of files req=
uired
> to trigger the issue (16 million), rather probably bh cached dx block=
s
> got lost in favour of other less important blocks.
> The patch below implements a read-ahead for *all* dx blocks of a dire=
ctory
> if a single dx block is missing in the cache. That also helps the LRU
> to cache important dx blocks.
>=20
> Unfortunately, it also has a performance trade-off for the first acce=
ss to
> a directory, although the READA flag is set already.
> Therefore at least for now, this option is disabled by default, but m=
ay
> be enabled using 'mount -o dx_read_ahead' or 'mount -odx_read_ahead=3D=
1'
>=20
> Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
> ---

A question is, is there any performance number for dx dir read ahead ?
My concern is, if buffer cache replacement behavior is not ideal, which=
 may replace a dx block by other (maybe) more hot
blocks, dx dir readahead will introduce more I/Os. In this case, we may=
 focus on exploring why dx block is replaced out
of buffer cache, other than using dx readahead.


[snip]
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 6f32da4..78290f0 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -334,6 +334,35 @@ struct stats dx_show_entries(struct dx_hash_info=
 *hinfo, struct inode *dir,
>  #endif /* DX_DEBUG */
> =20
>  /*
> + * Read ahead directory index blocks
> + */
> +static void dx_ra_blocks(struct inode *dir, struct dx_entry * entrie=
s)
> +{
> +	int i, err =3D 0;
> +	unsigned num_entries =3D dx_get_count(entries);
> +
> +	if (num_entries < 2 || num_entries > dx_get_limit(entries)) {
> +		dxtrace(printk("dx read-ahead: invalid number of entries\n"));
> +		return;
> +	}
> +
> +	dxtrace(printk("dx read-ahead: %d entries in dir-ino %lu \n",
> +			num_entries, dir->i_ino));
> +
> +	i =3D 1; /* skip first entry, it was already read in by the caller =
*/
> +	do {
> +		struct dx_entry *entry;
> +		ext4_lblk_t block;
> +
> +		entry =3D entries + i;
> +
> +		block =3D dx_get_block(entry);
> +		err =3D ext4_bread_ra(dir, dx_get_block(entry));
> +		i++;
> +	 } while (i < num_entries && !err);
> +}
> +


I see sync reading here (CMIIW), this is performance killer. An async b=
ackground reading ahead is better.

[snip]

Thanks.

Coly
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
