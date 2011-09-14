From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: add new test: tst_inode_size
Date: Wed, 14 Sep 2011 18:15:59 -0400
Message-ID: <20110914221559.GB15782@thunk.org>
References: <1316020593-19050-1-git-send-email-tytso@mit.edu>
 <0E958708-A440-43C9-B69F-4E677AB82580@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56798 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab1INWQB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Sep 2011 18:16:01 -0400
Content-Disposition: inline
In-Reply-To: <0E958708-A440-43C9-B69F-4E677AB82580@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 14, 2011 at 02:47:08PM -0600, Andreas Dilger wrote:
> One thing I noticed with this check_field() macro is that it doesn't
> actually detect the case if the size of a field is changed.  This hit
> me when I was making a cleanup to the large journal patch which renamed
> s_jnl_blocks[15] to s_jnl_size_lo and s_jnl_blocks[16] to s_jnl_size_hi
> for clarity.  The tst_super_size test passed just fine, but the e2fsck
> test scripts failed in weird and wonderful ways.
> 
> A better solution might be to explicitly pass the expected field size
> instead of getting both the size and offset from the structure itself.
> Since these structures change very rarely it isn't much maintenance,
> but it would be lousy if code was released that had some incorrect
> field offset because someone increased or decreased an earlier field
> without thinking enough, and those fields weren't used in normal tests.
> 
> I can submit a patch if you are interested.

Good point.  Yes, I agree it would be worth while to do this.

     	     	    	     	      - Ted
