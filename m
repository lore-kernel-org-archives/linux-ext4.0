From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 03/13] ext4: add a function which sets up a new group desc
Date: Fri, 12 Aug 2011 16:49:16 +0800
Message-ID: <CAGBYx2aqCT4eczhBqopRo=F799LH3TnWNErNNB8VOzmLQLHcYg@mail.gmail.com>
References: <1313033308-882-1-git-send-email-xiaoqiangnk@gmail.com>
	<1313033308-882-4-git-send-email-xiaoqiangnk@gmail.com>
	<B9FE530C-A531-4C2E-824B-178F31CA1E0E@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60700 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab1HLItR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Aug 2011 04:49:17 -0400
Received: by gxk21 with SMTP id 21so1823158gxk.19
        for <linux-ext4@vger.kernel.org>; Fri, 12 Aug 2011 01:49:17 -0700 (PDT)
In-Reply-To: <B9FE530C-A531-4C2E-824B-178F31CA1E0E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 11, 2011 at 2:42 PM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> On 2011-08-10, at 9:28 PM, Yongqiang Yang wrote:
>> This patch adds a function named ext4_setup_new_desc() which sets
>> up a new group descriptor and whose code is sopied from ext4_group_a=
dd().
>>
>> The function will be used by new resize implementation.
>
> Again, duplicating a big hunk of ext4_group_add(). =A0Similar comment=
s apply.
>
> Another question is whether this new resize code is safe from crashes=
?
> One of the original design goals of the resize code is that it would =
never
> leave a filesystem inconsistent if it crashed in the middle.
>
> The way that these patches are looking, it seems that they may not be=
 safe
> in this regard, and possibly leave the filesystem in an inconsistent =
state
> if they crash in the middle. =A0Maybe I'm missing something?
If journal is used, journal can bring the crashed fs to consistent
state like old resize.  The logic of new resize is the same as old
resize except adding multi groups each time.

I will check it further.

Thanks!
Yongqiang.
>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> fs/ext4/resize.c | =A0 54 ++++++++++++++++++++++++++++++++++++++++++=
++++++++++++
>> 1 files changed, 54 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
>> index 4fcd515..6320baa 100644
>> --- a/fs/ext4/resize.c
>> +++ b/fs/ext4/resize.c
>> @@ -777,6 +777,60 @@ out:
>> =A0 =A0 =A0 return err;
>> }
>>
>> +/*
>> + * ext4_setup_new_desc() sets up group descriptors specified by @in=
put.
>> + *
>> + * @handle: journal handle
>> + * @sb: super block
>> + */
>> +static int ext4_setup_new_desc(handle_t *handle, struct super_block=
 *sb,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct ext4=
_new_group_data *input)
>> +{
>> + =A0 =A0 struct ext4_sb_info *sbi =3D EXT4_SB(sb);
>> + =A0 =A0 ext4_group_t group;
>> + =A0 =A0 struct ext4_group_desc *gdp;
>> + =A0 =A0 struct buffer_head *gdb_bh;
>> + =A0 =A0 int gdb_off, gdb_num, err =3D 0;
>> +
>> + =A0 =A0 group =3D input->group;
>> +
>> + =A0 =A0 gdb_off =3D group % EXT4_DESC_PER_BLOCK(sb);
>> + =A0 =A0 gdb_num =3D group / EXT4_DESC_PER_BLOCK(sb);
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* get_write_access() has been called on gdb_bh by ext4_=
add_new_desc().
>> + =A0 =A0 =A0*/
>> + =A0 =A0 gdb_bh =3D sbi->s_group_desc[gdb_num];
>> + =A0 =A0 /* Update group descriptor block for new group */
>> + =A0 =A0 gdp =3D (struct ext4_group_desc *)((char *)gdb_bh->b_data =
+
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0gdb_off=
 * EXT4_DESC_SIZE(sb));
>> +
>> + =A0 =A0 memset(gdp, 0, EXT4_DESC_SIZE(sb));
>> + =A0 =A0 =A0/* LV FIXME */
>> + =A0 =A0 memset(gdp, 0, EXT4_DESC_SIZE(sb));
>> + =A0 =A0 ext4_block_bitmap_set(sb, gdp, input->block_bitmap); /* LV=
 FIXME */
>> + =A0 =A0 ext4_inode_bitmap_set(sb, gdp, input->inode_bitmap); /* LV=
 FIXME */
>> + =A0 =A0 ext4_inode_table_set(sb, gdp, input->inode_table); /* LV F=
IXME */
>> + =A0 =A0 ext4_free_blks_set(sb, gdp, input->free_blocks_count);
>> + =A0 =A0 ext4_free_inodes_set(sb, gdp, EXT4_INODES_PER_GROUP(sb));
>> + =A0 =A0 gdp->bg_flags =3D cpu_to_le16(EXT4_BG_INODE_ZEROED);
>> + =A0 =A0 gdp->bg_checksum =3D ext4_group_desc_csum(sbi, input->grou=
p, gdp);
>> +
>> + =A0 =A0 err =3D ext4_handle_dirty_metadata(handle, NULL, gdb_bh);
>> + =A0 =A0 if (unlikely(err)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_std_error(sb, err);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return err;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* We can allocate memory for mb_alloc based on the new =
group
>> + =A0 =A0 =A0* descriptor
>> + =A0 =A0 =A0*/
>> + =A0 =A0 err =3D ext4_mb_add_groupinfo(sb, group, gdp);
>> +
>> + =A0 =A0 return err;
>> +}
>> +
>> /* Add group descriptor data to an existing or new group descriptor =
block.
>> =A0* Ensure we handle all possible error conditions _before_ we star=
t modifying
>> =A0* the filesystem, because we cannot abort the transaction and not=
 have it
>> --
>> 1.7.5.1
>>
>
>
> Cheers, Andreas
>
>
>
>
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
