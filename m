From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/7] Fix fallout from changes to FUA and PREFLUSH
	definitions
Date: Tue,  2 May 2017 17:03:44 +0200
Message-ID: <20170502150351.29452-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: cluster-devel@redhat.com, Theodore Ts'o <tytso@mit.edu>,
	Mike Snitzer <snitzer@redhat.com>, linux-raid@vger.kernel.org,
	reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, Shaohua Li <shli@kernel.org>,
	Steven Whitehouse <swhiteho@redhat.com>, linux-btrfs@vger.kernel.org
To: <linux-fsdevel@vger.kernel.org>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

Hello,

this series addresses a performance issue caused by commit b685d3d65ac7 "block:
treat REQ_FUA and REQ_PREFLUSH as synchronous". We know for certain this
problem significanly regresses (over 10%, in some cases up to 100%) ext4 and
btrfs for dbench4 and reaim benchmarks.  Based on this I have fixed up also
other places which suffer from the same problem however those changes are
untested so maintainers please have a look whether the change makes sense to
you and also whether I possibly didn't miss some cases where REQ_SYNC should be
also added. Patches in this series are completely independent so if maintainers
agree with the change, feel free to take it through your tree.

The core of the problem is that above mentioned commit removed REQ_SYNC flag
from WRITE_{FUA|PREFLUSH|...} definitions.  generic_make_request_checks()
however strips REQ_FUA and REQ_PREFLUSH flags from a bio when the storage
doesn't report volatile write cache and thus write effectively becomes
asynchronous which can lead to performance regressions.

A side note for ext4: The two patches for ext4 & jbd2 are on top of the change
that got merged in the ext4 tree already.

								Honza

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
