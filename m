From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5] ext4: Fix setting of referenced bit in
 ext4_es_lookup_extent()
Date: Wed, 9 Mar 2016 22:45:44 -0500
Message-ID: <20160310034544.GA4937@thunk.org>
References: <1457000631-10215-1-git-send-email-jack@suse.cz>
 <1457000631-10215-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54498 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091AbcCJDps (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Mar 2016 22:45:48 -0500
Content-Disposition: inline
In-Reply-To: <1457000631-10215-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 03, 2016 at 11:23:47AM +0100, Jan Kara wrote:
> We were setting referenced bit on the extent structure we return from
> ext4_es_lookup_extent() which is just a private structure on stack. Thus
> setting had no effect. Set the bit in the structure in the status tree
> instead.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
