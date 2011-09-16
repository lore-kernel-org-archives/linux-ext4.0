From: Ted Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs: remove redundant last-group check after
 ext2fs_group_last_block2
Date: Fri, 16 Sep 2011 09:33:13 -0400
Message-ID: <20110916133313.GC6710@thunk.org>
References: <4E274D87.2040403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47502 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab1IPNdQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 09:33:16 -0400
Content-Disposition: inline
In-Reply-To: <4E274D87.2040403@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 20, 2011 at 11:49:59AM -0000, Eric Sandeen wrote:
> ext2fs_group_last_block2() already properly calculates
> the last block in the last group, so there is no need
> to special-case this after the call.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied with a slightly modified summary line:

   libext2fs: remove redundant last-group check in ext2fs_check_desc()

	   	  	    	       	     	- Ted
