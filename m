From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] sparc: Export needed symbol for ZERO_PAGE usage in
	modules.
Date: Mon, 24 Mar 2008 17:08:39 -0400
Message-ID: <20080324210839.GF18661@mit.edu>
References: <1206381777-12671-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080324.133445.229184630.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: aneesh.kumar@linux.vnet.ibm.com, cmm@us.ibm.com,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59208 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752321AbYCXVJj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Mar 2008 17:09:39 -0400
Content-Disposition: inline
In-Reply-To: <20080324.133445.229184630.davem@davemloft.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 24, 2008 at 01:34:45PM -0700, David Miller wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> Date: Mon, 24 Mar 2008 23:32:57 +0530
> 
> > ext4 use ZERO_PAGE(0) to zero out blocks. We need to export
> > different symbols in different arch for the usage of ZERO_PAGE
> > in modules.
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> Merge this in with the necessary ext4 changes, and no
> sooner.

This is something we plan to merge in the next 2.6.26 merge window,
which is presumably soon.  Stephen Rothwell picked this up as a
problem on the linux-next tree, when he tried to build ext4 as a
module on the Power architecture, and it's a problem on sparc as well.
We could merge this in the ext4-tree, but Andrew tends to get cranky
when we put patches which affect code outside of ext4 in the ext4
patchset.

We're happy to carry the patch in the ext4 tree, with an Acked-by with
you, and push it to Linus ourselves, if that's OK with everyone.  Or
we can push it to each individual architecture tree, which is what I
thought was considered the preferred practice.

Regards,

     	      	    	  	     	       - Ted
