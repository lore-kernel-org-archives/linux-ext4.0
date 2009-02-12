From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH] : Remove incompatible pointer assignment warning in ext4
	quota operations
Date: Thu, 12 Feb 2009 14:24:17 +0530
Message-ID: <ea11fea30902120054g5192f269y5cdf34795d9f8e1e@mail.gmail.com>
References: <ea11fea30901272117j760a34e8w5df0ec1916632f3f@mail.gmail.com>
	 <ea11fea30901272121x319aa2b3m2a5a5799b6df4d8a@mail.gmail.com>
	 <20090202161005.GG19165@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:41072 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZBLIyU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Feb 2009 03:54:20 -0500
Received: by ti-out-0910.google.com with SMTP id d10so354947tib.23
        for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2009 00:54:18 -0800 (PST)
In-Reply-To: <20090202161005.GG19165@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 2, 2009 at 9:40 PM, Jan Kara <jack@suse.cz> wrote:
>> On Wed, Jan 28, 2009 at 10:47 AM, Manish Katiyar <mkatiyar@gmail.com> wrote:
>> > Below patch removes the following warning during compilation :
>> >
>> >  CC [M]  fs/ext4/super.o
>> > fs/ext4/super.c:949: warning: initialization from incompatible pointer type
>> >  LD [M]  fs/ext4/ext4.o
>>
>> Sorry,
>>
>> Tha correct patch is here.
>>
>> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
>  Looks fine to me.
> Acked-by: Jan Kara <jack@suse.cz>

Hi Jan,

A simple doubt. Patches acked by you will be automatically picked up
or will I have to resend it with your ack added ??

Thanks -
Manish

>
>                                                                                Honza
>
>> ---
>>  fs/ext4/ext4.h  |    2 +-
>>  fs/ext4/inode.c |    4 ++--
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 3ab1a41..0164866 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -1088,7 +1088,7 @@ extern int ext4_chunk_trans_blocks(struct inode
>> *, int nrblocks);
>>  extern int ext4_block_truncate_page(handle_t *handle,
>>               struct address_space *mapping, loff_t from);
>>  extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page);
>> -extern unsigned long long ext4_get_reserved_space(struct inode *inode);
>> +extern qsize_t ext4_get_reserved_space(struct inode *inode);
>>
>>  /* ioctl.c */
>>  extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 6a316ec..6be09be 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -973,9 +973,9 @@ out:
>>       return err;
>>  }
>>
>> -unsigned long long ext4_get_reserved_space(struct inode *inode)
>> +qsize_t ext4_get_reserved_space(struct inode *inode)
>>  {
>> -     unsigned long long total;
>> +     qsize_t total;
>>
>>       spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>>       total = EXT4_I(inode)->i_reserved_data_blocks +
>> --
>> 1.5.4.3
>>
>> Thanks -
>> Manish
>>
>> >
>> >
>> > Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
>> > ---
>> >  fs/ext4/ext4.h |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> > index 3ab1a41..0164866 100644
>> > --- a/fs/ext4/ext4.h
>> > +++ b/fs/ext4/ext4.h
>> > @@ -1088,7 +1088,7 @@ extern int ext4_chunk_trans_blocks(struct inode
>> > *, int nrblocks);
>> >  extern int ext4_block_truncate_page(handle_t *handle,
>> >                struct address_space *mapping, loff_t from);
>> >  extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page);
>> > -extern unsigned long long ext4_get_reserved_space(struct inode *inode);
>> > +extern qsize_t ext4_get_reserved_space(struct inode *inode);
>> >
>> >  /* ioctl.c */
>> >  extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
>> > --
>> > 1.5.4.3
>> >
>> >
>> > Thanks -
>> > Manish
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> Jan Kara <jack@suse.cz>
> SuSE CR Labs
>
