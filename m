From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: handle NULL p_ext in
 ext4_ext_next_allocated_block()
Date: Wed, 26 Oct 2011 04:38:42 -0400
Message-ID: <20111026083842.GQ31921@thunk.org>
References: <1318122074-16056-1-git-send-email-curtw@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59698 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab1JZIiq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Oct 2011 04:38:46 -0400
Content-Disposition: inline
In-Reply-To: <1318122074-16056-1-git-send-email-curtw@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 08, 2011 at 06:01:14PM -0700, Curt Wohlgemuth wrote:
> In ext4_ext_next_allocated_block(), the path[depth] might
> have a p_ext that is NULL -- see ext4_ext_binsearch().  In
> such a case, dereferencing it will crash the machine.
> 
> This patch checks for p_ext == NULL in
> ext4_ext_next_allocated_block() before dereferencinging it.
> 
> Tested using a hand-crafted an inode with eh_entries == 0 in
> an extent block, verified that running FIEMAP on it crashes
> without this patch, works fine with it.
> 
> Signed-off-by: Curt Wohlgemuth <curtw@google.com>

Thanks, applied.

					- Ted
