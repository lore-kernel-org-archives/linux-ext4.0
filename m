From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext2,ext3,ext4: don't inherit APPEND_FL or
 IMMUTABLE_FL for new inodes
Date: Thu, 22 Dec 2011 13:19:49 -0500
Message-ID: <20111222181949.GE5041@thunk.org>
References: <20110814020617.GB3524@thunk.org>
 <1313288886-32689-1-git-send-email-tytso@mit.edu>
 <4EF371AC.6000001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44208 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab1LVSTw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Dec 2011 13:19:52 -0500
Content-Disposition: inline
In-Reply-To: <4EF371AC.6000001@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 22, 2011 at 12:06:36PM -0600, Eric Sandeen wrote:
> On 8/13/11 9:28 PM, Theodore Ts'o wrote:
> > This doesn't make much sense, and it exposes a bug in the kernel where
> > attempts to create a new file in an append-only directory using
> > O_CREAT will fail (but still leave a zero-length file).  This was
> > discovered when xfstests #79 was generalized so it could run on all
> > file systems.
> 
> Curious about the status of this one; I think it makes sense to me, but
> I don't think it ever made it upstream?  I'd be willing to give it a:
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> Are there concerns about it or did it just slip through the cracks?

Yes, it's there.  It hit upstream as of v3.2-rc1.  Commit id 1cd9f097

     	  	     	 	  - Ted
