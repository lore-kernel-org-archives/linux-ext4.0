From: Arturas K <arturas@cerberis.soften.ktu.lt>
Subject: rm: cannot remove `???': No such file or directory
Date: Mon, 24 Nov 2008 16:14:29 +0200
Message-ID: <492AB6C5.1050609@cerberis.soften.ktu.lt>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cerberis.soften.ktu.lt ([193.219.33.193]:49895 "EHLO
	cerberis.soften.ktu.lt" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbYKXOkj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Nov 2008 09:40:39 -0500
Received: from [172.16.6.95] (unknown [193.219.160.108])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by cerberis.soften.ktu.lt (Postfix) with ESMTP id 7EC1F160004B8
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 16:15:40 +0200 (EET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hello,

I did a simple/dirty benchmark on multiple file systems, and ext4dev 
encounters some problems recursively removing linux tree... tested with 
default and multiple altered option sets of mkfs.ext4dev and/or mount 
options - the same story :(

I guess there are locks on files where modification is committed to fs, 
but not yet flushed to disk or something like this. anyway this behavior 
is fatal for any temporary file operations...

--- test output ---

> ~# ( cd /srv ; time ( tar xf /tmp/linux-2.6.26.tar && sync ) ) && ( cd /srv/linux-2.6.26 ; time ( cat /tmp/patch-2.6.27 | patch -p1 > ./log && sync ) ) && ( cd /srv ; time ( rm -R linux-2.6.26 && sync ) )
> 
> real	0m9.515s
> user	0m0.112s
> sys	0m1.536s
> 
> real	0m11.752s
> user	0m2.680s
> sys	0m2.868s
> rm: cannot remove `linux-2.6.26/arch/powerpc/include/asm/bug.h': No such file or directory
> rm: cannot remove `linux-2.6.26/arch/alpha/include/asm/fb.h': No such file or directory
> rm: cannot remove `linux-2.6.26/arch/s390/include/asm/irq_regs.h': No such file or directory
> rm: cannot remove `linux-2.6.26/arch/sparc/include/asm/mmu.h': No such file or directory
> rm: cannot remove `linux-2.6.26/arch/sparc/include/asm/openprom_32.h': No such file or directory
> rm: cannot remove `linux-2.6.26/arch/arm/configs/ateb9200_defconfig': No such file or directory
> rm: cannot remove `linux-2.6.26/arch/m68knommu/include/asm/scatterlist.h': No such file or directory
> rm: cannot remove `linux-2.6.26/include/asm-um/irq_vectors.h': No such file or directory
> rm: cannot remove `linux-2.6.26/include/asm-m68k/virtconvert.h': No such file or directory
> rm: cannot remove `linux-2.6.26/include/linux/hrtimer.h': No such file or directory
> rm: cannot remove `linux-2.6.26/include/linux/hardirq.h': No such file or directory
> rm: cannot remove `linux-2.6.26/include/linux/crc32c.h': No such file or directory
> 
> real	0m0.721s
> user	0m0.012s
> sys	0m0.708s

--- system ---

ubuntu 8.10 amd64

 > ~# dpkg -l | grep linux-image-2.6.27
 > ii  linux-image-2.6.27-7-generic 2.6.27-7.16
 > ~# dpkg -l | grep e2fs
 > ii  e2fslibs 1.41.3-1ubuntu1
 > ii  e2fsprogs 1.41.3-1ubuntu1

---
ArturasK.
