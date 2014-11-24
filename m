From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/4] fs: split update_time() into update_time() and
 write_time()
Date: Mon, 24 Nov 2014 19:09:51 +0100
Message-ID: <20141124180951.GD26471@twin.jikos.cz>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
 <1416599964-21892-2-git-send-email-tytso@mit.edu>
 <1416600528.24312.10@mail.thefacebook.com>
 <20141121214245.GG7112@thunk.org>
 <20141124163830.GA26471@twin.jikos.cz>
 <20141124172216.GC31339@thunk.org>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>,
	linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141124172216.GC31339@thunk.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 24, 2014 at 12:22:16PM -0500, Theodore Ts'o wrote:
> On Mon, Nov 24, 2014 at 05:38:30PM +0100, David Sterba wrote:
> > 
> > It is necessary and the whole .update_time callback was added
> > intentionally, see commits
> > 
> > c3b2da314834499f34cba94f7053e55f6d6f92d8
> > fs: introduce inode operation ->update_time
> > 
> > e41f941a23115e84a8550b3d901a13a14b2edc2f
> > Btrfs: move over to use ->update_time
> 
> Being able to signal an error if the time update fails is still
> possible even if we drop update_time(), because the new write_time()
> function will return an error.

Fine, means your change does not break the current status. I was
providing the more complete list of related commits.

> > 2bc5565286121d2a77ccd728eb3484dff2035b58
> > Btrfs: don't update atime on RO subvolumes
> 
> Yes, but this doesn't answer my question about other places where the
> VFS is only checking MS_RDONLY and MNT_READONLY besides just
> update_atime().  Maybe we should be exposing an "is_readonly(inode)"
> inode operations function to address this?

Yes, if this is a lightweight check then it'd would allow to remove the
filesystem-specific checks.
