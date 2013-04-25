From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 1/2] mke2fs: fix force option to create filesystem on
 mounted device
Date: Fri, 26 Apr 2013 08:58:41 +0900
Message-ID: <5179C331.7050109@sx.jp.nec.com>
References: <510F6B75.6090408@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:49675 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477Ab3DZAKQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Apr 2013 20:10:16 -0400
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id r3Q0AD5v005047
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 26 Apr 2013 09:10:14 +0900 (JST)
In-Reply-To: <510F6B75.6090408@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2013/02/04 17:04, Kazuya Mio wrote:
> According to mke2fs man, we can create a filesystem on the mounted device
> when -FF option is specified.
> However, currently we have to specify -F option third to force mke2fs.
> This patch fixes the problem.
> 
> Note that force mke2fs for mounted block device fails because mke2fs opens
> a device with O_EXCL flag. This work is contradictory to mke2fs man page,
> but I'm not sure it should be fixed or not. What do you think?

Ted, please merge two patches if no problem is found.

http://patchwork.ozlabs.org/patch/217838/
http://patchwork.ozlabs.org/patch/217839/

Regards,
Kazuya Mio
