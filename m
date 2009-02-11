From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Ext4 tree backports for 2.6.27.13 and 2.6.28.2
Date: Wed, 11 Feb 2009 13:29:14 +0530
Message-ID: <20090211075914.GC20842@skywalker>
References: <E1LT8MN-0003Ps-Ur@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:54643 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbZBKH70 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Feb 2009 02:59:26 -0500
Content-Disposition: inline
In-Reply-To: <E1LT8MN-0003Ps-Ur@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 31, 2009 at 12:25:39AM -0500, Theodore Ts'o wrote:
> I've updated the ext4 backport branches on the ext4 git tree:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
>    http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git
> 
> The for-stable branch is branched off of 2.6.28.2, and has a candidate
> set of patches to be included in the next stable release.  The
> for-stable-2.6.27 branch is branched off of 2.6.27.13.  
> 
> I'm more confident with the 2.6.28 stable candidate than the 2.6.27
> stable candidates at the moment, but given that we just missed the
> 2.6.27.14 and 2.6.28.3 release cycles, that should give us plenty of
> time to test the patches.
> 
> 						- Ted
> 
> 
> 8556e8f3 18d5cb0 fd3bd090
>     ext4: Don't allow new groups to be added during block allocation
> 

This commit on for-stable-2.6.27 is not complete.
ac->alloc_semp is not assigned in the code.

-aneesh
