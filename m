From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] Add largedir feature
Date: Sat, 24 Jun 2017 01:43:56 -0400
Message-ID: <20170624054356.43nui7l6o27dphrr@thunk.org>
References: <A4690934-D680-4735-AEA6-8BF995990546@dilger.ca>
 <1494094761-19108-1-git-send-email-artem.blagodarenko@seagate.com>
 <19F5F19B-23F5-466A-B934-EB15896E1B15@dilger.ca>
 <20170622011142.gu5qdyqsmuox7v4f@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>,
        Eric Biggers <ebiggers3@gmail.com>,
        Yang Sheng <yang.sheng@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39000 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750805AbdFXFoE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 24 Jun 2017 01:44:04 -0400
Content-Disposition: inline
In-Reply-To: <20170622011142.gu5qdyqsmuox7v4f@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It looks like there are at least two xfstests failures if the largedir
feature is enabled.  generic/021 fails, but I think this may be a test
issue because it seems to be a mke2fs complaining about not having
enough space to create the file system.

generic/027, which is an ENOSPC hitter, is failing with largedir
enabled, but apparently it hasn't been failing w/o this feature being
enabled.  The test description is "Run 8 processes writing 1k files to
seperate files in seperate dirs to hit ENOSPC on small fs with little
free space. Loop for 100 iterations."

This was using the following configuration:

export EXT_MKFS_OPTIONS="-I 2048 -O ^64bit,mmp,uninit_bg,^extents,large_dir,dir_nlink,quota,huge_file,flex_bg -E lazy_journal_init"

						- Ted
