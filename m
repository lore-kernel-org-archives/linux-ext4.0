From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: ext4: fix reference counting bug on block allocation error
Date: Sun, 14 Aug 2016 21:46:29 +0200
Message-ID: <20160814194629.GA28207@kroah.com>
References: <20160727052921.5B41C35574@git2.kroah.org>
 <20160814183206.GA11040@kroah.com>
 <57B0BA84.1000600@oracle.com>
 <20160814185125.GA4077@kroah.com>
 <20160814185805.GA8087@kroah.com>
 <57B0C058.9010800@oracle.com>
 <20160814190919.GA9517@kroah.com>
 <57B0C81F.9000309@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbcHNTqU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Aug 2016 15:46:20 -0400
Content-Disposition: inline
In-Reply-To: <57B0C81F.9000309@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 14, 2016 at 09:35:59PM +0200, Vegard Nossum wrote:
> On 08/14/2016 09:09 PM, Greg KH wrote:
> > On Sun, Aug 14, 2016 at 09:02:48PM +0200, Vegard Nossum wrote:
> > > The commit which is being fixed is ancient:
> > > 
> > > $ git describe 8556e8f3b6
> > > v2.6.28-5758-g8556e8f3
> > > 
> > > It's probably already in the base of every current stable tree, no?
> > 
> > Huh?  Ok, this odd:
> > 	$ git describe --contains 8556e8f3b6
> > 	fatal: cannot describe '8556e8f3b6c4c11601ce1e9ea8090a6d8bd5daae'
> > 
> > Yet just a plain 'git describe' does work...
> > 
> > That's what threw me off, I only use --contains as that shows the
> > release the commit is in.
> > 
> > Ok, that makes me feel a bit better (that my scripts didn't miss the
> > patch, it was just old), but I wonder what is going on with git...
> > 
> 
> How odd.
> 
> There is this:
> 
> http://www.spinics.net/lists/git/msg246837.html
> 
> """
> Yes, the "describe --contains" algorithm uses timestamps to cut off the
> traversal, so it can do the wrong thing if there's clock skew. It has a
> "slop" margin of one day, but skew larger than that can fool it.
> """
> 
> It looks like ancestors of 87d8fe1 don't work:
> 
> $ for commit in $(git rev-list 87d8fe1^^..87d8fe1); do git describe
> --contains $commit; done
> v2.6.29-rc1~40^2~12
> fatal: cannot describe '0087d9fb3f29f59e8d42c8b058376d80e5adde4c'
> 
> So maybe it's because the parent commit is 2 days in the future:
> 
> $ git log --format=fuller 87d8fe1^^..87d8fe1
> commit 87d8fe1ee6b8d2f95076142d58c440dba4e7bdc2
> Author:     Theodore Ts'o <tytso@mit.edu>
> AuthorDate: Sat Jan 3 09:47:09 2009 -0500
> Commit:     Theodore Ts'o <tytso@mit.edu>
> CommitDate: Sat Jan 3 09:47:09 2009 -0500
> [...]
> 
> commit 0087d9fb3f29f59e8d42c8b058376d80e5adde4c
> Author:     Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> AuthorDate: Mon Jan 5 21:49:12 2009 -0500
> Commit:     Theodore Ts'o <tytso@mit.edu>
> CommitDate: Mon Jan 5 21:49:12 2009 -0500
> [...]

Ouch, that's some clock skew.

Thanks for working this out, I've now applied the patch to the stable
trees.

greg k-h
