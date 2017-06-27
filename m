From: Christoph Hellwig <hch@lst.de>
Subject: lseek SEEK_HOLE / SEEK_DATA fixes and switch to iomap V3-hch
Date: Tue, 27 Jun 2017 14:48:22 -0700
Message-ID: <20170627214828.1029-1-hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Here is my take on all the current seek work.  It has my XFS quota changes
(unmodified from last post), Andrea's page cache seek helper (unmodified
except that the export is dropped), and Andreas iomap SEEK_HOLE / DATA,
for which I've added a couple of cleanups and converted ext4 as well.

I've made sure both xfs and ext4 pass all the xfstests.
