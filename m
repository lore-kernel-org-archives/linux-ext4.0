From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: Review of	ext4-online-defrag-check-for-freespace-fragmentation.patch
Date: Wed, 17 Sep 2008 15:46:10 +0900
Message-ID: <48D0A7B2.7050000@rs.jp.nec.com>
References: <E1KedQ2-0004sG-Py@closure.thunk.org> <20080914021024.GB30537@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:34600 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbYIQGqe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Sep 2008 02:46:34 -0400
In-Reply-To: <20080914021024.GB30537@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Theodore Tso wrote:
> On Sat, Sep 13, 2008 at 06:16:42PM -0400, Theodore Ts'o wrote:
>> Secondly, some of the ioctl numbers chosen by the defrag patches overlap
>> other, already existing patches.  This is something we will need to fix,
>> long term.  For now, folks should know that we can't count on the ioctl
>> numbers being stable, since we will probably need to move them.
> 
> Note: I have done this in the version of the defrag patches in the
> ext4 patch queue, where all of the ioctl's introduced by the defrag
> patches have been renumbered starting at 15, to avoid conflicts with
> other ioctls that either exist already or could be introduced in the
> future.
> 
> If you don't mind, we can also merge up some of the patches that have
> been inserted in the patch queue, and then you can start working from
> the modified version in the patch queue.  The other way to move
> forward is that we can start creating new ioctl's that are more
> general and have carefully designed interfaces, and then as the
> replacement ioctl's are created, the defrag patches can be shortened
> and the on-line defrag command modified to use the new ioctl's.

I see, I will use the renumbered defrag patches in the patch queue.
(Currently, I am working on the defrag to use FS_IOC_FIEMAP
  instead of EXT4_IOC_EXTENTS_INFO and remove block size limitation
  to support 1KB and 2KB block size.  I will release them soon.)

Thanks,
Akira Fujita
