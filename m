From: Peng Tao <bergwolf@gmail.com>
Subject: Re: donor file data inconsistent after EXT4_IOC_MOVE_EXT
Date: Mon, 19 Oct 2009 10:28:46 +0800
Message-ID: <4ADBCEDE.3050009@gmail.com>
References: <4ADABDB2.6080905@gmail.com> <4ADBB585.7050402@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Kazuya Mio <k-mio@sx.jp.nec.com>, Theodore Ts'o <tytso@mit.edu>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:46265 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbZJSC2z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Oct 2009 22:28:55 -0400
Received: by fxm18 with SMTP id 18so4524115fxm.37
        for <linux-ext4@vger.kernel.org>; Sun, 18 Oct 2009 19:28:59 -0700 (PDT)
In-Reply-To: <4ADBB585.7050402@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Akira,
Akira Fujita wrote:
> Hi Peng,
> 
> This is a known issue, and I sent a patch to linux-ext4 2 weeks ago.
> Unfortunately it is not included in the ext4 patch queue yet.
> 
> http://marc.info/?l=linux-ext4&m=125447192709338&w=2
> 
> Would you retry your test case with above my patch?
It didn't work. I still got the old donor file data.

I applied the two patches to avoid conflicts:
http://marc.info/?l=linux-ext4&m=125447192609335&w=2
http://marc.info/?l=linux-ext4&m=125447192709338&w=2

[bergwolf@move_extent]$sh test-5.sh 
make full-img
========create full.img========
dd if=/home/bergwolf/vm/OpenSolaris200805.iso of=full-1.img bs=1M count=30
30+0 records in
30+0 records out
31457280 bytes (31 MB) copied, 0.907358 s, 34.7 MB/s
dd if="/home/bergwolf/vm/WINXP_EN_PRO_SP3_MSDN/WinXp+Sp3 enu.iso" of=full-2.img bs=1M count=30
30+0 records in
30+0 records out
31457280 bytes (31 MB) copied, 2.09212 s, 15.0 MB/s
md5sum full-1.img full-2.img
4f47bee75290d094c94f8a7cb2075c69  full-1.img
9e35330146a610d0aa2fab1d16aa2b09  full-2.img
./a.out full-1.img full-2.img
7680
7680
md5sum full-1.img full-2.img
4f47bee75290d094c94f8a7cb2075c69  full-1.img
9e35330146a610d0aa2fab1d16aa2b09  full-2.img	<---- wrong pagecache hit here
[bergwolf@move_extent]$cd
[bergwolf@~]$sudo umount /other/
[bergwolf@~]$sudo mount /other/
[bergwolf@~]$cd -
/other/test/move_extent
[bergwolf@move_extent]$md5sum full-2.img
4f47bee75290d094c94f8a7cb2075c69  full-2.img

<snip>

-- 
Best Regards,
Peng Tao
State Key Laboratory of Networking and Switching Technology
Beijing Univ. of Posts and Telecoms.
