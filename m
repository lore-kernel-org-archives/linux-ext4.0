From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: Re: [PATCH] logsave : Avoid unnecessary backgrounding of logsave in case of failures
Date: Sat, 11 Oct 2008 00:18:09 +0530
Message-ID: <ea11fea30810101148v1176734idf77a838b7401302@mail.gmail.com>
References: <ea11fea30810071044l6d8887e0udb52342f82412e4a@mail.gmail.com>
	 <20081010183157.GD8645@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:62290 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbYJJSsM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2008 14:48:12 -0400
Received: by gxk9 with SMTP id 9so1151236gxk.13
        for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 11:48:10 -0700 (PDT)
In-Reply-To: <20081010183157.GD8645@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 11, 2008 at 12:01 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Tue, Oct 07, 2008 at 11:14:11PM +0530, Manish Katiyar wrote:
>> Hi Ted,
>>
>> I am not sure why we wan't to background the logsave and keep retrying
>> opening the fd in case of failures.
>
> That's one of the main reason why logsave exists; the filesystem
> containing /var/log might not be mounted, or the root filesystem may
> be mounted read-only, and so the log file can't be written until the
> filesystem is remounted r/w or /var is mounted.
>
>> But there may be situations when we will never be able to succeed
>> and thus create unnecessary process. For example invoking it
>>
>> /home/mkatiyar/sbin> ./logsave /testfile ls
>
> The main use of logsave was in init.d scripts.  So I didn't really
> worry about the permissoin denied case.  Perhaps logsave should just
> fail hard and not even run the command if there is a permission denied
> error.  That would certainly be simpler...
>
>> +static void should_background(int err, int *nobackground) {
>> +     switch (err) {
>> +             case EPERM:
>> +             case EACCES:
>> +                     *nobackground = err;
>> +                     break;
>> +             default :
>> +                     *nobackground = 0;
>> +     }
>> +     return ;
>> +}
>
> Why is this its own function?

I made it that way so that in future if we want to handle any more
error numbers to bail out , we just need to add a case statement.

Thanks -
Manish

>
>                                                - Ted
>
