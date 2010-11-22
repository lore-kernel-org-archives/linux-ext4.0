From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: ext4 online defrag status?
Date: Mon, 22 Nov 2010 17:04:59 +0900
Message-ID: <4CEA242B.30908@sx.jp.nec.com>
References: <4CE97427.1090700@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:36975 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0KVIG5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Nov 2010 03:06:57 -0500
In-Reply-To: <4CE97427.1090700@wpkg.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Tomasz,

2010/11/22 4:33, Tomasz Chmielewski wrote:
> There have been some ext4 defrag patches posted in 2008 and 2009 - what is the state of this now in late 2010?

Ext4 online defragment has been already merged into the kernel space.
However, e4defrag command has been stopped updating since August 2009,
although some bugfix patches were posted.
I don't know why not e4defrag command is updated, but Ted, the e2fsprogs
maintainer, previously said that e4defrag needs acid test.
https://bugs.launchpad.net/ubuntu/+bug/321528

I have been continuing to evaluate e4defrag command. If someone would help,
please test the newest e4defrag by the following steps:

1. Download e2fsprogs git tree
    # git pull http://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git

2. Apply the patch I sent a while ago
    http://marc.info/?l=linux-ext4&m=128272690010784&w=4

3. Apply the latest bugfix patch
    http://marc.info/?l=linux-ext4&m=129015317309425&w=4

Regards,
Kazuya Mio
