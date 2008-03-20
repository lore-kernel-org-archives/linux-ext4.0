From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [2.6.25-rc5-ext4-36c86] attempt to access beyond end of device
Date: Wed, 19 Mar 2008 21:39:59 -0500
Message-ID: <47E1CE7F.6050706@redhat.com>
References: <18399.36935.640758.796880@frecb006361.adech.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Solofo.Ramangalahy@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbYCTCkf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2008 22:40:35 -0400
In-Reply-To: <18399.36935.640758.796880@frecb006361.adech.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Solofo.Ramangalahy@bull.net wrote:
> Hello,
> 
> During stress testing (workload: racer from ltp + fio/iometer), here
> is an error I am encountering:
> 8<------------------------------------------------------------------------------
> kernel: WARNING: at fs/buffer.c:1680 __block_write_full_page+0xd4/0x2af()

So this is WARN_ON(bh->b_size != blocksize);

What is b_size in this case?

-Eric
