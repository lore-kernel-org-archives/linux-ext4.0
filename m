From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 00/11] fscrypt: add some higher-level
 helper functions
Date: Fri, 20 Oct 2017 15:44:45 -0400
Message-ID: <20171020194445.dirxpfu2nk2n7a6b@thunk.org>
References: <20171009191544.43656-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Eric Biggers <ebiggers@google.com>, linux-f2fs-devel@lists.sourceforge.net,
 linux-fscrypt@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
 linux-ext4@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20171009191544.43656-1-ebiggers3@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 09, 2017 at 12:15:33PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> This series prepares to reduce code duplication among ext4, f2fs, and
> ubifs by introducing a S_ENCRYPTED inode flag (so we don't have to call
> back into the filesystem to test the filesystem-specific inode flag),
> then introducing new helper functions that are called at the beginning
> of the open, link, rename, lookup, and setattr operations.
> 
> In the future we maybe should even call these new helpers from the VFS
> so that each individual filesystem doesn't have to do it.  But that's
> not possible currently because fs/crypto/ can be built as a module.
> 
> The patches to switch the filesystems over to use the helper functions
> were included in v1 of this patchset.  They are not included now since
> I'm planning to get them picked up by the individual filesystem
> maintainers after this goes in.

Thanks, I've applied these patches plus the ones for ext4 on the
fscrypt.git tree.

The only concern I have is that in fscrypt_file_name() the warning
prints just the inode numbers, but not the block device (it replaced
an ext4_warning() call which automatically printed the block device).
I'll add a patch to fix that up in the next day or two.

     	   	    	     	- Ted

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
