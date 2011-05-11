From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: The new ext4 git tree re-org
Date: Wed, 11 May 2011 21:59:06 +0300
Message-ID: <BANLkTinwmwEEDtGV6iU8HiLp7oPdHGAA9w@mail.gmail.com>
References: <E1QJnQW-0002Lg-Ls@tytso-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58957 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab1EKS7I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 May 2011 14:59:08 -0400
Received: by eyx24 with SMTP id 24so228491eyx.19
        for <linux-ext4@vger.kernel.org>; Wed, 11 May 2011 11:59:07 -0700 (PDT)
In-Reply-To: <E1QJnQW-0002Lg-Ls@tytso-glaptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 10, 2011 at 4:56 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> I've uploaded an updated dev branch to the ext4 tree. =A0Compared to =
the
> previous version of dev branch, I've removed my modified version of
> Allison's "NULL pointer when make_indexed_dir returns -ENOSPC" patch,
> and I've added Amir's alloc_semp removal patches. =A0I'm still in the
> process of reviewing those patches; I've included them to make it eas=
ier
> for I and others to test them.
>

I have a general question regarding testing for next merge window.
What kernel do you usually use when testing the dev branch?
I started writing an xfstest to test online resize and filesystem
filling in parallel, based on test 224 (Delayed allocation at ENOSPC te=
st).
I started running test 224 on a kernel built from ext4/master
and it seemed to run too slow. looking at the waiting tasks
it looked like it could be related to I/O less throttling.
Since ext4/master is based on 2.6.39-rc3, I figured maybe I am running
a buggy kernel, so I merged 2.6.39-rc7 to ext4/master to build a new ke=
rnel.

Am I going in the right direction at all?
I have a dedicated server for tests (X64_64 quad core), so it you would
like me to run some xfstest runs with specific configuration, or certai=
n
patches applied, please let me know.



> For those folks who aren't regular attendees of the weekly ext4
> conference call[1], and so would have missed the announcement, we've
> made a change in how the branchs of the ext4 tree are organized. =A0T=
he
> master branch of the ext4 tree is now non-rewinding, so it should be
> considered a stable place to do patch development, or as a starting
> point to start git branches. =A0The dev branch is backed by the ext4 =
patch
> queue, and is subject to being rewound, mainly when a patch gets yank=
ed
> because testing or further review has discovered problems. =A0Please =
feel
> free to test the dev branch, but if you use it as a base for
> development, especially using git, please be aware that the dev branc=
h
> is subject to being rewound and rebased.
>
> [1] If you want to attent the conference call, please talk to me or
> Mingming Cao.
>
> Stephen, could you change the linux-next tree so that it pulls from t=
he
> ext4.git's "dev" branch, instead of the "next" branch? =A0 Many thank=
s!!
>
> Here are some convenient URL's (use the http://.. URL for web browsin=
g,
> and the git://... URL for git pull or git clone commands):
>
> * The ext4 tree:
> =A0 =A0 =A0 =A0http://git.kernel.org/pub/scm/linux/kernel/git/tytso/e=
xt4.git
> =A0 =A0 =A0 =A0git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ex=
t4.git
>
> * The ext4 patch queue (note: new URL):
> =A0 =A0 =A0 =A0https://github.com/tytso/ext4-patch-queue/commits/mast=
er
> =A0 =A0 =A0 =A0git://github.com/tytso/ext4-patch-queue.git
>
> * The e2fsprogs git tree (note in particular the maint, next, and mas=
ter
> =A0branches):
> =A0 =A0 =A0 =A0http://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
> =A0 =A0 =A0 =A0git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
>
> The next patch series that are scheduled to land in dev are Allison's
> "punch" patches, which has made several rounds on the ext4 list. =A0M=
y
> intentions are to start reviewing and integrating those patches into =
the
> dev tree on Wednesday. =A0If other people have any concerns, I'd
> appreciate any reviews or comments before then.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
> % git shortlog master..dev
> Amerigo Wang (1):
> =A0 =A0 =A0ext4: remove redundant #ifdef in super.c
>
> Amir Goldstein (5):
> =A0 =A0 =A0ext4: move ext4_add_groupblocks() to mballoc.c
> =A0 =A0 =A0ext4: implement ext4_add_groupblocks() by freeing blocks
> =A0 =A0 =A0ext4: synchronize ext4_mb_init_group() with buddy page loc=
k
> =A0 =A0 =A0ext4: teach ext4_mb_init_cache() to skip uptodate buddy ca=
ches
> =A0 =A0 =A0ext4: remove alloc_semp
>
> Jan Kara (1):
> =A0 =A0 =A0jbd2: Fix forever sleeping process in do_get_write_access(=
)
>
> Tao Ma (3):
> =A0 =A0 =A0ext4: use EXT4FS_DEBUG instead of EXT4_DEBUG in fsync.c
> =A0 =A0 =A0ext4: use s_inodes_per_block directly in __ext4_get_inode_=
loc
> =A0 =A0 =A0ext4: remove redundant check for first_not_zeroed in ext4_=
register_li_requ
>
> Theodore Ts'o (2):
> =A0 =A0 =A0jbd2: only print the debugging information for tid wraparo=
und once
> =A0 =A0 =A0ext4: remove unneeded ext4_journal_get_undo_access
>
> % git shortlog origin..master
> Curt Wohlgemuth (1):
> =A0 =A0 =A0ext4: don't set PageUptodate in ext4_end_bio()
>
> Jan Kara (2):
> =A0 =A0 =A0ext4: Fix fs corruption when make_indexed_dir() fails
> =A0 =A0 =A0ext4: fix deadlock in ext4_symlink() in ENOSPC conditions
>
> Shaohua Li (1):
> =A0 =A0 =A0ext4: remove dead code in ext4_has_free_blocks()
>
> Theodore Ts'o (5):
> =A0 =A0 =A0ext4: check for ext[23] file system features when mounting=
 as ext[23]
> =A0 =A0 =A0ext4: ignore errors when issuing discards
> =A0 =A0 =A0ext4: remove obsolete mount options from ext4's documentat=
ion
> =A0 =A0 =A0jbd2: fix fsync() tid wraparound bug
> =A0 =A0 =A0ext4: set extents flag when migrating file to use extents
>
> Yang Ruirui (1):
> =A0 =A0 =A0ext4: release page cache in ext4_mb_load_buddy error path
>
> Yongqiang Yang (3):
> =A0 =A0 =A0ext4: add a function merging extents right and left
> =A0 =A0 =A0ext4: add ext4_split_extent_at() and ext4_split_extent()
> =A0 =A0 =A0ext4: reimplement convert and split_unwritten
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
