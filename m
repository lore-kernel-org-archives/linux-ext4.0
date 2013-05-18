From: frankcmoeller@arcor.de
Subject: Re: Aw: Re: Ext4: Slow performance on first write after mount
Date: Sun, 19 May 2013 00:34:33 +0200 (CEST)
Message-ID: <1185744444.80149.1368916473310.JavaMail.ngmail@webmail14.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:55975 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753318Ab3ERWef (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 May 2013 18:34:35 -0400
Received: from mail-in-20-z2.arcor-online.net (mail-in-20-z2.arcor-online.net [151.189.8.85])
	by mx.arcor.de (Postfix) with ESMTP id 6274C2D655C
	for <linux-ext4@vger.kernel.org>; Sun, 19 May 2013 00:34:33 +0200 (CEST)
Received: from mail-in-16.arcor-online.net (mail-in-16.arcor-online.net [151.189.21.56])
	by mail-in-20-z2.arcor-online.net (Postfix) with ESMTP id 5BBBC6FA453
	for <linux-ext4@vger.kernel.org>; Sun, 19 May 2013 00:34:33 +0200 (CEST)
Received: from webmail14.arcor-online.net (webmail14.arcor-online.net [151.189.8.67])
	by mail-in-16.arcor-online.net (Postfix) with ESMTP id 539E08247
	for <linux-ext4@vger.kernel.org>; Sun, 19 May 2013 00:34:33 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andrei,

thanks for the informations! Didn't know that it is around 32 MB data for a 1TB disk. 

Regarding bigalloc: I read on the ext4 website (https://ext4.wiki.kernel.org/index.php/Bigalloc) this:
"The bigalloc feature first appeared in the v3.2 kernel. As of this writing (in the v3.7 kernel) 
bigalloc still has some problems if the delayed allocation is enabled, especially if the file 
system is close to full."
Is bigalloc really stable? Since when is it stable? Were there bigger bugs in some versions?
I ask because the software (OpenPli) we use uses different kernel versions for different boxes. 
Some boxes use 3.8.7 kernel, some 3.3.8 and so on (it's not changeable because of closed source
drivers).

Is an ext4 bigalloc partition resizeable? I saw a bug report and a patch in January 2013 regarding this.
If it works well, I could resize my partition and create a new bigalloc one. Then move files and resize
again. Or is the only possibility a reformat?

Regards,
Frank

----- Original Nachricht ----
Von:     "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>
An:      "frankcmoeller@arcor.de" <frankcmoeller@arcor.de>
Datum:   18.05.2013 22:34
Betreff: Re: Aw: Re: Ext4: Slow performance on first write after mount

> Frank,
> 
> Well, the main point was to use bigalloc. Unfortunately it requires
> reformat.
> W/o bigalloc there will be ~7800 block groups for 1T drive. Those groups
> take 32M of ondisk data and up to 64M when it comes to RAM because of
> runtime buddy bitmaps. I don't think it worth storing buddy bitmaps on
> drive. It's not a surprise it can take long time to read lots of block
> bitmaps scattered over drive and construct buddies out of them. And it's
> not a surprise some these pages are evicted under high memory pressure.
> With bigalloc 1M cluster size you get 256 times less metadata (128K
> instead of 32M) and you get all the benefits of faster allocate,
> truncate and lesser fragmentation.
> 
> Yes, you don't know file size in advance, but speculating say each 128M
> is clearly a benefit. truncate to real file size once recording finished
> to release unused preallocated space.
> There are some caveats with O_DIRECT, but it is faster if done correctly.
> 
> Regards,
> Andrei.
> 
