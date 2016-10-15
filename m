From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fscrypto: lock inode while setting encryption policy
Date: Sat, 15 Oct 2016 09:54:01 -0400
Message-ID: <20161015135401.3lc3liibnigf5seq@thunk.org>
References: <1475087688-4048-1-git-send-email-ebiggers@google.com>
 <ea8b7140-f04e-380d-b5ae-263f029c0624@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers@google.com>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        jaegeuk@kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ea8b7140-f04e-380d-b5ae-263f029c0624@nod.at>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 29, 2016 at 07:20:20PM +0200, Richard Weinberger wrote:
> On 28.09.2016 20:34, Eric Biggers wrote:
> > i_rwsem needs to be acquired while setting an encryption policy so that
> > concurrent calls to FS_IOC_SET_ENCRYPTION_POLICY are correctly
> > serialized (especially the ->get_context() + ->set_context() pair), and
> > so that new files cannot be created in the directory during or after the
> > ->empty_dir() check.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Reviewed-by: Richard Weinberger <richard@nod.at>

Thanks, applied.

					- Ted
