From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/12] ext4: Disable merging of uninitialized extents
Date: Thu, 31 Jan 2013 11:54:06 -0500
Message-ID: <20130131165406.GA14486@thunk.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-5-git-send-email-jack@suse.cz>
 <87vcamdi6e.fsf@openvz.org>
 <87a9rpssj8.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46376 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab3AaQy1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2013 11:54:27 -0500
Content-Disposition: inline
In-Reply-To: <87a9rpssj8.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 31, 2013 at 11:47:23AM +0400, Dmitry Monakhov wrote:
> OK I've found it. I'm a bit disappointed, it is even not a race
> condition, but simple corruption.
> Patch is available here: http://article.gmane.org/gmane.comp.file-systems.ext4/36762
> link for sain mailer client: <1359617098-18451-1-git-send-email-dmonakhov@openvz.org>
> After this bug was fixed it is safe to apply both Jan's patches:
> [PATCH 04/12] ext4: Disable merging of uninitialized extents
> [PATCH 05/12] ext4: Remove unnecessary wait for extent conversion in ext4_fallocate()
> At least it survives after all my tests.

Thanks for finding it!  As folks have probably noticed the dev branch
and linux-next already has all of the other patches (except for #3,
which we've agreed isn't needed since the original code was correct
as-is).  I'll work on reviewing your patch and then applying the last
three, and then over the weekend I'll push the master branch up, thus
casting all of the patches currently in the tree into stone.

> BTW: It is appeared that ext4_debug() infrastructure is almost unusable
> because based on printk() instead of light-wait event tracing infrastructure.
> I'm now work on patch-set which fix that.

Yes, I haven't used the ext4_debug infrastructure in quite some time.
As I've needed to do debugging I've added new tracepoints, and in some
cases I hadn't gotten around to removing the old ext4_debug code, on
the assumption that maybe someone else was still using it, but mostly
because I was lazy.   That would be a great thing to do.

	      	      	   	      	    - Ted
