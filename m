From: Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: quota: dqio_mutex design
Date: Thu, 3 Aug 2017 21:19:01 +0800
Message-ID: <CAP9B-QnvPJTvh3b0igBOJm+i-kzWPLcKM0qiPb-sfLxztzJUaA@mail.gmail.com>
References: <10928956.Fla3vXZ7d9@panda> <1691224.ooLB1CWbbI@panda>
 <CAP9B-QmBKVOfmT3=5wR9_P23+r6KGW_rfzJES4Y6pkjSofvPGg@mail.gmail.com> <8584759.E72qcEIvA1@panda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Shuichi Ihara <sihara@ddn.com>, Wang Shilong <wshilong@ddn.com>,
        Li Xi <lixi@ddn.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
To: Andrew Perepechko <anserper@yandex.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:35288 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbdHCNTC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Aug 2017 09:19:02 -0400
In-Reply-To: <8584759.E72qcEIvA1@panda>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Thu, Aug 3, 2017 at 8:24 PM, Andrew Perepechko <anserper@yandex.ru> wrote:
>>
>> I don't think this is right, as far as i understand, journal quota need go
>> together with quota space change update inside same transaction, this will
>> break consistency if power off or RO happen.
>>
>
> Hello Wang!
>
> There is no transaction change in this case because all callers of this
> function have open handles for the same transaction.
>
> If you enter that DQ_MOD_B check, you are guaranteed to reference
> the SAME transaction as the thread that's in between of mark_dirty
> and clear_dirty.
>

This change mean if this dquot is dirty we skip, this
won't work because in this way, quota update is only kept in vfs dquota memory
and newer update is not wrote to journal file and not wrapped into transaction
too.

This is not what journal quota means to do.


Thanks,
Shilong


> Thank you,
> Andrew
