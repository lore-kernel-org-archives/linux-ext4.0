From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: One question about ext4_fallocate
Date: Thu, 19 Jul 2012 22:51:40 +0800
Message-ID: <50081EFC.5060601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Allison Henderson <achender@linux.vnet.ibm.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52139 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2GSOvw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jul 2012 10:51:52 -0400
Received: by pbbrp8 with SMTP id rp8so4479928pbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 19 Jul 2012 07:51:51 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear all,

I have one question about ext4_fallocate:
	For its parameters, offset & len, it will preallocate
	one space with length >= len, right?

>From the code:
	map.m_lblk = offset >> blkbits;
	/*
	 * We can't just convert len to max_blocks because
	 * If blocksize = 4096 offset = 3072 and len = 2048
	 */
	max_blocks = (EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits)
		- map.m_lblk;

We can see that the target space is enlarged to the (floor, ceiling) of 
(offset, offset+len). Right?

If I'm wrong, please correct me.


Regards,
