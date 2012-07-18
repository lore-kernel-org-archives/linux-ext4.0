From: Wolfgang Rohdewald <wolfgang@rohdewald.de>
Subject: renaming socket in use does not update /proc/X/fd
Date: Wed, 18 Jul 2012 22:30:24 +0200
Message-ID: <9267688.AUvn3KEijS@i5>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:56489 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab2GRUaW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Jul 2012 16:30:22 -0400
Received: from i5.rohdewald.de (p5B3E0AD9.dip0.t-ipconnect.de [91.62.10.217])
	by smtp.strato.de (jorabe mo53) (RZmta 29.19 DYNA|AUTH)
	with ESMTPA id 20151bo6IJReiP for <linux-ext4@vger.kernel.org>;
	Wed, 18 Jul 2012 22:30:20 +0200 (CEST)
Received: from i5.localnet (localhost.localdomain [127.0.0.1])
	by i5.rohdewald.de (Postfix) with ESMTP id 6219E5E014E
	for <linux-ext4@vger.kernel.org>; Wed, 18 Jul 2012 22:30:24 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

normally, renaming a file in use does update its name in /proc/X/fd

but this does not work for sockets. And so fuser fails to tell me
about the process using the socket when renamed.

why is that so?

using ext4 of course

i5:~/.kajonggserver$ fuser socket
/home/wr/.kajonggserver/socket: 27557
i5:~/.kajonggserver$ l /proc/27557/fd/3
lrwx------ 1 wr wr 64 Jul 18 22:00 /proc/27557/fd/3 -> socket:[1344224]
i5:~/.kajonggserver$ mv socket X
i5:~/.kajonggserver$ fuser X
i5:[Exit 1 (SIGHUP)]~/.kajonggserver$ l /proc/27557/fd/3
lrwx------ 1 wr wr 64 Jul 18 22:00 /proc/27557/fd/3 -> socket:[1344224]


Linux i5 3.2.0-26-generic #41-Ubuntu SMP Thu Jun 14 17:49:24 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

I am keeping the process 27557 running should you want more info about that process

-- 
Wolfgang
