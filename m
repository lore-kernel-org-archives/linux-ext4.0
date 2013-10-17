From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Fixup kerndoc annotation of
 mpage_map_and_submit_extent()
Date: Wed, 16 Oct 2013 23:31:58 -0400
Message-ID: <20131017033158.GB11932@thunk.org>
References: <1381843949-31805-1-git-send-email-jack@suse.cz>
 <1381843949-31805-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47079 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761822Ab3JQDcA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Oct 2013 23:32:00 -0400
Content-Disposition: inline
In-Reply-To: <1381843949-31805-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 15, 2013 at 03:32:29PM +0200, Jan Kara wrote:
> Document give_up_on_write argument of mpage_map_and_submit_extent().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
