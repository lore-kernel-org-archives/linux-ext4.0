From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/5] ext4: ext4_rename should dirty dir_bh with the
 correct directory
Date: Tue, 25 Oct 2011 09:08:30 -0400
Message-ID: <20111025130829.GH31921@thunk.org>
References: <20111021211759.10784.17257.stgit@elm3c44.beaverton.ibm.com>
 <20111021211806.10784.76743.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38463 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933213Ab1JYNIk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Oct 2011 09:08:40 -0400
Content-Disposition: inline
In-Reply-To: <20111021211806.10784.76743.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 21, 2011 at 02:18:06PM -0700, Darrick J. Wong wrote:
> When ext4_rename performs a directory rename (move), dir_bh is a buffer that is
> modified to update the '..' link in the directory being moved (old_inode).
> However, ext4_handle_dirty_metadata is called with the old parent directory
> inode (old_dir) and dir_bh, which is incorrect because dir_bh does not belong
> to the parent inode.  Fix this error.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

This was already merged (git commit: bcaa9929750 in the master branch).

     	 	 	     	     		 - Ted
