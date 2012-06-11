From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] e2fsck/tests: Add the regression test case for
 e2fsck.
Date: Mon, 11 Jun 2012 01:07:29 -0400
Message-ID: <20120611050729.GA12379@thunk.org>
References: <1337238967-4704-1-git-send-email-tm@tao.ma>
 <1337238967-4704-3-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48987 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab2FKFHa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jun 2012 01:07:30 -0400
Content-Disposition: inline
In-Reply-To: <1337238967-4704-3-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 17, 2012 at 03:16:07PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In commit "e2fsck: Let end_blk to be the maximum value of u32."
> we fix a bug where a normal fallocate will cause e2fsck complain.
> So add it to the regression test suite.
> 
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

I've changed the description of this commit to reflect the change in
how I propose to fix the problem....

					- Ted

commit 8d12c46a22965179cae1e3b47778fdee5efeb513
Author: Tao Ma <boyu.mt@taobao.com>
Date:   Sun Jun 10 23:56:30 2012 -0400

    tests: add new test f_zero_extent_length
    
    If all of the extents in the last extent tree block (ETB) in a
    non-trivial extent tree contain uninitialized extents which are after
    the end of the file as defined by i_size, the hueristics will
    incorrectly estimate the last entry (and hence the node's e_len field)
    in the last entry of each level of the extent tree.
    
    As Tao Ma has noted, since e2fsck was requiring that the length
    (e_len) field of interior nodes be non-zero, this was causing false
    failures where e2fsck would declare that the extent tree was
    corrupted.
    
    This was fixed in commit 9c40d14841: "e2fsck: only check for
    zero-length leaf extents".  Add a regression test case to ensure that
    this issue remains fixed.
    
    Signed-off-by: Tao Ma <boyu.mt@taobao.com>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>
