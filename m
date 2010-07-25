From: horhe <skrzynka_na_spami@kolekcja.mejor.pl>
Subject: Re: [problem] strange values displayed by e2freefrag
Date: Sun, 25 Jul 2010 13:42:51 +0200
Message-ID: <i2h800$69c$1@dough.gmane.org>
References: <i2fkse$lkr$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:51626 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab0GYLnI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Jul 2010 07:43:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Oczbl-0005b1-On
	for linux-ext4@vger.kernel.org; Sun, 25 Jul 2010 13:43:05 +0200
Received: from ip-194.54.191.238.spray.net.pl ([194.54.191.238])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sun, 25 Jul 2010 13:43:05 +0200
Received: from skrzynka_na_spami by ip-194.54.191.238.spray.net.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sun, 25 Jul 2010 13:43:05 +0200
In-Reply-To: <i2fkse$lkr$1@dough.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After reboot, values are correct:
Device: /dev/mapper/vg--bez--raidu-lvarchiwumnowe
Blocksize: 4096 bytes
Total blocks: 52166656
Free blocks: 7632537 (14.6%)

Min. free extent: 4 KB
Max. free extent: 128120 KB
Avg. free extent: 3444 KB

HISTOGRAM OF FREE EXTENT SIZES:
Extent Size Range :  Free extents   Free Blocks  Percent
    4K...    8K-  :          1506          1506    0.02%
    8K...   16K-  :          1564          3924    0.05%
   16K...   32K-  :          1112          5710    0.07%
   32K...   64K-  :           228          2474    0.03%
   64K...  128K-  :           222          5058    0.07%
  128K...  256K-  :           266         12227    0.16%
  256K...  512K-  :           305         28058    0.37%
  512K... 1024K-  :           487         84407    1.11%
    1M...    2M-  :           600        232959    3.05%
    2M...    4M-  :           769        566341    7.42%
    4M...    8M-  :           790       1141959   14.96%
    8M...   16M-  :           499       1352032   17.71%
   16M...   32M-  :           337       1870576   24.51%
   32M...   64M-  :           126       1345245   17.63%
   64M...  128M-  :            44        979274   12.83%

I was completly full partition, then i freed 15% space (about 30G), then
i saw strange values from first post.
I can't reproduce this problem, i filled up partition, removed files and
problem doesn't apper.
Regards,
Marcin

