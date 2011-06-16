From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: [PATCH 00/11 RESEND] e4defrag: fragmentation score rework and
 cleanups
Date: Thu, 16 Jun 2011 10:18:26 +0200
Message-ID: <4DF9BC52.40203@wpkg.org>
References: <4DF916B8.5010001@wpkg.org> <4DF99052.8020201@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:56897 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab1FPIS3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jun 2011 04:18:29 -0400
In-Reply-To: <4DF99052.8020201@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 16.06.2011 07:10, Kazuya Mio wrote:
> 2011/06/16 5:31, Tomasz Chmielewski wrote:
>> Out of curiosity: is there a minimal kernel version requirement (one
>> which can be safely used with e4defrag)?
>
> EXT4_IOC_MOVE_EXT ioctl was merged 2.6.31. And then some bugfix were merged
> before 2.6.35. I suggest you to build 2.6.35 or later if you try to do
> e4defrag.
>
> e4defrag also merged some bugfix like this patch, so you should use
> the latest e4defrag.

Thanks for clarification.


> If you find out something about online defrag, please post a comment.

My main usage for e4defrag would be defragmenting virtual guest (like 
KVM) file-based images.

These images are typically quite small when created (i.e. qcow2, or a 
"raw", sparse file), but grow in time, which leads to serious fragmentation.

I noticed that when using e4defrag on such a file-based image, while the 
guest is running (i.e. the file is in use), all IO from that guest to 
the disk (disk is this file) is "frozen".

In other words, as soon as we run e4defrag, any guest writes to that 
file will only complete if e4defrag finishes. As the images can be quite 
big, it can mean guest IO can be frozen even for hours.


Is it a known/intended limitation (at least, it behaved like this when I 
tried e4defrag a few months ago)?

In some cases, it can be a serious drawback, potentially leading to 
filesystem corruption in the guest - if guest block layer is SCSI, with 
default settings (at least in Linux) it may detect that no IO happened 
for some time, and just "offline" the disk.


-- 
Tomasz Chmielewski
http://wpkg.org
