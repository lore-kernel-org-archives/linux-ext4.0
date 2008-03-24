From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: e2fsprogs and fast symlink
Date: Mon, 24 Mar 2008 08:36:41 -0400
Message-ID: <20080324123641.GH24943@mit.edu>
References: <20080321114234.GB6542@skywalker> <alpine.DEB.1.00.0803241323350.4451@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61882 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757363AbYCXMhM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Mar 2008 08:37:12 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0803241323350.4451@sheep.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 24, 2008 at 01:25:33PM +0100, Christian Kujau wrote:
> Aneesh, can you elaborate a bit for me (a user, not a developer) what this 
> means? I too had these "Fast symlink 12 has EXTENT_FL set.  Clear<y>?" 
> messages on my ext4 fs and I went on to "Clear" these things. Now I notice 
> some serious performance (or better: load) problems when doing stuff on 
> ext4 and I'm not sure if this could be related to the changes e2fsprogs 
> did.

It should make no difference.  The bug which Aneesh was pointing out
was that e2fsck was complaining about long symlinks in ext4 which got
deleted, and which thus got mistaken for fast symlinks with the
EXTENTS_FL flag set, even though said inodes were already deleted.

So this should not make any difference in terms of ext4 performance;
just noise in terms of needlessly annoying someone running e2fsck.

     	      	       		  	   	   - Ted
