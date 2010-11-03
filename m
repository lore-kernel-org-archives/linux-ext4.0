From: Pol Hallen <ext4@fuckaround.org>
Subject: Re: EXT4-fs (dm-0): unsupported inode size: 0
Date: Wed, 3 Nov 2010 13:37:48 +0100
Message-ID: <201011031337.49172.ext4@fuckaround.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vsmtp21.tin.it ([212.216.176.109]:55317 "EHLO vsmtp21.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab0KCMhx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Nov 2010 08:37:53 -0400
Received: from lorna.homeunix.org (87.15.143.204) by vsmtp21.tin.it (8.5.113)
        id 4BC86A490DE15B36 for linux-ext4@vger.kernel.org; Wed, 3 Nov 2010 13:37:50 +0100
Received: from pollon.localnet (unknown [192.168.1.2])
	by lorna.homeunix.org (Postfix) with ESMTP id F096764C52E
	for <linux-ext4@vger.kernel.org>; Wed,  3 Nov 2010 13:37:10 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> What does blkid /dev/mapper/pp say?  Maybe it's got something besides
> ext4 on it now.

/dev/mapper/pp: UUID="cfbe4076-753a-4d3c-9b9d-e18c6e0f2957" TYPE="ext4" 
/dev/sdb1: UUID="a805e772-0bca-4f4c-ad60-f3d0eaf2cc32" TYPE="crypto_LUKS" 

Pol
