From: Roy Yang <roy@cohesity.com>
Subject: Re: Ext4 stuck at wait_transaction_locked
Date: Sat, 27 Aug 2016 07:45:57 -0700
Message-ID: <CAFz9U7SHbv4i=x-2mVYKw5TG_Q9_F+WSp5+jHiHWoQGHJXRmXw@mail.gmail.com>
References: <CAFz9U7TAWtpQPfgG0u=6_jtVUhK5ahPGGnGy6GK8RZ-0XM2pfg@mail.gmail.com>
 <20160827133642.4znpf3aprhgbdtwv@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:36758 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753534AbcH0Op7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Aug 2016 10:45:59 -0400
Received: by mail-ua0-f182.google.com with SMTP id m60so142241655uam.3
        for <linux-ext4@vger.kernel.org>; Sat, 27 Aug 2016 07:45:58 -0700 (PDT)
In-Reply-To: <20160827133642.4znpf3aprhgbdtwv@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
  Thank you very much for reply.
  The stack trace of the process is killed is:

94346.777541] java invoked oom-killer: gfp_mask=0xd0, order=0, oom_score_adj=0

[94346.777548] java cpuset=/ mems_allowed=0-1

[94346.777551] CPU: 11 PID: 18564 Comm: java Not tainted
3.10.0-327.22.2.el7..x86_64 #1

[94346.777553] Hardware name: Intel Corporation S2600TP/S2600TP, BIOS
SE5C610.86B.01.01.0016.033120161139 03/31/2016

[94346.777555]  ffff88104cb7a280 000000003ccafc27 ffff881046c77cd0
ffffffff816360f4

[94346.777563]  ffff881046c77d60 ffffffff8163108f ffff881046c77d18
0000000000000297

[94346.777567]  ffffea003fff1fc0 ffff881046c77d30 ffffffff8116cd26
ffff8810491110e8

[94346.777572] Call Trace:

[94346.777584]  [<ffffffff816360f4>] dump_stack+0x19/0x1b

[94346.777588]  [<ffffffff8163108f>] dump_header+0x8e/0x214

[94346.777595]  [<ffffffff8116cd26>] ? find_lock_task_mm+0x56/0xc0

[94346.777598]  [<ffffffff8116d1be>] oom_kill_process+0x24e/0x3b0

[94346.777605]  [<ffffffff81088dae>] ? has_capability_noaudit+0x1e/0x30

[94346.777611]  [<ffffffff811d40e5>] mem_cgroup_oom_synchronize+0x575/0x5a0

[94346.777614]  [<ffffffff811d34b0>] ? mem_cgroup_charge_common+0xc0/0xc0

[94346.777617]  [<ffffffff8116da34>] pagefault_out_of_memory+0x14/0x90

[94346.777620]  [<ffffffff8162f4bf>] mm_fault_error+0x68/0x12b

[94346.777625]  [<ffffffff81642012>] __do_page_fault+0x3e2/0x450

[94346.777628]  [<ffffffff816420a3>] do_page_fault+0x23/0x80

[94346.777633]  [<ffffffff8163e308>] page_fault+0x28/0x30

[94346.777636] Task in /system.slice/_elasticsearch.scope killed as a
result of limit of /system.slice/_elasticsearch.scope

[94346.777639] memory: usage 1433600kB, limit 1433600kB, failcnt 45132

[94346.777640] memory+swap: usage 1433600kB, limit 9007199254740991kB, failcnt 0

[94346.777642] kmem: usage 0kB, limit 9007199254740991kB, failcnt 0

[94346.777643] Memory cgroup stats for
/system.slice/_elasticsearch.scope: cache:148KB rss:1433452KB
rss_huge:1126400KB mapped_file:4KB swap:0KB inactive_anon:0KB
active_anon:1433452KB inactive_file:108KB active_file:20KB
unevictable:0KB

 We adjust the memory limit and avoid this process is killed. Now the
problem goes away. If possible, we still want to understand why Ext4
is stuck in this case.

  Thank you,

  Roy


On Sat, Aug 27, 2016 at 6:36 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Aug 25, 2016 at 11:52:07PM -0700, Roy Yang wrote:
>> I need your help to debug one ext4 issue. We consistently see Ext4
>> stuck at wait_transaction_locked after another process is killed by
>> cgroup because of oom. We have two processes keeping writing data to
>> the same disk, and one was killed because of oom; the other process
>> will stall at all I/O operations pretty soon.
>
> You're using an ancient, 3.10-based RHEL 7 kernel:
>
>> Linux sedhaswell04-node-1 3.10.0-327.22.2.el7.cohesity.x86_64 #1 SMP
>> Tue Jul 5 12:41:09 PDT 2016 x86_64 x86_64 x86_64 GNU/Linux
>
> As far as I know this bug does not exist in the upstream kernel ---
> but the 3.10 kernel was released in June 2013, and since then changes
> are the responsibility of Red Hat / CentOS.  So you would need to get
> support from Red Hat, since they have made a huge number of changes to
> the kernel.
>
> If you had given us the stack trace from the task that got OOM-killed,
> we might be able to take a quick look, but if you use a distribution
> kernel, it is the responsibility of the distribution to support you
> --- this is, after all, why they get paid the big bucks.  :-)
>
> If you want to you use the latest upstream kernel, we would be much
> more likely to help, although of course unlike Red Hat we don't have
> any kind of guaranteed response time.  For that, you would need to go
> find a distribution and pay the aforementioned big bucks.  :-)
>
> Cheers,
>
>                                           - Ted
>
