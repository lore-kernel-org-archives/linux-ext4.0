From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: powerpc e2fsprogs and fast symlink
Date: Thu, 20 Mar 2008 08:50:28 -0400
Message-ID: <20080320125028.GX3158@mit.edu>
References: <20080319193801.GA16687@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59078 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753970AbYCTMvZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Mar 2008 08:51:25 -0400
Content-Disposition: inline
In-Reply-To: <20080319193801.GA16687@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 20, 2008 at 01:08:01AM +0530, Aneesh Kumar K.V wrote:
> Hi Ted,
> 
> While testing on powerpc i found that e2fsck is getting confused about
> fast symlink on powerpc. On x86_64 it works fine.

What version of e2fsprogs are you testing?  Are you using 1.40.8, or
the git 'next' (or 'master') branch?  I was missing a byte-swap patch
in 1.40.8; it is in the git tree at this point.

   	      	    	    	    	 - Ted
