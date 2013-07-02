From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 0/2 V3] Fix mke2fs -F for consistency with the man page
Date: Tue, 02 Jul 2013 17:35:22 +0900
Message-ID: <51D290CA.7010605@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:52159 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab3GBIo4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Jul 2013 04:44:56 -0400
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id r628isDI016937
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 2 Jul 2013 17:44:54 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I try to fix mke2fs -F for consistency with the man page.
The previous version of this patch series is as follows:

http://patchwork.ozlabs.org/patch/253634/
http://patchwork.ozlabs.org/patch/253633/

Change log:
- rephrase the patch description
- add reviewed-by to 1/2 patch

 configure.in           |    2 ++
 lib/ext2fs/ismounted.c |   38 ++++++++++++++++++++++++++++++++++++++
 misc/util.c            |    4 ++--
 3 files changed, 42 insertions(+), 2 deletions(-)
