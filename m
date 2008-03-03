From: Solofo.Ramangalahy@bull.net
Subject: [PATCH] Tool to report free space fragmentation
Date: Mon, 3 Mar 2008 10:53:18 +0100
Message-ID: <18379.51854.340624.548572@frecb006361.adech.frec.bull.fr>
References: <1204490384.3375.13.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
To: Kalpak Shah <Kalpak.Shah@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39727 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYCCJxN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Mar 2008 04:53:13 -0500
In-Reply-To: <1204490384.3375.13.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Kalpak Shah writes:
 > e2freefrag is a simple tool to report free space fragmentation on
 > ext2/3/4 filesystems.

Thanks for this tool.

 > Index: e2fsprogs-1.40.5/misc/Makefile.in

FYI, the patch does not apply on 1.40.7.

-- 
solofo
