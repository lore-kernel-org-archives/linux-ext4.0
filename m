From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] ext4: add EXT4_IOC_ALLOC_DA_BLKS ioctl
Date: Tue, 24 Feb 2009 08:14:08 -0500
Message-ID: <20090224131408.GA1362@mit.edu>
References: <1235451952-2726-1-git-send-email-tytso@mit.edu> <1235451952-2726-2-git-send-email-tytso@mit.edu> <1235451952-2726-3-git-send-email-tytso@mit.edu> <1235451952-2726-4-git-send-email-tytso@mit.edu> <1235451952-2726-5-git-send-email-tytso@mit.edu> <20090224093832.GB25657@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44963 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbZBXNOR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 08:14:17 -0500
Content-Disposition: inline
In-Reply-To: <20090224093832.GB25657@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 24, 2009 at 03:08:32PM +0530, Aneesh Kumar K.V wrote:
> 
> I guess we need a  matching
> 	mnt_drop_write();
> 

Oops.  Nice catch, thanks.  I'll fixed it up in the ext4 patch queue.

       	    	   	    	       	     - Ted
