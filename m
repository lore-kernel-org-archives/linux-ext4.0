From: Jan Kara <jack@suse.cz>
Subject: Checks in ext4_ext_fiemap_cb() broken
Date: Mon, 25 Jul 2011 17:58:36 +0200
Message-ID: <20110725155836.GF6107@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
	tytso@mit.edu
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab1GYP6i (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jul 2011 11:58:38 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

  I just had a look at the code checking delayed allocated buffers in
ext4_ext_fiemap_cb(). I believe the checks there could use some elimiation
of common patterns but that's just a minor thing. The main problem is that
the code can easily crash the kernel when it races with page reclaim. You
just cannot access most of the page contents (and for buffers it is
especially true) without locking the page. Getting a reference via
find_get_pages_tag() guarantees you the structure cannot go away but mm is
still free to detach the page from the mapping at any moment. So you must
always lock a page and check that it still belongs to the desired mapping
before you check 'page_has_buffers()'.

								Honza
--
Jan Kara <jack@suse.cz>
SUSE Labs, CR
