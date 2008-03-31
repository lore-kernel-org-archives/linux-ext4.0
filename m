From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH, E2FSPROGS] ext2fs_set_gdt_csum(): Clean up superblock
	dirty flag handling
Date: Mon, 31 Mar 2008 19:47:58 -0400
Message-ID: <20080331234758.GC11828@mit.edu>
References: <20080325084039.GA10804@webber.adilger.int> <1207006592-13980-1-git-send-email-tytso@mit.edu> <1207006592-13980-2-git-send-email-tytso@mit.edu> <1207006592-13980-3-git-send-email-tytso@mit.edu> <1207006592-13980-4-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64437 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415AbYCaXsx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2008 19:48:53 -0400
Content-Disposition: inline
In-Reply-To: <1207006592-13980-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There were three different changes all bundled in the
lib/ext2fs/csum.c patches.  I separated them out so it was easier to
understand what was going on.

							- Ted
