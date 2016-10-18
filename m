From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH] fscrypto: move ioctl processing more fully into common code
Date: Tue, 18 Oct 2016 14:22:07 +0200
Message-ID: <CAFLxGvz8KV=zzy=fijEuK7qtCivS=A2BBpNvNksv4J06KTSmZw@mail.gmail.com>
References: <1476723246-47420-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        "Theodore Ts'o" <tytso@mit.edu>, jaegeuk@kernel.org,
        David Gstir <david@sigma-star.at>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1476723246-47420-1-git-send-email-ebiggers@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric,

On Mon, Oct 17, 2016 at 6:54 PM, Eric Biggers <ebiggers@google.com> wrote:
> Multiple bugs were recently fixed in the "set encryption policy" ioctl.
> To make it clear that fscrypt_process_policy() and fscrypt_get_policy()
> implement ioctls and therefore their implementations must take standard
> security and correctness precautions, rename them to
> fscrypt_ioctl_set_policy() and fscrypt_ioctl_get_policy().  Make the
> latter take in a struct file * to make it consistent with the former.
>
> In addition, make the common functions do the copies to and from
> userspace rather than duplicating this code within each filesystem, and
> memset the policy to 0 to make it clear there is no stack leak.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/policy.c       | 36 +++++++++++++++++++++++-------------
>  fs/ext4/ext4.h           |  4 ++--
>  fs/ext4/ioctl.c          | 34 +++++-----------------------------
>  fs/f2fs/f2fs.h           |  4 ++--
>  fs/f2fs/file.c           | 19 ++-----------------
>  include/linux/fscrypto.h | 12 ++++++------
>  6 files changed, 40 insertions(+), 69 deletions(-)

Hmm, are you sure the change is worth it?
The patch basically moves a copy_from/to_user() from ext4/f2fs into fscrypto.

-- 
Thanks,
//richard
