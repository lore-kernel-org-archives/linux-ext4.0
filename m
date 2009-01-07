From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Remove "extents" mount option
Date: Wed, 7 Jan 2009 21:30:46 +0530
Message-ID: <20090107160046.GC9617@skywalker>
References: <1231267777-18831-1-git-send-email-tytso@mit.edu> <20090107053250.GA9617@skywalker> <20090107144502.GC17110@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:45942 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZAGQA6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Jan 2009 11:00:58 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id n07FxJkx018254
	for <linux-ext4@vger.kernel.org>; Thu, 8 Jan 2009 02:59:19 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n07G0ueM247294
	for <linux-ext4@vger.kernel.org>; Thu, 8 Jan 2009 03:00:56 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n07G0uvY019168
	for <linux-ext4@vger.kernel.org>; Thu, 8 Jan 2009 03:00:56 +1100
Content-Disposition: inline
In-Reply-To: <20090107144502.GC17110@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 07, 2009 at 09:45:02AM -0500, Theodore Tso wrote:
> On Wed, Jan 07, 2009 at 11:02:50AM +0530, Aneesh Kumar K.V wrote:
> > On Tue, Jan 06, 2009 at 01:49:37PM -0500, Theodore Ts'o wrote:
> > > This mount option is largely superfluous, and in fact the way it was
> > > implemented was buggy; if a filesystem which did not have the extents
> > > feature flag was mounted -o extents, the filesystem would attempt to
> > > create and use extents-based file even though the extents feature flag
> > > was not eabled.  The simplest thing to do is to nuke the mount option
> > > entirely.  It's not all that useful to force the non-creation of new
> > > extent-based files if the filesystem can support it.
> > > 
> > 
> > Ext4 -> Ext3 migration story is to mount the filesystem with -o
> > noextents and copy the file around. If we remove the -o noextents
> > options how do we force the creation of non extent format files ?
> 
> 1) How much do we care about ext4->ext3 migration?  
> 
> 2) That only deals with extent-based files; it doesn't deal with any
> of the other ext4-specific features.
> 
> What's the scenario you're thinking about here?  When would it be
> useful for users to be able to downgrade extent-based files to
> indirect block files by copying files around?
> 

The user migrate from ext3 to ext4 and later wants to move back. So
with ext3 to ext4 migration  he use tune2fs to enable the extent
feature. Now later he wants to move back to ext3. The only way is mount
the filesystem with -o noextents and copy the new files created in
extent format back. Then mount it using ext3.

-aneesh
