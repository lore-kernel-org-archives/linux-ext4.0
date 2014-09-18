From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] jbd2: Simplify calling convention around
 __jbd2_journal_clean_checkpoint_list
Date: Thu, 18 Sep 2014 01:02:09 -0400
Message-ID: <20140918050209.GF24887@thunk.org>
References: <1410946290-5128-1-git-send-email-jack@suse.cz>
 <1410946290-5128-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35080 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbaIRFCM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Sep 2014 01:02:12 -0400
Content-Disposition: inline
In-Reply-To: <1410946290-5128-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 17, 2014 at 11:31:30AM +0200, Jan Kara wrote:
> __jbd2_journal_clean_checkpoint_list() returns number of buffers it
> freed but noone was using the value so just stop doing that. This
> also allows for simplifying the calling convention for
> journal_clean_once_cp_list().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
