From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: rm: cannot remove `???': No such file or directory
Date: Mon, 24 Nov 2008 12:26:05 -0600
Message-ID: <492AF1BD.5080604@redhat.com>
References: <492AB6C5.1050609@cerberis.soften.ktu.lt>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Arturas K <arturas@cerberis.soften.ktu.lt>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45156 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbYKXS0M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Nov 2008 13:26:12 -0500
In-Reply-To: <492AB6C5.1050609@cerberis.soften.ktu.lt>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Arturas K wrote:
> hello,
> 
> I did a simple/dirty benchmark on multiple file systems, and ext4dev 
> encounters some problems recursively removing linux tree... tested with 
> default and multiple altered option sets of mkfs.ext4dev and/or mount 
> options - the same story :(
> 
> I guess there are locks on files where modification is committed to fs, 
> but not yet flushed to disk or something like this. anyway this behavior 
> is fatal for any temporary file operations...

This might be fixed by the patch that just showed up on the list today :)

--- fwd ---

PATCH ext4: fix to call_filldir

I happened to find a bug running bonnie++-1.03a on an ext4 filesystem,
when it complained about not being able to remove a file.

Further investigation showed a problem with call_filldir(), which is not
quite correct with respect to the same function in fs/ext3/dir.c.  The
patch below fixes this problem.

---

-Eric

> --- test output ---
> 
>> ~# ( cd /srv ; time ( tar xf /tmp/linux-2.6.26.tar && sync ) ) && ( cd /srv/linux-2.6.26 ; time ( cat /tmp/patch-2.6.27 | patch -p1 > ./log && sync ) ) && ( cd /srv ; time ( rm -R linux-2.6.26 && sync ) )
>>
>> real	0m9.515s
>> user	0m0.112s
>> sys	0m1.536s
>>
>> real	0m11.752s
>> user	0m2.680s
>> sys	0m2.868s
>> rm: cannot remove `linux-2.6.26/arch/powerpc/include/asm/bug.h': No such file or directory
>> rm: cannot remove `linux-2.6.26/arch/alpha/include/asm/fb.h': No such file or directory
>> rm: cannot remove `linux-2.6.26/arch/s390/include/asm/irq_regs.h': No such file or directory
>> rm: cannot remove `linux-2.6.26/arch/sparc/include/asm/mmu.h': No such file or directory
>> rm: cannot remove `linux-2.6.26/arch/sparc/include/asm/openprom_32.h': No such file or directory
>> rm: cannot remove `linux-2.6.26/arch/arm/configs/ateb9200_defconfig': No such file or directory
>> rm: cannot remove `linux-2.6.26/arch/m68knommu/include/asm/scatterlist.h': No such file or directory
>> rm: cannot remove `linux-2.6.26/include/asm-um/irq_vectors.h': No such file or directory
>> rm: cannot remove `linux-2.6.26/include/asm-m68k/virtconvert.h': No such file or directory
>> rm: cannot remove `linux-2.6.26/include/linux/hrtimer.h': No such file or directory
>> rm: cannot remove `linux-2.6.26/include/linux/hardirq.h': No such file or directory
>> rm: cannot remove `linux-2.6.26/include/linux/crc32c.h': No such file or directory
>>
>> real	0m0.721s
>> user	0m0.012s
>> sys	0m0.708s
> 
> --- system ---
> 
> ubuntu 8.10 amd64
> 
>  > ~# dpkg -l | grep linux-image-2.6.27
>  > ii  linux-image-2.6.27-7-generic 2.6.27-7.16
>  > ~# dpkg -l | grep e2fs
>  > ii  e2fslibs 1.41.3-1ubuntu1
>  > ii  e2fsprogs 1.41.3-1ubuntu1
> 
> ---
> ArturasK.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

