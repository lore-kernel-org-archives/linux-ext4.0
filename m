From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 0/2 V2] Fix mke2fs -F for consistency with the man page
Date: Mon, 24 Jun 2013 15:28:49 +0900
Message-ID: <51C7E721.508@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:40671 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab3FXGjq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Jun 2013 02:39:46 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id r5O6djdm004829
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 24 Jun 2013 15:39:45 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I try to fix mke2fs -F for consistency with the man page.
The previous version of this patch series is as follows:

http://patchwork.ozlabs.org/patch/217838/
http://patchwork.ozlabs.org/patch/217839/

Change log:
- Rebase to e2fsprogs-1.42.8

 configure.in           |    2 ++
 lib/ext2fs/ismounted.c |   38 ++++++++++++++++++++++++++++++++++++++
 misc/util.c            |    4 ++--
 3 files changed, 42 insertions(+), 2 deletions(-)

Regards,
Kazuya Mio
