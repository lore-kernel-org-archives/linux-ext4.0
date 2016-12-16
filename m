From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 3/3] fscrypt: consolidate fscrypt_has_permitted_context()
 checks
Date: Fri, 16 Dec 2016 12:46:40 -0800
Message-ID: <20161216204640.GA14264@gmail.com>
References: <1481829584-50218-1-git-send-email-ebiggers3@gmail.com>
 <1481829584-50218-3-git-send-email-ebiggers3@gmail.com>
 <5de5b934-5709-ca29-c277-99d93539b1c0@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        David Gstir <david@sigma-star.at>,
        Eric Biggers <ebiggers@google.com>
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5de5b934-5709-ca29-c277-99d93539b1c0@nod.at>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 16, 2016 at 01:22:51PM +0100, Richard Weinberger wrote:
> On 15.12.2016 20:19, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Now that fscrypt_has_permitted_context() compares the fscrypt_context
> > rather than the fscrypt_info when needed, it is no longer necessary to
> > delay fscrypt_has_permitted_context() from ->lookup() to ->open() for
> > regular files, as introduced in commit ff978b09f973 ("ext4 crypto: move
> > context consistency check to ext4_file_open()").  Therefore the check in
> > ->open(), along with the dget_parent() hack, can be removed.
> > 
> > It's also no longer necessary to check the file type before calling
> > fscrypt_has_permitted_context().
> > 
> > This patch makes these changes for both ext4 and f2fs.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  fs/ext4/file.c  | 12 ------------
> >  fs/ext4/namei.c | 10 ++--------
> >  fs/f2fs/file.c  | 15 +++++----------
> >  fs/f2fs/namei.c |  7 ++-----
> >  4 files changed, 9 insertions(+), 35 deletions(-)
> 
> Can please also take care of UBIFS? :-)
> 
> Thanks,
> //richard

Yes, I see that UBIFS encryption just got merged yesterday, so I'll send a
version that updates UBIFS too.  And it seems the
fscrypt_has_permitted_context() call in ubifs_lookup() is missing, so I'll add
that too.

I'm wondering if it would make more sense to do a separate patch for each
filesystem?  But in this case the filesystem changes are dependent on the prior
patches to fs/crypto/, so they can't simply be sent through the per-filesystem
trees unless each one merges in the fs/crypto/ changes too.

Eric
