From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: Re: [PATCH] ext2 : correct comments in fs/ext2/balloc.c
Date: Tue, 3 Jun 2008 17:49:05 +0530
Message-ID: <ea11fea30806030519w4a94efc8wa2d8adebd8ce7b48@mail.gmail.com>
References: <ea11fea30805311115t72773c4u66999762bb53d157@mail.gmail.com>
	 <919fe2b30806030516l4e7ba605kd9a01a18865cbdcc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: "Mark Asselstine" <asselsm@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:48556 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757939AbYFCMTH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 08:19:07 -0400
Received: by ti-out-0910.google.com with SMTP id b6so508880tic.23
        for <linux-ext4@vger.kernel.org>; Tue, 03 Jun 2008 05:19:05 -0700 (PDT)
In-Reply-To: <919fe2b30806030516l4e7ba605kd9a01a18865cbdcc@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 3, 2008 at 5:46 PM, Mark Asselstine <asselsm@gmail.com> wrote:
> On Sat, May 31, 2008 at 2:15 PM, Manish Katiyar <mkatiyar@gmail.com> wrote:
>> This patch corrects the wrong function name mentioned in the comments
>> of ext2_free_blocks()  function
>>
>> ========================================================
>>
>> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> Reviewed-by: Mark Asselstine <mark.asselstine@windriver.com>
>
> One comment, lose the timestamps  they add no value.

OK Mark,... Will resend the patch with timestamp removed.

Thanks -
Manish


>>
>> --- a/fs/ext2/balloc.c   2008-05-11 23:54:40.000000000 +0530
>> +++ b/fs/ext2/balloc.c        2008-05-31 23:44:20.000000000 +0530
>> @@ -478,7 +478,7 @@
>>  }
>>
>>  /**
>> - * ext2_free_blocks_sb() -- Free given blocks and update quota and i_blocks
>> + * ext2_free_blocks() -- Free given blocks and update quota and i_blocks
>>  * @inode:             inode
>>  * @block:             start physcial block to free
>>  * @count:             number of blocks to free
>>
>>
>> ==========================================================
>>
>> --
>> Thanks & Regards,
>> ********************************************
>> Manish Katiyar ( http://mkatiyar.googlepages.com )
>> 3rd Floor, Fair Winds Block
>> EGL Software Park
>> Off Intermediate Ring Road
>> Bangalore 560071, India
>> ***********************************************
>> --
>> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>



-- 
Thanks & Regards,
********************************************
Manish Katiyar ( http://mkatiyar.googlepages.com )
3rd Floor, Fair Winds Block
EGL Software Park
Off Intermediate Ring Road
Bangalore 560071, India
***********************************************
