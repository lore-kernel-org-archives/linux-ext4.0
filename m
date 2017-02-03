From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC/PATCH 0/3] Implement XFS's GOINGDOWN ioctl for ext4
Date: Fri, 3 Feb 2017 09:05:01 +0200
Message-ID: <CAOQ4uxhQubTwdOtmXXsaW4hVjKt2yBhSFG92ie0QcO+HGD9ioQ@mail.gmail.com>
References: <20170202225924.19301-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20170202225924.19301-1-tytso@mit.edu>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Feb 3, 2017 at 12:59 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> This is a proof of concept implementation of XFS's GOINGDOWN ioctl for
> ext4.
>
> I've tried to replicate XFS's semantics (as much as they can translate
> to ext4).  This test series is currently *not* passing xfstests.
> Specifically, the following tests are failing:
>
>         generic/042 generic/044 generic/045 generic/046
>
> As near as I can tell, these tests are sensitive to how the file
> system implements and handles delayed allocation.  In particular,
> generic/04[456] assumes that if you do a delayed allocation write of
> 64k, and then truncate the file to 64k or 32k, the file will either be
> zero length, or i_size is non-zero, it MUST NOT have no extents.
>
> It's not clear to me why this needs to be true.  The test description
> says "test for NULL files problem".  But since POSIX states that how
> truncate will handle truncates beyond i_size is unspecified, and what
> happens after a crash w/o an fsync() is similarly unspecified, it's
> not clear what is the best way to deal with this.
>
> One is to simply use a different ioctl code point, to avoid enabling
> the xfstests tests.  Another to modify the tests to skip them for
> ext4.  Or I can teach kvm-xfstests and gce-xfstests to ignore these
> test failures by skipping the tests in my test framework.
>
> Comments, thoughts?

I have a naive question about generic implementation:
We already have mnt_want_write() hooks in generic vfs code,
so it should be easy enough to set the shutdown bit on sb and return -EIO there.
Wouldn't it be better to add mnt_want_read() hooks in vfs helpers
instead of duplicating
the fs specific hooks? I hear f2fs is yet another potential customer??

I realize this needs more thinking and more work, so
no intention of blocking your immediate production needs, just wondering
about future implementation that is more robust and fs agnostic.

>
>                                                 - Ted
>
> P.S.  So I'm not implementing this just for increased xfstests
> coverage; I have an operational need for this functionality on
> production systems.  The short version is if you are tearing down a
> container, and you don't care about its scratch space, being able to
> drop all of the writes from being sent to the storage device (which
> might be over the network, say using iSCSI), is a Good Thing.
>
> Theodore Ts'o (3):
>   ext4: rename s_resize_flags to s_ext4_flags
>   ext4: add shutdown bit and check for it
>   ext4: add EXT4_IOC_GOINGDOWN ioctl
>
>  fs/ext4/ext4.h      | 26 +++++++++++++++++++++++---
>  fs/ext4/ext4_jbd2.c |  2 ++
>  fs/ext4/file.c      | 12 ++++++++++++
>  fs/ext4/fsync.c     |  3 +++
>  fs/ext4/ialloc.c    |  3 +++
>  fs/ext4/inode.c     | 25 +++++++++++++++++++++++++
>  fs/ext4/ioctl.c     | 42 ++++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/namei.c     | 12 ++++++++++++
>  fs/ext4/resize.c    |  5 +++--
>  fs/ext4/super.c     |  2 +-
>  fs/ext4/xattr.c     |  3 +++
>  11 files changed, 129 insertions(+), 6 deletions(-)
>
> --
> 2.11.0.rc0.7.gbe5a750
>
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
