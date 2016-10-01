From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH] fscrypto: make XTS tweak initialization endian-independent
Date: Sat, 1 Oct 2016 18:03:31 +0200
Message-ID: <CAFLxGvyCHwWms8wJf1gU0hRj__Q0Z2F2wKuZ3sYNfp8wQ9S4PQ@mail.gmail.com>
References: <1475258329-146528-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        "Theodore Ts'o" <tytso@mit.edu>, jaegeuk@kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1475258329-146528-1-git-send-email-ebiggers@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric,

On Fri, Sep 30, 2016 at 7:58 PM, Eric Biggers <ebiggers@google.com> wrote:
> The XTS tweak (or IV) was initialized differently on little endian and
> big endian systems.  Because the ciphertext depends on the XTS tweak, it
> was not possible to use an encrypted filesystem created by a little
> endian system on a big endian system and vice versa, even if they shared
> the same PAGE_SIZE.  Fix this by always using little endian.
>
> This will break hypothetical big endian users of ext4 or f2fs
> encryption.  However, all users we are aware of are little endian, and
> it's believed that "real" big endian users are unlikely to exist yet.
> So this might as well be fixed now before it's too late.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/crypto.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> index 61057b7d..98f87fe 100644
> --- a/fs/crypto/crypto.c
> +++ b/fs/crypto/crypto.c
> @@ -151,7 +151,10 @@ static int do_page_crypto(struct inode *inode,
>                         struct page *src_page, struct page *dest_page,
>                         gfp_t gfp_flags)
>  {
> -       u8 xts_tweak[FS_XTS_TWEAK_SIZE];
> +       struct {
> +               __le64 index;
> +               u8 padding[FS_XTS_TWEAK_SIZE - sizeof(__le64)];
> +       } xts_tweak;

While we are here, wouldn't it make sense to rename the variable to "iv"?
In aes-xts mode the IV is used as tweak. But it is still an IV and passed
as IV parameter to the crypto API.

Especially when other cipher modes are used this is confusing.

-- 
Thanks,
//richard
