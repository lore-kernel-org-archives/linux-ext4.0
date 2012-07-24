From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: "Setting filesystem feature 'metadata_csum' not supported" when
 trying to enable ext4 metadata checksums
Date: Tue, 24 Jul 2012 17:32:21 +0700
Message-ID: <500E79B5.1000003@wpkg.org>
References: <500E4384.4090002@wpkg.org> <20120724075000.GA10906@gmail.com> <500E6209.2060604@wpkg.org> <20120724094445.GA11369@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:37939 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab2GXKc1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jul 2012 06:32:27 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 0BCDA34B6EB
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jul 2012 12:32:27 +0200 (CEST)
Received: from [192.168.10.177] (unknown [223.204.74.89])
	by mail.virtall.com (Postfix) with ESMTPSA id E520F34B6DC
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jul 2012 12:32:25 +0200 (CEST)
In-Reply-To: <20120724094445.GA11369@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/24/2012 04:44 PM, Zheng Liu wrote:

>> root@s9:/usr/src/e2fsprogs# misc/tune2fs -O metadata_csum /dev/sda1
>> tune2fs 1.42.3 (14-May-2012)
>> rewrite_directory: Unknown code kJe 176 while rewriting directories
>>
>> Expected?
>
> No, it seems that it is not our expectation.  Could you please provide
> more information?  Such as feature list.  Use "debugfs -R
> 'stats' /dev/${DEVICE}" to get it, please.

The file is over 200 kB, so uploaded it here:

http://blog.wpkg.org/debugfs-stats.txt


-- 
Tomasz Chmielewski

