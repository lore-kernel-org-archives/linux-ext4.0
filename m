From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Bug: Large writes can fail on ext4 if the write buffer is not
 empty
Date: Thu, 19 Apr 2012 09:15:40 -0500
Message-ID: <4F901E0C.3010008@redhat.com>
References: <20120412160658.GA9697@gmail.com> <793C2320-255A-4894-AA07-70EDBB1DDDA5@iki.fi> <alpine.LRH.2.00.1204191543570.13563@ruuvi.it.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>
To: Jouko Orava <jouko.orava@helsinki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506Ab2DSOPs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Apr 2012 10:15:48 -0400
In-Reply-To: <alpine.LRH.2.00.1204191543570.13563@ruuvi.it.helsinki.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/19/12 8:10 AM, Jouko Orava wrote:
> Hi Zheng,
> 
> I can confirm the bug exists on latest RHEL 6 x86_64 kernels (2.6.32-220).
> 
> On current mainline kernels all writes are limited to one page under 2GB,
> which masks the problem. I have not checked if mainline 2.6.32 has this
> limit or not. It does not matter: the limit is just a band-aid to paper
> over filesystem bugs, and should not mean you don't fix filesystem bugs.

FWIW, we tried fairly hard to get the limit lifted in the vfs, to no avail.

> I can confirm the one line patch to fs/ext4/file.c does fix the problem.
> I have test kernels based on 2.6.32-220.7.1.el6.x86_64 with only
> the patch applied, at
> 	http://www.helsinki.fi/~joorava/kernel/
> if anyone else is interested in testing.
> 
> I did some (limited) testing on ext4 with the patch. It fixes the problem:
> large writes work very well too. No problems popped up in testing.
> 
> Tested-by: Jouko Orava <jouko.orava@helsinki.fi>
> 
> 
> I'd also like to point at the real bug here, in Jouni's original strace:
> 
> 	writev(3, [{"\0\0\0\0\0\0\0\0", 8}, {"", 2147483648}], 2) = -2147483640
> 
> The syscall returns a negative value, which is not the actual number of
> bytes written (since it is 32-bit wrapped), and errno has not been
> changed. There is no way for userspace to handle this result correctly!
> 
> There is no way anyone sane should just gloss over this saying
> "programmer fault, you're doing it wrong".
> This is a real bug, and deserves fixing sooner rather than later.

Agreed, I think Dave was a little to quick on the draw on his reply.  :)

-Eric

> Thanks,
>    Jouko Orava
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

