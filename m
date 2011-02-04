From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: make grpinfo slab cache names static
Date: Fri, 4 Feb 2011 00:17:28 -0500
Message-ID: <20110204051728.GC2623@thunk.org>
References: <4D374CB9.6050508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44662 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728Ab1BDFRd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Feb 2011 00:17:33 -0500
Content-Disposition: inline
In-Reply-To: <4D374CB9.6050508@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, added to the ext4 patch queue.

-- Ted


On Wed, Jan 19, 2011 at 02:42:33PM -0600, Eric Sandeen wrote:
> In 2.6.37 I was running into oopses with repeated module
> loads & unloads.  I tracked this down to:
> 
> fb1813f4 ext4: use dedicated slab caches for group_info structures
> 
> (this was in addition to the features advert unload problem)
> 
> The kstrdup & subsequent kfree of the cache name was causing
> a double free.  In slub, at least, if I read it right it allocates
> & frees the name itself, slab seems to do something different...
> so in slub I think we were leaking -our- cachep->name, and double
> freeing the one allocated by slub.
> 
> After getting lost in slab/slub/slob a bit, I just looked at other
> sized-caches that get allocated.  jbd2, biovec, sgpool all do it
> more or less the way jbd2 does.  Below patch follows the jbd2
> method of dynamically allocating a cache at mount time from
> a list of static names.
> 
> (This might also possibly fix a race creating the caches with
> parallel mounts running).
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
