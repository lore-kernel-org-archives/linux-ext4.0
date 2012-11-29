From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsck: Fix incorrect interior node logical start values
Date: Thu, 29 Nov 2012 09:22:31 -0600
Message-ID: <50B77DB7.70307@redhat.com>
References: <50A546D8.3020500@redhat.com> <20121129133129.GC20413@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab2K2PWb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Nov 2012 10:22:31 -0500
In-Reply-To: <20121129133129.GC20413@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/29/12 7:31 AM, Theodore Ts'o wrote:
> Hmm, it looks like you didn't run the regression test script before
> submitting this patch?

No :(  I ran it against several filesystems mangled by xfstests,
IIRC, but TBH I forgot to run the e2fsprogs suite.  My mistake,
I've gotten out of that habit.  Mea culpa.

> It looks like it's not a bug which your patch introduced, but rather,
> it uncovered a bug.  This was a failure in the second run of
> f_extent_bad_node, because in the fix we didn't make sure we updated
> the starting block of parent node when we cleared a node in the extent
> tree.  (see below)
> 
> This brings up another question.  Did you test file systems after
> running punch on a number of different files to make sure the e2fsck
> is happy withe file systems which current kernels might generate?

I'm pretty sure I did test it against punched files, but I can
do further testing if you have a particular concern ....

> In this particular test case, even though the logical start didn't
> match, it doesn't cause any problems because it's at the left-most
> branch of the tree.  I want to make sure we aren't triggering failures
> for file systems where the kernel is creating which is technically
> incorrect, but which isn't causing problems in practice...

But it's a weird inconsistency isn't it, and fixing it up in fsck should
be the right thing to do anyway?

-Eric

> 	       	     	   	   - Ted
> 
> % ./test_script f_extent_bad_node
> f_extent_bad_node: bad interior node in extent tree: failed
> --- ../../tests/f_extent_bad_node/expect.2     2012-07-06 13:37:27.316253023 +0000
> +++ f_extent_bad_node.2.log		       2012-11-29 13:24:11.119306973 +0000
> @@ -1,7 +1,23 @@
>  Pass 1: Checking inodes, blocks, and sizes
> +Interior extent node level 0 of inode 12:
> +Logical start 0 does not match logical start 3 at next level.  Fix? yes
> +
> +Inode 12, i_blocks is 8, should be 6.  Fix? yes
> +
>  Pass 2: Checking directory structure
>  Pass 3: Checking directory connectivity
>  Pass 4: Checking reference counts
>  Pass 5: Checking group summary information
> -test_filesys: 12/16 files (0.0% non-contiguous), 25/100 blocks
> -Exit status is 0
> +Block bitmap differences:  -24
> +Fix? yes
> +
> +Free blocks count wrong for group #0 (75, counted=76).
> +Fix? yes
> +
> +Free blocks count wrong (75, counted=76).
> +Fix? yes
> +
> +
> +test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
> +test_filesys: 12/16 files (0.0% non-contiguous), 24/100 blocks
> +Exit status is 1
> 125 tests succeeded	1 tests failed
> Tests failed: f_extent_bad_node 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

