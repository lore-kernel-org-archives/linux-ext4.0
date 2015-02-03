From: Nikhilesh Reddy <reddyn@codeaurora.org>
Subject: Re: Writes blocked on wait_for_stable_page (Writes of less than page
 size sometimes take too long)
Date: Tue, 03 Feb 2015 15:51:41 -0800
Message-ID: <54D15F0D.6030109@codeaurora.org>
References: <54C93169.3000600@codeaurora.org> <54C93811.1040107@codeaurora.org> <20150128213914.GE9976@birch.djwong.org> <54C96F87.7000502@codeaurora.org> <54C97262.3010406@codeaurora.org> <20150128235705.GI21455@birch.djwong.org> <20150201023723.GB3070@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:47234 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383AbbBCXvn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Feb 2015 18:51:43 -0500
In-Reply-To: <20150201023723.GB3070@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks so much Darrick and Ted!
You guys have been a lot of help. I really appreciate it.

On Sat 31 Jan 2015 06:37:23 PM PST, Theodore Ts'o wrote:
> On Wed, Jan 28, 2015 at 03:57:05PM -0800, Darrick J. Wong wrote:
>> Yes, that wait_for_page_writeback() was replaced with a call to
>> wait_for_stable_page() upstream, so it'll probably work for your 3.10
>> kernel.
>>
>> (I also wonder why not jump to a newer LTS kernel, but that's neither
>> here nor there.)
>
> Nikhilesh said that he was using a 64-bit android device.  I'm going
> to guess it is based off of the AOSP kernel for the Nexus 9, which is
> a 64-bit android device that uses 3.10 as a base.  It's not *really* a
> 3.10 kernel, though, becausre it looks like bits and pieces of the VFS
> was forward ported to a somewhat newer version so they could backport
> F2FS to the Nexus 9 kernel.  But I'm guessing he's using it because
> there are device drivers he needs that might not be available without
> a lot of forward-porting work on a newer kernel.
>

Yes we cant really move to a newer kernel just yet. :)

> If you are interested in trying to use a somewhat newer version of
> ext4, I just *happen* to have a backport of the 3.18 version of ext4
> on top of a stock version of 3.10.  You can find it at the
> backport-to-3.10 branch of the ext4.git tree on git.kernel.org.

Thanks that is awesome... yes...Will look into them.Thanks!

>
> If you are starting from the AOSP version of the Nexus 9 kernel, the
> patch series from that branch won't apply 100% cleanly, because of the
> changes resulting from the F2FS backport.  It's relatively
> straight-forward though to use the backport-to-3.10 patch series as a
> model to get a version of 3.18 ext4 on top of the AOSP kernel, though;
> it's mostly dropping or reworking patches that were no longer
> necessary thanks to the F2FS backport.
>
> If there is interest, I can look into what might be involved in making
> a git repo of an AOSP kernel with the 3.18 ext4 code backported to it
> available.
>
> I won't give any warrantees, of course, since the AOSP kernel doesn't
> build on x86 and so I can't easily run regression tests on it.  So if
> it breaks, you will get to keep both pieces.  I will try to at least
> look at bug reports, though, and I can say that 3.18 backport on the
> stock 3.10 kernel survives xfstests much better than the 3.10 version
> of ext4, since a modern xfstests very quickly caused the stock 3.10
> kernel to panic.  :-)
>
> 						- Ted
>

Yes I can run testing on my end to make sure everything is good.

Thanks So much once again.

-- 
Thanks
Nikhilesh Reddy

Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
