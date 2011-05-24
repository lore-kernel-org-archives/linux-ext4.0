From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH] ext4: invalidate gap cache when writing extents last
 block
Date: Tue, 24 May 2011 17:33:42 +0900
Message-ID: <4DDB6D66.3010703@sx.jp.nec.com>
References: <alpine.LFD.2.00.1105130829160.3768@dhcp-27-109.brq.redhat.com> <1305268616-5167-1-git-send-email-lczerner@redhat.com> <4DCCF208.3040704@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:56095 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab1EXIeb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 May 2011 04:34:31 -0400
In-Reply-To: <4DCCF208.3040704@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Lukas,
How do you think about my comment?

Regards,
Kazuya Mio

2011/05/13 17:55, Kazuya Mio wrote:
> 2011/05/13 15:36, Lukas Czerner wrote:
>> That is because due to defensive programming we planted a lot of
>> BUG_ON's to prevent the length of the gap cache to be zero, but in this
>> case it actually will be zero, because there will be no gap at the end
>> of the file.
> 
> Um, I think there is a block (blocksize -1 byte) in gap.
> And this gap should be used for the next block searching.
> According to ext4_ext_in_cache(), len=0 means the special case
> which we have no cache extent, so len=0 should be disallowed.
> 
> Moreover, if we create the file which has 2^32-1 offset,
> we can't get extent which starts from this offset with FIEMAP ioctl.
> That's why I think the maximum file size should be 2^32-1 * blocksize.
> 
> Regards,
> Kazuya Mio
