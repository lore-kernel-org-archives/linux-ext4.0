From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RESEND PATCH 2/2] ext4: ext4_inode_is_fast_symlink should use cluster size
Date: Mon, 23 Dec 2013 12:33:43 -0700
Message-ID: <8E8C882A-F729-436F-BD37-38903B9C5932@dilger.ca>
References: <1387515880-10185-1-git-send-email-yangyongqiang01@baidu.com> <1387515880-10185-2-git-send-email-yangyongqiang01@baidu.com> <CAGBYx2Zx7jnK-DmM7=RCCVwz4N0FfE_-=eETO8OkLt5McCXttg@mail.gmail.com> <20131223121703.GA4284@orion.maiolino.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:64191 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757639Ab3LWTdn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Dec 2013 14:33:43 -0500
Received: by mail-pd0-f176.google.com with SMTP id w10so5458368pde.7
        for <linux-ext4@vger.kernel.org>; Mon, 23 Dec 2013 11:33:43 -0800 (PST)
In-Reply-To: <20131223121703.GA4284@orion.maiolino.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If actually prefer if we changed this function from checking the blocks count to checking the symlink length (i_size) to determine if this is a fast or slow symlink.

I don't think there has ever been a kernel that stores symlinks < 60 chars in an external block, and it would definitely avoid the many, many times this function has been wrong because of xattrs and other things that change the number of blocks allocated to an inode. Using the block count instead of i_size makes it impossible to change the number of blocks associated with a symlink without breaking older kernels (and I'm sure this will break again in the future, just as it did when xattrs started appearing on symlinks in the first place. I'd really prefer that we move away from that. 

Also, it doesn't seem obvious to me that a symlink in a bigalloc filesystem should account for ALL of the blocks in the cluster to the inode vs. just the blocks actually needed to store the symlink name. 

Cheers, Andreas

> On Dec 23, 2013, at 5:17, Carlos Maiolino <cmaiolino@redhat.com> wrote:
> 
>> On Fri, Dec 20, 2013 at 01:13:33PM +0800, Yongqiang Yang wrote:
>> From: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> 
>> can be reproduced by xfstests 62 with  bigalloc and 128bit size inode.
>> 
>> Signed-off-by: Yongqiang Yang <yangyongqiang01@baidu.com>
>> ---
>> fs/ext4/inode.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 9115f28..1869fcf 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -145,7 +145,7 @@ static int ext4_meta_trans_blocks(struct inode
>> *inode, int lblocks,
>> static int ext4_inode_is_fast_symlink(struct inode *inode)
>> {
>>        int ea_blocks = EXT4_I(inode)->i_file_acl ?
>> -               (inode->i_sb->s_blocksize >> 9) : 0;
>> +                       EXT4_CLUSTER_SIZE(inode->i_sb) >> 9 : 0;
> 
> Code looks good, but looks like it has an extra TAB here. Just a cosmetic thing;
> despite that, consider it
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
