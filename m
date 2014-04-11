From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] resize2fs: fix over-pessimistic heuristic.
Date: Fri, 11 Apr 2014 12:05:25 +0400
Message-ID: <877g6wi94q.fsf@openvz.org>
References: <1396788965-11777-1-git-send-email-dmonakhov@openvz.org> <20140411033915.GA21215@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:41171 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbaDKIF3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Apr 2014 04:05:29 -0400
Received: by mail-la0-f41.google.com with SMTP id gl10so3292809lab.28
        for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2014 01:05:27 -0700 (PDT)
In-Reply-To: <20140411033915.GA21215@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 10 Apr 2014 23:39:15 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sun, Apr 06, 2014 at 04:56:05PM +0400, Dmitry Monakhov wrote:
> > In worst case we need one extent per moved block. Number of blocks to
> > be moved is less or equals to blks_needed.
> 
> I can believe that the original safety margin of 0.2% of how much we
> will be shrinking the file system might have been overly pessimistic.
> 
> However I'm concerned that your change might be over-optimistic.  For
> example, if we are shrinking the file system down to under 500 blocks,
> then the safety_margin will be 0 --- but it's could very easily be the
> case that an extent tree will need to grow.
> 
> I'd accept this change, although I don't know it would make a
> difference in the cases you are concerned about:
> 
> 		blk64_t safe_margin = (ext2fs_blocks_count(fs->super) -
> 				       blks_needed)/500;
> 		if (safe_margin > blks_needed)
> 			safe_margin = blks_needed;
> 
> How and why are you using this? 
We have test-suite for ploop/resize2fs test which try to cover most dark
corners of online resize2fs and offline shrink. Test appeared to be
useful and ideally it should be pushed to xfsetsts, but the way it was
written on python and has too many Parallels speciffic API stuff (instead
of generic 'resize2fs /$DEV $SIZE' it call 'vzctl set $CONTAINERID $SIZE' )
I have plans to rewrite this test according to xfstest rules and submit
it someday(next month or later). One of subtests looks like follows:
# Test that we can grow filesystem up to the limit, and shrink it back.
mke2fs $dev -Eresize=$((~0)) 10G
mount $dev $mnt
# fill filesystem with containers info (~750Mb)
tar -zxf container.tar.gz $mnt
# online grow to maximum size
resize2fs $dev 16T
# Perform online shrink back to original size
umount $dev $mnt
resize2fs $dev 10G
## Last command will fail  because safity_margin = 32G
> I've never been all that exicited
> about the -M option, since it's been abused in so many different ways,
> and the result when you compress the file system that significantly is
> often no good for performance.
That is true. But setting safe_margin to 50% of space IMHO is too
pessimistic, because filesystem becomes unusable from 90-95%
Even more when user ask to shrink filesytem to it's minimum size he
MUST realize that result filesystem will be size optimized in contrast
to performance. Since we have to introduce some heuristic I'll beat on 25%  :) 
               blk64_t safe_margin = (ext2fs_blocks_count(fs->super) -
                                      blks_needed)/500;
               if (safe_margin > blks_needed / 2)
                       safe_margin = blks_needed /2;

> 
> 					- Ted
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
