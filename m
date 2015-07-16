From: Jan Kara <jack@suse.com>
Subject: [PATCH 0/4 v2] Remove ext3 filesystem driver
Date: Thu, 16 Jul 2015 11:53:02 +0200
Message-ID: <1437040386-31148-1-git-send-email-jack@suse.com>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>, Ted Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  here is the second iteration of my patches to remove ext3 filesystem driver.
Changes since the first version are:
* Regenerated the patch removing ext3 (using git format-patch -D) so that it's
  not so huge
* Added Kconfig option handling so that old configs with EXT3_FS set but not
  EXT4_FS set still result in a kernel supporting ext3 filesystem
* Created a patch updating ext4 Kconfig entry to assure users their old ext3
  filesystems stay on-disk format compatible
* Added acks

If there won't be further objections, I will queue the series in my tree for
the next merge window.

								Honza
