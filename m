From: Jan Kara <jack@suse.cz>
Subject: Re: Help on Implementation of EXT3 type Ordered Mode in EXT4
Date: Mon, 29 Mar 2010 17:45:34 +0200
Message-ID: <20100329154534.GE5835@quack.suse.cz>
References: <20100212200726.GD5337@thunk.org>
 <38f6fb7d1002130043s54e61e74jcc3297aeeac294b0@mail.gmail.com>
 <20100215150021.GE3434@quack.suse.cz>
 <38f6fb7d1002160210x6dc86fb5o82825e7677c07994@mail.gmail.com>
 <20100216131039.GB3153@quack.suse.cz>
 <20100216141854.GT5337@thunk.org>
 <38f6fb7d1002170737l1e9e3b72ub08e106283c26501@mail.gmail.com>
 <38f6fb7d1003182023j5513640csdc797adb49393ea0@mail.gmail.com>
 <20100322165209.GB4754@quack.suse.cz>
 <38f6fb7d1003230341j4ff52fffidc614d566476b5bc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	Jiaying Zhang <jiayingz@google.com>
To: Kailas Joshi <kailas.joshi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab0C2QpV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Mar 2010 12:45:21 -0400
Content-Disposition: inline
In-Reply-To: <38f6fb7d1003230341j4ff52fffidc614d566476b5bc@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Tue 23-03-10 16:11:45, Kailas Joshi wrote:
> I have Lock Debugging enables but that didn't give any warnings.
> However, when I did echo "w" >/proc/sysrq-trigger after system lockup,
> I got the stack trace for locked up process.
> 
> Following are the stack traces of the processes (I suspect) resulting
> in total system lockup -
  <snip>

  So kjournald is waiting on a page lock and everyone else waits for
kjournald to finish committing or for page lock as well. The strange thing
is that I don't see anybody who could hold the page lock everyone is
waiting on. So I think further debugging should go in this direction - find
out on which page do we wait and who is holding it's lock (you'd need to
add tracking of page lock owner but that shouldn't be too hard).

> I have few questions here.
> I guess process named jbd2/sdb1-8 is kjournald thread. But what is
  Yes.

> flush-8:16 process? Is it the kernel thread for periodically writing
> dirty pages to disk?
  Yes.

> Is it the case that these threads are running concurrently at certain
> time and are trying to get lock on same pages resulting into deadlock?
  It should not happen - they should always acquire page lock in
index-increasing order so that way deadlocks should be avoided...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
