From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: restart ext4_ext_remove_space() after transaction restart V2
Date: Wed, 26 May 2010 18:23:55 +0400
Message-ID: <87k4qqlp1g.fsf@openvz.org>
References: <1271910671-16627-1-git-send-email-dmonakhov@openvz.org>
	<20100525133241.GF5556@thunk.org> <87632ckqcy.fsf@openvz.org>
	<20100525214447.GA14530@thunk.org> <87hblvqb6c.fsf@openvz.org>
	<87pr0ilw3n.fsf_-_@openvz.org> <20100526132352.GA29528@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz,
	aneesh.kumar@linux.vnet.ibm.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:7296 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab0EZOX7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 May 2010 10:23:59 -0400
Received: by fg-out-1718.google.com with SMTP id e12so836577fga.1
        for <linux-ext4@vger.kernel.org>; Wed, 26 May 2010 07:23:58 -0700 (PDT)
In-Reply-To: <20100526132352.GA29528@thunk.org> (tytso@mit.edu's message of
	"Wed, 26 May 2010 09:23:52 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu writes:

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
This is the biggest myth about truncate. Personally i always use to
thought like this. But later i've found that it is not so. See later.
> (It only clears STATE_EXT_TRUNC if it is set and if the flags
> EXT4_GET_BLOCKS_CREATE is set.  I'm not sure what the point of that
> is, either.)
This is the core idea of the patch.

*Truncate* task set the bit to signal that truncate is under progress for
inode.

Later if we face a needs to restart transaction which result in
i_data_sem indernal drop/acquire.
And when the sem was dropped new block may be allocated by a
flusher task (delay allocation writeback in the middle of the file)

*Flusher* will discover than STATE_EXT_TRUNC is set and clear it
is allocation is really necessary(EXT4_GET_BLOCKS_CREATE is set)
By clearing STATE_EXT_TRUNC bit flusher let truncate task to know
what it have to restart it's job. 

*Back to truncate task*. We can may sure what allocation not happens by
testing STATE_EXT_TRUNC bit. And it it was cleared we have to
restart truncate from very beginning because all data we have collected
may not longer be valid, even depth of the file may increase.

For example if we about to truncate inode with following leaf block
{ee_block:1000, ee_len:100}
So if block allocation happens while we are restarting transaction
leaf block may looks like follows:
{ee_block:500, ee_len:10} {ee_block:1000, ee_len:10} 
See that latest extent has changed it's position.
This was not an issue for ext3 because it's blocks placed in deterministic
positions.
