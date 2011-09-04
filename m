From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix a possible corruption in dx_probe.
Date: Sun, 4 Sep 2011 09:57:40 -0400
Message-ID: <20110904135740.GD3461@thunk.org>
References: <1314806452-8763-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38605 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab1IDN5l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Sep 2011 09:57:41 -0400
Content-Disposition: inline
In-Reply-To: <1314806452-8763-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 01, 2011 at 12:00:52AM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> For all the callers of dx_probe, frame_in is passed in uninitialized.
> So we should set frame->bh to NULL in the beginning of while, not
> the end. Otherwise, the first "goto fail2" will try to brelse(frame->bh)
> while frame->bh is still invalid.

There's a "frame->bh = NULL" statement at the very beginning of
dx_probe().   Shouldn't that do the trick?

						- Ted
