From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: One question about ext4_fallocate
Date: Thu, 19 Jul 2012 08:42:12 -0700
Message-ID: <A9962DF5-1C88-4385-A8DA-20227E055910@dilger.ca>
References: <50081EFC.5060601@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54956 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab2GSPmS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jul 2012 11:42:18 -0400
Received: by pbbrp8 with SMTP id rp8so4544449pbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 19 Jul 2012 08:42:18 -0700 (PDT)
In-Reply-To: <50081EFC.5060601@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 2012-07-19, at 7:51 AM, Wang Sheng-Hui wrote:
> I have one question about ext4_fallocate:
> 	For its parameters, offset & len, it will preallocate
> 	one space with length >= len, right?
> 
> From the code:
> 	map.m_lblk = offset >> blkbits;
> 	/*
> 	 * We can't just convert len to max_blocks because
> 	 * If blocksize = 4096 offset = 3072 and len = 2048
> 	 */
> 	max_blocks = (EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits)
> 		- map.m_lblk;
> 
> We can see that the target space is enlarged to the (floor, ceiling) of 
> (offset, offset+len). Right?
> 
> If I'm wrong, please correct me.

A whole block has to be allocated for fallocate, but if KEEP_SIZE is not used, the i_size should be changed to match the actual requested size.

Cheers, Andreas





