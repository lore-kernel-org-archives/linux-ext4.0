From: Theodore Tso <tytso@mit.edu>
Subject: Re: What's in e2fsprogs.git (stable)
Date: Tue, 17 Jun 2008 08:05:11 -0400
Message-ID: <20080617120511.GC12448@mit.edu>
References: <20080313180503.GC31653@mit.edu> <20080320202243.GO13719@mit.edu> <20080402000626.GB302@mit.edu> <20080407165505.GD11997@mit.edu> <20080418183935.GA25797@mit.edu> <20080421162726.GF9700@mit.edu> <20080428025302.GC30840@mit.edu> <20080524234904.GC5970@mit.edu> <20080603023955.GK23119@mit.edu> <20080608024104.GA30132@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:52491 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754907AbYFQMFM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jun 2008 08:05:12 -0400
Content-Disposition: inline
In-Reply-To: <20080608024104.GA30132@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* The 'maint' branch has these fixes since the last announcement.

David Planella Molas (1):
  po: update ca.po (from translationproject.org)


* The 'master' branch has these since the last announcement
  in addition to the above.

Iustin Pop (3):
  badblocks: add a max bad blocks count option
  badblocks: fix a possible bug in parse_uint
  badblocks: implement read throttling

Theodore Ts'o (4):
  resize2fs: Fix support for the uninit_bg feature
  ext2fs_zero_blocks: Avoid clearing more blocks than requested
  resize2fs: Prohibit the combination of flex_bg and !resize_inode
  Update version.h for 1.41-WIP-0617 snapshot release

------
URL's for the e2fsprogs repository:
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
