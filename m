From: Solofo.Ramangalahy@bull.net
Subject: [RFC][PATCH 2/3] ext4 online defrag (ver 0.7)
Date: Tue, 18 Mar 2008 10:39:16 +0100
Message-ID: <18399.36292.193936.627393@frecb006361.adech.frec.bull.fr>
References: <200803060001.AA00324@TNESG9526.rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:50162 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbYCRJjE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Mar 2008 05:39:04 -0400
In-Reply-To: <200803060001.AA00324@TNESG9526.rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Akira Fujita writes:
 > -			printk(KERN_ERR "defrag: failed ext4_ext_defrag\n");
 > -			goto ERR;
 > +			printk(KERN_ERR "ext4 defrag: "
 > +				"Moving victim file failed. ino [%lu]\n",
 > +				ext_info->ino);

This triggers this warning:
fs/ext4/defrag.c: In function 'ext4_defrag_move_victim':
fs/ext4/defrag.c:458: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'long long unsigned int'

(ext4-online-defrag-free-space-fragmentation.patch from ext4-patch-queue 36c86f09d6ac97c2797a1a94d76e2fc1dc3b03f8)

-- 
solofo
