From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Large directories and poor order correlation
Date: Mon, 14 Mar 2011 17:52:49 -0400
Message-ID: <20110314215249.GE8120@thunk.org>
References: <4D7E7990.90209@cfl.rr.com>
 <4D7E7C7F.1040509@redhat.com>
 <4D7E8005.4030201@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35159 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab1CNVwy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Mar 2011 17:52:54 -0400
Content-Disposition: inline
In-Reply-To: <4D7E8005.4030201@cfl.rr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 14, 2011 at 04:52:21PM -0400, Phillip Susi wrote:
> It seems unreasonable to ask applications to read all directory entries,
> then sort them by inode number to achieve reasonable performance.  This
> seems like something the fs should be doing.

Unfortunately the kernel can't do it, because a directory could be
arbitrarily big, and kernel memory is non-swappable.  In addition,
what if a process opens a directory, starts calling readdir, pauses in
the middle, and then holds onto it for days, weeks, or months?

Combine that with POSIX requirements about how readdir() has to behave
if files are added or deleted during a readdir() session (even a
readdir session which takes days, weeks, or months), and it's a
complete mess.

It's not hard to provide library routines that do the right thing, and
I have written an LD_PRELOAD which intercepts opendir() and readdir()
calls and does the sorting in userspace.  Perhaps the right answer is
getting this into libc, but I have exactly two words for you: "Uhlrich
Drepper".

					- Ted
