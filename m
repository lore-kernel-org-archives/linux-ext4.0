From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Fix forever sleeping process in
 do_get_write_access()
Date: Sun, 8 May 2011 19:14:49 -0400
Message-ID: <20110508231449.GF15585@thunk.org>
References: <1304597439-7185-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44789 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab1EHXOz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 May 2011 19:14:55 -0400
Content-Disposition: inline
In-Reply-To: <1304597439-7185-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 05, 2011 at 02:10:39PM +0200, Jan Kara wrote:
> In do_get_write_access() we wait on BH_Unshadow bit for buffer to get
> from shadow state. The waking code in journal_commit_transaction() has
> a bug because it does not issue a memory barrier after the buffer is moved
> from the shadow state and before wake_up_bit() is called. Thus a waitqueue
> check can happen before the buffer is actually moved from the shadow state
> and waiting process may never be woken. Fix the problem by issuing proper
> barrier.
> 
> Reported-by: Tao Ma <boyu.mt@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, I've added this to the ext4 tree.  (Currently in the dev
branch, pending testing.)

					- Ted
