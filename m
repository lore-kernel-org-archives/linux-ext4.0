From: Theodore Tso <tytso@mit.edu>
Subject: Re: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Fri, 6 Oct 2006 08:21:05 -0400
Message-ID: <20061006122105.GA21816@thunk.org>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com> <20061005205526.7fe744f5.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Kleikamp <shaggy@austin.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:32448 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1751080AbWJFMVO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Oct 2006 08:21:14 -0400
To: Andrew Morton <akpm@osdl.org>
Content-Disposition: inline
In-Reply-To: <20061005205526.7fe744f5.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 05, 2006 at 08:55:26PM -0700, Andrew Morton wrote:
> On Thu, 05 Oct 2006 13:23:30 -0500
> Dave Kleikamp <shaggy@austin.ibm.com> wrote:
> 
> > I have rebuilt the ext4/jbd2 patches against linux-2.6.19-rc1.  The
> > patch set is located at
> > ftp://kernel.org/pub/linux/kernel/people/shaggy/ext4/2.6.19-rc1/ext4-patches-2.6.19-rc1.tar.gz
> > 
> 
> So let me see if I have this right.
> 
> You grab Alexandre's kit from http://www.bullopensource.org/ext4/20060926/
> and a plain old `mke2fs -j' gives a filesystem which will mount as ext3 or
> ext4.
> 
> If you then mount this filesystem with `-t ext4dev -o extents', it becomes
> incompatible with the ext3 driver.  Yes?

I agree that's the wrong behaviour, and I've always hated the idea of
using using mount -o options to enable ext3/4 features.  (When do it
with EA's and acl's, sigh, and that's wrong too, but at least I was
able to paper over that later by adding default mount option support
into the superblock.)

The right way to do this is to only enable a feature like extents
after using tune2fs -O extents, or creating a filesystem with mke2fs
-O extents.

Can we change the patches to do this, please?

						- Ted
