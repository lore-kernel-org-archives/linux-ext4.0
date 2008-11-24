From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH -V4] ext4: Fix lockdep recursive locking warning
Date: Mon, 24 Nov 2008 00:02:40 -0500
Message-ID: <20081124050240.GA20928@mit.edu>
References: <1227285646-16263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081122204625.GF9150@mit.edu> <20081123024911.GG9150@mit.edu> <20081123163349.GB17002@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:33133 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855AbYKXFFi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Nov 2008 00:05:38 -0500
Content-Disposition: inline
In-Reply-To: <20081123163349.GB17002@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've added your patch to the patch queue, using the following commit
comment, and using it to replace
aneesh-9-fix-lockdeep-recursive-locking-warning in the patch queue.

Please note that commit description explains what was the problem you
were trying to solve, some notes about why this works, what the
limitations might be with the approach.  This is the kind of commit
logs we should strive for.  We've been complemented for the clarity of
our commit logs, and much of that is because I've been rewriting the
changelog messages.  If everyone who submits patches could strive to
meet similar standards, I'd greatly appreciated.

						- Ted

ext4: Fix lockdep recursive locking warning

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

In ext4_mb_init_group(), if the filesystem block size is less than
PAGE_SIZE/2, the code tries to grab alloc_sem for multiple block
groups in a loop.  We need to allow for this by using
down_write_nested() and passing in the loop index as a lock subclass
number.  This works because no other code path needs to take multiple
alloc_sem's.  Note that lockdep will fail for filesystem blocksize
smaller than to PAGE_SIZE/16k.  (e.g., a 1k filesystem blocksize with
a 32k page size, or a 2k filesystem blocksize with a 64k blocksize,
etc.)
