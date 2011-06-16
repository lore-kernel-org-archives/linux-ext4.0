From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 00/11 RESEND] e4defrag: fragmentation score rework and
 cleanups
Date: Thu, 16 Jun 2011 14:10:42 +0900
Message-ID: <4DF99052.8020201@sx.jp.nec.com>
References: <4DF916B8.5010001@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:34739 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1FPFLn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jun 2011 01:11:43 -0400
In-Reply-To: <4DF916B8.5010001@wpkg.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/06/16 5:31, Tomasz Chmielewski wrote:
> Out of curiosity: is there a minimal kernel version requirement (one which can be safely used with e4defrag)?

EXT4_IOC_MOVE_EXT ioctl was merged 2.6.31. And then some bugfix were merged
before 2.6.35. I suggest you to build 2.6.35 or later if you try to do
e4defrag.

e4defrag also merged some bugfix like this patch, so you should use
the latest e4defrag.

If you find out something about online defrag, please post a comment.

Regards,
Kazuya Mio
