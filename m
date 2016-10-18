From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] fscrypto: move ioctl processing more fully into common
 code
Date: Tue, 18 Oct 2016 09:52:50 -0700
Message-ID: <20161018165250.GA34034@google.com>
References: <1476723246-47420-1-git-send-email-ebiggers@google.com>
 <CAFLxGvz8KV=zzy=fijEuK7qtCivS=A2BBpNvNksv4J06KTSmZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>, jaegeuk@kernel.org,
        David Gstir <david@sigma-star.at>
To: Richard Weinberger <richard.weinberger@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFLxGvz8KV=zzy=fijEuK7qtCivS=A2BBpNvNksv4J06KTSmZw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 18, 2016 at 02:22:07PM +0200, Richard Weinberger wrote:
> 
> Hmm, are you sure the change is worth it?
> The patch basically moves a copy_from/to_user() from ext4/f2fs into fscrypto.
> 

Hi Richard,

In my opinion consolidating the copy_from/to_user() is worthwhile by itself.
The filesystem encryption code should be shared when possible, and right now
there's no reason for each filesystem to do its own copy_from/to_user().

The renaming to fscrypt_ioctl_* is also important because it makes it clear that
the functions implement ioctls.  I've already fixed four bugs in the "set
policy" ioctl, and I think these bugs would have been more obvious with a
clearer code organization.

Eric
