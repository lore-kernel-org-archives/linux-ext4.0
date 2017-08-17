From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4] ext4: reduce lock contention in __ext4_new_inode
Date: Thu, 17 Aug 2017 11:21:53 +0200
Message-ID: <20170817092153.GA14074@quack2.suse.cz>
References: <20170808050517.7160-1-wshilong@ddn.com>
 <20170816164211.GA31117@quack2.suse.cz>
 <3ED34739A4E85E4F894367D57617CDEFEDA401CE@LAX-EX-MB2.datadirect.datadirectnet.com>
 <20170817091959.GB7644@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="lrZ03NoBR/3+SXJZ"
Cc: Jan Kara <jack@suse.cz>, Wang Shilong <wangshilong1991@gmail.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "adilger@dilger.ca" <adilger@dilger.ca>,
        Shuichi Ihara <sihara@ddn.com>, Li Xi <lixi@ddn.com>
To: Wang Shilong <wshilong@ddn.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37860 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751616AbdHQJV4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 17 Aug 2017 05:21:56 -0400
Content-Disposition: inline
In-Reply-To: <20170817091959.GB7644@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 17-08-17 11:19:59, Jan Kara wrote:
> Hi Shilong!
> 
> On Thu 17-08-17 06:23:26, Wang Shilong wrote:
> >      thanks for good suggestion, just one question we could not hold lock
> > with nojounal mode, how about something attached one?
> > 
> > please let me know if you have better taste for it, much appreciated!
> 
> Thanks for quickly updating the patch! Is the only reason why you cannot
> hold the lock in the nojournal mode that sb_getblk() might sleep? The
> attached patch should fix that so that you don't have to special-case the
> nojournal mode anymore.

Forgot to attach the patch - here it is. Feel free to include it in your
series as a preparatory patch.

								Honza

