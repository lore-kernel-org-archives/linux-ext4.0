Return-Path: <SRS0=U5g5=4N=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1AC3C35E04
	for <linux-ext4@archiver.kernel.org>; Tue, 25 Feb 2020 16:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99FCC20CC7
	for <linux-ext4@archiver.kernel.org>; Tue, 25 Feb 2020 16:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582648924;
	bh=HCcldr63vGZliX4tFsN//KvWjU/8RG5en/RcSjTvcAQ=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:List-ID:
	 From;
	b=FLB4PerpQsyRUeA29oEGANcrT3TuHJsnGsUDIS/bhEH+ukI7PgTNIxfvNdER4LPnu
	 JR5c7d9Jdf/EQuZxRMTLNJ2DPkTBpFwM83GUCliYGGRlaDHKWjz79lbZ7n/iMytF0Y
	 wRbhusIA/qbdrydkG0CZ8+jY8XoZUnIQFCp6L6yU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731065AbgBYQmD (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 25 Feb 2020 11:42:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:43708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728499AbgBYQmD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 25 Feb 2020 11:42:03 -0500
Received: from paulmck-ThinkPad-P72.home (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7003720732;
        Tue, 25 Feb 2020 16:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582648922;
        bh=HCcldr63vGZliX4tFsN//KvWjU/8RG5en/RcSjTvcAQ=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=lobyvBc918gRy0eR7ZvL/SIDpZAJi496eFdW07XJlgT2Y/z+g5/+WlmWcQnXfdNKT
         gYSMTgT/geHJHpC5RlFX3Sv0PmyBytJdMCwC8M5trCAUdoDqVE0Z1oKeCyK/ep8yWa
         Uevlc1CqYAZf/obUxw1gkDsARH4794jUR5k8DpUs=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 09FBB3521A4D; Tue, 25 Feb 2020 08:38:27 -0800 (PST)
Date:   Tue, 25 Feb 2020 08:38:27 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Uladzislau Rezki <urezki@gmail.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] ext4: fix potential race between online resizing and
 write operations
Message-ID: <20200225163826.GW2935@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200220045233.GC476845@mit.edu>
 <20200221003035.GC2935@paulmck-ThinkPad-P72>
 <20200221131455.GA4904@pc636>
 <20200221202250.GK2935@paulmck-ThinkPad-P72>
 <20200222222415.GC191380@google.com>
 <20200223011018.GB2935@paulmck-ThinkPad-P72>
 <20200224174030.GA22138@pc636>
 <20200225020705.GA253171@google.com>
 <20200225035549.GU2935@paulmck-ThinkPad-P72>
 <CAEXW_YQbiHW=yKiYAs0=8Mp84W6UunM6OOkHE66yXT6cSchm7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXW_YQbiHW=yKiYAs0=8Mp84W6UunM6OOkHE66yXT6cSchm7A@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Feb 25, 2020 at 09:17:11AM -0500, Joel Fernandes wrote:
> On Mon, Feb 24, 2020 at 10:55 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> [...]
> > > > As for "task_struct's rcu_read_lock_nesting". Will it be enough just
> > > > have a look at preempt_count of current process? If we have for example
> > > > nested rcu_read_locks:
> > > >
> > > > <snip>
> > > > rcu_read_lock()
> > > >     rcu_read_lock()
> > > >         rcu_read_lock()
> > > > <snip>
> > > >
> > > > the counter would be 3.
> > >
> > > No, because preempt_count is not incremented during rcu_read_lock(). RCU
> > > reader sections can be preempted, they just cannot goto sleep in a reader
> > > section (unless the kernel is RT).
> >
> > You are both right.
> >
> > Vlad is correct for CONFIG_PREEMPT=n and CONFIG_DEBUG_ATOMIC_SLEEP=y
> > and Joel is correct otherwise, give or take the possibility of other
> > late-breaking corner cases.  ;-)
> 
> Oh yes, but even for PREEMPT=n, rcu_read_lock() is just a NOOP for
> that configuration and doesn't really mess around with preempt_count
> if I recall :-D. (doesn't need to mess with preempt_count because
> being in kernel mode is non-preemptible for PREEMPT=n anyway).

For PREEMPT=n, rcu_read_lock() is preempt_disable(), see the code
in include/linux/rcupdate.h.  ;-)

							Thanx, Paul
