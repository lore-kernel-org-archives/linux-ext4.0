From: Jan Kara <jack@suse.cz>
Subject: Possible bug with extent status tree
Date: Mon, 11 Mar 2013 21:38:34 +0100
Message-ID: <20130311203834.GA22229@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738Ab3CKUig (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Mar 2013 16:38:36 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

  while looking into the ext4 code I spotted one thing which I think is a
bug introduced by extent status tree code. The problem is that
ext4_map_blocks() checks extent status tree and if the extent is found, it
doesn't call into ext4_ext_map_blocks(). However ext4_ext_direct_IO() expects
that if the extent DIO is done to is unwritten, EXT4_IO_END_UNWRITTEN flag
gets set in the io_end (or inode) flags and that happens only in
ext4_ext_map_blocks().

The easiest fix seems to be to move setting of flags from
ext4_ext_map_blocks() up into ext4_map_blocks() (or maybe even
_ext4_get_block()). What do you think?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
