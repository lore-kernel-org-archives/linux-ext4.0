Return-Path: <SRS0=vuM7=RP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 912D5C43381
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Mar 2019 21:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 627C6213A2
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Mar 2019 21:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfCLV3x (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 12 Mar 2019 17:29:53 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54826 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbfCLV3w (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Mar 2019 17:29:52 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1h3oy4-0006F8-Ay; Tue, 12 Mar 2019 15:29:48 -0600
Received: from ip68-227-174-240.om.om.cox.net ([68.227.174.240] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1h3oy3-0000Ej-9t; Tue, 12 Mar 2019 15:29:48 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Petr Mladek <pmladek@suse.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocky" <rafael.j.wysocki@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-ext4@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>
References: <20190306132938.hzyb7gee5actx3l3@pathway.suse.cz>
        <CAHk-=wi=m7vcLJB2uqTPcVd603ygCeKr7NBtR5y0M8KHtMzFWg@mail.gmail.com>
Date:   Tue, 12 Mar 2019 16:29:25 -0500
In-Reply-To: <CAHk-=wi=m7vcLJB2uqTPcVd603ygCeKr7NBtR5y0M8KHtMzFWg@mail.gmail.com>
        (Linus Torvalds's message of "Sun, 10 Mar 2019 10:56:34 -0700")
Message-ID: <87k1h3pyru.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1h3oy3-0000Ej-9t;;;mid=<87k1h3pyru.fsf@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.240;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/gD3HVN1G6bap8nCkcSl5zFOUqhScq9C0=
X-SA-Exim-Connect-IP: 68.227.174.240
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [question] panic() during reboot -f (reboot syscall)
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, Mar 6, 2019 at 5:29 AM Petr Mladek <pmladek@suse.com> wrote:
>>
>> I wonder if it is "normal" to get panic() when the system is rebooted
>> using "reboot -f". I looks a bit weird to me.
>
> No, a panic is never normal (except possibly for test modules etc, of course).
>
>> Now, "reboot -f" just calls the reboot() syscall. I do not see
>> anything that would stop processes.
>
> There isn't supposed to be anything. It's meant for "things are
> screwed up, just reboot *now* without doing anything else".
>
> The "reboot now" is basically meant to be a poor man's power cycle.
>
>> But it shuts down devices very early, via:
>>
>>   + kernel_restart()
>>     + kernel_restart_prepare()
>>       + blocking_notifier_call_chain(&reboot_notifier_list, SYS_RESTART, cmd);
>>       + device_shutdown()
>
> The problem is that there are conflicting goals here, and the kernel
> doesn't even *know* if this is supposed to be a normal clean reboot,
> or a "reboot -f" that just shuts down everything.
>
> On a nice clean reboot (where init has shut everything down) we
> obviously _do_ want to shut devices down etc. Quite often you need to
> do it just to make sure they come up nicely again (because the
> firmware isn't even always re-initializing things properly on a soft
> reboot).
>
> But on a "reboot -f", user space _hasn't_ cleaned up, and just wants
> things to reboot. But the kernel doesn't really know. It just gets the
> reboot system call in both cases.
>
>> By other words. It looks like the panic() is possible by design.
>> But it looks a bit weird. Any opinion?
>
> It's definitely not "by design", but it might be unavoidable in this case.
>
> Of course, "unavoidable" is relative. There could be workarounds that
> are reasonably ok in practice.
>
> Like having the filesystem panic code see "oh, system_state isn't
> SYSTEM_RUNNING, so I shouldn't be panicing".

I wonder if there is an easy way to get the scheduler to not schedule
userspace processes once the reboot system call has started.  That
sounds like the simple way to avoid this kind of confusion.

Eric

