Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34182 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbeLCLKG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2018 06:10:06 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id DDAF82B231
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 11:09:30 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 11:09:28 +0000
Message-ID: <bug-201685-13602-ZQq53Un7xR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #197 from Marc Burkhardt (marc@osknowledge.org) ---
(In reply to Marc Burkhardt from comment #194)
> (In reply to Rainer Fiebig from comment #192)
> > #136
> > 
> > It has been suggested that I/O-schedulers may play a role in this. So
> here's
> > are my settings for 4.19.x for comparison. They deviate from yours in some
> > points but I really don't know whether this has any relevance. You may want
> > to give it a try anyway. As I've said, 4.19.x is a nice kernel here.
> > 
> > > grep -i sched .config_4.19-rc5 
> > CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> > CONFIG_CGROUP_SCHED=y
> > CONFIG_FAIR_GROUP_SCHED=y
> > CONFIG_RT_GROUP_SCHED=y
> > CONFIG_SCHED_AUTOGROUP=y
> > CONFIG_SCHED_OMIT_FRAME_POINTER=y
> > CONFIG_SCHED_SMT=y
> > CONFIG_SCHED_MC=y
> > CONFIG_SCHED_MC_PRIO=y
> > CONFIG_SCHED_HRTICK=y
> > # CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
> > # CONFIG_CPU_FREQ_GOV_SCHEDUTIL is not set
> > # IO Schedulers
> > CONFIG_IOSCHED_NOOP=y
> > CONFIG_IOSCHED_DEADLINE=y
> > CONFIG_IOSCHED_CFQ=y
> > CONFIG_CFQ_GROUP_IOSCHED=y
> > CONFIG_DEFAULT_IOSCHED="deadline"
> > CONFIG_MQ_IOSCHED_DEADLINE=y
> > CONFIG_MQ_IOSCHED_KYBER=y
> > # CONFIG_IOSCHED_BFQ is not set
> > CONFIG_NET_SCHED=y
> > # Queueing/Scheduling
> > CONFIG_USB_EHCI_TT_NEWSCHED=y
> > CONFIG_SCHED_INFO=y
> > CONFIG_SCHED_TRACER=y
> 
> Really, how come you say "these are your settings"?
> 
> The settings are, what is actually being used not what has ben compiled-in
> or I miss anything?
> 
> What's the coincidence between 
> 
> CONFIG_DEFAULT_IOSCHED="deadline" + CONFIG_IOSCHED_DEADLINE=y
> 
> and
> 
> cat /sys/block/sda/queue/scheduler 
> mq-deadline [kyber] bfq none
> 
> Please see #139 - wee need a list of what is effectively used and not what
> is actually possible. Bare metal or not. Intel? AMD? hugepages or nor?

I use an allegedly wrong compiler, I use 4.19.y, I use ext4 with and without
dm-crypt, I use a scheduler, .... and I am currently NOT affected by that bug
even running the tests that people say triggers the bug.

Just to make it clear again: I'm not a kernel dev, ok, but I use Linux for
along time and I'm willing to help out what setup is *not* affected. Maybe I do
something totally wrong here but I'm willing to help out as a gibe-back to the
community providing me the OS I use solely for 20+ years.

I think the discussion should (at this point) not gather around what your
kernel is *capable* of, but just what actually is set-up to trigger the bug.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
