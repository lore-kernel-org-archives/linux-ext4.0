From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/8][e2fsprogs] use existing function
	ext2fs_group_first_block()
Date: Sun, 14 Oct 2007 18:53:06 -0400
Message-ID: <20071014225306.GD9715@thunk.org>
References: <1188487715.15770.35.camel@ext1.frec.bull.fr> <1188487896.15770.39.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41121 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbXJNWxb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Oct 2007 18:53:31 -0400
Content-Disposition: inline
In-Reply-To: <1188487896.15770.39.camel@ext1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The subject line (i.e, the git one-line summary) was too generic; when
people look at the repository via gitk, "use existing function
ext2fs_group_first_block()" doesn't really give any context.  I
replaced the description with the following and I accepted it into the
git tree.

  libext2fs: use ext2fs_group_first_block() instead of open-coded equivalent
    
  Use ext2fs_group_first_block() instead of the open-coded equivalent in
  ext2fs_super_and_bgd_loc() and ext2fs_descriptor_block_loc().
    
  Signed-off-by: Valerie Clement <valerie.clement@bull.net>
  Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

							- Ted
