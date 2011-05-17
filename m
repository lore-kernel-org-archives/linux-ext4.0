From: Vivek Haldar <haldar@google.com>
Subject: Re: [PATCH] ext4: count hits/misses of extent cache and expose in sysfs.
Date: Tue, 17 May 2011 16:05:51 -0700
Message-ID: <BANLkTikMqWe-fghd3=FAGprrJT+cckaFXA@mail.gmail.com>
References: <1305671213-7624-1-git-send-email-haldar@google.com>
	<3C42B155-FF68-4972-990D-7EC92B4AF3C1@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:5514 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562Ab1EQXGJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2011 19:06:09 -0400
Received: from wpaz1.hot.corp.google.com (wpaz1.hot.corp.google.com [172.24.198.65])
	by smtp-out.google.com with ESMTP id p4HN5rv3020622
	for <linux-ext4@vger.kernel.org>; Tue, 17 May 2011 16:05:53 -0700
Received: from qwk3 (qwk3.prod.google.com [10.241.195.131])
	by wpaz1.hot.corp.google.com with ESMTP id p4HN5bSs005401
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 17 May 2011 16:05:52 -0700
Received: by qwk3 with SMTP id 3so713003qwk.33
        for <linux-ext4@vger.kernel.org>; Tue, 17 May 2011 16:05:51 -0700 (PDT)
In-Reply-To: <3C42B155-FF68-4972-990D-7EC92B4AF3C1@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 17, 2011 at 3:57 PM, Andreas Dilger
<adilger.kernel@dilger.ca> wrote:
> On May 17, 2011, at 16:26, Vivek Haldar wrote:
>> The number of hits and misses for each filesystem is exposed in
>> /sys/fs/ext4/<dev>/extent_cache_{hits, misses}.
>
> There was some discussion on the ext4 concall whether the use of the =
ext4 extent cache is preventing extent and/or index blocks from being "=
touched", and possibly causing them to be dropped from cache prematurel=
y.
>
> If you are currently investigating this area of the code it would be =
good if you could take a look at the code to determine if this is the c=
ase or not.

I wasn't looking at that issue specifically, but now that you mention
it, I'll keep an eye out for it.

>
>> Tested: fsstress, manual checks.
>> Signed-off-by: Vivek Haldar <haldar@google.com>
>> ---
>> fs/ext4/ext4.h =A0 =A0| =A0 =A03 +++
>> fs/ext4/extents.c | =A0 =A07 ++++++-
>> fs/ext4/super.c =A0 | =A0 16 ++++++++++++++++
>> 3 files changed, 25 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 47986ae..9625b19 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -1144,6 +1144,9 @@ struct ext4_sb_info {
>> =A0 =A0 =A0 unsigned long s_ext_blocks;
>> =A0 =A0 =A0 unsigned long s_ext_extents;
>> #endif
>> + =A0 =A0 /* ext4 extent cache stats */
>> + =A0 =A0 unsigned long extent_cache_hits;
>> + =A0 =A0 unsigned long extent_cache_misses;
>>
>> =A0 =A0 =A0 /* for buddy allocator */
>> =A0 =A0 =A0 struct ext4_group_info ***s_group_info;
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index e363f21..1ea440a 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -2035,6 +2035,7 @@ ext4_ext_in_cache(struct inode *inode, ext4_lb=
lk_t block,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ext4_extent *ex)
>> {
>> =A0 =A0 =A0 struct ext4_ext_cache *cex;
>> + =A0 =A0 struct ext4_sb_info *sbi;
>> =A0 =A0 =A0 int ret =3D 0;
>>
>> =A0 =A0 =A0 /*
>> @@ -2042,6 +2043,7 @@ ext4_ext_in_cache(struct inode *inode, ext4_lb=
lk_t block,
>> =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>> =A0 =A0 =A0 cex =3D &EXT4_I(inode)->i_cached_extent;
>> + =A0 =A0 sbi =3D EXT4_SB(inode->i_sb);
>>
>> =A0 =A0 =A0 /* has cache valid data? */
>> =A0 =A0 =A0 if (cex->ec_len =3D=3D 0)
>> @@ -2057,6 +2059,10 @@ ext4_ext_in_cache(struct inode *inode, ext4_l=
blk_t block,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D 1;
>> =A0 =A0 =A0 }
>> errout:
>> + =A0 =A0 if (!ret)
>> + =A0 =A0 =A0 =A0 =A0 =A0 sbi->extent_cache_misses++;
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 sbi->extent_cache_hits++;
>> =A0 =A0 =A0 spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>> =A0 =A0 =A0 return ret;
>> }
>> @@ -3900,4 +3906,3 @@ int ext4_fiemap(struct inode *inode, struct fi=
emap_extent_info *fieinfo,
>>
>> =A0 =A0 =A0 return error;
>> }
>> -
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index fc827bb..20cc98f 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -2439,6 +2439,18 @@ static ssize_t lifetime_write_kbytes_show(str=
uct ext4_attr *a,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_SB(sb)->s_secto=
rs_written_start) >> 1)));
>> }
>>
>> +static ssize_t extent_cache_hits_show(struct ext4_attr *a,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 struct ext4_sb_info *sbi, char *buf)
>> +{
>> + =A0 =A0 return snprintf(buf, PAGE_SIZE, "%lu\n", sbi->extent_cache=
_hits);
>> +}
>> +
>> +static ssize_t extent_cache_misses_show(struct ext4_attr *a,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 struct ext4_sb_info *sbi, char *buf)
>> +{
>> + =A0 =A0 return snprintf(buf, PAGE_SIZE, "%lu\n", sbi->extent_cache=
_misses);
>> +}
>> +
>> static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 struct ext4_sb_info *sbi,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 const char *buf, size_t count)
>> @@ -2496,6 +2508,8 @@ static struct ext4_attr ext4_attr_##name =3D _=
_ATTR(name, mode, show, store)
>> EXT4_RO_ATTR(delayed_allocation_blocks);
>> EXT4_RO_ATTR(session_write_kbytes);
>> EXT4_RO_ATTR(lifetime_write_kbytes);
>> +EXT4_RO_ATTR(extent_cache_hits);
>> +EXT4_RO_ATTR(extent_cache_misses);
>> EXT4_ATTR_OFFSET(inode_readahead_blks, 0644, sbi_ui_show,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode_readahead_blks_store, s_inode_r=
eadahead_blks);
>> EXT4_RW_ATTR_SBI_UI(inode_goal, s_inode_goal);
>> @@ -2511,6 +2525,8 @@ static struct attribute *ext4_attrs[] =3D {
>> =A0 =A0 =A0 ATTR_LIST(delayed_allocation_blocks),
>> =A0 =A0 =A0 ATTR_LIST(session_write_kbytes),
>> =A0 =A0 =A0 ATTR_LIST(lifetime_write_kbytes),
>> + =A0 =A0 ATTR_LIST(extent_cache_hits),
>> + =A0 =A0 ATTR_LIST(extent_cache_misses),
>> =A0 =A0 =A0 ATTR_LIST(inode_readahead_blks),
>> =A0 =A0 =A0 ATTR_LIST(inode_goal),
>> =A0 =A0 =A0 ATTR_LIST(mb_stats),
>> --
>> 1.7.3.1
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
Regards,
Vivek
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
