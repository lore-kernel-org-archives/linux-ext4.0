From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] JBD: release checkpoint journal heads through
 try_to_release_page when the memory is exhausted
Date: Mon, 27 Oct 2008 14:26:57 -0700
Message-ID: <20081027142657.2120aa3f.akpm@linux-foundation.org>
References: <20081017.223716.147444348.00960188@stratos.soft.fujitsu.com>
	<20081020160249.ff41f762.akpm@linux-foundation.org>
	<20081023174101.85b59177.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, sct@redhat.com,
	linux-fsdevel@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918AbYJ0V1f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Oct 2008 17:27:35 -0400
In-Reply-To: <20081023174101.85b59177.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(added linux-fsdevel)

On Thu, 23 Oct 2008 17:41:01 +0900
Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:

> Hi Andrew.
> 
> > > rather costly.  An alternative might be to implement a shrinker
> > > callback function for the journal_head slab cache.  Did you consider
> > > this?
> > Yes.
> > But the unused-list and counters are required by managing the shrink targets("journal head") 
> > if we implement a shrinker. 
> > I thought that comparatively big code changes were necessary for jbd to accomplish it. 
> 
> > However I will try it. 
> 
> I managed to build a shrinker callback function for the journal_head slab cache.
> This code size is less than before but the logic of it seems to be more complex
>  than before.
> However, I haven't got any troubles while I am testing some easy load operations
> on the fixed kernel.
> But I think a system may hang up if concurrently several journal_head shrinker 
> are executed.
> So, I will retry to build more appropriate fix.

yeah, that's not very pretty either, is it?

> Please give me comments if you have a nicer idea.

Stepping back a bit...

The basic problem is, I believe, that some client of the blockdev
(ext3) is adding metadata to the blockdev's data structures
(buffer_heads) but we have no means by which the blockdev code can call
back into that client requesting that the metadata be released, yes?

We can fix the problem which you've identified by adding a means for
the blockdev code (def_blk_aops.releasepage()) to call back into ext3,
yes?

If so, how do we do that?

I seem to recall that there's code somewhere in the tree which does
things like taking a copy of bdev->address_space_operations and
reinstalling that, and overwriting selected fields, and then arranging
somehow for the old value to be reinstalled when the client releases
the blockdev.  That's plain nasty.

Perhaps what we could do is to add a new

	blkdev_register_releasepage(struct block-device *,
					int (*)(struct page *, gfp_t)

function and call that from within ext3 initialisation.  (This could be
a block_device_operations entry, but is there any point in doing that?)


Within blkdev_register_releasepage(), record the address of that
function in the `struct block_device' (with what locking??) and then
implement def_blk_aops.releasepage(), which calls
bdev->registered_releasepage().  Set def_blk_aops.releaspage() to point
at try_to_free_buffers() to provide the default behaviour.

Then we'd need a blkdev_unregister_releasepage() which restores the old
value.  Or, better, make blkdev_register_releasepage()
return the old value and require that clients of the blockdev (ie:
ext3) restore the old value prior to releasing the blockdev.



Or something along these lines, anyway..

