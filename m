From: Ted Ts'o <tytso@mit.edu>
Subject: Re: e2fsck aborts when invalid indirect block is encountered
Date: Thu, 1 Sep 2011 13:00:39 -0400
Message-ID: <20110901170039.GA4110@thunk.org>
References: <20110901063410.GA8313@notebook.chenhuan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36990 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab1IARAm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Sep 2011 13:00:42 -0400
Content-Disposition: inline
In-Reply-To: <20110901063410.GA8313@notebook.chenhuan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 01, 2011 at 02:34:10PM +0800, Chen Huan wrote:
> Hi, All.
> 
> During a recent read-only checking of an corrupted ext3 file system,
> I found a strange behaviour of e2fsck: when an inode has an invalid
> indirect block number, e2fsck aborts with the following message:
> 
>     e2fsck 1.39 (29-May-2006)
>     Pass 1: Checking inodes, blocks, and sizes
>     Inode 12 has illegal block(s).  Clear? no
> 
>     Illegal block #-1 (4294967295) in inode 12.  IGNORED.
>     Error while iterating over blocks in inode 12: Illegal indirect block found
>     e2fsck: aborted

> My question is: Is this behaviour a bug or intended?

This is deliberate.  There are two reasons for this:

(1) e2fsck -n is currently defined as being equivalent to (a) opening
the file system read-only, and (b) answering 'no' to all questions
asked by e2fsck.

(2) In the case where you *aren't* doing an e2fsck -n, there are
certain situations where not correcting an error means (a) that its
dangerous to try to fix anything afterwards, and that (b) many of the
diagnostics issued by e2fsck can not be relied upon.

We could change things so that e2fsck doesn't abort in the case where
-n is specified, which would avoid the problem 2a, but it breaks the
definition of 1b.  It also doesn't solve the problem listed in 2b.
Still, if it's really annoying it's something I could consider
changing.  Let me sleep on it.

	      	      	   	   - Ted
