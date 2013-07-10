From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] Fix O_SYNC AIO DIO
Date: Thu, 11 Jul 2013 00:01:27 +0200
Message-ID: <1373493689-2168-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com, hch@lst.de,
	Jeff Moyer <jmoyer@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  so now that necessary patches for ext4 writeback code are merged, I've ported
Christoph's patches to fix handling of O_SYNC AIO DIO to current kernel. The
patchset survives xfstests run for ext4 & xfs so it should be sane. Since this
touches several filesystems (although only ext4 & xfs are non-trivial), the
question is who should carry these patches. Maybe Al? But since xfs and ext4
changes are non-trivial, I'd like to have a review from their developers...

								Honza
