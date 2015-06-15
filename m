From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] xfstests-bld: exclude ext4 defrag tests from unsupported
 configurations
Date: Sun, 14 Jun 2015 21:14:33 -0400
Message-ID: <20150615011433.GA15793@thunk.org>
References: <20150610181319.GA23530@localhost.localdomain>
 <20150610192810.GB24181@thunk.org>
 <20150611200051.GA505@localhost.localdomain>
 <20150612002421.GB505@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35024 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbbFOBOf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Jun 2015 21:14:35 -0400
Content-Disposition: inline
In-Reply-To: <20150612002421.GB505@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 11, 2015 at 08:24:21PM -0400, Eric Whitney wrote:
> Spoke too soon - hit what looks like the old problem on ARM running 4.1-rc7
> on the ninth trial run.  Various components of the test are left in the 'D'
> state after a familiar oops - kernel BUG at fs/jbd2/transaction.c:2150 while
> truncating.
> 
> I'll see if I can still get the problem to appear on x86_64.

I was able to reproduce this on x86_64, after running a kernel build
on the host as an antogonist.  I'm guessing that the race window is
pretty narrow, so that's why it wasn't triggering for me easily until
I had some additional I/O traffic to slow things down further.

After some investigation, it looks like this bug has been around since
2008(!).  I'll send out a fix.

						- Ted
