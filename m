From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [e2fsprogs] Implement resync of declared blocks for software RAID
Date: Tue, 08 Dec 2009 21:26:35 +0100
Message-ID: <87bpi9xldw.fsf@basil.nowhere.org>
References: <20091208183046.GH4508@clouds>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jody McIntyre <scjody@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:53102 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965956AbZLHU0c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Dec 2009 15:26:32 -0500
In-Reply-To: <20091208183046.GH4508@clouds> (Jody McIntyre's message of "Tue, 08 Dec 2009 13:30:48 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jody McIntyre <scjody@sun.com> writes:

> This patch resyncs declared blocks on journal recovery.  This must be done
> as part of journal replay for filesystems with
> JFS_FEATURE_INCOMPAT_DECLARE_BLOCKS; we have previously guaranteed to MD
> that we will resync any blocks that may have been undergoing writes at
> the time of a system crash.
>
> The SET_RESYNC_ALL and CLEAR_RESYNC_ALL ioctls are used to instruct MD
> to resync all blocks being read and written.
>
> This patch is UNTESTED and is being sent only because I am no longer
> working on declared mode.

Is this the only e2fsprogs patch needed for this feature, apart
from the kernel patches you posted?

Too bad you're not working on it anymore, I definitely liked
the idea.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
