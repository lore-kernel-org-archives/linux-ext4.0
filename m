From: tytso@mit.edu
Subject: Re: [Bug 15910] zero-length files and performance degradation
Date: Mon, 10 May 2010 10:34:33 -0400
Message-ID: <20100510143433.GS18762@thunk.org>
References: <bug-15910-13602@https.bugzilla.kernel.org/>
 <201005091819.o49IJCQG017276@demeter.kernel.org>
 <20100510025612.GM18762@thunk.org>
 <AANLkTilQyGvZeyJiGZFjkKIF9qXPQ2l1YNh_W8jvg1J0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50163 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab0EJOel (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 May 2010 10:34:41 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTilQyGvZeyJiGZFjkKIF9qXPQ2l1YNh_W8jvg1J0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 10, 2010 at 10:22:47PM +0800, Peng Tao wrote:
> What about letting fsync() on dir recursively fsync() all
> files/sub-dirs in the dir?
> Then apps can unpack package in a temp dir, fsync(), and rename.

There are programs to do who execute fsync() on a directory, and they
do not expect a recursive fsync() on all files/subdirectories in a
directory.

At least for Linux, sync() is synchronous and will do what you want.
There is unfortunately not a portable way to do what you want short of
fsync'ing all of the files after they are written.  This case is
mostly optimized under ext3/4 (we could do a bit better for ext4, but
the performance shouldn't be disastrous --- certainly much better than
write a file, fsync, rename a file, repeat).

					- Ted
