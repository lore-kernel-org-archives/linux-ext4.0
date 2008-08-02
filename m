From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH v3]Ext4: journal credits reservation fixes for DIO,
	fallocate and delalloc writepages
Date: Fri, 1 Aug 2008 20:22:29 -0400
Message-ID: <20080802002228.GB8433@mit.edu>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker> <1216774311.6505.4.camel@mingming-laptop> <20080723074226.GA15091@skywalker> <1217032947.6394.2.camel@mingming-laptop> <1217383118.27664.14.camel@mingming-laptop> <20080801192947.GA8789@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@sun.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54950 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751208AbYHBAWe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2008 20:22:34 -0400
Content-Disposition: inline
In-Reply-To: <20080801192947.GA8789@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2008 at 03:29:47PM -0400, Theodore Tso wrote:
> I'm noticing that when I reboot, presumably either just before or just
> after remounting the filesystem read-only, I'm getting a whole series
> of
> 
> ext4_da_writepages: Not enough credits to flush N pages
> 
> .. where N is mostly 1, but occasionally will be 2.
> 
> I'm not sure why this is happening; I did run sync before rebooting,
> and I haven't noticed any files written just before the reboot getting
> corrupted, but there is something strange happening here.

I instrumented the check, and it is returning an error -30 --- EROFS.

So it's not the fault journal credits patch, but I'm a bit concerned
why ext4_da_writepages is getting called right before the system is
rebooted, and presumably after the filesystem is remounted read/only.

							- Ted
