From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH] ext4: validate number of meta clusters in group
Date: Sun, 10 Jul 2016 22:51:53 -0400
Message-ID: <20160711025153.GO26097@thunk.org>
References: <57766AE1.1040508@oracle.com>
 <20160702074903.GA4914@birch.djwong.org>
 <577EB740.10502@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Vegard Nossum <vegard.nossum@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58386 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757265AbcGKCwA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Jul 2016 22:52:00 -0400
Content-Disposition: inline
In-Reply-To: <577EB740.10502@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 07, 2016 at 10:10:40PM +0200, Vegard Nossum wrote:
> 
> I ran into a second problem (this time it was num_clusters_in_group()
> returning a bogus value) with the same symptoms (random memory
> corruptions), the new attached patch fixes both problems by checking the
> values at mount time.

Can you give me a dumpe2fs -h of a file system that is causing
num_clusters_in_group() to be bogus?

I want to make sure I'm checking that correct base values, insteda of
doing a brute force loop over all of the block groups and calling
ext4_num_clusters_in_group() and ext4_num_base_meta_clusters() for all
block groups.

Thanks!!

					- Ted
