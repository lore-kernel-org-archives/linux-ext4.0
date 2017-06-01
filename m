From: Jan Kara <jack@suse.cz>
Subject: [PATCH 00/35 v1] pagevec API cleanups
Date: Thu,  1 Jun 2017 11:32:10 +0200
Message-ID: <20170601093245.29238-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, tytso@mit.edu,
	linux-xfs@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>,
	Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>,
	Hugh Dickins <hughd@google.com>, linux-f2fs-devel@lists.sourceforge.net,
	David Howells <dhowells@redhat.com>,
	David Sterba <dsterba@suse.com>, ceph-devel@vger.kernel.org,
	Nadia Yvette Chambers <nyc@holomorphy.com>,
	Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
	Bob Peterson <rpeterso@redhat.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>, linux-ext4@vger.kernel.org,
	linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org
To: <linux-mm@kvack.org>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

Hello,

This series cleans up pagevec API. The original motivation for the series is
the patch "fs: Fix performance regression in clean_bdev_aliases()" however it
has somewhat grown beyond that... The series is pretty large but most of the
patches are trivial in nature. What the series does is:

* Make all pagevec_lookup_ and find_get_ functions update index to where the
  search terminated. Currently tagged page lookup did update the index, other
  variants did not...

* Implement ranged variants for pagevec_lookup and find_get_ functions. Lot
  of callers actually want a ranged lookup and we unnecessarily opencode this
  in lot of them.

* Remove nr_pages argument from pagevec_ API since after implementing ranged
  lookups everyone just wants to pass PAGEVEC_SIZE there.

The conversion of the APIs for entries variants is not such a clear win as
for the other cases as callers tend to play more complex games with indices
etc. (hello THP). I still think the conversion is worth it for consistency
but I'm open to ideas (including just discarding that part) there.

The series also contains several fixes in the beginning to the bugs that I've
found during these cleanups. I've included them to have a clean base (4.12-rc3)
but those should get merged independently (e.g. ext4 fixes are already sitting
in ext4 tree). Also it is possible to split the series in smaller parts (like
convert one API at a time) however I wanted to post the full series so that
people can get the full picture.

The series can be also obtained from my git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git find_get_pages_range

Opinions and review welcome!

								Honza

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
