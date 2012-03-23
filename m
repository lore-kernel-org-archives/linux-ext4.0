From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext2: No longer export ext2_fs.h to user space
Date: Fri, 23 Mar 2012 09:13:31 -0400
Message-ID: <20120323131331.GA29631@thunk.org>
References: <20120322183135.GC4028@thunk.org>
 <1332494856-31943-1-git-send-email-thierry.reding@avionic-design.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Andreas Dilger <aedilger@gmail.com>, linux-ext4@vger.kernel.org
To: Thierry Reding <thierry.reding@avionic-design.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1332494856-31943-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Mar 23, 2012 at 10:27:36AM +0100, Thierry Reding wrote:
> Since the on-disk format has been stable for quite some time, users
> should either use the headers provided by libext2fs or keep a private
> copy of this header. For the full discussion, see this thread:
> 
> 	https://lkml.org/lkml/2012/3/21/516
> 
> While at it, this commit removes all __KERNEL__ guards, which are now
> unnecessary.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Ted Ts'o <tytso@mit.edu>
> Cc: Artem Bityutskiy <dedekind1@gmail.com>
> Cc: Andreas Dilger <aedilger@gmail.com>
> Cc: linux-ext4@vger.kernel.org

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

Thanks!!

Al, do you want to take this in the VFS tree, or do you want me to
carry this in the ext4 tree?  Or Jan could carry it in the ext2 tree.
I don't really have strong feelings about who picks it up.  I will if
no one else wants to...

					- Ted
