From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: resize2fs: Memory allocation failed while trying to resize
Date: Thu, 29 Aug 2013 11:04:30 -0500
Message-ID: <521F710E.7000409@redhat.com>
References: <CA+3zgmtOoDGSGQrk4k3QNuAkgpoDgF+xUkFT5qY9cKKS76MiQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Tim <elatllat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab3H2QEd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Aug 2013 12:04:33 -0400
In-Reply-To: <CA+3zgmtOoDGSGQrk4k3QNuAkgpoDgF+xUkFT5qY9cKKS76MiQQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/28/13 10:29 AM, Tim wrote:
> Hi,
> 
> I used resize2fs to do an online grow of from 8TB to 12TB and that worked fine.
> now I'm trying to offline shrink back down to 8TB and resize2fs is
> unable to do so.
> 
> Output:
> resize2fs -M /dev/mapper/
> crypt_left
> resize2fs 1.42.5 (29-Jul-2012)
> Resizing the filesystem on /dev/mapper/crypt_left to 1885633106 (4k) blocks.
> resize2fs: Memory allocation failed while trying to resize
> /dev/mapper/crypt_left
> Please run 'e2fsck -fy /dev/mapper/crypt_left' to fix the filesystem
> after the aborted resize operation.
> 
> I am using a raspberrypi so it's 32-bit and limited to 256MB and I
> have 2x that in swap.

Ok, now, hold on right there ;)

On the one hand it's worth understanding which memory allocation failed
and whether there's anything to be done about it, but:

Hoping to administer a 12T filesystem on a box with 256M of memory is
almost certainly wishful thinking.  (ok, 768M with swap)


A crucial part of deploying systems with very large filesystems is ensuring
that there is enough system memory to go along with it; in this case,
there almost certainly is not.

> uname -a
> Linux test 3.6.11+ #474 PREEMPT Thu Jun 13 17:14:42 BST 2013 armv6l GNU/Linux
> 
> I was watching top and never saw it use more that 53% of the RAM but I
> may have missed the crucial moment.
> (taken during a "e2fsck -fy ")
> free
>              total used free shared buffers cached
> Mem: 237648 225440 12208 0 63240 11796
> -/+ buffers/cache: 150404 87244
> Swap: 475132 13444 461688
> 
> Please let me know if there is anything that would help solve this issue.

You might use gdb, or an instrumented resize2fs, to find out which memory
allocation is failing and/or where the memory allocations are going.
The sad truth may just be that 256M + 512M swap isn't going to do the
trick.

-Eric
