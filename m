From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: patches in queue but missing from series?
Date: Sun, 14 Sep 2008 14:43:56 -0700
Message-ID: <48CD859C.8070301@redhat.com>
References: <48CD7DEC.6080008@redhat.com> <20080914213448.GB8706@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33274 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbYINVpr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Sep 2008 17:45:47 -0400
In-Reply-To: <20080914213448.GB8706@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Sun, Sep 14, 2008 at 02:11:08PM -0700, Eric Sandeen wrote:
>> Looking at what's in the patch queue, but not in the series file:
>>
>> ext4-fix-hang-due-to-corrupted-jinode.patch
>> ext4-new-defm-options
>> ext4-online-resize-fix-for-group-descriptor-corruption.patch
>> Fix-EXT_MAX_BLOCK.patch
>> jbd2-dio-kjournal-race-EIO.patch
>> jbd-dio-kjournal-race-EIO.patch
>>
>> Some of these are probably intentional (I think Ted has the printk
>> throttling stuff queued up to send) but have any of these simply gotten
>> lost somehow?  Or merged upstream (or obsoleted) but not removed?
> 
> Well, all of the patches in the ext3 directory are non-ext4 patches
> which I sent to akpm on Friday or Saturday; I decided to check them
> into the patch queue to make sure they don't get lost.  I'll remove
> them when they are confirmed in -mm.  These would be:
> 
>> ext2-printk-throttling
>> ext3_dx_readdir_hash_collision_fix.patch
>> ext3-printk-throttling
>> ext3_truncate_block_allocated_on_a_failed_ext3_write_begin.patch
> 
> Some of the patches were ones that fixed bugs introduced in other
> patches, and were folded into a parent patch.  This was the case for
> ext4-fix-hang-due-to-corrupted-jinode.patch, which was folded into the
> patch that ultimately became commit 678aaf48 in the mainline Linux
> tree.

Ok that's what I thought.

> Ext4-new-defm-options was a patch I was working on that never got
> finished.  It probably shouldn't have gotten checked into the patch
> queue.

Ok.

> Girish's Fix-EXT_MAX_BLOCK.patch caused regression failures, so it was
> dropped from the patch series.  I don't think anyone ever went back to
> figure out why it was causing the ext4 tree to blow up.

Ok.  Maybe it'd be better for something like that to comment it out of
the patch series, with a reason why?  *shrug*

> As far as jbd2-dio-kjournal-race-EIO.patch and
> jbd-dio-kjournal-race-EIO.patch are concerned,
> jbd2-dio-kjournal-race-EIO.patch doesn't even apply any more.  I'm
> guess it was fixed in some other way for jbd2.  It looks the jbd patch
> could apply, but if it's still a valid fix, it should be fed through
> akpm.  Mingming, do you know what the status of these two patches are?
> 
>        		    	     	      	     	- Ted

Great - owners looking over these orphaned/lost patches is probably the
best approach.  :)

Thanks,
-Eric
