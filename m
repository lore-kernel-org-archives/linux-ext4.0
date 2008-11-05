From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH -v2 7/9] ext4: don't use the block freed but not
	yet committed during buddy initialization
Date: Wed, 5 Nov 2008 20:53:22 +0530
Message-ID: <20081105152322.GC6244@skywalker>
References: <1225733769-23734-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081104171515.GL30291@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:57420 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYKEPY4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 10:24:56 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id mA5FO9qA030572
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 02:24:09 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA5FNgjP4620398
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 02:23:42 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA5FNc7Z029000
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 02:23:38 +1100
Content-Disposition: inline
In-Reply-To: <20081104171515.GL30291@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 04, 2008 at 12:15:15PM -0500, Theodore Tso wrote:
> On Mon, Nov 03, 2008 at 11:06:07PM +0530, Aneesh Kumar K.V wrote:
> > +static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
> > +					ext4_group_t group,
> > +					struct ext4_free_data *entry)
> > +{
> 	...
> > +	if (n->rb_left) {
> > +		new_entry = rb_entry(n->rb_left, struct ext4_free_data, node);
> > +		ext4_mb_generate_from_freelist(sb, bitmap, group, new_entry);
> > +	}
> > +	if (n->rb_right) {
> > +		new_entry = rb_entry(n->rb_right, struct ext4_free_data, node);
> > +		ext4_mb_generate_from_freelist(sb, bitmap, group, new_entry);
> > +	}
> 
> ext4_mb_generate_from_freelist() is recursively calling itself, which
> could easily blow the stack if there are a large number of items on
> the free list (remember, this can include data blocks if
> !ext4_should_writeback_data()).
> 
> You should probably use rb_first and rb_next in a loop rather than a
> recursive descent. 

Will do this.

>I also remain concerned that
> ext4_mb_generate_from_freelist() is could burn a large amount of CPU
> in some cases, and as I said on the conference call, if there is a way
> to avoid it, that would be a Good Thing.

We need ext4_mb_generate_from_freelist for multiple case

a) While generating the buddy information we need to make sure we don't
use the blocks released but not yet committed to disk. We may force
buddy rebuild because we added a new group via resize. We need to do
a buddy rebuild irrespective of whether we use ext4_mb_free_blocks or
EXT4_MB_GRP_NEED_INIT flag

b) We we release inode preallocation we look at the block bitmap
and mark the blocks found free in the bitmap using mb_free_blocks.
Now if we  allocate some blocks and later free some of them we may 
have called ext4_mb_free blocks on them which mean we would have
marked the blocks free on bitmap. Now on file close we release
inode pa. We look at the block bitmap and if the block is free
in bitmap we call mb_free_blocks. Also on committing the transaction we
call mb_free_blocks on them. To avoid the above we need to make sure
when we discard_inode_pa we look at a bitmap that have block freed
and not yet committed as used.

-aneesh
