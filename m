From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Use WRITE_SYNC in journal checkpoint.
Date: Mon, 27 Jun 2011 12:41:58 -0400
Message-ID: <20110627164158.GD2729@thunk.org>
References: <1307418559-3329-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44573 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab1F0QmD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jun 2011 12:42:03 -0400
Content-Disposition: inline
In-Reply-To: <1307418559-3329-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 07, 2011 at 11:49:19AM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In journal checkpoint, we write the buffer and wait for its finish.
> But in cfq, the async queue has a very low priority, and in our test,
> if there are too many sync queues and every queue is filled up with
> requests, the write request will be delayed for quite a long time and
> all the tasks which are waiting for journal space will end with errors like:

Thanks, added to the ext4 patch tree.

					- Ted
