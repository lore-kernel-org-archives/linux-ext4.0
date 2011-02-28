From: Ted Ts'o <tytso@mit.edu>
Subject: Re: orphan cleanup on readonly fs will corrupt future fs!
Date: Mon, 28 Feb 2011 00:48:41 -0500
Message-ID: <20110228054841.GR2924@thunk.org>
References: <AANLkTi=_QBgDutcb7h2XHpjHR6k-4Rj-r6zryMXaNn6e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49785 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436Ab1B1QFe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Feb 2011 11:05:34 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=_QBgDutcb7h2XHpjHR6k-4Rj-r6zryMXaNn6e@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 26, 2011 at 08:21:47PM +0200, Amir Goldstein wrote:
> Hi guys,
> 
> I have just realized something very disturbing -
> that orphan cleanup is not being skipped on readonly mount of ext4/ext3.
> 
> I know that journal recovery is done on readonly mount
> and there is problem with that, since nothing happens
> in the fs level.
> 
> But orphan cleanup deletes inodes and frees blocks and that
> could be very bad for some RO_COMPAT features, SNAPSHOT
> and BIGALLOC to name two.

Yes, good point.  Fortunately it won't be a problem for the BIGALLOC
feature, since other changes in the superblock will cause the kernel's
sanity checks to refuse to mount it until we teach future kernels how
not to freak out when s_blocks_per_group > blocksize * 8, for example.

But yes, this is something we should fix.

						- Ted
