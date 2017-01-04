From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fs/ext4/indirect.c:81: possible 32 / 64 bit mixup ?
Date: Wed, 4 Jan 2017 07:22:05 -0500
Message-ID: <20170104122205.n6ex2h54kmcevs5d@thunk.org>
References: <VI1PR08MB1022ECA50A4A6FF961F3749B9C610@VI1PR08MB1022.eurprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: David Binderman <dcb314@hotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <VI1PR08MB1022ECA50A4A6FF961F3749B9C610@VI1PR08MB1022.eurprd08.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 04, 2017 at 10:40:38AM +0000, David Binderman wrote:
> Hello there,
> 
> linux-4.10-rc2/fs/ext4/indirect.c:81]: (style) int result is assigned to long variable. If the variable is long to avoid loss of information, then you have loss of information.

The on disk representation of indirect blocks is a u32.  Which is to
say, you can't use an indirect block mapped inode to address physical
block numbers beyond 2**32.  A 64-bit ext4 file system normally only
uses extent-mapped inodes, which can address the full set of block
numbers.

It is _possible_, but rare to have a 64-bit file system with indirect
blocks.  The only way it can happen in practice is with a 32-bit file
system that is later converted to be 64-bit using an off-line
conversion process.

(Which many distributions don't support beecause it's one more thing
for their QA folks to test; it also requires the latest e2fsprogs
1.43.x utilities, and since it's relatively new code, I usually tell
people to backup their file system first.  That way, if it succeeds,
it's faster than doing a backup, mkfs, restore sequence; and if it
fails, you can always fall back to that.  :-)

Cheers,

						- Ted
