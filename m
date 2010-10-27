From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4 patches for 2.6.37-rc1?
Date: Wed, 27 Oct 2010 16:29:34 -0400
Message-ID: <20101027202933.GD3194@thunk.org>
References: <AANLkTikXgtFRSZRCjT9skEgsUzTqbuuhO2Cmv4RTrOTM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: sedat.dilek@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33055 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab0J0U3p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Oct 2010 16:29:45 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTikXgtFRSZRCjT9skEgsUzTqbuuhO2Cmv4RTrOTM@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 27, 2010 at 12:36:46PM +0200, Sedat Dilek wrote:
> 
> I was wondering if Ted will send ext4 patches within the open
> merge-window for 2.6.37-rc1.

Yes, I am planning on sending patches to Linus.

It's a bit late because I've been crazy busy this past few weeks.

> If you plan to send to Linus, can you give a short overview what
> endusers will expect?

lazy inode table init, improved scalability for buffered writeback (3x
throughput improvement when writing large files in parallel on 48 and
192 threads on a 48-core machine), and a bunch of cleanups and bug
fixes.

> BTW, in which of the GIT trees ([1], [2]) is the ext4 development
> actually happening?
> 
> [1] http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=summary
> [2] http://repo.or.cz/w/ext4-patch-queue.git

Primary development happens in [2], and then it gets mirrored to [1]
periodically.

						- Ted
