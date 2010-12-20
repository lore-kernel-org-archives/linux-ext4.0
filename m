From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH]: icount: Replace the icount list by a two-level tree
Date: Mon, 20 Dec 2010 12:46:09 -0700
Message-ID: <3718B2E6-3AB9-4E47-A37D-00D0302A73D7@dilger.ca>
References: <029B6C3A-FB77-4C56-84B3-49DDB81220B0@tudelft.nl>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>
To: Christian Doerr <c.doerr@tudelft.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:40246 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932999Ab0LTTqM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Dec 2010 14:46:12 -0500
In-Reply-To: <029B6C3A-FB77-4C56-84B3-49DDB81220B0@tudelft.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-12-20, at 11:30, Christian Doerr wrote:
> I am writing you with a follow-up question to your response in this thread (http://comments.gmane.org/gmane.comp.file-systems.ext4/21646), where you're given a general rule of thumb on the memory usage of e2fsck.
> 
> My problem is similar to the one posted there (my thread is http://serverfault.com/questions/201554/e2fsck-aborts-memory-allocation-failed), except that I am checking a broken 9TB partition with now 12 GB of RAM (+ swap space, upgraded from 4GB) which still doesn't seem enough.
> 
> In regard to the bugzilla patch you're referring to, would you consider it possible to build an old set of libraries that would compile against this patch? If so, do you have any intuition when the libraries might have changed? After one month of debugging, I am ready to try anything...


Have you actually tested the patch that was posted in that thread?
<http://article.gmane.org/gmane.comp.file-systems.ext4/20731/

This addresses one aspect of the memory utilization problem, where libext2fs was trying to make a single allocation that was larger than 1/2 of RAM to handle hard-linked files, and preventing it from using the swap.  With the patch, the allocations are smaller, and can be swapped out individually instead of simply failing the allocation outright.

If this patch resolves your problem, we should look into getting this patch included in the upstream e2fsprogs.  Ted is going to be making a new release this week, so you may still have some time to get it included.


Looking at the error message you provided "Error while storing directory block information" (PR_1_ADD_DBLOCK), it looks like this is the result of an allocation failure in the function ext2fs_add_dir_block() function, which is a similar problem to the icount one fixed above, but in a different part of the code.  ext2fs_add_dir_block() is also trying to do a single large allocation to handle all of the directories in the filesystem, but is failing to be able to reallocate the array.

It looks like the ext2fs_dblist_*() functions would also allow changing the internal list implementation into a 2-level tree as was done for the icount structures, to avoid such large memory allocations.  It appears that the dblist is generated as an unsorted list initially (unlike icount), and is then later sorted with qsort().  If this was changed to a 2-level tree the qsort() would be done within individual leaf blocks, and then a merge sort would be needed to combine the blocks afterward.  I don't think it makes sense to create this initially as a sorted tree, because several different sort functions are used within e2fsck on this list.  This is unfortunately not work that I am able to do right now, but anyone with some C programming skills could tackle.


Also, Lukas Czerner has been working on an "rbtree" patch for the bitmap memory reduction.  While the bitmap memory allocation may not be the problem being seen here, reducing the memory used by the various bitmaps would certainly make more memory available for other parts of e2fsck.  Note, however, that Lukas' code is currently in the early stages of development, so I would only suggest to run them in read-only mode (-n) until he is further along with development/testing.


Cheers, Andreas





