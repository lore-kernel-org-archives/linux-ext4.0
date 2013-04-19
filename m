From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: mext_insert_extents should update extent block checksum
Date: Fri, 19 Apr 2013 14:20:22 -0400
Message-ID: <20130419182022.GC20513@thunk.org>
References: <20130419055012.GB5617@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42957 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab3DSSUj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Apr 2013 14:20:39 -0400
Content-Disposition: inline
In-Reply-To: <20130419055012.GB5617@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 18, 2013 at 10:50:12PM -0700, Darrick J. Wong wrote:
> When we alter any part of the extent tree that is not part of the inode during
> on online defrag, we must update the extent header's checksum before dirtying
> the block.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
