From: pg_jf2@jf2.for.sabi.co.UK (Peter Grandi)
Subject: Re: benchmark results
Date: Thu, 24 Dec 2009 13:05:39 +0000
Message-ID: <19251.26403.762180.228181@tree.ty.sabi.co.uk>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, ext-users <ext3-users@redhat.com>,
	linu
Return-path: <jfs-discussion-bounces@lists.sourceforge.net>
In-Reply-To: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=jfs-discussion>
List-Post: <mailto:jfs-discussion@lists.sourceforge.net>
List-Help: <mailto:jfs-discussion-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=subscribe>
Errors-To: jfs-discussion-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

> I've had the chance to use a testsystem here and couldn't
> resist

Unfortunately there seems to be an overproduction of rather
meaningless file system "benchmarks"...

> running a few benchmark programs on them: bonnie++, tiobench,
> dbench and a few generic ones (cp/rm/tar/etc...) on ext{234},
> btrfs, jfs, ufs, xfs, zfs. All with standard mkfs/mount options
> and +noatime for all of them.

> Here are the results, no graphs - sorry: [ ... ]

After having a glance, I suspect that your tests could be
enormously improved, and doing so would reduce the pointlessness of
the results.

A couple of hints:

* In the "generic" test the 'tar' test bandwidth is exactly the
  same ("276.68 MB/s") for nearly all filesystems.

* There are read transfer rates higher than the one reported by
  'hdparm' which is "66.23 MB/sec" (comically enough *all* the
  read transfer rates your "benchmarks" report are higher).

BTW the use of Bonnie++ is also usually a symptom of a poor
misunderstanding of file system benchmarking.

On the plus side, test setup context is provided in the "env"
directory, which is rare enough to be commendable.

> Short summary, AFAICT:
>     - btrfs, ext4 are the overall winners
>     - xfs to, but creating/deleting many files was *very* slow

Maybe, and these conclusions are sort of plausible (but I prefer
JFS and XFS for different reasons); however they are not supported
by your results as they seem to me to lack much meaning, as what is
being measured is far from clear, and in particular it does not
seem to be the file system performance, or anyhow an aspect of
filesystem performance that might relate to common usage.

I think that it is rather better to run a few simple operations
(like the "generic" test) properly (unlike the "generic" test), to
give a feel for how well implemented are the basic operations of
the file system design.

Profiling a file system performance with a meaningful full scale
benchmark is a rather difficult task requiring great intellectual
fortitude and lots of time.

>     - if you need only fast but no cool features or
>       journaling, ext2 is still a good choice :)

That is however a generally valid conclusion, but with a very,
very important qualification: for freshly loaded filesystems.
Also with several other important qualifications, but "freshly
loaded" is a pet peeve of mine :-).

------------------------------------------------------------------------------
This SF.Net email is sponsored by the Verizon Developer Community
Take advantage of Verizon's best-in-class app development support
A streamlined, 14 day to market process makes app distribution fast and easy
Join now and get one step closer to millions of Verizon customers
http://p.sf.net/sfu/verizon-dev2dev 
