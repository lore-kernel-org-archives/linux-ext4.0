From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/5] ext4: ext4_mkdir should dirty dir_block with the
 parent inode
Date: Tue, 25 Oct 2011 09:09:24 -0400
Message-ID: <20111025130924.GI31921@thunk.org>
References: <20111021211759.10784.17257.stgit@elm3c44.beaverton.ibm.com>
 <20111021211812.10784.27324.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38467 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933213Ab1JYNJ2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Oct 2011 09:09:28 -0400
Content-Disposition: inline
In-Reply-To: <20111021211812.10784.27324.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 21, 2011 at 02:18:12PM -0700, Darrick J. Wong wrote:
> ext4_mkdir calls ext4_handle_dirty_metadata with dir_block and the inode "dir".
> Unfortunately, dir_block belongs to the newly created directory (which is
> "inode"), not the parent directory (which is "dir").  Fix the incorrect
> association.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

This is already checked in (git commit: f9287c1f2d3 in the master branch).

     			   		- Ted
