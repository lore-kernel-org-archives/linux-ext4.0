From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Fwd: Ext4 bug with fallocate
Date: Sun, 18 Oct 2009 10:57:32 -0500
Message-ID: <4ADB3AEC.8040901@redhat.com>
References: <a125a870910180836i66781e1ey8113e7f8569f1fad@mail.gmail.com> <a125a870910180847s5f3eaf6cxfe58e6ceb26419c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Fredrik Andersson <nablaman@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630AbZJRP5d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Oct 2009 11:57:33 -0400
In-Reply-To: <a125a870910180847s5f3eaf6cxfe58e6ceb26419c6@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fredrik Andersson wrote:
> Hi, I'd like to report what I'm fairly certain is an ext4 bug. I hope
> this is the right place to do so.
> 
> My program creates a big file (around 30 GB) with posix_fallocate (to
> utilize extents), fills it with data and uses ftruncate to crop it to
> its final size (usually somewhere between 20 and 25 GB).
> The problem is that in around 5% of the cases, the program locks up
> completely in a syscall. The process can thus not be killed even with
> kill -9, and a reboot is all that will do.

does echo w > /proc/sysrq-trigger (this does sleeping processes; or use 
echo t for all processes) show you where the stuck threads are?

-Eric

