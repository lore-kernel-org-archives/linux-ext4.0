From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] update 068 to reproduce an unfreeze hanging up problem
Date: Wed, 4 Jan 2012 09:59:44 -0500
Message-ID: <20120104145944.GA21381@infradead.org>
References: <20111213094245.4004.61FB500B@jp.fujitsu.com>
 <20111213063212.GC14273@dastard>
 <20111214112209.1002.61FB500B@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34729
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755796Ab2ADO7t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jan 2012 09:59:49 -0500
Content-Disposition: inline
In-Reply-To: <20111214112209.1002.61FB500B@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 14, 2011 at 11:22:10AM +0900, Masayoshi MIZUMA wrote:
> > test 068 will catch problems like the one your specific test
> > catches, but maybe not every time. Test 068 will catch problems your
> > test case won't, though - it's a trade-off between having lots of
> > tests that are similar but slightly different (difficult to
> > maintain, increases runtime, etc), and having one test that
> > exercises the functionality in a simple manner likely to detect
> > problems.
> 
> Thank you for your explanation about the policy and I understand it.


> I tried to reproduce the problem not dropping the sleep, but the problem was
> not reproduced... Therefore, I dropped it and the problem was reproduced.
> 
> However, as you mentioned, the problem is a timing proglem, so the
> my reproduction might be just by chance. Dropping sleep may increase
> the possibility of the reproduction, but not every time, so the change
> is not good. That is same for the arguments of fsstress which I changed.
> 
> OK, I update 068 just to run other filesystem, ext3, ext4 and btrfs which
> I confirmed xfs_freeze works on.
> (xfs_freeze may work on the other filesystems which have freeze_fs/unfreeze_fs
>  super_operations but I don't confirm...)
> 
> The patch is below.

Given that MIZUMAs patch reproduces a real life issue I think adding
his original patch in addition to this change would be a good idea.

Dave, do you have a strong opinion against that?

