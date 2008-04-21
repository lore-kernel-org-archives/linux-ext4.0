From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: What's in e2fsprogs.git (stable)
Date: Mon, 21 Apr 2008 12:27:26 -0400
Message-ID: <20080421162726.GF9700@mit.edu>
References: <20071217171135.GB7070@thunk.org> <20080101180128.GB23047@mit.edu> <20080211044108.GA25089@mit.edu> <20080219050347.GT25098@mit.edu> <20080229142830.GB8968@mit.edu> <20080313180503.GC31653@mit.edu> <20080320202243.GO13719@mit.edu> <20080402000626.GB302@mit.edu> <20080407165505.GD11997@mit.edu> <20080418183935.GA25797@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65000 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755028AbYDUToQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2008 15:44:16 -0400
Content-Disposition: inline
In-Reply-To: <20080418183935.GA25797@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* The 'master' branch has these since the last announcement
  in addition to the above.

Eric Sandeen (5):
  print a bit more info for the tst_extents info command
  Fix ext2fs_extent_insert when at last extent in node
  Make extent_goto() deterministic when logical block not found
  e2fsck: Only check PR_1_EXTENT_ENDS_BEYOND for leaf nodes
  blkid: more sanity checks for swap v1

Theodore Ts'o (5):
  Add support for the HUGE_FILE feature
  Fix tst_extents build when building w/o dynamic libraries
  Rename the feature uninit_groups to uninit_bg
  Change the primary name of the extents feature to be 'extent'
  mke2fs: Disentangle lazy_bg from uninit_bg's lazy inode table
      initialization

----
URL's for the e2fsprogs repository:
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
