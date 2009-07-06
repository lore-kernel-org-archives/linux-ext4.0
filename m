From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Fix goal inum check
Date: Sun, 5 Jul 2009 23:47:05 -0400
Message-ID: <20090706034705.GA11907@mit.edu>
References: <20090623111521.GA27273@lore>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45552 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbZGFDrC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jul 2009 23:47:02 -0400
Content-Disposition: inline
In-Reply-To: <20090623111521.GA27273@lore>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 23, 2009 at 01:15:21PM +0200, Johann Lombardi wrote:
> The goal inode is specificed by inode number which belongs
> to [1; s_inodes_count].
> 
> Signed-off-by: Johann Lombardi <johann@sun.com>

Thanks, added to the ext4 patch queue.

					- Ted
