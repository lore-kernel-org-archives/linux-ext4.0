From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH] ext4: Automatic setting of {INODE,BLOCK}_UNINIT flags
Date: Thu, 25 Oct 2012 07:37:03 -0700
Message-ID: <3946C047-0561-4E6B-9F0B-CBB0763A4822@gmail.com>
References: <1351149943-4827-1-git-send-email-tracek@redhat.com> <CAGBYx2bU=G0X4GDZSjznnn12yAxJXs=RWn_x1EvHM8RGbkdk0A@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Tomas Racek <tracek@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"lczerner@redhat.com" <lczerner@redhat.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36646 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab2JZAl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2012 20:41:26 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so2391616pbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2012 17:41:26 -0700 (PDT)
In-Reply-To: <CAGBYx2bU=G0X4GDZSjznnn12yAxJXs=RWn_x1EvHM8RGbkdk0A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-10-25, at 0:44, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:
> Does it make sense in no journal mode?

This is even more important in nojournal mode, since that will need to run e2fsck after every boot. 

Cheers, Andreas

> On Thu, Oct 25, 2012 at 3:25 PM, Tomas Racek <tracek@redhat.com> wrote:
>> When last inode from bg is freed, set the INODE_UNINIT flag, similarly
>> when last block is freed, set BLOCK_UNINIT flag. This can speed up
>> subsequent fsck run.
>> 
>> Signed-off-by: Tomas Racek <tracek@redhat.com>
>> ---
>> fs/ext4/ialloc.c  | 4 ++++
>> fs/ext4/mballoc.c | 4 ++++
>> 2 files changed, 8 insertions(+)
>> 
>> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
>> index 4facdd2..6e4b982 100644
>> --- a/fs/ext4/ialloc.c
>> +++ b/fs/ext4/ialloc.c
>> @@ -289,6 +289,10 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
>> 
>>        count = ext4_free_inodes_count(sb, gdp) + 1;
>>        ext4_free_inodes_set(sb, gdp, count);
>> +
>> +       if (count == EXT4_INODES_PER_GROUP(sb))
>> +               gdp->bg_flags |= cpu_to_le16(EXT4_BG_INODE_UNINIT);
>> +
>>        if (is_directory) {
>>                count = ext4_used_dirs_count(sb, gdp) - 1;
>>                ext4_used_dirs_set(sb, gdp, count);
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index 526e553..28bce35 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -4665,6 +4665,10 @@ do_more:
>> 
>>        ret = ext4_free_group_clusters(sb, gdp) + count_clusters;
>>        ext4_free_group_clusters_set(sb, gdp, ret);
>> +
>> +       if(ret == EXT4_BLOCKS_PER_GROUP(sb))
>> +               gdp->bg_flags |= cpu_to_le16(EXT4_BG_BLOCK_UNINIT);
>> +
>>        ext4_block_bitmap_csum_set(sb, block_group, gdp, bitmap_bh);
>>        ext4_group_desc_csum_set(sb, block_group, gdp);
>>        ext4_unlock_group(sb, block_group);
>> --
>> 1.7.11.7
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> Best Wishes
> Yongqiang Yang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
