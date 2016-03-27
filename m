From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH 0/5] Miklos's vfs/nfs/ext4 patches in the ext4.git tree
Date: Sun, 27 Mar 2016 10:06:14 +0200
Message-ID: <CA+icZUWO82Mew_3BNS32EVU1zSzpoNQqTGNyJiEJsKUocEvUUg@mail.gmail.com>
References: <1459026600-9232-1-git-send-email-tytso@mit.edu>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	David Howells <dhowells@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>, jaegeuk@kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1459026600-9232-1-git-send-email-tytso@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Mar 26, 2016 at 10:09 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> I have the following patches in the ext4.git tree which I plan to push
> to Linus as bug fixes during this development cycles.  Al, are you
> happy with Miklos's v2 version of "fs: add file_dentrY()" patch?
>
> Miklos Szeredi (4):
>   fs: add file_dentry()
>   nfs: use file_dentry()
>   ext4: use dget_parent() in ext4_file_open()
>   ext4: use file_dentry()
>
> Theodore Ts'o (1):
>   ext4 crypto: use dget_parent() in ext4_d_revalidate()
>

I asked that already in a previous series of that patchset.

Are those CC-stable-tags correct?

fs: add file_dentry()
Cc: <stable@vger.kernel.org> # v4.2

nfs: use file_dentry()
Cc: <stable@vger.kernel.org> # v4.2

ext4: use dget_parent() in ext4_file_open()
Cc: <stable@vger.kernel.org> # v4.5

ext4: use file_dentry()
Cc: <stable@vger.kernel.org> # v4.5

ext4 crypto: use dget_parent() in ext4_d_revalidate()
Cc: stable@vger.kernel.org

- Sedat -

>  fs/dcache.c            |  5 ++++-
>  fs/ext4/crypto.c       | 12 ++++++++----
>  fs/ext4/file.c         | 12 ++++++++----
>  fs/nfs/dir.c           |  6 +++---
>  fs/nfs/inode.c         |  2 +-
>  fs/nfs/nfs4file.c      |  4 ++--
>  fs/overlayfs/super.c   | 33 +++++++++++++++++++++++++++++++++
>  include/linux/dcache.h | 10 ++++++++++
>  include/linux/fs.h     | 10 ++++++++++
>  9 files changed, 79 insertions(+), 15 deletions(-)
>
> --
> 2.5.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
