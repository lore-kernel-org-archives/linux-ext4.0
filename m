From: frankcmoeller@arcor.de
Subject: Aw: Re: Ext4: Slow performance on first write after mount
Date: Sat, 18 May 2013 12:50:02 +0200 (CEST)
Message-ID: <1323812284.643758.1368874202987.JavaMail.ngmail@webmail11.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:46450 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752801Ab3ERKuE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 May 2013 06:50:04 -0400
Received: from mail-in-10-z2.arcor-online.net (mail-in-10-z2.arcor-online.net [151.189.8.27])
	by mx.arcor.de (Postfix) with ESMTP id 09A9F301BF
	for <linux-ext4@vger.kernel.org>; Sat, 18 May 2013 12:50:03 +0200 (CEST)
Received: from mail-in-11.arcor-online.net (mail-in-11.arcor-online.net [151.189.21.51])
	by mail-in-10-z2.arcor-online.net (Postfix) with ESMTP id 063B228AA02
	for <linux-ext4@vger.kernel.org>; Sat, 18 May 2013 12:50:03 +0200 (CEST)
Received: from webmail11.arcor-online.net (webmail11.arcor-online.net [151.189.8.83])
	by mail-in-11.arcor-online.net (Postfix) with ESMTP id 03D2535A60D
	for <linux-ext4@vger.kernel.org>; Sat, 18 May 2013 12:50:03 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andrei,

thanks for your quick answer!
Perhaps you understood me wrong. The general write performance is quite good. We can record more than 4 HD channels at the same time without problems. Except the problems with the first write after mount. And there are also some users which have problems 1-2 times during a recording.
I think the ext4 group initialization is the main problem, because it takes so long (as written before: around 1300 groups per second). Why don't you store the gathered informations on disk when a umount takes place?

With fallocate the group initialization is partly made before first write. This helps, but it's no solution, because the finally file size is unknown. So I cannot preallocate space for the complete file. And after the preallocated space is consumed the same problem with the initialization arises until all groups are initialized.

I also made some tests with O_DIRECT (my first tests ever). Perhaps I did something wrong, but it isn't very fast. And you have to take care about alignment and there are several threads in the internet which explain why you shouldn't use it (or only in very special situations and I don't think that my situation is one of them). And ext4 group initialization takes also place when using O_DIRECT (as said before perhaps I did something wrong).

Regards,
Frank

----- Original Nachricht ----
Von:     "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>
An:      "frankcmoeller@arcor.de" <frankcmoeller@arcor.de>, ext4 development <linux-ext4@vger.kernel.org>
Datum:   17.05.2013 23:18
Betreff: Re: Ext4: Slow performance on first write after mount

> Hi Frank,
> 
> Consider using bigalloc feature (requires reformat), preallocate space
> with fallocate and use O_DIRECT for reads/writes. However, 188k writes
> are too small for good throughput with O_DIRECT. You might also want to
> adjust max_sectors_kb to something larger than 512k.
> 
> We're doing 6in+6out 20Mbps streams just fine.
> 
> Regards,
> Andrei.
> 
