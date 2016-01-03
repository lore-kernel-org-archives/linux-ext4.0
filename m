From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: disable retry logic in ext4_set_encrypted_filename
Date: Sat, 2 Jan 2016 22:54:40 -0500
Message-ID: <20160103035440.GR3248@thunk.org>
References: <3125077.SmBO9VTSER@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3125077.SmBO9VTSER@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jan 02, 2016 at 08:50:11PM +0100, Arnd Bergmann wrote:
> gcc correctly warns that the ctx variable in ext4_set_encrypted_filename
> has gone out of scope in ext4_set_encrypted_filename if we enter the
> retry path and a 'goto' into the previous code block can not guarantee
> to get the contents back:
> 
> fs/ext4/namei.c: In function 'ext4_set_encrypted_filename':
> fs/ext4/namei.c:4035:10: warning: 'ctx' may be used uninitialized in this function [-Wmaybe-uninitialized]
>    retval = ext4_xattr_set_handle(handle, inode,

Sorry, this was a known bug that I fixed about a week ago, but I
hadn't pushed out an update to the ext4 dev branch because I hadn't
had a chance to finish testing the project quota changes.  I've just
pushed out an update.

					- Ted
