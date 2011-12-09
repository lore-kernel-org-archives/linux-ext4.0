From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: 277 new test to check freeze/unfreeze works
 well or not under heavy load.
Date: Fri, 9 Dec 2011 18:17:00 +1100
Message-ID: <20111209071700.GD14273@dastard>
References: <20111209145231.5A5F.61FB500B@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
To: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111209145231.5A5F.61FB500B@jp.fujitsu.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 09, 2011 at 02:52:31PM +0900, Masayoshi MIZUMA wrote:
> Hi,
> 
> unfreeze function, thaw_super(), sometimes hangs up if flush kernel
> thread does writeback to the same filesystem concurrently.
> (the problem is reported at
>  http://marc.info/?l=linux-ext4&m=132339590004560&w=2)
> 
> This test runs freeze/unfreeze under heavy load. If the problem is
> reproduced, this test will hang up...

This is effectively a duplicate of test 068, which is currently
described as an XFS only test. It is actually generic now that
xfs_freeze works on other filesytsems, so please update 068
appropriately rather that introducing a new test.

Cheers,

Dave

-- 
Dave Chinner
david@fromorbit.com
