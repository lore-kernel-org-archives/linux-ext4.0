From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/4] fs: split update_time() into update_time() and
 write_time()
Date: Mon, 24 Nov 2014 17:38:30 +0100
Message-ID: <20141124163830.GA26471@twin.jikos.cz>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
 <1416599964-21892-2-git-send-email-tytso@mit.edu>
 <1416600528.24312.10@mail.thefacebook.com>
 <20141121214245.GG7112@thunk.org>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <clm@fb.com>, linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141121214245.GG7112@thunk.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 21, 2014 at 04:42:45PM -0500, Theodore Ts'o wrote:
> Out of curiosity, why does btrfs_update_time() need to call
> btrfs_root_readonly()?  Why can't it just depend on the
> __mnt_want_write() call in touch_atime()?

mnt_want_write looks only at the mountpoint flags, the readonly
subvolume status is external to that.

> Surely if there are times when it's not OK to write into a btrfs file
> system and mnt_is_readonly() returns false, the VFS is going to get
> very confused abyway.
> 
> If the btrfs_update_time() is not necessary, then we could drop
> btrfs_update_time() and update_time() from the inode operations
> entirely, and depend on the VFS-level code in update_time().

It is necessary and the whole .update_time callback was added
intentionally, see commits

c3b2da314834499f34cba94f7053e55f6d6f92d8
fs: introduce inode operation ->update_time

e41f941a23115e84a8550b3d901a13a14b2edc2f
Btrfs: move over to use ->update_time

2bc5565286121d2a77ccd728eb3484dff2035b58
Btrfs: don't update atime on RO subvolumes
