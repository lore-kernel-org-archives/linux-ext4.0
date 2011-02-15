From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [BUG] ext4: cannot unfreeze a filesystem due to a deadlock
Date: Tue, 15 Feb 2011 12:03:52 -0500
Message-ID: <20110215170352.GE4255@thunk.org>
References: <20110207205325.FB6A.61FB500B@jp.fujitsu.com>
 <20110215160630.GH17313@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38829 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073Ab1BOREA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Feb 2011 12:04:00 -0500
Content-Disposition: inline
In-Reply-To: <20110215160630.GH17313@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 15, 2011 at 05:06:30PM +0100, Jan Kara wrote:
> Thanks for detailed analysis. Indeed this is a bug. Whenever we do IO
> under s_umount semaphore, we are prone to deadlock like the one you
> describe above.

One of the fundamental problems here is that the freeze and thaw
routines are using down_write(&sb->s_umount) for two purposes.  The
first is to prevent the resume/thaw from racing with a umount (which
it could do just as well by taking a read lock), but the second is to
prevent the resume/thaw code from racing with itself.  That's the core
fundamental problem here.

So I think we can solve this by introduce a new mutex, s_freeze, and
having the the resume/thaw first take the s_freeze mutex and then
second take a read lock on the s_umount.

						- Ted
