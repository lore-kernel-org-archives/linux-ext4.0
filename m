From: Julia Lawall <julia@diku.dk>
Subject: question about ext4/inode.c
Date: Mon, 2 Nov 2009 17:10:46 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0911021708550.2115@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:50876 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336AbZKBQKn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Nov 2009 11:10:43 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The function ext4_da_writepages_trans_blocks contains the following code:

        if (!(inode->i_flags & EXT4_EXTENTS_FL) &&
            (max_blocks > EXT4_MAX_TRANS_DATA))
                max_blocks = EXT4_MAX_TRANS_DATA;


Elsewhere the constant EXT4_EXTENTS_FL is used as follows:

EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL

Should that be done in ext4_da_writepages_trans_blocks as well?

thanks,
julia
