From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ditching e4b->alloc_semp
Date: Sat, 5 Mar 2011 11:06:56 -0500
Message-ID: <20110305160656.GA3505@thunk.org>
References: <AANLkTikSLsuiZGYaUKtQnMQNZ6Pj=K_RDkYtpK98ujy1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42823 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580Ab1CFANf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Mar 2011 19:13:35 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTikSLsuiZGYaUKtQnMQNZ6Pj=K_RDkYtpK98ujy1@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 21, 2011 at 10:02:44PM +0200, Amir Goldstein wrote:
> 
> 1. (AKA easy lane) use a single page (or more) per block group.
> this will increase the memory usage for 1K blocks fs and for 2K block fs
> on 8K page system, but are these use cases really that common?

The most common use cases will be 4k block file system on 16k page
systems, which show up on PowerPC and Itanium systems.

> 2. (AKA hard lane) attach buffer heads to buddy page and use
> buffer_uptodate() and buffer_lock() instead of PageUptodate() and lock_page()
> to initialize buddy cache of groups that share the same page.

How about this; use lock_page() to guarantee exclusive access to the
shared buddy bitmap, and then define a new bit in
ext4_group_info->bb_state to indicate whether or not a particular
block group has been initialized.  If the page has gotten flushed from
memory, so that it is not present at all (i.e., find_get_page returns
NULL), then iterate over all of the groups to clear the
EXT4_GROUP_INFO_BUDDY_INIT bit.

If the page is returned by find_get_page(), then all you need to do is
check the EXT4_GROUP_INFO_BUDDY_INIT bit to discover whether or not or
not the buddy bitmap needs to be initialized.

							- Ted
