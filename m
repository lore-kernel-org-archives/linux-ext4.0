From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Thu, 18 Nov 2010 18:53:50 +0000
Message-ID: <20101118185350.GD19804@ZenIV.linux.org.uk>
References: <20101116110058.GA4298@amd>
 <20101116130146.GG4757@quack.suse.cz>
 <4CE35A6D.2040906@redhat.com>
 <20101117043845.GA3586@amd>
 <4CE362B0.6040607@redhat.com>
 <20101117061057.GA3989@amd>
 <20101118030613.GQ3290@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Piggin <npiggin@kernel.dk>, Eric Sandeen <sandeen@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:38840 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab0KRSyG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Nov 2010 13:54:06 -0500
Content-Disposition: inline
In-Reply-To: <20101118030613.GQ3290@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 17, 2010 at 10:06:13PM -0500, Ted Ts'o wrote:

> This makes sense to me as well.
> 
> Acked-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> So how do we want to send this patch to Linus?  It's a writeback
> change, so through some mm tree?  Or it lives in fs/fs-writeback.c
> (which I always thought was weird; why is it not in mm/?), so maybe
> through the VFS tree, even though I don't think Al would really care
> about this patch.

As in "don't really like", TBH.  I'll take it (with saner commit message
and comment in the source), but I really wonder if we are just asking for
more trouble down the road.

Specifically, I *really* want to see locking rules for that sucker
spelled out.  What can be held by caller?
