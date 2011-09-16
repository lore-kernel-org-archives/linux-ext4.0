From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [V3] e2fsprogs: add ext2fs_group_blocks_count helper
Date: Fri, 16 Sep 2011 09:22:53 -0400
Message-ID: <20110916132253.GA6710@thunk.org>
References: <4E286CD6.6030401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54703 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab1IPNW6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 09:22:58 -0400
Content-Disposition: inline
In-Reply-To: <4E286CD6.6030401@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 21, 2011 at 08:15:50AM -0000, Eric Sandeen wrote:
> Code to count the number of blocks in the last partial
> group is cut and pasted around the e2fsprogs codebase
> a few times.
> 
> Making this a helper function should improve matters.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.  Apologies for the delay.

					- Ted
