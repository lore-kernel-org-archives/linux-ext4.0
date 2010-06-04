From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] Update ctime when changing the file's permission by setfacl
Date: Fri,  4 Jun 2010 17:07:51 +0200
Message-ID: <1275664075-4703-1-git-send-email-jack@suse.cz>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499Ab0FDPIZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Jun 2010 11:08:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  I went through filesystems in fs/ supporting acl's and checked which could
have the same issue as ext3. In the end I've ended up with just these four
patches. I'll take care of merging the ext2-bit and I'm sending it just for
completeness / review. The other patches should probably go through respective
maintainers...

									Honza

