From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Update s_free_{inodes,blocks}_count during
 online resize
Date: Tue, 20 Mar 2012 15:54:42 -0400
Message-ID: <20120320195442.GA23266@thunk.org>
References: <20120306194020.GI15164@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54424 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087Ab2CTTyq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Mar 2012 15:54:46 -0400
Content-Disposition: inline
In-Reply-To: <20120306194020.GI15164@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 06, 2012 at 11:40:20AM -0800, Darrick J. Wong wrote:
> When we're doing an online resize of an ext4 filesystem, we need to update the
> free inode and block counts in the superblock so that fsck doesn't complain.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Thanks, applied.

					- Ted
