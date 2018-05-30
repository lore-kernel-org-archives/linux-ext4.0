From: Nick Desaulniers <nick.desaulniers@gmail.com>
Subject: Re: [PATCH] ext4: prefer strlcpy to strncpy
Date: Tue, 29 May 2018 18:59:41 -0700
Message-ID: <CAH7mPvh7rQG5TPeWUXNEkF=WuPNroAozHrWAvZfLGPw0dSmBBQ@mail.gmail.com>
References: <1527574913-10561-1-git-send-email-nick.desaulniers@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Nick Desaulniers <nick.desaulniers@gmail.com>,
        linux-ext4@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ebiggers@google.com
To: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527574913-10561-1-git-send-email-nick.desaulniers@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 28, 2018 at 11:21 PM, Nick Desaulniers
<nick.desaulniers@gmail.com> wrote:
> Fixes a stringop-truncation warning from gcc-8.
>
> Signed-off-by: Nick Desaulniers <nick.desaulniers@gmail.com>
> ---
>  fs/ext4/super.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index eb104e8..d47c85f 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -323,11 +323,11 @@ static void __save_error_info(struct super_block *sb, const char *func,
>                 return;
>         es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
>         es->s_last_error_time = cpu_to_le32(get_seconds());
> -       strncpy(es->s_last_error_func, func, sizeof(es->s_last_error_func));
> +       strlcpy(es->s_last_error_func, func, sizeof(es->s_last_error_func));
>         es->s_last_error_line = cpu_to_le32(line);
>         if (!es->s_first_error_time) {
>                 es->s_first_error_time = es->s_last_error_time;
> -               strncpy(es->s_first_error_func, func,
> +               strlcpy(es->s_first_error_func, func,
>                         sizeof(es->s_first_error_func));
>                 es->s_first_error_line = cpu_to_le32(line);
>                 es->s_first_error_ino = es->s_last_error_ino;
> --
> 2.7.4
>

Eric points out this will leave the rest of dest uninitialized if size
is less than length of src.
