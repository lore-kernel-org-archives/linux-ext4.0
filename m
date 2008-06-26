From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: fix online resize with mballoc
Date: Thu, 26 Jun 2008 17:26:59 -0600
Message-ID: <20080626232659.GY6239@webber.adilger.int>
References: <20080626143704.642665893@bull.net>
 <1214492283.10187.17.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:64514 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbYFZX1D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Jun 2008 19:27:03 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m5QNR1i4018575
	for <linux-ext4@vger.kernel.org>; Thu, 26 Jun 2008 16:27:02 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K3300L01FFWCQ00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 26 Jun 2008 16:27:01 -0700 (PDT)
In-reply-to: <1214492283.10187.17.camel@localhost>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 26, 2008  16:58 +0200, Fr=EF=BF=BDd=EF=BF=BDric Boh=EF=BF=BD wro=
te:
> From: Frederic Bohe <frederic.bohe@bull.net>
>=20
> Update group infos when updating a group's descriptor.
> Add group infos when adding a group's descriptor.
> Refresh cache pages used by mb_alloc when changes occur.

Excellent, thank you for fixing this issue.  Minor comments below.

> +/* Create and initialize ext4_group_info data */
> +/* for the given group. */
> +
> +int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group=
,
> +struct ext4_group_desc *desc)

Please indent the continued line to match '(' on previous line.

> +	if (group % EXT4_DESC_PER_BLOCK(sb) =3D=3D 0) {
> +		metalen =3D sizeof(*meta_group_info)
> +			<< EXT4_DESC_PER_BLOCK_BITS(sb);

Please put operator "<<" at end of previous line.

> +		meta_group_info =3D kmalloc(metalen, GFP_KERNEL);
> +		if (meta_group_info =3D=3D NULL) {
> +			printk(KERN_ERR "EXT4-fs: can't allocate mem for a "
> +			"buddy group\n");

Indent continued line to '('

> +			goto exit_meta_group_info;
> +		}
> +		sbi->s_group_info[group >>
> +			EXT4_DESC_PER_BLOCK_BITS(sb)] =3D meta_group_info;

Prefer keeping related operations on the same line, like:

		sbi->s_group_info[group >> EXT4_DESC_PER_BLOCK_BITS(sb)] =3D
			meta_group_info;

> +	/*
> +	 * calculate needed size. if change bb_counters size,
> +	 * don't forget about ext4_mb_generate_buddy()
> +	 */
> +	len =3D sizeof(struct ext4_group_info);
> +	len +=3D sizeof(unsigned short) * (sb->s_blocksize_bits + 2);

It would be good to use an actual structure and not "sizeof(unsigned sh=
ort)"
because if the structure changes then this calculation will be wrong.
Something like the following is much safer and will always be correct:
=09
	len =3D offsetof(typeof(*meta_group_info),
		       bb_counters[sb->s_blocksize_bits + 2]);

I see that your code is copied from ext4_mb_init_backend(), so fault is
not yours, but it is still good to make the code safe against future bu=
gs.

> +	/*
> +	 * initialize bb_free to be able to skip
> +	 * empty groups without initialization
> +	 */
> +	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
> +		meta_group_info[i]->bb_free =3D
> +		ext4_free_blocks_after_init(sb, group, desc);
> +	} else {
> +		meta_group_info[i]->bb_free =3D
> +		le16_to_cpu(desc->bg_free_blocks_count);
> +	}

Please indent continued lines.

> +	INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
> +
> +#ifdef DOUBLE_CHECK
> +	{
> +	struct buffer_head *bh;
> +	meta_group_info[i]->bb_bitmap =3D
> +		kmalloc(sb->s_blocksize, GFP_KERNEL);
> +	BUG_ON(meta_group_info[i]->bb_bitmap =3D=3D NULL);
> +	bh =3D ext4_read_block_bitmap(sb, group);
> +	BUG_ON(bh =3D=3D NULL);
> +	memcpy(meta_group_info[i]->bb_bitmap, bh->b_data,
> +		sb->s_blocksize);
> +	put_bh(bh);
> +	}

Please indent inside this scope.

> +#endif
> +
> +	return 0;
> +exit_group_info:

Blank line after "return"

> +int ext4_mb_add_more_groupinfo(struct super_block *sb, ext4_group_t =
group,
> +				struct ext4_group_desc *desc)
> +{
> +	/* Cache pages containing dynamic mb_alloc datas (buddy and bitmap
> +	* datas) are set not up to date so that they will be re-initilaized
> +	* during the next call to ext4_mb_load_buddy
> +	*/

Comment continuation should line up '*' in a single column.

>  static int ext4_mb_init_backend(struct super_block *sb)
>  {
> +	/* This is the total number of blocks used by GDT including
> +	* the number of reserved blocks for GDT.
> +	* The s_group_info array is allocated with this value
> +	* to allow a clean online resize without a complex
> +	* manipulation of pointer.
> +	* The drawback is the unused memory when no resize
> +	* occurs but it's very low in terms of pages
> +	* (see comments below)
> +	*/

Also align comment '*' in the same columns.

> +	num_meta_group_infos_max =3D num_meta_group_infos +
> +				le16_to_cpu(es->s_reserved_gdt_blocks);

The only drawback of NOT handling this properly is that once (eventuall=
y)
we allow resizing with META_BG this code will be broken again.  It at
least deserves a comment like "Need to handle this properly when META_B=
G
resizing is allowed" so that it will show up on any grep for META_BG.

It probably also makes sense to round this up to the next power-of-two
value, since kmalloc will do that internally anyways, and it gives us
some resizing headroom for no cost.

> @@ -2276,62 +2431,15 @@ static int ext4_mb_init_backend(struct s
>  		sbi->s_group_info[i] =3D meta_group_info;
>  	}
> =20
>  	for (i =3D 0; i < sbi->s_groups_count; i++) {
> +		if (ext4_mb_add_groupinfo(sb, i, desc) !=3D 0)
> +			goto err_freebuddy;

This is much nicer, great.

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
