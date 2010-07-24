From: horhe <skrzynka_na_spami@kolekcja.mejor.pl>
Subject: [problem] strange values displayed by e2freefrag
Date: Sat, 24 Jul 2010 23:10:34 +0200
Message-ID: <i2fkse$lkr$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:52717 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756030Ab0GXVPH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Jul 2010 17:15:07 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Ocm3j-0007SN-P1
	for linux-ext4@vger.kernel.org; Sat, 24 Jul 2010 23:15:03 +0200
Received: from ip-194.54.191.238.spray.net.pl ([194.54.191.238])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 24 Jul 2010 23:15:03 +0200
Received: from skrzynka_na_spami by ip-194.54.191.238.spray.net.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 24 Jul 2010 23:15:03 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!
Today i run e2freefrag on ext4 partition and i saw:
Device: /dev/mapper/vg--bez--raidu-lvarchiwumnowe
Blocksize: 4096 bytes
Total blocks: 52166656
Free blocks: 57254 (0.1%)

Min. free extent: 4 KB
Max. free extent: 128120 KB
Avg. free extent: 3396 KB

HISTOGRAM OF FREE EXTENT SIZES:
Extent Size Range :  Free extents   Free Blocks  Percent
    4K...    8K-  :          1500          1500    2.62%
    8K...   16K-  :          1566          3933    6.87%
   16K...   32K-  :          1112          5707    9.97%
   32K...   64K-  :           228          2480    4.33%
   64K...  128K-  :           222          5061    8.84%
  128K...  256K-  :           269         12364   21.59%
  256K...  512K-  :           307         28279   49.39%
  512K... 1024K-  :           487         84412  147.43%
    1M...    2M-  :           621        240621  420.27%
    2M...    4M-  :           780        574302  1003.08%
    4M...    8M-  :           803       1162903  2031.13%
    8M...   16M-  :           488       1317526  2301.19%
   16M...   32M-  :           312       1728598  3019.17%
   32M...   64M-  :           119       1269059  2216.54%
   64M...  128M-  :            49       1088111  1900.50%

And i'm suprised when i can see so high percents, i don't know hot to
interpret this values.
e2fsprogs-1.41.12
Regards!
Marcin

