From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: "Setting filesystem feature 'metadata_csum' not supported" when
 trying to enable ext4 metadata checksums
Date: Tue, 24 Jul 2012 15:51:21 +0700
Message-ID: <500E6209.2060604@wpkg.org>
References: <500E4384.4090002@wpkg.org> <20120724075000.GA10906@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:35209 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab2GXIvc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jul 2012 04:51:32 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 3B96F34B6CF
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jul 2012 10:51:29 +0200 (CEST)
Received: from [192.168.10.177] (unknown [223.204.74.89])
	by mail.virtall.com (Postfix) with ESMTPSA id 23D8534B6CE
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jul 2012 10:51:27 +0200 (CEST)
In-Reply-To: <20120724075000.GA10906@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/24/2012 02:50 PM, Zheng Liu wrote:

> Could you please checkout the 'pu' branch in e2fsprogs?  You need to
> use pu branch of e2fsprogs because the patches of metadata checksum
> for e2fsprogs are in this branch.
>
> BTW, until 3.5 kernel, it seems that metadata checksum still has a bug.
> Here is a patch to fix this bug [1].
>
> 1. http://www.spinics.net/lists/linux-ext4/msg32685.html

OK, tried with pu branch and got this:

root@s9:/usr/src/e2fsprogs# misc/tune2fs -O metadata_csum /dev/sda1
tune2fs 1.42.3 (14-May-2012)
rewrite_directory: Unknown code kJe 176 while rewriting directories

Expected?

-- 
Tomasz Chmielewski
http://blog.wpkg.org

