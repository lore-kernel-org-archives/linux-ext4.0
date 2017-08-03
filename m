From: Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: quota: dqio_mutex design
Date: Thu, 3 Aug 2017 19:31:04 +0800
Message-ID: <CAP9B-QmBKVOfmT3=5wR9_P23+r6KGW_rfzJES4Y6pkjSofvPGg@mail.gmail.com>
References: <10928956.Fla3vXZ7d9@panda> <20170801130242.GH4215@quack2.suse.cz>
 <20170802162552.GA30353@quack2.suse.cz> <1691224.ooLB1CWbbI@panda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
To: Andrew Perepechko <anserper@yandex.ru>,
        Shuichi Ihara <sihara@ddn.com>,
        Wang Shilong <wshilong@ddn.com>, Li Xi <lixi@ddn.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:35856 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752211AbdHCLbF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Aug 2017 07:31:05 -0400
In-Reply-To: <1691224.ooLB1CWbbI@panda>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Guys,

We DDN is investigating the same issue!

Some comments comes:

On Thu, Aug 3, 2017 at 1:52 AM, Andrew Perepechko <anserper@yandex.ru> wrote:
>> On Tue 01-08-17 15:02:42, Jan Kara wrote:
>> > Hi Andrew,
>> >
>> I've been experimenting with this today but this idea didn't bring any
>> benefit in my testing. Was your setup with multiple users or a single user?
>> Could you give some testing to my patches to see whether they bring some
>> benefit to you?
>>
>>                                                               Honza
>
> Hi Jan!
>
> My setup was with a single user. Unfortunately, it may take some time before
> I can try a patched kernel other than RHEL6 or RHEL7 with the same test,
> we have a lot of dependencies on these kernels.
>
> The actual test we ran was mdtest.
>
> By the way, we had 15+% performance improvement in creates from the
> change that was discussed earlier in this thread:
>
>            EXT4_SB(dquot->dq_sb)->s_qf_names[GRPQUOTA]) {
> +              if (test_bit(DQ_MOD_B, &dquot->dq_flags))
> +                       return 0;

I don't think this is right, as far as i understand, journal quota need go
together with quota space change update inside same transaction, this will
break consistency if power off or RO happen.

Here is some ideas that i have thought:

1) switch dqio_mutex to a read/write lock, especially, i think most of
time journal quota updates is in-place update, that means we don't need
change quota tree in memory, firstly try read lock, retry with write lock if
there is real tree change.

2)another is similar idea of Andrew's walkaround, but we need make correct
fix, maintain dirty list for per transaction, and gurantee quota updates are
flushed when commit transaction, this might be complex, i am not very
familiar with JBD2 codes.

It will be really nice if we could fix this regression, as we see 20% performace
regression.

Thanks,
Shilong

>                dquot_mark_dquot_dirty(dquot);
>                return ext4_write_dquot(dquot);
>
> The idea was that if we know that some thread is somewhere between
> mark_dirty and clear_dirty, then we can avoid blocking on dqio_mutex,
> since that thread will update the ondisk dquot for us.
>
