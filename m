From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] fscrypto: make filename crypto functions return 0 on
 success
Date: Thu, 15 Sep 2016 18:12:29 -0400
Message-ID: <20160915221229.e25o5xw7bhbeixbe@thunk.org>
References: <1473960529-29158-1-git-send-email-ebiggers@google.com>
 <20160915202401.GB52239@jaegeuk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers@google.com>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
To: Jaegeuk Kim <jaegeuk@kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160915202401.GB52239@jaegeuk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 15, 2016 at 01:24:01PM -0700, Jaegeuk Kim wrote:
> On Thu, Sep 15, 2016 at 10:28:49AM -0700, Eric Biggers wrote:
> > Several filename crypto functions: fname_decrypt(),
> > fscrypt_fname_disk_to_usr(), and fscrypt_fname_usr_to_disk(), returned
> > the output length on success or -errno on failure.  However, the output
> > length was redundant with the value written to 'oname->len'.  It is also
> > potentially error-prone to make callers have to check for '< 0' instead
> > of '!= 0'.
> > 
> > Therefore, make these functions return 0 instead of a length, and make
> > the callers who cared about the return value being a length use
> > 'oname->len' instead.  For consistency also make other callers check for
> > a nonzero result rather than a negative result.
> > 
> > This change also fixes the inconsistency of fname_encrypt() actually
> > already returning 0 on success, not a length like the other filename
> > crypto functions and as documented in its function comment.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Acked-by: Jaegeuk Kim <jaegeuk@kernel.org>

Thanks, applied.

						- Ted
