From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/29] ext4: Use io_end for multiple bios
Date: Thu, 11 Apr 2013 23:55:43 -0400
Message-ID: <20130412035543.GD4865@thunk.org>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33714 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab3DLDzp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Apr 2013 23:55:45 -0400
Content-Disposition: inline
In-Reply-To: <1365456754-29373-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 08, 2013 at 11:32:07PM +0200, Jan Kara wrote:
> Change writeback path to create just one io_end structure for the extent
> to which we submit IO and share it among bios writing that extent. This
> prevents needless splitting and joining of unwritten extents when they
> cannot be submitted as a single bio.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied to the ext4 patch queue for testing.

		       	    	  	- Ted
