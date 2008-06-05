From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -v2] ext4: Use inode preallocation with -o noextents
Date: Thu, 5 Jun 2008 11:37:01 -0400
Message-ID: <20080605153701.GB25477@mit.edu>
References: <1211229262-11012-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080604022356.GA7094@mit.edu> <20080604040101.GA22348@skywalker> <20080605032220.GC10488@mit.edu> <20080605084329.GB8942@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:35251 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752928AbYFEPh6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 11:37:58 -0400
Content-Disposition: inline
In-Reply-To: <20080605084329.GB8942@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 05, 2008 at 02:13:29PM +0530, Aneesh Kumar K.V wrote:
> 
> Something like below ? . I will send a final patch once I get the
> patchqueu updated. I am not able to reach repo.or.cz currently.

This is better, but it still means that we are exporting a large
number of functions to the callers.  It's not clear to me we need so
many different variants of ext4_new_blocks_* --- what is their
justification to exist?

For example, why not just have:

static ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
       				ext4_lblk_t iblock, ext4_fsblk_t goal,
				unsigned long *count, int *errp, int meta)

where if inode is NULL, then you're allocating a metadata block, and
if count is NULL, then you only want one block.  Of course, this needs
to be carefully documented at the function.

						- Ted
