From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: restart ext4_ext_remove_space() after
 transaction restart V2
Date: Wed, 26 May 2010 15:46:03 +0200
Message-ID: <20100526134603.GA3494@quack.suse.cz>
References: <1271910671-16627-1-git-send-email-dmonakhov@openvz.org>
 <20100525133241.GF5556@thunk.org>
 <87632ckqcy.fsf@openvz.org>
 <20100525214447.GA14530@thunk.org>
 <87hblvqb6c.fsf@openvz.org>
 <87pr0ilw3n.fsf_-_@openvz.org>
 <20100526132352.GA29528@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org,
	jack@suse.cz, aneesh.kumar@linux.vnet.ibm.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:59511 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758000Ab0E0Px3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 May 2010 11:53:29 -0400
Content-Disposition: inline
In-Reply-To: <20100526132352.GA29528@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 26-05-10 09:23:52, tytso@mit.edu wrote:
> One more thing.  Why do you need EXT4_STATE_EXT_TRUNC?
> 
> The only place which tests it in any kind of real way is
> ext4_ext_truncate_extend_restart(), and it is only called by one
> function, ext4_ext_rm_leaf(), and *it* is only called in one place,
> inside ext4_ext_remove_space(), and *it* surronds the call with
> ext4_set_inode_state(inode, EXT4_STATE_EXT_TRUNC) and
> ext4_clear_inode_state(inode, EXT4_STATE_EXT_TRUNC).
> 
> And while a truncate is happening, no other block allocation can
> happen, so the test in ext4_ext_map_blocks() doesn't seem to do much.
  This is false. As soon as we drop i_data_sem, allocation *can* happen
from writeback path. Because truncate has already invalidated all the pages
past new_size, it must be for some page before new_size but still it could
modify an extent tree node we passed through when looking up our extent...

> (It only clears STATE_EXT_TRUNC if it is set and if the flags
> EXT4_GET_BLOCKS_CREATE is set.  I'm not sure what the point of that
> is, either.)
  I think the idea Dmitry tries to implement is:
When allocation like I describe above happens while we droppped i_data_sem,
restart the whole truncation.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
