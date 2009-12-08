From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: writev corruption and 64-bit quota patches for 2.6.33-rc1?
Date: Tue, 08 Dec 2009 20:03:09 +0300
Message-ID: <87ein5bdpu.fsf@openvz.org>
References: <20091208110043.GC4095@quack.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:54207 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935861AbZLHRCy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Dec 2009 12:02:54 -0500
Received: from dmon-lp ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru (Sun Java(tm) System Messaging Server 7u2-7.02 64bit
 (built Apr 16 2009)) with ESMTPA id <0KUC0072ZFKWLK50@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Tue, 08 Dec 2009 20:07:47 +0300 (MSK)
In-reply-to: <20091208110043.GC4095@quack.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

>   Hi Ted,
>
>   do you plan on merging my fixes for writev filesystem corruption and
> 64-bit quota patches? The writev patch is independent of any other patch
> and should go in ASAP, 64-bit quota patch depends on generic quota code
BTW, where can I find this changes for generic quota code.
Your linux-quota-2.6.git disappeared from kernel.org couple weeks ago,
so I can't find in anywhere.

> change so either I can merge it or you can merge a bit later (it's a small
> change for ext4).
>   The patches were sent as:
> http://marc.info/?l=linux-ext4&m=125978147226649&w=3
> (writev corruption fix - it has a minor whitespace bug so I'm attaching a
> version with that bug fixed)
> http://marc.info/?l=linux-ext4&m=125978717902673&w=3
> (64-bit quota support)
>
>
> 								Honza
