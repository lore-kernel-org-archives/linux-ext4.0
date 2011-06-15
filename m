From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: [PATCH 00/11 RESEND] e4defrag: fragmentation score rework and
 cleanups
Date: Wed, 15 Jun 2011 22:31:52 +0200
Message-ID: <4DF916B8.5010001@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: k-mio@sx.jp.nec.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:51344 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab1FOUbz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Jun 2011 16:31:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Hi,
>
> This patch set adds the new function get_fragment_score() to libe2p, that
> calculates the fragmentation score. Fragmentation score shows how badly

Out of curiosity: is there a minimal kernel version requirement (one 
which can be safely used with e4defrag)?


-- 
Tomasz Chmielewski
http://wpkg.org

