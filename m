From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc4-mm1: some issues on sparc64
Date: Sun, 9 Dec 2007 01:03:11 -0800
Message-ID: <20071209010311.5bc7318d.akpm@linux-foundation.org>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<200712081920.28748.m.kozlowski@tuxland.pl>
	<20071208102239.2457eeaa.akpm@linux-foundation.org>
	<20071209.004517.201813773.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: m.kozlowski@tuxland.pl, linux-kernel@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-ext4@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58208 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750732AbXLIJDS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Dec 2007 04:03:18 -0500
In-Reply-To: <20071209.004517.201813773.davem@davemloft.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 09 Dec 2007 00:45:17 -0800 (PST) David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Sat, 8 Dec 2007 10:22:39 -0800
> 
> > That's
> > 
> >         J_ASSERT_BH(bh, !buffer_jbddirty(bh));
> > 
> > at the end of journal_unmap_buffer().
> > 
> > I don't recall seeing that before and I can't think of anything we've
> > done recently which could cause it, sorry.
> 
> If the per-cpu data patches are in the -mm tree that is the first
> place I would start looking at for possible cause.

They aren't.  The dust hadn't settled enough on those when Christoph shot
through on vacation.
