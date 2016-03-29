From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/5] Miklos's vfs/nfs/ext4 patches in the ext4.git tree
Date: Tue, 29 Mar 2016 20:58:45 +0100
Message-ID: <20160329195844.GW17997@ZenIV.linux.org.uk>
References: <1459026600-9232-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	dhowells@redhat.com,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>, jaegeuk@kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459026600-9232-1-git-send-email-tytso@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Mar 26, 2016 at 05:09:55PM -0400, Theodore Ts'o wrote:
> I have the following patches in the ext4.git tree which I plan to push
> to Linus as bug fixes during this development cycles.  Al, are you
> happy with Miklos's v2 version of "fs: add file_dentrY()" patch?

I'm not really happy, but I guess we'll have to live with that approach.
I would still like to point out that *any* use of file_dentry() (or
file->f_path.dentry, for that matter) is a serious red flag - odds are,
the code using it is broken, possibly by design.

I still don't understand the locking in ext4 crypto, and I'm not at all
convinced that it is correct ;-/  OTOH, there are filesystems where we
really need dentry and (hopefully) treat it sanely enough, so consider
that helper and method ACKed.  I can take it via vfs.git, or leave it
to ext4.git, or do some combination thereof (e.g. the infrastructure
goes into never-rebased branch in vfs.git, with ext4/btrfs/nfs merging
from it).  Up to you...

Al, still bloody unhappy about the whole pile of worms...
