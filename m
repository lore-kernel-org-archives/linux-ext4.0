From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] e2fsprogs: enable user namespace xattrs by default
Date: Wed, 16 Feb 2011 16:49:10 -0500
Message-ID: <20110216214910.GB26780@thunk.org>
References: <4D5C1380.2020602@redhat.com>
 <4D5C15C6.5000802@redhat.com>
 <C637E27A-6E13-4950-B4CC-0451FDB421B9@dilger.ca>
 <4D5C252B.2010102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34621 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab1BPVtO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Feb 2011 16:49:14 -0500
Content-Disposition: inline
In-Reply-To: <4D5C252B.2010102@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 16, 2011 at 01:27:39PM -0600, Eric Sandeen wrote:
> On 2/16/11 1:15 PM, Andreas Dilger wrote:
> > On 2011-02-16, at 11:21, Eric Sandeen wrote:
> >> User namespace xattrs are generally useful, and I think extN
> >> is the only filesystem requiring a special mount option to
> >> enable them, when xattrs are otherwise available.  So this
> >> change sets that mount option into the defaults.
> >>
> > 
> > Wouldn't it be more useful to change this in the kernel, instead of only changing it in the superblock for new filesystems?
> > 
> 
> I thought about that; maybe it should happen in both places?

Yes, agreed.  Maybe we should do the same thing with posix ACL's as
well?  ACL's can only take away access as compared to the unix
permission bits, so it's safe to enable ACL's.

	   	    	      	 	- Ted


