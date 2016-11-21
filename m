From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 3/4] generic: test encrypted file access
Date: Mon, 21 Nov 2016 11:23:30 -0800
Message-ID: <20161121192330.GD30672@google.com>
References: <1479412027-34416-1-git-send-email-ebiggers@google.com>
 <1479412027-34416-4-git-send-email-ebiggers@google.com>
 <20161120223151.GK28177@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>
To: Dave Chinner <david@fromorbit.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161120223151.GK28177@dastard>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 21, 2016 at 09:31:51AM +1100, Dave Chinner wrote:
> 
> But, then again, why wouldn't you just dump:
> 
> ls -lR edir |_filter_scratch
> 
> to the golden output file to confirm everything is exactly as you
> expect it to be in the encrypted directory? It'll catch un-encrypted
> names, wrong subdir depth, etc.
> 

This won't work because the encrypted filenames are unpredictable.  The
filenames in a directory are encrypted by a key unique to that directory which
is derived from the designated keyring key and a per-inode nonce.  Nonces are
generated randomly by the kernel, so the per-inode encryption keys cannot be
predicted even if you were to put a fixed key into the keyring rather than a
random one.  This is by design because for confidentiality reasons, the same
filename in different directories must not encrypt to the same ciphertext.  A
similar argument applies to the contents of regular files and to symlink
targets.

(Yes, I should make this clear in a comment in the test.)

> 
> > +cat $(find edir -maxdepth 1 -type f | head -1) 2>tmp
> > +if ! egrep -q 'Required key not available' tmp; then
> > +	echo "Reading encrypted file w/o key didn't fail with ENOKEY"
> > +	cat tmp
> > +	exit 1
> > +fi
> 
> md5sum `find edir -maxdepth 1 -type f | head -1` | _filter_scratch
> 
> You'll either get a md5sum of the data or an error message
> in the golden output. The wrong one will trigger a failure.

This won't quite work because the encrypted filename cannot be predicted, but it
would work if the filename were to be filtered out.

I'll take all your suggestions which don't assume predictable filenames.

Thanks,

Eric
