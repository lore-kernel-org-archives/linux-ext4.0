From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 4/4] ext4: fix incorrect block reservation on quota
 transfer.
Date: Tue, 08 Dec 2009 09:48:19 +0300
Message-ID: <87zl5uvu4s.fsf@openvz.org>
References: <1259132261-16785-1-git-send-email-dmonakhov@openvz.org>
 <1259132261-16785-2-git-send-email-dmonakhov@openvz.org>
 <1259132261-16785-3-git-send-email-dmonakhov@openvz.org>
 <1259132261-16785-4-git-send-email-dmonakhov@openvz.org>
 <1260234137.4206.148.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:36742 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbZLHGsG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Dec 2009 01:48:06 -0500
Received: from dmon-lp ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru (Sun Java(tm) System Messaging Server 7u2-7.02 64bit
 (built Apr 16 2009)) with ESMTPA id <0KUB007O7N478400@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Tue, 08 Dec 2009 09:52:58 +0300 (MSK)
In-reply-to: <1260234137.4206.148.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mingming <cmm@us.ibm.com> writes:

> On Wed, 2009-11-25 at 09:57 +0300, Dmitry Monakhov wrote:
>> Inside ->setattr() call both ATTR_UID and ATTR_GID may be valid
>> This means that we may end-up with transferring all quotas. Add
>> we have to reserve QUOTA_DEL_BLOCKS for all quotas, as we do in
>> case of QUOTA_INIT_BLOCKS.
>> 
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>
> Seems correct to me. It looks like ext3 need similar fix, mind to send a
> ext3 patch as well?
Done.
>
> Reviewed-by: Mingming Cao <cmm@us.ibm.com>
>> ---
>>  fs/ext4/inode.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 211722b..d42e954 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -5439,7 +5439,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>>  		/* (user+group)*(old+new) structure, inode write (sb,
>>  		 * inode block, ? - but truncate inode update has it) */
>>  		handle = ext4_journal_start(inode, (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
>> -					EXT4_QUOTA_DEL_BLOCKS(inode->i_sb))+3);
>> +					EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3);
>>  		if (IS_ERR(handle)) {
>>  			error = PTR_ERR(handle);
>>  			goto err_out;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
