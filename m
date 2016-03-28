From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 0/5] Miklos's vfs/nfs/ext4 patches in the ext4.git tree
Date: Mon, 28 Mar 2016 10:02:22 -0400
Message-ID: <20160328140222.alfdic6nvdt3rpmf@floor.thefacebook.com>
References: <1459026600-9232-1-git-send-email-tytso@mit.edu>
 <CA+icZUUCF5-2YFkCeMze5Tsd-xynvmNBjTA8Qj7nE4LoCTa2-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	David Howells <dhowells@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>, <jaegeuk@kernel.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+icZUUCF5-2YFkCeMze5Tsd-xynvmNBjTA8Qj7nE4LoCTa2-w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 28, 2016 at 12:51:22AM +0200, Sedat Dilek wrote:
> On Sat, Mar 26, 2016 at 10:09 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > I have the following patches in the ext4.git tree which I plan to push
> > to Linus as bug fixes during this development cycles.  Al, are you
> > happy with Miklos's v2 version of "fs: add file_dentrY()" patch?
> >
> > Miklos Szeredi (4):
> >   fs: add file_dentry()
> >   nfs: use file_dentry()
> >   ext4: use dget_parent() in ext4_file_open()
> >   ext4: use file_dentry()
> >
> > Theodore Ts'o (1):
> >   ext4 crypto: use dget_parent() in ext4_d_revalidate()
> >
> >  fs/dcache.c            |  5 ++++-
> >  fs/ext4/crypto.c       | 12 ++++++++----
> >  fs/ext4/file.c         | 12 ++++++++----
> >  fs/nfs/dir.c           |  6 +++---
> >  fs/nfs/inode.c         |  2 +-
> >  fs/nfs/nfs4file.c      |  4 ++--
> >  fs/overlayfs/super.c   | 33 +++++++++++++++++++++++++++++++++
> >  include/linux/dcache.h | 10 ++++++++++
> >  include/linux/fs.h     | 10 ++++++++++
> >  9 files changed, 79 insertions(+), 15 deletions(-)
> >
> > --
> > 2.5.0
> >
> 
> Might be good to have...
> 
> "Btrfs: fix crash/invalid memory access on fsync when using overlayfs"
> 
> ...also in this series.

Yeah, I've been waiting on Miklos' patch to push the corresponding btrfs
fix.  I can do it separately or it can go in here too.  Either way is
fine with me.

-chris
