From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: add checks of block references for non-extent
	inodes
Date: Tue, 31 Mar 2009 08:37:55 -0400
Message-ID: <20090331123755.GE13356@mit.edu>
References: <49B94396.2020800@ph.tum.de> <49C3A51C.1030201@ph.tum.de> <49D1D737.9080105@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	sfr@canb.auug.org.au,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-next@vger.kernel.org
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47927 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbZCaMiG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Mar 2009 08:38:06 -0400
Content-Disposition: inline
In-Reply-To: <49D1D737.9080105@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 31, 2009 at 10:41:27AM +0200, Thiemo Nagel wrote:
> Dear Ted, Aneesh, Stephen,
>
> thanks a lot for your comments and fixes!  The attached patch (applied  
> on-top) should fix the
> * buffer head leak spotted by Aneesh
> * warning reported by Stephen
>
> Kind regards,

Thanks, I've merged this into your patch in the ext4 patch queue.

	     	    	      	   	    - Ted
