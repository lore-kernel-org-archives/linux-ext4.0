From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] MAINTAINERS: fscrypto: recommend linux-fsdevel for
 fscrypto patches
Date: Mon, 24 Oct 2016 15:58:26 -0700
Message-ID: <20161024225826.GC83082@google.com>
References: <1477340955-145575-1-git-send-email-ebiggers@google.com>
 <8426b631-dc03-b45a-ec58-fc3ae5cdf0c9@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, tytso@mit.edu, jaegeuk@kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8426b631-dc03-b45a-ec58-fc3ae5cdf0c9@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 24, 2016 at 10:44:41PM +0200, Richard Weinberger wrote:
> That's a very good idea!
> Do we also have designated git tree for fscrypto?
> As soon UBIFS file encryption is mainline I'll have to monitor changes
> to fscrypto very closely because changes in fscrypto could introduce
> changes in the on-flash format of UBIFS.
> i.e. a subtle change in filename encryption... :-)

There isn't yet a dedicated fscrypto tree.  Ted has been taking in most of my
fscrypto patches through the ext4 tree.

This was discussed briefly before, but as designed filesystems do not need to be
aware of the format of the xattr (fscrypt_context) or the format of the
encrypted data per se.  Thus, new modes/formats can be introduced without
requiring changes to filesystem-specific code.  The point that was brought up is
whether some filesystems would additionally like to track in their superblock
which encryption modes and flags are used and either deny mounts or warn at
mount-time if some are unrecognized.  So it should be decided soon if UBIFS is
going to do that or not.

Eric
