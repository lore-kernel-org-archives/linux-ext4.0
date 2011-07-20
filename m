From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH bigalloc] e2fsprogs: change root-inode to extent-mapped
Date: Wed, 20 Jul 2011 13:49:37 -0400
Message-ID: <20110720174937.GA17971@thunk.org>
References: <1311140311-20242-1-git-send-email-hao.bigrat@gmail.com>
 <B27D0C6A-E0F5-4196-872B-392AA72FB348@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "hao.bigrat@gmail.com" <hao.bigrat@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Robin Dong <sanbai@taobao.com>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34881 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab1GTRtl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jul 2011 13:49:41 -0400
Content-Disposition: inline
In-Reply-To: <B27D0C6A-E0F5-4196-872B-392AA72FB348@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 20, 2011 at 09:52:49AM -0600, Andreas Dilger wrote:
> 
> That reminds me of a question I had with bigalloc - are htree
> directories supported with bigalloc?  For a 1MB bigalloc chunksize
> it would mean a fanout of 256k, or a maximum directory size of 256GB
> with only a single level.

Yes, htree directories are supported with bigalloc; but it still works
on *blocks*, whereas *clusters* are just used for allocation purposes.

> 
> Any thoughts about increasing the directory size beyond 2GB?
> 

I think the best way to do that is to support more than two levels of
directories.  I seem to recall your telling me that one of your team
had prototyped something like this a while back?  Or is my memory
playing tricks on me?

							- Ted
