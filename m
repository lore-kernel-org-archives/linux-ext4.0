From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [patch] e4defrag: relevant file fragmentation: fix arithmetic
 error as non-root
Date: Wed, 01 Sep 2010 17:09:43 +0900
Message-ID: <4C7E0A47.7010206@sx.jp.nec.com>
References: <4C7A7645.8010906@rid-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Rid <andreas@rid-net.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:44843 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab0IAIMF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Sep 2010 04:12:05 -0400
In-Reply-To: <4C7A7645.8010906@rid-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

I will send the patch "[RFC][PATCH V2 5/5] e4defrag: add solving relevant file
fragmentation mode" includes your patches next time.

2010/08/30 0:01, Andreas Rid wrote:
> I found a bug on your patch "[RFC][PATCH V2 5/5] e4defrag: add solving relevant file fragmentation mode"
> 
> The variable "blocks_per_group" is only initialized as root cause of restrict access to the super-block.
> As a non root user this cause an arithmetic error in function relevant_balloc

You're right. Thanks.

Regards,
Kazuya Mio
