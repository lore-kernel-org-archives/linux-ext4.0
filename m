From: Jan Kara <jack@suse.com>
Subject: [PATCH 0/3] Remove ext3 filesystem driver
Date: Wed, 15 Jul 2015 12:26:24 +0200
Message-ID: <1436955987-7305-1-git-send-email-jack@suse.com>
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

  so I have created this patch set which removes ext3 driver (and some related support
code) from the kernel. See changelog of patch 2/3 for more details. If noone objects,
I will queue the series in my tree for the next merge window.

Jens, are you OK with me merging patch 3/3 or do you want me to send it to you once
the first two patches get merged?

Ted, this also touches ext4 driver so that it always handles ext3 filesystems so ack
from you would be nice.

									Honza
