From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Question on ext4 directory hashes in combination with file name
 encryption
Date: Fri, 30 Sep 2016 18:05:33 -0400
Message-ID: <20160930220533.x4cbv2g2ynsetqhn@thunk.org>
References: <9a5198b3-0c00-a558-5132-9c38b4bb8795@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        David Gstir <david@sigma-star.at>
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9a5198b3-0c00-a558-5132-9c38b4bb8795@nod.at>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Sep 30, 2016 at 04:09:09PM +0200, Richard Weinberger wrote:
> 
> if I read the ext4 code correctly, you pass encrypted filenames to ext4fs_dirhash().
> These filenames are not encoded and therefore binary gibberish.

That's correct.

> Isn't this a problem for the ext4 hash functions? My fear is that these hashes are optimized
> for ASCII strings and produce more collisions when binary data is used as input.

I'm not particularly worried.  In general, while the converse is true;
that hashes that assume that they are used for binary data might not
work as well for ASCII strings, the ext4 hash functions should work
fine for binary data.

					- Ted
