From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: Review of ext4-online-defrag-move-victim-files.patch
Date: Wed, 17 Sep 2008 15:38:19 +0900
Message-ID: <48D0A5DB.6020103@rs.jp.nec.com>
References: <E1KecTT-0004nW-Oc@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:64903 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbYIQGio (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Sep 2008 02:38:44 -0400
In-Reply-To: <E1KecTT-0004nW-Oc@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
Thank you for your review comments.

Theodore Ts'o wrote:
> Hi,
> 
> I've been looking over the defrag patches with an eye towards getting
> them merged.  This patch concerns me for a number of reasons.  First of
> all, it is calling into a number of private functions which had
> previously been static functions in fs/ext4/balloc.c.  Specifically,
> goal_in_my_reservation(), rsv_window_remove(), rsv_is_empty(),
> alloc_new_reservation(), try_to_extend_reservation().  
> 
> This is bad for a couple of reasons.  First of all, the functions
> weren't renamed, so it results in the namespace leakage.  In general,
> non-static functions should be prefixed by ext4_ so that we know they
> came from the ext4 filesystem code.  Secondly, these were internal
> functions were intended for use in an older set of block allocation
> functions that may be removed in the future --- they had previously only
> been used by the function ext4_old_new_blocks(), which is used only when
> the mount option nomballoc is given.  Given the superiority of the new
> multi-block allocator, it's likely that this old code will be going
> away.
> 
> One of the things which further worries me is that your patch seems to
> be making changes to the mballoc() code as well.  Given that the
> reservations code in fs/ext4/balloc.c was never intended to used at the
> same time as the multi-block allocator code in mballoc(), I suspect
> there will be a problem here if the goal of reserving blocks using the
> reservation code was to prevent some other inode using allocating those
> blocks, since the multi-block allocator does not honor reservations made
> by the reservations code, since normally the reservations code is not
> active when the mballoc code is active (the two are mutually exclusive).

Is there any good way to use block reservation with mballoc?
If not, fixing defragger not to use block reservation
in the force mode would be better.

Regards,
Akira Fujita
