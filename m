From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 1/2] ext4: fix journal ref count in move_extent_par_page
Date: Tue, 04 Aug 2009 17:23:48 +0900
Message-ID: <4A77F014.7060403@rs.jp.nec.com>
References: <1249213404-6277-1-git-send-email-bergwolf@gmail.com>	 <4A76A00F.30506@rs.jp.nec.com> <6149e97b0908030617q2dfe598bsbbac45969f1f2625@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:34166 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbZHDIYI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Aug 2009 04:24:08 -0400
In-Reply-To: <6149e97b0908030617q2dfe598bsbbac45969f1f2625@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Peng Tao wrote:
> Hi, Akira,
> 
> 2009/8/3 Akira Fujita <a-fujita@rs.jp.nec.com>:
>> Hi Peng,
>>
>> Peng Tao wrote:
>>> move_extent_par_page calls a_ops->write_begin() to increase journal handler's
>>> reference count. However, if either mext_replace_branches() or ext4_get_block
>>> fails, the increased reference count isn't decreased. This will cause later
>>> umounting of the fs forever hangs. The patch addresses the issue by calling
>>> ext4_journal_stop() if page is not NULL (which means a_ops->write_end() isn't
>>> invoked).
>> In case mext_replaced_branches() or ext4_get_block failed,
>> ext4_journal_stop() is called at out2 label(*)
>> and then journal reference counter is decreased.
>> Therefore I think this fix is not necessary.
> well, the orginal code calls both ext4_journal_start and
> a_ops->write_begin(). So the journal reference was increased twice but
> only gets decreased once in case of failure. This can be simply
> verified by returning -1 at the begining of mext_replaced_branches().
> With such modification, the fs cannot be umounted because of the wrong
> reference count.

Ah, I missed.
Sorry for the noise.
The patch looks good to me.

Regards,
Akira Fujita
