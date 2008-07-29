From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH] jbd2: don't abort if flushing file data failed
Date: Tue, 29 Jul 2008 14:53:36 +0900
Message-ID: <488EB060.7080303@hitachi.com>
References: <1217118414-18636-1-git-send-email-tytso@mit.edu>
    <1217118414-18636-2-git-send-email-tytso@mit.edu>
    <1217118414-18636-3-git-send-email-tytso@mit.edu>
    <1217118414-18636-4-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50470 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbYG2Fxp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jul 2008 01:53:45 -0400
Received: from mlsv5.hitachi.co.jp (unknown [133.144.234.166])
	by mail7.hitachi.co.jp (Postfix) with ESMTP id 65E0F37AC5
	for <linux-ext4@vger.kernel.org>; Tue, 29 Jul 2008 14:53:44 +0900 (JST)
In-Reply-To: <1217118414-18636-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello, Ted

> [PATCH] ext4: don't read inode block if the buffer has a write error
> [PATCH] jbd2: don't abort if flushing file data failed

Thank you for porting my ext3/jbd patches to ext4/jbd2.
I would appreciate if you port the remained two patch set (haven't
been posted yet), too.  Although I'll try to port them by myself. 

Best regards,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

