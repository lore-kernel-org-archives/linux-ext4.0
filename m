From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: handle errors in ext4_clear_blocks()
Date: Sun, 20 Mar 2011 21:32:13 -0400
Message-ID: <20110321013213.GD4135@thunk.org>
References: <AANLkTi=zteq96AQ54f3qo29dRGCmMhwtR4BzKPXQLt0W@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60574 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab1CUBcQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Mar 2011 21:32:16 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTi=zteq96AQ54f3qo29dRGCmMhwtR4BzKPXQLt0W@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 01, 2011 at 02:28:26PM +0200, Amir Goldstein wrote:
> Checking return code from ext4_journal_get_write_access() is important
> with snapshots, because this function invokes COW, so may return new
> errors, such as ENOSPC.
> 
> ext4_clear_blocks() now returns < 0 for fatal errors, in which case,
> ext4_free_data() is aborted.

I'll apply this patch because it's not wrong, but I don't think it's
enough.  Just aborting ext4_free_data() is going to get you into
beaucoup trouble, since that happens inside ext4_truncate().  Aborting
ext4_free_data without even returning an error code is going to leave
the file system corrupted.  But aborting the truncate code (this is
only in the non-extent-mapped inode case) is going to get _awfully_
messy.

I suspect you may need to estimate how many blocks you need, and check
to make sure you can COW that many blocks, and reserve them so the you
don't have to deal with a failure in the middle of an ext4_truncate()
operation.  This is not going to be pretty....

	    	    	      	    - Ted
