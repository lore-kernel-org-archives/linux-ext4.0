From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] Add extent conversion support to chattr
Date: Tue, 9 Sep 2008 10:39:15 -0400
Message-ID: <20080909143915.GG21071@mit.edu>
References: <1220951542-1451-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080909114647.GA14052@infradead.org> <20080909134347.GB21071@mit.edu> <20080909140929.GA5335@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:37596 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbYIIOmJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 10:42:09 -0400
Content-Disposition: inline
In-Reply-To: <20080909140929.GA5335@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 09, 2008 at 07:39:29PM +0530, Aneesh Kumar K.V wrote:
> 
> Shouldn't other file system give error when we call an ioctl with
> EXT4_IOC_MIGRATE on the fd ?

Only if by some incredible bad luck the ioctl number (which is after
all only at 16 bit number) doesn't happen to do something else random,
like security erase the entire filesystem.  :-)

> On ext3 I get the below error
> [an/chattr@e2fsprogs-upstream-build]$ ./misc/chattr -E ./misc/e2undo
> ./misc/chattr: Inappropriate ioctl for device while converting ./misc/e2undo to extent format
> 

#1, it really should be +e, since we are turning on the extent flag,
and #2, we should give a much more user-understandable error message
in that case.

						- Ted

