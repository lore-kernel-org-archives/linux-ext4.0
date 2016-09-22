From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Check for encryption feature before
 fscrypt_process_policy()
Date: Thu, 22 Sep 2016 18:38:03 -0400
Message-ID: <20160922223803.ggz2qodtqtht7oot@thunk.org>
References: <1474527054-24207-1-git-send-email-richard@nod.at>
 <20160922194931.GA53380@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Richard Weinberger <richard@nod.at>, adilger.kernel@dilger.ca,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        david@sigma-star.at, jaegeuk@kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160922194931.GA53380@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 22, 2016 at 12:49:31PM -0700, Eric Biggers wrote:
> 
> Ted had actually pointed out that the reason this hasn't already been fixed is
> that some users, e.g. Android, do not set the feature flag but still expect the
> filesystem encryption code to work.  Maybe he can chime in with regards to when
> (if ever) it would make sense to make this change.

I think it's fine to fix it now in upstream.  It might cause some
problems for Cyanogen developers if they want to try to use an
upstream kernel and also enable the ext4 encryption feature, but the
fix to make_ext4fs isn't all that hard.

> Also, it seems the default block size for mkfs.ext4 is determined by a heuristic
> and isn't guaranteed to be 1 KiB.  So the commit message probably should say
> something more general like "filesystems created with a block size other than
> PAGE_SIZE".

In fact mke2fs only uses 1k block sizes for filessystems smaller than
512M.  If you were take a census of all ext4 file systems out there,
the most common block size you would see is 4k.

Cheers,

						- Ted

       	  	       	    	     	  
