From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH -v2 7/9] ext4: don't use the block freed but not
	yet committed during buddy initialization
Date: Tue, 4 Nov 2008 12:15:15 -0500
Message-ID: <20081104171515.GL30291@mit.edu>
References: <1225733769-23734-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:37232 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756931AbYKDRPV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Nov 2008 12:15:21 -0500
Content-Disposition: inline
In-Reply-To: <1225733769-23734-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 03, 2008 at 11:06:07PM +0530, Aneesh Kumar K.V wrote:
> +static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
> +					ext4_group_t group,
> +					struct ext4_free_data *entry)
> +{
	...
> +	if (n->rb_left) {
> +		new_entry = rb_entry(n->rb_left, struct ext4_free_data, node);
> +		ext4_mb_generate_from_freelist(sb, bitmap, group, new_entry);
> +	}
> +	if (n->rb_right) {
> +		new_entry = rb_entry(n->rb_right, struct ext4_free_data, node);
> +		ext4_mb_generate_from_freelist(sb, bitmap, group, new_entry);
> +	}

ext4_mb_generate_from_freelist() is recursively calling itself, which
could easily blow the stack if there are a large number of items on
the free list (remember, this can include data blocks if
!ext4_should_writeback_data()).

You should probably use rb_first and rb_next in a loop rather than a
recursive descent.  I also remain concerned that
ext4_mb_generate_from_freelist() is could burn a large amount of CPU
in some cases, and as I said on the conference call, if there is a way
to avoid it, that would be a Good Thing.

						- Ted
