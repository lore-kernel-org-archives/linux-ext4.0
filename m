From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [e2fsprogs] Bug in salvage_directory
Date: Tue, 10 Jul 2007 12:17:32 +0530
Message-ID: <1184050052.4440.2.camel@garfield>
References: <1183973522.3889.10.camel@garfield.linsyssoft.com>
	 <20070709165016.GA21922@thunk.org> <1184003549.4347.6.camel@garfield>
	 <20070709230234.GE2343@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:57785 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbXGJGqm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jul 2007 02:46:42 -0400
In-Reply-To: <20070709230234.GE2343@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-07-09 at 19:02 -0400, Theodore Tso wrote:
> On Mon, Jul 09, 2007 at 11:22:05PM +0530, Kalpak Shah wrote:
> > Yes even prev->rec_len cannot be beyond fs->blocksize. I do have the
> > corrupt filesystem image but it is a large one. 
> > 
> > This patch certainly works well and corrects the problem in a single run
> > of e2fsck.
> 
> When you say "this patch", I assume you meant the patch I wrote as
> opposed to the one you submitted, right? 

Yes, I meant the patch you wrote. 

Thanks,
Kalpak.

>  In any case, I've created a
> test case (attached) which is fixed in a single run of e2fsck, but
> which your patch requires two runs to fix. 
> 
> So I will be committing my patch into the tree.
> 
> Regards,
> 
> 							- Ted
> 
> 
> 				
