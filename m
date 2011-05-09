From: Ted Ts'o <tytso@mit.edu>
Subject: Re: errors in ext4_mb_generate_buddy and ext4_remount
Date: Sun, 8 May 2011 21:01:12 -0400
Message-ID: <20110509010112.GC4138@thunk.org>
References: <f93bc5d54d25e080b5438bcdc3af8f84@imap.dd24.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34334 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285Ab1EIBBP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 May 2011 21:01:15 -0400
Content-Disposition: inline
In-Reply-To: <f93bc5d54d25e080b5438bcdc3af8f84@imap.dd24.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 08, 2011 at 12:56:19AM +0000, Christoph Anton Mitterer wrote:
> 
> However, I constantly get these errors:
> [  331.744025] EXT4-fs (dm-2): error count: 10
> [  331.744030] EXT4-fs (dm-2): initial error at 1304673122:
> ext4_mb_generate_buddy:731
> [  331.744034] EXT4-fs (dm-2): last error at 1304673124: ext4_remount:4250
> ... (probably) when reading some files. I guess it's reading files, at
> least it happens during a debsums run (checks the package sums of more or
> less all Debian packages installed).
> Also the numbers in the errors above, are (at least until know, and as far
> as I looked after it) the same.
> 
> It also happens (as far as I can see) only once, i.e. if the error has
> already occurred, and I do e.g. my debsums again, it's not printed again.
> 
> fsck runs through fine (but quite quick; yes - of course - I've used -f)
> 
> Any ideas? (Please CC me as I'm off list).

Kernels 2.6.35 and newer will set superblock fields that will result
in those messages.  They're not error messages per se; it's just a
notification that there was an file system error in the past that
hasn't been fixed yet.  In your case, it *has* been fixed, but you
don't have a new enough version of e2fsprogs so that it clears the
relevant parts of the superblock.

The debian packages of e2fsprogs version 1.41.14-1 in experimental, or
1.41.12-4 in unstable, has the necessary new code in e2fsck.  I'm
working on getting the patch pushed to Debian obsolete^H^H^H^H^H^H^H
stable; hopefully that will happen in the next week or two.

		       	    	      	       - Ted
