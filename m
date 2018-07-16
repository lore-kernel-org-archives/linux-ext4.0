From: dann frazier <dann.frazier@canonical.com>
Subject: Re: [Bisect] ext4_validate_inode_bitmap:98: comm stress-ng: Corrupt
 inode bitmap
Date: Mon, 16 Jul 2018 17:13:56 -0600
Message-ID: <CALdTtntvwdL02Nn69-QQ8EwKChoVJ-3FXqfNh+po_RZji76KQQ@mail.gmail.com>
References: <20180706174324.GA3049@xps13.dannf> <20180707041018.GB3546@thunk.org>
 <20180710165143.GA20459@xps13.dannf> <20180710204329.GB20459@xps13.dannf>
 <b39169ad-2237-0a4f-e3d1-afc51ac10fa5@canonical.com> <20180712230826.GB28610@thunk.org>
 <CALdTtns1yL6z3mvWF70bXvpB0hXFgfRxdTg+sBTMzJKG7L7prA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "Theodore Ts'o" <tytso@mit.edu>, Ike Pan <ike.pan@canonical.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        yanaijie@huawei.com, Colin King <colin.king@canonical.com>,
        Kamal Mostafa <kamal.mostafa@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALdTtns1yL6z3mvWF70bXvpB0hXFgfRxdTg+sBTMzJKG7L7prA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jul 14, 2018 at 5:21 AM dann frazier <dann.frazier@canonical.com> wrote:
>
> On Thu, Jul 12, 2018 at 5:08 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
> >
> > >
> > > Review console log and on each run I have filesystem rebuild. The problem
> > > is that mke2fs I am using is 1.44.3-rc2. I am now reseting the environment
> > > and re-test.
> > >
> >
> > Could it be that you saw the error in ext4_validate_block_bitmap()?
>
> Looks like it. From Ike's report:
>
> # grep EXT4 d05-4-ipmi.log
> [ 26.215587] EXT4-fs (sdb2): mounted filesystem with ordered data
> mode. Opts: (null)
> [ 29.844105] EXT4-fs (sdb2): re-mounted. Opts: errors=remount-ro
> [ 3586.211348] EXT4-fs error (device sda2):
> ext4_validate_block_bitmap:383: comm stress-ng: bg 4705: bad block
> bitmap checksum
> [ 8254.776992] EXT4-fs error (device sda2):
> ext4_validate_block_bitmap:383: comm stress-ng: bg 4193: bad block
> bitmap checksum
>
> I've ran my test case for several days w/ just the inode bitmap fix
> and haven't been able to reproduce it - but perhaps that's just the
> nature of the chdir test.

hey Ted,

Turns out the stress-ng 'mknod' test and - less reliably - the
'dentry' test can tickle the "bad block bitmap checksum" bug pretty
easily. stress-ng wasn't *detecting* the error, but Colin has just
released a new version that does. We've been running with your updated
patch on 3 machines for several iterations, and have not seen another
occurrence.

  -dann

> > The patch which I sent Dann only fixed the problem for inode bitmaps;
> > I noticed today that we need to fix it for block allocation bitmaps as
> > well.
>
> I've also now ran several iterations w/ the block bitmap fix as well,
> and still no problems, so:
>
> Tested-by: dann frazier <dann.frazier@canonical.com>
>
> > commit 8d5a803c6a6ce4ec258e31f76059ea5153ba46ef
> > Author: Theodore Ts'o <tytso@mit.edu>
> > Date:   Thu Jul 12 19:08:05 2018 -0400
> >
> >     ext4: check for allocation block validity with block group locked
> >
> >     With commit 044e6e3d74a3: "ext4: don't update checksum of new
> >     initialized bitmaps" the buffer valid bit will get set without
> >     actually setting up the checksum for the allocation bitmap, since the
> >     checksum will get calculated once we actually allocate an inode or
> >     block.
> >
> >     If we are doing this, then we need to (re-)check the verified bit
> >     after we take the block group lock.  Otherwise, we could race with
> >     another process reading and verifying the bitmap, which would then
> >     complain about the checksum being invalid.
> >
> >     https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1780137
> >
> >     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> >     Cc: stable@kernel.org
>
> Would it also make sense to add the following?
>
> Fixes: 044e6e3d74a3 ("ext4: don't update checksum of new initialized bitmaps")
>
>   -dann
>
> > diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> > index e68cefe08261..aa52d87985aa 100644
> > --- a/fs/ext4/balloc.c
> > +++ b/fs/ext4/balloc.c
> > @@ -368,6 +368,8 @@ static int ext4_validate_block_bitmap(struct super_block *sb,
> >                 return -EFSCORRUPTED;
> >
> >         ext4_lock_group(sb, block_group);
> > +       if (buffer_verified(bh))
> > +               goto verified;
> >         if (unlikely(!ext4_block_bitmap_csum_verify(sb, block_group,
> >                         desc, bh))) {
> >                 ext4_unlock_group(sb, block_group);
> > @@ -386,6 +388,7 @@ static int ext4_validate_block_bitmap(struct super_block *sb,
> >                 return -EFSCORRUPTED;
> >         }
> >         set_buffer_verified(bh);
> > +verified:
> >         ext4_unlock_group(sb, block_group);
> >         return 0;
> >  }
> > diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> > index fb83750c1a14..e9d8e2667ab5 100644
> > --- a/fs/ext4/ialloc.c
> > +++ b/fs/ext4/ialloc.c
> > @@ -90,6 +90,8 @@ static int ext4_validate_inode_bitmap(struct super_block *sb,
> >                 return -EFSCORRUPTED;
> >
> >         ext4_lock_group(sb, block_group);
> > +       if (buffer_verified(bh))
> > +               goto verified;
> >         blk = ext4_inode_bitmap(sb, desc);
> >         if (!ext4_inode_bitmap_csum_verify(sb, block_group, desc, bh,
> >                                            EXT4_INODES_PER_GROUP(sb) / 8)) {
> > @@ -101,6 +103,7 @@ static int ext4_validate_inode_bitmap(struct super_block *sb,
> >                 return -EFSBADCRC;
> >         }
> >         set_buffer_verified(bh);
> > +verified:
> >         ext4_unlock_group(sb, block_group);
> >         return 0;
> >  }
