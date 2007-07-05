From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [PATCH] ext4 statfs speed up
Date: Thu, 05 Jul 2007 12:35:01 -0700
Message-ID: <1183664101.19473.16.camel@dyn9047017100.beaverton.ibm.com>
References: <1183659098.19473.9.camel@dyn9047017100.beaverton.ibm.com>
	 <1183661043.24971.22.camel@colyt43.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 <linux-ext4@vger.kernel.org>
To: coly li <colyli@gmail.com>, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:34827 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbXGETd2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jul 2007 15:33:28 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l65JXS9X015696
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jul 2007 15:33:28 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l65JXOVW268236
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jul 2007 13:33:25 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l65JXNJR015069
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jul 2007 13:33:23 -0600
In-Reply-To: <1183661043.24971.22.camel@colyt43.site>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-07-06 at 02:44 +0800, coly li wrote:
> Badari,
>=20
> How about the performance improvement, is there any benchmark result =
?
>=20
> Coly

The original patch came from Andrea Dilger - where they use this patch
in their luster code. Andrea, do you have perf. numbers ?

BTW, I am doing perf. analysis too. I will share the results.

Thanks,
Badari

>=20
>=20
> =E5=9C=A8 2007-07-05=E5=9B=9B=E7=9A=84 11:11 -0700=EF=BC=8CBadari Pul=
avarty=E5=86=99=E9=81=93=EF=BC=9A
> > This is a patch that speeds up statfs.  It is very simple -=20
> > the "overhead" calculation, which takes a huge amount of time=20
> > for large filesystems, never changes unless the size of the=20
> > filesystem itself changes.  That means we can store it in memory=20
> > and only recalculate if the filesystem has been resized (almost=20
> > never).
> >=20
> > It also fixes a minor problem that we never update the on-disk=20
> > superblock free blocks/inodes counts until the filesystem is=20
> > unmounted.  While not fatal, we may as well update that on disk=20
> > when we have the information, and it makes things like debugfs=20
> > and dumpe2fs report a bit more accurate info.
> >=20
> > Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
> > Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> >=20
> >  fs/ext4/super.c            |   25 +++++++++++++++----------
> >  include/linux/ext4_fs_sb.h |    2 ++
> >  2 files changed, 17 insertions(+), 10 deletions(-)
> >=20
> > Index: linux-2.6.22-rc7/include/linux/ext4_fs_sb.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.22-rc7.orig/include/linux/ext4_fs_sb.h	2007-07-01 12:=
54:24.000000000 -0700
> > +++ linux-2.6.22-rc7/include/linux/ext4_fs_sb.h	2007-07-04 22:09:59=
=2E000000000 -0700
> > @@ -39,6 +39,8 @@ struct ext4_sb_info {
> >  	unsigned long s_gdb_count;	/* Number of group descriptor blocks *=
/
> >  	unsigned long s_desc_per_block;	/* Number of group descriptors pe=
r block */
> >  	unsigned long s_groups_count;	/* Number of groups in the fs */
> > +	unsigned long s_overhead_last;  /* Last calculated overhead */
> > +	unsigned long s_blocks_last;    /* Last seen block count */
> >  	struct buffer_head * s_sbh;	/* Buffer containing the super block =
*/
> >  	struct ext4_super_block * s_es;	/* Pointer to the super block in =
the buffer */
> >  	struct buffer_head ** s_group_desc;
> > Index: linux-2.6.22-rc7/fs/ext4/super.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.22-rc7.orig/fs/ext4/super.c	2007-07-01 12:54:24.00000=
0000 -0700
> > +++ linux-2.6.22-rc7/fs/ext4/super.c	2007-07-04 22:12:27.000000000 =
-0700
> > @@ -2481,19 +2481,19 @@ static int ext4_statfs (struct dentry *=20
> >  	struct super_block *sb =3D dentry->d_sb;
> >  	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> >  	struct ext4_super_block *es =3D sbi->s_es;
> > -	ext4_fsblk_t overhead;
> > -	int i;
> >  	u64 fsid;
> > =20
> > -	if (test_opt (sb, MINIX_DF))
> > -		overhead =3D 0;
> > -	else {
> > -		unsigned long ngroups;
> > -		ngroups =3D EXT4_SB(sb)->s_groups_count;
> > +	if (test_opt(sb, MINIX_DF)) {
> > +		sbi->s_overhead_last =3D 0;
> > +	} else if (sbi->s_blocks_last !=3D le32_to_cpu(es->s_blocks_count=
)) {
> > +		unsigned long ngroups =3D sbi->s_groups_count, i;
> > +		ext4_fsblk_t overhead =3D 0;
> >  		smp_rmb();
> > =20
> >  		/*
> > -		 * Compute the overhead (FS structures)
> > +		 * Compute the overhead (FS structures).  This is constant
> > +		 * for a given filesystem unless the number of block groups
> > +		 * changes so we cache the previous value until it does.
> >  		 */
> > =20
> >  		/*
> > @@ -2517,18 +2517,23 @@ static int ext4_statfs (struct dentry *=20
> >  		 * Every block group has an inode bitmap, a block
> >  		 * bitmap, and an inode table.
> >  		 */
> > -		overhead +=3D (ngroups * (2 + EXT4_SB(sb)->s_itb_per_group));
> > +		overhead +=3D ngroups * (2 + sbi->s_itb_per_group);
> > +		sbi->s_overhead_last =3D overhead;
> > +		smp_wmb();
> > +		sbi->s_blocks_last =3D le32_to_cpu(es->s_blocks_count);
> >  	}
> > =20
> >  	buf->f_type =3D EXT4_SUPER_MAGIC;
> >  	buf->f_bsize =3D sb->s_blocksize;
> > -	buf->f_blocks =3D ext4_blocks_count(es) - overhead;
> > +	buf->f_blocks =3D ext4_blocks_count(es) - sbi->s_overhead_last;
> >  	buf->f_bfree =3D percpu_counter_sum(&sbi->s_freeblocks_counter);
> > +	es->s_free_blocks_count =3D cpu_to_le32(buf->f_bfree);
> >  	buf->f_bavail =3D buf->f_bfree - ext4_r_blocks_count(es);
> >  	if (buf->f_bfree < ext4_r_blocks_count(es))
> >  		buf->f_bavail =3D 0;
> >  	buf->f_files =3D le32_to_cpu(es->s_inodes_count);
> >  	buf->f_ffree =3D percpu_counter_sum(&sbi->s_freeinodes_counter);
> > +	es->s_free_inodes_count =3D cpu_to_le32(buf->f_ffree);
> >  	buf->f_namelen =3D EXT4_NAME_LEN;
> >  	fsid =3D le64_to_cpup((void *)es->s_uuid) ^
> >  	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
> >=20
> >=20
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
