From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: resize2fs minimum size wrong
Date: Sat, 23 May 2015 19:36:03 -0400
Message-ID: <20150523233603.GA3270@thunk.org>
References: <5560EEB1.8070003@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54820 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbbEWXgH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 May 2015 19:36:07 -0400
Content-Disposition: inline
In-Reply-To: <5560EEB1.8070003@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 23, 2015 at 05:18:41PM -0400, Phillip Susi wrote:
> 
> So I have a filesystem with nothing beyond group 16 used ( including
> metadata ), so it should be able to shrink to ~524288 blocks, yet
> resize2fs claims the minimum size is 770083 blocks.  Resize debug output
> follows:

Figuring out the minimum size in a way where we don't screw up and
pick a number too _low_ is tricky, because if resize2fs aborts in the
middle, we can end up with a corrupted file system.

I have continued to severely regret accepting the patch that
calculates the minimum size necessary, because it's *hard* to get it
right, and if it's too aggressive, users lose data, and get angry, and
if it's too liberal, then users whine.

I'm going to guess the problem has to do with the reserved space
needed so that resize works correctly, and the amount of reserved
space needed drops as we decrease the nmber of block groups.  So if
you start with a very large file system, and then try to shrink it
down to minimum size, you may need to run resize2fs -M multiple times.
Which to be honest, is just fine as far as I'm concerned, because I've
been trying to strongly discourage the use of resize2fs -M in the
first place, because it tends to leave a highly non-optimal file
system.

						- Ted
