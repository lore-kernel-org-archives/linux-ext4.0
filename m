From: Solofo.Ramangalahy@bull.net
Subject: Re: [2.6.25-rc5-ext4-36c86] attempt to access beyond end of device
Date: Thu, 20 Mar 2008 04:04:44 +0100
Message-ID: <18401.54348.973211.395007@frecb006361.adech.frec.bull.fr>
References: <18399.36935.640758.796880@frecb006361.adech.frec.bull.fr>
	<47E1CE7F.6050706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Solofo.Ramangalahy@bull.net, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43840 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbYCTDEb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Mar 2008 23:04:31 -0400
In-Reply-To: <47E1CE7F.6050706@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen writes:
 > > kernel: WARNING: at fs/buffer.c:1680 __block_write_full_page+0xd4/0x2af()
 > 
 > So this is WARN_ON(bh->b_size != blocksize);
 > 
 > What is b_size in this case?

I did not collected it on this run, but I typically get things like:
blocksize 132112384 != 4096

-- 
solofo

