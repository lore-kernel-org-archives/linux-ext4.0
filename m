From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: "Setting filesystem feature 'metadata_csum' not supported" when trying
 to enable ext4 metadata checksums
Date: Tue, 24 Jul 2012 13:41:08 +0700
Message-ID: <500E4384.4090002@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:44840 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706Ab2GXGtv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jul 2012 02:49:51 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 5177634B6A7
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jul 2012 08:41:13 +0200 (CEST)
Received: from [192.168.10.177] (unknown [223.204.74.89])
	by mail.virtall.com (Postfix) with ESMTPSA id 5DEAA34B6A6
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jul 2012 08:41:11 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With Linux 3.5, it should be possible to use ext4 metadata checksums; 
enabling of which should be made with the following command:


# tune2fs -O metadata_csum /dev/sda1
tune2fs 1.42 (29-Nov-2011)
Setting filesystem feature 'metadata_csum' not supported.


Running kernel 3.5, tried the latest e2fsprogs from git.

What am I missing here?


-- 
Tomasz Chmielewski
http://blog.wpkg.org
