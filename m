From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Remove "extents" mount option
Date: Wed, 7 Jan 2009 09:45:02 -0500
Message-ID: <20090107144502.GC17110@mit.edu>
References: <1231267777-18831-1-git-send-email-tytso@mit.edu> <20090107053250.GA9617@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47038 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbZAGOpE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Jan 2009 09:45:04 -0500
Content-Disposition: inline
In-Reply-To: <20090107053250.GA9617@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 07, 2009 at 11:02:50AM +0530, Aneesh Kumar K.V wrote:
> On Tue, Jan 06, 2009 at 01:49:37PM -0500, Theodore Ts'o wrote:
> > This mount option is largely superfluous, and in fact the way it was
> > implemented was buggy; if a filesystem which did not have the extents
> > feature flag was mounted -o extents, the filesystem would attempt to
> > create and use extents-based file even though the extents feature flag
> > was not eabled.  The simplest thing to do is to nuke the mount option
> > entirely.  It's not all that useful to force the non-creation of new
> > extent-based files if the filesystem can support it.
> > 
> 
> Ext4 -> Ext3 migration story is to mount the filesystem with -o
> noextents and copy the file around. If we remove the -o noextents
> options how do we force the creation of non extent format files ?

1) How much do we care about ext4->ext3 migration?  

2) That only deals with extent-based files; it doesn't deal with any
of the other ext4-specific features.

What's the scenario you're thinking about here?  When would it be
useful for users to be able to downgrade extent-based files to
indirect block files by copying files around?

						- Ted
