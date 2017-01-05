From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't allow encrypted operations without keys
Date: Thu, 5 Jan 2017 15:15:54 -0500
Message-ID: <20170105201554.zolkpxdr27jdw25v@thunk.org>
References: <20161228034812.ikoat5x3e7ucnac7@thunk.org>
 <20161228052252.10314-1-tytso@mit.edu>
 <20170105192619.GF21696@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Filesystem Development List
        <linux-fsdevel@vger.kernel.org>, jaegeuk@kernel.org,
        richard@nod.at, ebiggers@google.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170105192619.GF21696@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 05, 2017 at 11:26:19AM -0800, Eric Biggers wrote:
> Something I'm thinking about is making things easier for filesystems by having
> functions like "fscrypt_rename_hook()" which would handle all these needed
> checks.  It would be easy to do with out-of-line functions in fs/crypto/, but we
> don't want to be making ->is_encrypted() calls through the fscrypt_operations
> all the time, when an inlined call to ext4_encrypted_inode() (or f2fs or
> ubifs_encrypted_inode()) is much faster.  I think it could be implemented as
> efficiently as now if the hooks were defined in a header and called a macro like
> "fs_encrypted_inode()" which filesystems would have to #define first.  It would
> be a little ugly, but at least it would be less error-prone than having multiple
> filesystems replicate these increasingly complex checks.

We could make things a lot simpler and a lot more efficient by adding
make flags at the VFS level in struct super and struct inode meaning
"file systems has fscrypt enabled", and "the inode is encrypted using
fscrypt".  That way, we wouldn't need to go through through
fscrypt_operations to do these tests.  We could just set the flags
appropriately when the struct inode or struct super is instantiated.

   	      	    	    		       	  - Ted
