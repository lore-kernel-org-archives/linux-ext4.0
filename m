From: Peter Fordham <peter.fordham@gmail.com>
Subject: Re: spinlocks in ext4
Date: Thu, 11 Oct 2012 11:37:46 -0700
Message-ID: <CAK5=ZRJt3KCQniUA+-E4kn_51nFvB34796wOoG4vrmzU5nfwOA@mail.gmail.com>
References: <CAK5=ZRLQErM1dOT_Tuf-SC4-3VK_o6TRg-0k8A=iQGgFY6S+aw@mail.gmail.com>
	<20121009005425.GB20682@thunk.org>
	<20121009011036.GC20682@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:39813 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759126Ab2JKShq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2012 14:37:46 -0400
Received: by mail-ia0-f174.google.com with SMTP id y32so1469844iag.19
        for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2012 11:37:46 -0700 (PDT)
In-Reply-To: <20121009011036.GC20682@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8 October 2012 18:10, Theodore Ts'o <tytso@mit.edu> wrote:
> How expensive are memory barriers on ARM, anyway?

The performance monitors seem to be telling me that a DMB just after a
store which misses in the L1 & L2, (causing an eviction of a clean
line and a line-fill, I assume) takes over 100 cycles.

I'm seeing a 20% slow down in ext4 performance when enabling SMP on my
device. I'm starting to think there might be issues with the memory
system.

-Pete
