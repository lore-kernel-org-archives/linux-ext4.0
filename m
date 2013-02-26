From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH] ext4: cleanup sbi->s_kobj after quota initialization failure
Date: Mon, 25 Feb 2013 17:14:26 -0800
Message-ID: <CAGr1F2EjCa9Zm_TmMZtdXKO=GC5rrwusPJ4fwffHrtxVbpSyDA@mail.gmail.com>
References: <512BCFBB.30208@suse.com> <20130225233244.GA20992@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jeff Mahoney <jeffm@suse.com>, "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:43644 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933429Ab3BZBOr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Feb 2013 20:14:47 -0500
Received: by mail-ie0-f179.google.com with SMTP id k11so3898073iea.10
        for <linux-ext4@vger.kernel.org>; Mon, 25 Feb 2013 17:14:46 -0800 (PST)
In-Reply-To: <20130225233244.GA20992@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This seems to have been fixed in the ext4 master branch by commit
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commitdiff;h=72ba74508b2857e71d65fc93f0d6b684492fc740


On Mon, Feb 25, 2013 at 3:32 PM, Jan Kara <jack@suse.cz> wrote:
> On Mon 25-02-13 15:55:23, Jeff Mahoney wrote:
>> If ext4_enable_quotas fails, it jumps to failed_mount7, which doesn't
>> tear down the kobj.
>   The patch looks good. You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>
>
>                                                                 Honza
>
>> Cc: Aditya Kali <adityakali@google.com>
>> Cc: Jan Kara <jack@suse.cz>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  fs/ext4/super.c |    6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -3794,7 +3794,7 @@ no_journal:
>>           !(sb->s_flags & MS_RDONLY)) {
>>               err = ext4_enable_quotas(sb);
>>               if (err)
>> -                     goto failed_mount7;
>> +                     goto failed_mount8;
>>       }
>>  #endif  /* CONFIG_QUOTA */
>>
>> @@ -3813,6 +3813,10 @@ cantfind_ext4:
>>               ext4_msg(sb, KERN_ERR, "VFS: Can't find ext4 filesystem");
>>       goto failed_mount;
>>
>> +failed_mount8:
>> +     kobject_del(&sbi->s_kobj);
>> +     kobject_put(&sbi->s_kobj);
>> +     wait_for_completion(&sbi->s_kobj_unregister);
>>  failed_mount7:
>>       ext4_unregister_li_request(sb);
>>  failed_mount6:
>>
>> --
>> Jeff Mahoney
>> SUSE Labs
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR



--

Aditya
