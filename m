From: Theodore Tso <tytso@mit.edu>
Subject: Re: which tree should I generate the ext4 patch ?
Date: Wed, 23 May 2007 08:17:24 -0400
Message-ID: <20070523121723.GC5608@thunk.org>
References: <1179910843.4119.33.camel@coly-t43.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: coly <colyli@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56544 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760160AbXEWMRn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 May 2007 08:17:43 -0400
Content-Disposition: inline
In-Reply-To: <1179910843.4119.33.camel@coly-t43.site>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 23, 2007 at 05:00:43PM +0800, coly wrote:
> 
> These days, I am tring to post my patch for inode reservation on
> linux-ext4. But I am confused on which tree I should generate the patch.
> 
> I worked on mm-tree. But now Thoedore creates a tree for ext4, so should
> I generate the patch based on tso-tree ?

The mm-tree is fed from the ext4 patch series, so there shouldn't be
much difference.

> Same question to e2fsprogs. I guess maybe I should generate the patch
> for e2fsprogs based on e2fsprogs-TEST branch, a.k.a 1.40-WIP-0407. Isn't
> it ?

Yes, or if you want to use the very latest, you can use the Mercurial
repository located at:

	http://thunk.org/hg/e2fsprogs

I will be switch to git at some point in the near future, probably
after the e2fsprogs 1.40 release, but for now that's the place to get
the very latest.  

In practice, it's not hard to rebase patches, but patches against the
more recent versions are definitely appreciated.  So if you're not
familiar with using Mercurial, please feel free to use the
1.40-WIP-0407 as the base for your patches.  

Regards, 

					- Ted
