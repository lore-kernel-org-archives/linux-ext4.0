From: Jouko Orava <jouko.orava@helsinki.fi>
Subject: Re: Bug: Large writes can fail on ext4 if the write buffer is not
 empty
Date: Thu, 19 Apr 2012 16:10:03 +0300 (EEST)
Message-ID: <alpine.LRH.2.00.1204191543570.13563@ruuvi.it.helsinki.fi>
References: <20120412160658.GA9697@gmail.com> <793C2320-255A-4894-AA07-70EDBB1DDDA5@iki.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Zheng Liu <gnehzuil.liu@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-rs1-vallila2.fe.helsinki.fi ([128.214.173.75]:39647 "EHLO
	smtp-rs1-vallila2.fe.helsinki.fi" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752808Ab2DSNkU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Apr 2012 09:40:20 -0400
In-Reply-To: <20120412160658.GA9697@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Zheng,

I can confirm the bug exists on latest RHEL 6 x86_64 kernels (2.6.32-220).

On current mainline kernels all writes are limited to one page under 2GB,
which masks the problem. I have not checked if mainline 2.6.32 has this
limit or not. It does not matter: the limit is just a band-aid to paper
over filesystem bugs, and should not mean you don't fix filesystem bugs.

I can confirm the one line patch to fs/ext4/file.c does fix the problem.
I have test kernels based on 2.6.32-220.7.1.el6.x86_64 with only
the patch applied, at
	http://www.helsinki.fi/~joorava/kernel/
if anyone else is interested in testing.

I did some (limited) testing on ext4 with the patch. It fixes the problem:
large writes work very well too. No problems popped up in testing.

Tested-by: Jouko Orava <jouko.orava@helsinki.fi>


I'd also like to point at the real bug here, in Jouni's original strace:

	writev(3, [{"\0\0\0\0\0\0\0\0", 8}, {"", 2147483648}], 2) = -2147483640

The syscall returns a negative value, which is not the actual number of
bytes written (since it is 32-bit wrapped), and errno has not been
changed. There is no way for userspace to handle this result correctly!

There is no way anyone sane should just gloss over this saying
"programmer fault, you're doing it wrong".
This is a real bug, and deserves fixing sooner rather than later.

Thanks,
   Jouko Orava
