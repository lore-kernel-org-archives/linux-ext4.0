From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 0/2 V3] Fix mke2fs -F for consistency with the man page
Date: Fri, 12 Jul 2013 15:51:35 +0900
Message-ID: <51DFA777.50205@sx.jp.nec.com>
References: <51D290CA.7010605@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:46113 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095Ab3GLHCT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Jul 2013 03:02:19 -0400
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id r6C72Iji023594
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 12 Jul 2013 16:02:18 +0900 (JST)
In-Reply-To: <51D290CA.7010605@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2013/07/02 17:35, Kazuya Mio wrote:
> I try to fix mke2fs -F for consistency with the man page.

Ted, could you please merge this patchset if you don't have any comments.

http://patchwork.ozlabs.org/patch/256301/
http://patchwork.ozlabs.org/patch/256302/

Regards,
Kazuya Mio

