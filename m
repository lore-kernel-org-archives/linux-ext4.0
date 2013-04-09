From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Improve credit estimate for
 EXT4_SINGLEDATA_TRANS_BLOCKS
Date: Tue, 9 Apr 2013 12:42:25 -0400
Message-ID: <20130409164225.GB5980@thunk.org>
References: <1365496448-9907-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60678 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936277Ab3DIQm2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Apr 2013 12:42:28 -0400
Content-Disposition: inline
In-Reply-To: <1365496448-9907-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 09, 2013 at 10:34:07AM +0200, Jan Kara wrote:
> Estimate of 27 credits for allocation of a block in extent based inode
> is unnecessarily high. We can easily argue 20 is enough.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, added to the dev branch for testing.

	      	     	 	    - Ted
