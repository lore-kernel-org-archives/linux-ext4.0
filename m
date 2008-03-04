From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [2.6.25-rc2-mm1] Oops in __kmalloc
Date: Tue, 04 Mar 2008 11:41:23 +0100
Message-ID: <47CD2753.5050905@gmail.com>
References: <47C42DDF.3060506@gmail.com> <20080226100913.9412b41c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Jan Sonnek <xsonnek@fi.muni.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.180]:16194 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbYCDKkm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Mar 2008 05:40:42 -0500
Received: by ik-out-1112.google.com with SMTP id c28so766434ika.5
        for <linux-ext4@vger.kernel.org>; Tue, 04 Mar 2008 02:40:40 -0800 (PST)
In-Reply-To: <20080226100913.9412b41c.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Morton napsal(a):
> On Tue, 26 Feb 2008 16:18:55 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> Hi,
>>
>> while booting up a notebook on 32 bit, this oopses appeared on the console
>> after ext3 fsck:
>> http://www.fi.muni.cz/~xslaby/sklad/mem_oops/
>>
>> It's 2.6.25-rc2-mm1, I can't find similar reports, is this known or hardware
>> issue (unlikely, 2.6.24.2 seems to be OK)?
> 
> I don't recall seeing a similar report and yes, it'll be a kernel bug.
> 
> We've fixed a few things and it could be that this will just go away in
> next -mm.  If it doesn't, a bisection search would be good, thanks.

Well, next -mm is out. Could you test, Jan? [our -mm git is up-to-date]
