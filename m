From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: add checks of block references for non-extent
	inodes
Date: Fri, 27 Mar 2009 21:10:54 -0400
Message-ID: <20090328011054.GA2155@mit.edu>
References: <49B94396.2020800@ph.tum.de> <49C3A51C.1030201@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:41569 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838AbZC1BK6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Mar 2009 21:10:58 -0400
Content-Disposition: inline
In-Reply-To: <49C3A51C.1030201@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 20, 2009 at 03:15:56PM +0100, Thiemo Nagel wrote:
> Dear Ted,
>
> I'm sending an improved patch as I've come to the conclusion that the  
> previous patch is too lenient in two ways:
> * off-by-one in the check of the upper block limit
> * it shouldn't stop when encountering a reference to block number zero  
> because, if I'm not mistaken, references behind it still might be  
> accessed in sparse files / when seeking behind the end of a file.

Note: this patch has a rather fatal flaw; it doens't check to make
sure that file is a regular file or directory first.  If you have a
fast symlink, ext4_iget() will blow up since it's a non-extent file,
but the i_blocks[] will contain an ASCII string.

I'll fix up your patch to deal add the appropriate checking.

          	    	       	       	   - Ted
