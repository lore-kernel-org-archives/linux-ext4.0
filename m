From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/11] ext4: Convert ext4 DAX IO to iomap framework
Date: Tue,  1 Nov 2016 22:06:10 +0100
Message-ID: <1478034381-19037-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
        linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>,
        Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

this patch set converts ext4 DAX IO paths to the new iomap framework and
removes the old bh-based DAX functions. As a result ext4 gains PMD page
fault support, also some other minor bugs get fixed. The patch set is based
on Ross' DAX PMD page fault support series [1]. It passes xfstests both in
DAX and non-DAX mode.

The question is how shall we merge this. If Dave is pulling PMD patches through
XFS tree, then these patches could go there as well (chances for conflicts
with other ext4 stuff are relatively low) or Dave could just export a stable
branch with PMD series which Ted would just pull...

								Honza

[1] http://www.spinics.net/lists/linux-mm/msg115247.html
