From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/2] vfs: call file_ioctl call for directories.
Date: Sat, 2 May 2009 19:06:38 -0400
Message-ID: <20090502230638.GA12368@mit.edu>
References: <1239806343-14219-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39818 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbZEBXGw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 May 2009 19:06:52 -0400
Content-Disposition: inline
In-Reply-To: <1239806343-14219-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 15, 2009 at 08:09:02PM +0530, Aneesh Kumar K.V wrote:
> Most of the ioctl callback in file_ioctl should be done even
> for directories. For ext4 fiemap should work even for directories.
> Similarly FIGETBSZ  should work for directories. For bmap filefrag command
> doesn't do the ioctl if the type is not a regular file.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Thanks, I've pulled this into the ext4 patch queue.

	     	    	      	       	     - Ted
