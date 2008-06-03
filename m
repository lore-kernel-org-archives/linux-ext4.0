From: Theodore Tso <tytso@mit.edu>
Subject: Re: What's in e2fsprogs.git (stable)
Date: Mon, 2 Jun 2008 22:39:55 -0400
Message-ID: <20080603023955.GK23119@mit.edu>
References: <20080219050347.GT25098@mit.edu> <20080229142830.GB8968@mit.edu> <20080313180503.GC31653@mit.edu> <20080320202243.GO13719@mit.edu> <20080402000626.GB302@mit.edu> <20080407165505.GD11997@mit.edu> <20080418183935.GA25797@mit.edu> <20080421162726.GF9700@mit.edu> <20080428025302.GC30840@mit.edu> <20080524234904.GC5970@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:37806 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752787AbYFCCkM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 22:40:12 -0400
Content-Disposition: inline
In-Reply-To: <20080524234904.GC5970@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* The 'maint' branch has these fixes since the last announcement.

Benno Schulenberg (1):
  po: update es.po (from translationproject.org)

Ricardo M. Correia (1):
  Add ZFS detection to libblkid

Theodore Ts'o (2):
  debian: Improve e2fsprogs package description
  debian: Improve uuid-runtime package description


* The 'master' branch has these since the last announcement
  in addition to the above.

Theodore Ts'o (5):
  Remove bashism in test script for libblkid
  e2fsck: Don't skip an extent after deleting an invalid extent
  e2fsck: Don't double count an extent after deleting the last extent
  ext2fs_extent_replace: Support uninit extents and check validity of
      e_len
  ext2fs_extent_open: If the inode is empty, initialize the extent
      tree

------
URL's for the e2fsprogs repository:
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
