Return-Path: <SRS0=0UAC=MJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42550 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727015AbeI0SXk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 27 Sep 2018 14:23:40 -0400
Date: Thu, 27 Sep 2018 14:05:40 +0200
From: Jan Kara <jack@suse.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-ext4@vger.kernel.org
Subject: [GIT PULL] ext2 DAX fix
Message-ID: <20180927120540.GD16469@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Greg,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_v4.19-rc6

to get an ext2 patch fixing fsync(2) for DAX mounts.

Top of the tree is ee4af50ca94f. The full shortlog is:

Toshi Kani (1):
      ext2, dax: set ext2_dax_aops for dax files

The diffstat is

 fs/ext2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
