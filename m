From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/4] fs: split update_time() into update_time() and
 write_time()
Date: Tue, 25 Nov 2014 16:51:41 +0100
Message-ID: <20141125155141.GF26471@twin.jikos.cz>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
 <1416599964-21892-2-git-send-email-tytso@mit.edu>
 <20141124152101.GA12575@infradead.org>
 <20141124173430.GB26471@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: dsterba@suse.cz, Christoph Hellwig <hch@infradead.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141124173430.GB26471@twin.jikos.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 24, 2014 at 06:34:30PM +0100, David Sterba wrote:
> The btrfs_root_readonly checks in setxattr and removexattr are
> unnecessary because they're done through xattr_permisssion. I'll send a
> patch to remove them.

Does not work because the security.* and system.* namespaces do not call
the permission() hook, so no patch. However, if the proposed
inode_is_readonly callback is merged, we can replace the btrfs-specific
checks with is_readonly check in xattr_permission().
