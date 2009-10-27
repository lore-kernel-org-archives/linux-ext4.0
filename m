From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Fwd: Ext4 bug with fallocate
Date: Mon, 26 Oct 2009 23:42:03 -0500
Message-ID: <4AE67A1B.8060704@redhat.com>
References: <a125a870910180836i66781e1ey8113e7f8569f1fad@mail.gmail.com> <a125a870910180847s5f3eaf6cxfe58e6ceb26419c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Fredrik Andersson <nablaman@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbZJ0Ema (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Oct 2009 00:42:30 -0400
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


Not trying to ignore you, but trying to sort out some corruption issues 
that I'm afraid I have to rank higher than a hang for now...

 From the traces, things are hung up on the i_data_sem; several 
pdflushes want it for read in ext4_get_blocks_wrap, and drbdmakes 
presumably have it downed for write in ext4_ext_truncate.  I'm not 
immediately seeing the deadlock tonight, but then it's getting late...

Is the application that's triggering this something you can share?

Thanks,
-Eric
