From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 27/32] ext4: xattr inode deduplication
Date: Thu, 22 Jun 2017 11:45:56 -0400
Message-ID: <20170622154556.mutvsh7lxw5kvhvb@thunk.org>
References: <20170622014939.3592-1-tahsin@google.com>
 <20170622014939.3592-4-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170622014939.3592-4-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 06:49:34PM -0700, Tahsin Erdogan wrote:
> Ext4 now supports xattr values that are up to 64k in size (vfs limit).
> Large xattr values are stored in external inodes each one holding a
> single value. Once written the data blocks of these inodes are immutable.
> 
> The real world use cases are expected to have a lot of value duplication
> such as inherited acls etc. To reduce data duplication on disk, this patch
> implements a deduplicator that allows sharing of xattr inodes.
> 
> The deduplication is based on an in-memory hash lookup that is a best
> effort sharing scheme. When a xattr inode is read from disk (i.e.
> getxattr() call), its crc32c hash is added to a hash table. Before
> creating a new xattr inode for a value being set, the hash table is
> checked to see if an existing inode holds an identical value. If such an
> inode is found, the ref count on that inode is incremented. On value
> removal the ref count is decremented and if it reaches zero the inode is
> deleted.
> 
> The quota charging for such inodes is manually managed. Every reference
> holder is charged the full size as if there was no sharing happening.
> This is consistent with how xattr blocks are also charged.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Applied, thanks

				- Ted
