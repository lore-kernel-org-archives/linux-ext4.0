From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH, E2FSPROGS] debugfs: Add support for "set_block_group
	<bg_num> checksum calc"
Date: Mon, 31 Mar 2008 19:46:34 -0400
Message-ID: <20080331234634.GB11828@mit.edu>
References: <20080325084039.GA10804@webber.adilger.int> <1207006592-13980-1-git-send-email-tytso@mit.edu> <1207006592-13980-2-git-send-email-tytso@mit.edu> <1207006592-13980-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64130 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751571AbYCaXrA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2008 19:47:00 -0400
Content-Disposition: inline
In-Reply-To: <1207006592-13980-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch was done without un-static'ing ext2fs_group_desc_csum(),
but rather by using the already exported ext2fs_group_desc_csum_set()
function.  I also printed the calculated checksum so it would be more
clear what was going on.

					- Ted

