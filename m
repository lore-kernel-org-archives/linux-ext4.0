From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Check io list state and avoid an unnecessary
 mutex_lock in ext4_end_io_work.
Date: Mon, 31 Oct 2011 11:02:06 -0400
Message-ID: <20111031150206.GC16825@thunk.org>
References: <1315989182-6170-1-git-send-email-tm@tao.ma>
 <20111029205740.GB16825@thunk.org>
 <4EAD01C1.1060002@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37930 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932943Ab1JaPCJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Oct 2011 11:02:09 -0400
Content-Disposition: inline
In-Reply-To: <4EAD01C1.1060002@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 30, 2011 at 03:50:25PM +0800, Tao Ma wrote:
> sorry, but I thought I had considered this case.
> There are 2 callers. One is ext4_end_io_work(which has the bug I pointed
> out), the other is ext4_flush_complete_IO which has already done the
> check before calling ext4_end_io_nolock. And that's the reason why I
> move the check from ext4_end_io_nolock to ext4_end_io_work. So for the
> ext4_flush_complete_IO case, your new patch will spin_lock twice for the
> checking. Do I miss something here?

Ah, you're right; my mistake.  When I looked closely, though, I found
that ext4_flush_completed_IO() had a call to list_empty() without
taking the spinlock, which would also be problematic.  When I looked
more closely, I found more ways to optimize things, which also close
up a few potential (I think theoretical) race conditions.

Let me know what you think....

					- Ted