> > ________________________________________
> > From: Jan Kara [jack@suse.cz]
> > Sent: Thursday, August 17, 2017 0:42
> > To: Wang Shilong
> > Cc: linux-ext4@vger.kernel.org; tytso@mit.edu; Wang Shilong; adilger@dilger.ca; Shuichi Ihara; Li Xi
> > Subject: Re: [PATCH v4] ext4: reduce lock contention in __ext4_new_inode
> > 
> > On Tue 08-08-17 13:05:17, Wang Shilong wrote:
> > > From: Wang Shilong <wshilong@ddn.com>
> > >
> > > While running number of creating file threads concurrently,
> > > we found heavy lock contention on group spinlock:
> > >
> > > FUNC                           TOTAL_TIME(us)       COUNT        AVG(us)
> > > ext4_create                    1707443399           1440000      1185.72
> > > _raw_spin_lock                 1317641501           180899929    7.28
> > > jbd2__journal_start            287821030            1453950      197.96
> > > jbd2_journal_get_write_access  33441470             73077185     0.46
> > > ext4_add_nondir                29435963             1440000      20.44
> > > ext4_add_entry                 26015166             1440049      18.07
> > > ext4_dx_add_entry              25729337             1432814      17.96
> > > ext4_mark_inode_dirty          12302433             5774407      2.13
> > >
> > > most of cpu time blames to _raw_spin_lock, here is some testing
> > > numbers with/without patch.
> > >
> > > Test environment:
> > > Server : SuperMicro Sever (2 x E5-2690 v3@2.60GHz, 128GB 2133MHz
> > >          DDR4 Memory, 8GbFC)
> > > Storage : 2 x RAID1 (DDN SFA7700X, 4 x Toshiba PX02SMU020 200GB
> > >           Read Intensive SSD)
> > >
> > > format command:
> > >         mkfs.ext4 -J size=4096
> > >
> > > test command:
> > >         mpirun -np 48 mdtest -n 30000 -d /ext4/mdtest.out -F -C \
> > >                 -r -i 1 -v -p 10 -u #first run to load inode
> > >
> > >         mpirun -np 48 mdtest -n 30000 -d /ext4/mdtest.out -F -C \
> > >                 -r -i 5 -v -p 10 -u
> > >
> > > Kernel version: 4.13.0-rc3
> > >
> > > Test  1,440,000 files with 48 directories by 48 processes:
> > >
> > > Without patch:
> > >
> > > File Creation   File removal
> > > 79,033          289,569 ops/per second
> > > 81,463          285,359
> > > 79,875          288,475
> > > 79,917          284,624
> > > 79,420          290,91
> > >
> > > with patch:
> > > File Creation   File removal
> > > 691,528               296,574 ops/per second
> > > 691,946               297,106
> > > 692,030               296,238
> > > 691,005               299,249
> > > 692,871               300,664
> > >
> > > Creation performance is improved more than 8X with large
> > > journal size. The main problem here is we test bitmap
> > > and do some check and journal operations which could be
> > > slept, then we test and set with lock hold, this could
> > > be racy, and make 'inode' steal by other process.
> > >
> > > However, after first try, we could confirm handle has
> > > been started and inode bitmap journaled too, then
> > > we could find and set bit with lock hold directly, this
> > > will mostly gurateee success with second try.
> > >
> > > This patch dosen't change logic if it comes to
> > > no journal mode, luckily this is not normal
> > > use cases i believe.
> > >
> > > Tested-by: Shuichi Ihara <sihara@ddn.com>
> > > Signed-off-by: Wang Shilong <wshilong@ddn.com>
> > 
> > The results look great and the code looks correct however I dislike the
> > somewhat complex codeflow with your hold_lock variable. So how about
> > cleaning up the code as follows:
> > 
> > Create function like
> > 
> > unsigned long find_inode_bit(struct super_block *sb, ext4_group_t group,
> >                 struct buffer_head *bitmap, unsigned long start_ino)
> > {
> >         unsigned long ino;
> > 
> > next:
> >         ino = ext4_find_next_zero_bit(...);
> >         if (ino >= EXT4_INODES_PER_GROUP(sb))
> >                 return 0;
> >         if (group == 0 && (ino+1) < EXT4_FIRST_INO(sb)) {
> >                 ...
> >                 return 0;
> >         }
> >         if ((EXT4_SB(sb)->s_journal == NULL) &&
> >                     recently_deleted(sb, group, ino)) {
> >                 start_ino = ino + 1;
> >                 if (start_ino < EXT4_INODES_PER_GROUP(sb))
> >                         goto next;
> >         }
> >         return ino;
> > }
> > 
> > Then you can use this function from __ext4_new_inode() when looking for
> > free ino and also in case test_and_set_bit() fails you could just do:
> > 
> > ext4_lock_group(sb, group);
> > ret2 = ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data);
> > if (ret2) {
> >         /* Someone already took the bit. Repeat the search with lock held.*/
> >         ino = find_inode_bit(sb, group, inode_bitmap_bh, ino);
> >         if (ino) {
> >                 ret2 = ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data);
> >                 WARN_ON_ONCE(!ret2);
> >         }
> > }
> > ext4_unlock_group(sb, group);
> > 
> > And that's it, no strange bool variables and conditional locking. And as a
> > bonus it also works for nojournal mode in the same way.
> > 
> >                                                                 Honza
> > 
> > > ---
> > > v3->v4: codes cleanup and avoid sleep.
> > > ---
> > >  fs/ext4/ialloc.c | 30 +++++++++++++++++++++++++++++-
> > >  1 file changed, 29 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> > > index 507bfb3..23380f39 100644
> > > --- a/fs/ext4/ialloc.c
> > > +++ b/fs/ext4/ialloc.c
> > > @@ -761,6 +761,7 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
> > >       ext4_group_t flex_group;
> > >       struct ext4_group_info *grp;
> > >       int encrypt = 0;
> > > +     bool hold_lock;
> > >
> > >       /* Cannot create files in a deleted directory */
> > >       if (!dir || !dir->i_nlink)
> > > @@ -917,17 +918,40 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
> > >                       continue;
> > >               }
> > >
> > > +             hold_lock = false;
> > >  repeat_in_this_group:
> > > +             /* if @hold_lock is ture, that means, journal
> > > +              * is properly setup and inode bitmap buffer has
> > > +              * been journaled already, we can directly hold
> > > +              * lock and set bit if found, this will mostly
> > > +              * gurantee forward progress for each thread.
> > > +              */
> > > +             if (hold_lock)
> > > +                     ext4_lock_group(sb, group);
> > > +
> > >               ino = ext4_find_next_zero_bit((unsigned long *)
> > >                                             inode_bitmap_bh->b_data,
> > >                                             EXT4_INODES_PER_GROUP(sb), ino);
> > > -             if (ino >= EXT4_INODES_PER_GROUP(sb))
> > > +             if (ino >= EXT4_INODES_PER_GROUP(sb)) {
> > > +                     if (hold_lock)
> > > +                             ext4_unlock_group(sb, group);
> > >                       goto next_group;
> > > +             }
> > >               if (group == 0 && (ino+1) < EXT4_FIRST_INO(sb)) {
> > > +                     if (hold_lock)
> > > +                             ext4_unlock_group(sb, group);
> > >                       ext4_error(sb, "reserved inode found cleared - "
> > >                                  "inode=%lu", ino + 1);
> > >                       continue;
> > >               }
> > > +
> > > +             if (hold_lock) {
> > > +                     ext4_set_bit(ino, inode_bitmap_bh->b_data);
> > > +                     ext4_unlock_group(sb, group);
> > > +                     ino++;
> > > +                     goto got;
> > > +             }
> > > +
> > >               if ((EXT4_SB(sb)->s_journal == NULL) &&
> > >                   recently_deleted(sb, group, ino)) {
> > >                       ino++;
> > > @@ -950,6 +974,10 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
> > >                       ext4_std_error(sb, err);
> > >                       goto out;
> > >               }
> > > +
> > > +             if (EXT4_SB(sb)->s_journal)
> > > +                     hold_lock = true;
> > > +
> > >               ext4_lock_group(sb, group);
> > >               ret2 = ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data);
> > >               ext4_unlock_group(sb, group);
> > > --
> > > 2.9.3
> > >
> > --
> > Jan Kara <jack@suse.com>
> > SUSE Labs, CR
> 
> 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--lrZ03NoBR/3+SXJZ
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Do-not-unnecessarily-allocate-buffer-in-recentl.patch"

>From c9e9550fe6e2a7e498c1a8b709b570f4c5ed8e2b Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 17 Aug 2017 11:07:10 +0200
Subject: [PATCH] ext4: Do not unnecessarily allocate buffer in
 recently_deleted()

In recently_deleted() function we want to check whether inode is still
cached in buffer cache. Use sb_find_get_block() for that instead of
sb_getblk() to avoid unnecessary allocation of bdev page and buffer
heads.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ialloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 507bfb3344d4..0d03e73dccaf 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -707,9 +707,9 @@ static int recently_deleted(struct super_block *sb, ext4_group_t group, int ino)
 	if (unlikely(!gdp))
 		return 0;
 
-	bh = sb_getblk(sb, ext4_inode_table(sb, gdp) +
+	bh = sb_find_get_block(sb, ext4_inode_table(sb, gdp) +
 		       (ino / inodes_per_block));
-	if (unlikely(!bh) || !buffer_uptodate(bh))
+	if (!bh || !buffer_uptodate(bh))
 		/*
 		 * If the block is not in the buffer cache, then it
 		 * must have been written out.
-- 
2.12.3


--lrZ03NoBR/3+SXJZ--
