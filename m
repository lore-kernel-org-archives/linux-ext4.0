From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/5] ext4: Factor out determining of hole size
Date: Wed, 9 Mar 2016 22:54:30 -0500
Message-ID: <20160310035430.GB4937@thunk.org>
References: <1457000631-10215-1-git-send-email-jack@suse.cz>
 <1457000631-10215-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54528 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965262AbcCJDyc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Mar 2016 22:54:32 -0500
Content-Disposition: inline
In-Reply-To: <1457000631-10215-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 03, 2016 at 11:23:48AM +0100, Jan Kara wrote:
> ext4_ext_put_gap_in_cache() determines hole size in the extent tree,
> then trims this with possible delayed allocated blocks, and inserts the
> result into the extent status tree. Factor out determination of the size
> of the hole in the extent tree as we will need this information in
> ext4_ext_map_blocks() as well.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

							- Ted
