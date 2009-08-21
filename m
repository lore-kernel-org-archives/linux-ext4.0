From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC -V2 4/4] ext4: Avoid group preallocation for
	closed files
Date: Thu, 20 Aug 2009 22:45:45 -0400
Message-ID: <20090821024545.GA9529@mit.edu>
References: <1249874635-24250-1-git-send-email-tytso@mit.edu> <1249874635-24250-5-git-send-email-tytso@mit.edu> <20090820064035.GB23232@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@sun.com>,
	Alex Tomas <bzzz@sun.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:54910 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbZHUCpq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Aug 2009 22:45:46 -0400
Content-Disposition: inline
In-Reply-To: <20090820064035.GB23232@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 20, 2009 at 12:10:35PM +0530, Aneesh Kumar K.V wrote:
> > +	if ((size == isize) &&
> 
> What is this check supposed to help us ?. This would also imply we
> disable prealloc only if we are allocating the last chunk in the
> file.

That was the idea, yes; the idea was to disable preallocation if the
file is small enough that it could be written in a single call to
ext4_da_writepages, or if we are allocating/writing the last chunk in
a file.  Otherwise, preallocation would be a good thing.

> shouldn't it be !ext4_fs_is_busy(sbi) ?. Can you also write function
> documentation for ext4_fs_is_busy. I found in confusing that you are
> decrementing s_lock_busy if we are going to spin on spin_lock.

Um, oops.  Yeah, good point.  It should be !ext4_fs_is_busy().  I also
have the logic backwards in ext4_lock_group as well, so the two errors
mostly cancel each other out.  I'll fix that in the patch.

       	      	   	       	    	- Ted
