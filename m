From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] fs/ext4/extents_status.c: fix 64-bit number truncation bug
Date: Sun, 6 Apr 2014 15:39:09 +0200
Message-ID: <CAMuHMdVT9O8C0fhMbaqS2nB1jfLAZtanp6YGPU6Q-T5b7=n20Q@mail.gmail.com>
References: <53396AC1.10108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Guan Xuetao <gxt@mprc.pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53396AC1.10108@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 31, 2014 at 3:16 PM, Chen Gang <gang.chen.5i5j@gmail.com> w=
rote:
> '0x7FDEADBEEF' will be truncated to 32-bit number under unicore32. Ne=
ed
> append 'ULL' for it.
>
> The related warning (with allmodconfig under unicore32):
>
>     CC [M]  fs/ext4/extents_status.o
>   fs/ext4/extents_status.c: In function =E2=80=98__es_remove_extent=E2=
=80=99:
>   fs/ext4/extents_status.c:813: warning: integer constant is too larg=
e for =E2=80=98long=E2=80=99 type

Thanks! This is failing on all 32-bit architectures.

> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  fs/ext4/extents_status.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 0a014a7..0ebc212 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -810,7 +810,7 @@ retry:
>
>                         newes.es_lblk =3D end + 1;
>                         newes.es_len =3D len2;
> -                       block =3D 0x7FDEADBEEF;
> +                       block =3D 0x7FDEADBEEFULL;
>                         if (ext4_es_is_written(&orig_es) ||
>                             ext4_es_is_unwritten(&orig_es))
>                                 block =3D ext4_es_pblock(&orig_es) +

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
                                -- Linus Torvalds
