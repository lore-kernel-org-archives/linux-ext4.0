From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: fix NULL pointer dereference from orig_data in
 fill_super and remount.
Date: Mon, 07 Nov 2011 04:50:34 +0530
Message-ID: <4EB71642.8070502@linux.vnet.ibm.com>
References: <1320592775-2046-1-git-send-email-linkinjeon@gmail.com> <4EB6EF07.1070102@linux.vnet.ibm.com> <CAKYAXd87ry6D4xsBwkXC4at6kDZgHu=_Qa+0kdhEsN=RSMk1ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: NamJae Jeon <linkinjeon@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:46306 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab1KFXUm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Nov 2011 18:20:42 -0500
Received: from /spool/local
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <srivatsa.bhat@linux.vnet.ibm.com>;
	Mon, 7 Nov 2011 04:50:39 +0530
In-Reply-To: <CAKYAXd87ry6D4xsBwkXC4at6kDZgHu=_Qa+0kdhEsN=RSMk1ag@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/07/2011 04:43 AM, NamJae Jeon wrote:
> 2011/11/7 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>:
>> On 11/06/2011 08:49 PM, Namjae Jeon wrote:
>>> Fix NULL pointer dereference from orig_data in fill_super and remount.
>>>
>>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>>> ---
>>>  fs/ext4/super.c |   12 ++++++++++--
>>>  1 files changed, 10 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>>> index 9953d80..3770d3f 100644
>>> --- a/fs/ext4/super.c
>>> +++ b/fs/ext4/super.c
>>> @@ -3102,7 +3102,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>>>                               __releases(kernel_lock)
>>>                               __acquires(kernel_lock)
>>>  {
>>> -     char *orig_data = kstrdup(data, GFP_KERNEL);
>>>       struct buffer_head *bh;
>>>       struct ext4_super_block *es = NULL;
>>>       struct ext4_sb_info *sbi;
>>> @@ -3124,6 +3123,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>>>       int err;
>>>       unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
>>>       ext4_group_t first_not_zeroed;
>>> +
>>> +     char *orig_data = kstrdup(data, GFP_KERNEL);
>>> +     if (!orig_data)
>>> +             return ret;
>>>
>>>       sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
>>>       if (!sbi)
>>> @@ -4398,6 +4401,10 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
>>>       int i;
>>>  #endif
>>>       char *orig_data = kstrdup(data, GFP_KERNEL);
>>> +     if (!orig_data) {
>>> +             err = -ENOMEM;
>>> +             goto failed_alloc_orig;
>>
>> I didn't quite get why 'failed_alloc_orig' is needed here.
>> Why can't we just return -ENOMEM? Anyway we haven't yet
>> clobbered any opts at this point, right?
>>
>> See my comments below.
>>
>>> +     }
>>>
>>>       /* Store the original options */
>>>       lock_super(sb);
>>> @@ -4562,6 +4569,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
>>>       return 0;
>>>
>>>  restore_opts:
>>> +     kfree(orig_data);
>>> +failed_alloc_orig:
>>>       sb->s_flags = old_sb_flags;
>>>       sbi->s_mount_opt = old_opts.s_mount_opt;
>>>       sbi->s_mount_opt2 = old_opts.s_mount_opt2;
>>
>> This would put garbage values in sb->... and sbi->... when we jump
>> to 'failed_alloc_orig' upon 'orig_data' allocation failure, because
>> the old_* variables were still uninitialized at that point.
>>
>>> @@ -4580,7 +4589,6 @@ restore_opts:
>>>       }
>>>  #endif
>>>       unlock_super(sb);
>>> -     kfree(orig_data);
>>>       return err;
>>>  }
>>>
>>
>> Thanks,
>> Srivatsa S. Bhat
> Hi.
> Thanks for your review. It's my mistake.
> I will post patch v2 after modifing again.

Sure. And please CC linux-ext4@vger.kernel.org for ext4 related patches.

Thanks,
Srivatsa S. Bhat

