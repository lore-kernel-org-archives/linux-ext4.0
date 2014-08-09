From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: e2fsck readahead speedup performance report
Date: Fri, 8 Aug 2014 21:06:34 -0700
Message-ID: <20140809040634.GL11191@birch.djwong.org>
References: <20140809031845.GJ11191@birch.djwong.org>
 <20140809035646.GA23604@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48579 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaHIEGj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Aug 2014 00:06:39 -0400
Content-Disposition: inline
In-Reply-To: <20140809035646.GA23604@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 08, 2014 at 11:56:46PM -0400, Theodore Ts'o wrote:
> Interesting results!
> 
> I noticed that the 1TB SSD did seem to suffer when you went from
> multi-threaded to single-threaded.  Was this a SATA-attached or
> USB-attached SSD?  And any insights about why the SSD seemed to
> require threading for better performance when using readaead?

PCIE, and it might simply be having issues. :/

One thing I haven't looked into is how exactly the kernel maps IO
requests to queue slots -- does each CPU get its own pile of slots to
use up?  I _think_ it does, but it's been a few months since I poked
at mq.  Hmm... max_sectors_kb=128, which isn't unusually odd.  Guess
I'll keep digging.

The other disks seems fairly normal, at least.

--D
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
