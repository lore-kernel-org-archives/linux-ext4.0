From: Theodore Tso <tytso@mit.edu>
Subject: Re: Rare xfsqa test failure
Date: Tue, 18 Aug 2009 17:42:18 -0400
Message-ID: <20090818214218.GK28560@mit.edu>
References: <E1MdNJu-0006uc-GX@closure.thunk.org> <20090818170705.GI5931@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56698 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbZHRVmV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Aug 2009 17:42:21 -0400
Content-Disposition: inline
In-Reply-To: <20090818170705.GI5931@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 18, 2009 at 11:07:05AM -0600, Andreas Dilger wrote:
> > EXTENTS:
> > (65-80): 60720-60735, (81-222 [uninit]): 1181574-1181715, (223-229): 1181716-118
> > 1722
> > debugfs:  
> > 
> > So it looks like there's a race which can cause ext4 to somehow miss an
> > i_size update.
> 
> Are you sure it is a failure to update i_size, or is it possibly an
> fallocate that extends the block count beyond i_size?

Look at the EXTENTS report from debugfs; blocks 81-222 are
uninitialized from an fallocate, but block 223-229 are initialized.

	      	      		     	   - Ted
