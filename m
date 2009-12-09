From: tytso@mit.edu
Subject: Re: [PATCH 2/4] ext4: fix reserved space transferring on chown()
 [V2]
Date: Tue, 8 Dec 2009 20:42:59 -0500
Message-ID: <20091209014259.GV27692@thunk.org>
References: <1259132261-16785-1-git-send-email-dmonakhov@openvz.org>
 <1259132261-16785-2-git-send-email-dmonakhov@openvz.org>
 <20091207171835.GB16078@skywalker.linux.vnet.ibm.com>
 <87ocmalgh0.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60656 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbZLIBm5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Dec 2009 20:42:57 -0500
Content-Disposition: inline
In-Reply-To: <87ocmalgh0.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 07, 2009 at 10:41:15PM +0300, Dmitry Monakhov wrote:
> Absolutely right. I've fixed an issue, but overlooked the BIGGEST one.
> So off course my patch is wrong, even if we will acquire lock in
> different order " dqptr_sem > i_block_reservation_lock"
> we sill getting in to sleeping  spin lock problems by following scenario:
> ext4_da_update_reserve_space()
> ->dquot_claim_space()
> ASSUMES that we hold i_block_reservation_lock here.
> -->mark_dquot_dirty()
> --->ext4_write_dquot()
>     if (journalled quota) ext4_write_dquot();
> ---->dquot_commit()
> ----->mutex_lock(&dqopt->dqio_mutt's); <<< sleep here.
> 
> This means that we have fully redesign quota reservation locking. 
> As i already suggested previously here:
> http://thread.gmane.org/gmane.comp.file-systems.ext4/16576/focus=16587 

Given this, should I include this patch for now, given that it does
fix _one_ race, or should I hold off until you redo the locking?  How
long do you think to send a revised/new patch?

     	    	     	    		- Ted
