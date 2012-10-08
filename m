From: Peter Fordham <peter.fordham@gmail.com>
Subject: spinlocks in ext4
Date: Mon, 8 Oct 2012 16:33:45 -0700
Message-ID: <CAK5=ZRLQErM1dOT_Tuf-SC4-3VK_o6TRg-0k8A=iQGgFY6S+aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:41577 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2JHXdq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Oct 2012 19:33:46 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so2877722wey.19
        for <linux-ext4@vger.kernel.org>; Mon, 08 Oct 2012 16:33:45 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Can someone give me a quick outline of why spinlocks are required in
the EXT4 code? Don't all file-system requests originate from user
context, hence meaning all locking be done with mutexes or semaphores.

I'm doing some profiling on an ARM device it's showing up spin unlock
taking a lot of time and I'd like to migrate to using mutex's instead
since they don't incur penalties from synchronization instructions
like DMB.  I'm guessing there's some underlying reason why this isn't
safe and I'd like to understand it.

thanks,

-Pete Fordham
