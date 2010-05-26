From: tytso@mit.edu
Subject: Re: [PATCH] ext4: restart ext4_ext_remove_space() after
 transaction restart V2
Date: Wed, 26 May 2010 09:23:52 -0400
Message-ID: <20100526132352.GA29528@thunk.org>
References: <1271910671-16627-1-git-send-email-dmonakhov@openvz.org>
 <20100525133241.GF5556@thunk.org>
 <87632ckqcy.fsf@openvz.org>
 <20100525214447.GA14530@thunk.org>
 <87hblvqb6c.fsf@openvz.org>
 <87pr0ilw3n.fsf_-_@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz,
	aneesh.kumar@linux.vnet.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34286 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab0EZNX6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 May 2010 09:23:58 -0400
Content-Disposition: inline
In-Reply-To: <87pr0ilw3n.fsf_-_@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

One more thing.  Why do you need EXT4_STATE_EXT_TRUNC?

The only place which tests it in any kind of real way is
ext4_ext_truncate_extend_restart(), and it is only called by one
function, ext4_ext_rm_leaf(), and *it* is only called in one place,
inside ext4_ext_remove_space(), and *it* surronds the call with
ext4_set_inode_state(inode, EXT4_STATE_EXT_TRUNC) and
ext4_clear_inode_state(inode, EXT4_STATE_EXT_TRUNC).

And while a truncate is happening, no other block allocation can
happen, so the test in ext4_ext_map_blocks() doesn't seem to do much.
(It only clears STATE_EXT_TRUNC if it is set and if the flags
EXT4_GET_BLOCKS_CREATE is set.  I'm not sure what the point of that
is, either.)

					- Ted
