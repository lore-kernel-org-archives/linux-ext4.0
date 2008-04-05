From: Adrian Bunk <bunk@kernel.org>
Subject: ext4 compile error on m68k
Date: Sat, 5 Apr 2008 13:24:08 +0300
Message-ID: <20080405102408.GB30987@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org, linux-m68k@lists.linux-m68k.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	geert@linux-m68k.org, zippel@linux-m68k.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55780 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbYDEKYd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Apr 2008 06:24:33 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit aa02ad67d9b308290fde390682cd039b29f7ab85
"ext4: Add ext4_find_next_bit()" causes the following regression:

<--  snip  -->

...
  CC [M]  fs/ext4/mballoc.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/ext4/mballoc.c: In function 'mb_find_next_bit':
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/ext4/mballoc.c:696: error: implicit declaration of function 'generic_find_next_le_bit'
make[3]: *** [fs/ext4/mballoc.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

