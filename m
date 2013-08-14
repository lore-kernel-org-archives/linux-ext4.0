From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2 v2] Fix O_SYNC AIO DIO
Date: Wed, 14 Aug 2013 11:10:54 +0200
Message-ID: <1376471456-11966-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  this is second iteration of patches to fix handling of O_SYNC AIO DIO.
Since previous version I've addressed Dave's comments:
 - slightly expanded changelog of the first patch
 - workqueue is now created with parameters allowing paralelism
 - workqueue name contains sb->s_id
 - workqueue is created on demand (I decided to do this to reduce the overhead
   in unnecessary cases)

The patchset survives xfstests run for ext4 & xfs so it should be sane. Since
this touches several filesystems (although only ext4 & xfs are non-trivial),
the question is who should carry these patches. Maybe Al? But since xfs and
ext4 changes are non-trivial, I'd like to have a review from their
developers...

								Honza
