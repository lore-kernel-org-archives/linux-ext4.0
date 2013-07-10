From: Dustin Lundquist <dustin@null-ptr.net>
Subject: Re: kernel BUG at fs/buffer.c:1234!
Date: Tue, 09 Jul 2013 21:05:54 -0700
Message-ID: <51DCDDA2.1000808@null-ptr.net>
References: <51C1DF40.7030708@null-ptr.net> <20130619185537.GB24587@thunk.org> <51C32BB1.5070902@null-ptr.net> <20130620163406.GB4982@thunk.org> <51D5DBA2.4050705@null-ptr.net> <20130708141201.GG5988@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.overthere.org ([67.214.208.79]:34611 "EHLO
	mail.overthere.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3GJEF4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jul 2013 00:05:56 -0400
In-Reply-To: <20130708141201.GG5988@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/08/2013 07:12 AM, Jan Kara wrote:
>    Hum, so it's interesting that ecryptfs_lookup() WARN_ON() didn't trigger
> but ext4 one did. Strangely enough I don't see a place in the call chain
> where irqs could get disabled. Can you maybe trace using irq tracing at
> which point exactly do we disable interrupts?

I'm not familiar with irq tracing, but I traced it as far as a function 
pointer in a macro at fs/ecryptfs/keystore.c:840 then tried blacklisting 
the aesni_intel module and I haven't been able to reproduce it since.

At this point I would be interested if anyone else can reproduce it on 
another Intel Ivy Bridge system with aesni and Linux 3.10:
1. Setup an ecryptfs mount over an ext4 file system
2. Cause a program running inside ecryptfs mount to core dump

Thanks,


Dustin Lundquist
