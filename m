From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] ext4: address a benign compiler warning
Date: Wed, 12 Feb 2014 18:59:42 -0800
Message-ID: <1392260382.2214.18.camel@joe-AO722>
References: <1392257593-3736-1-git-send-email-patrick@parcs.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Patrick Palka <patrick@parcs.ath.cx>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1392257593-3736-1-git-send-email-patrick@parcs.ath.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2014-02-12 at 21:13 -0500, Patrick Palka wrote:
> When !defined(CONFIG_EXT4_DEBUG), mb_debug() should be defined as an
> empty do-while statement so as to suppress the following compiler
> warning:

Hello Patrick.

> fs/ext4/mballoc.c: In function =E2=80=98ext4_mb_cleanup_pa=E2=80=99:
> fs/ext4/mballoc.c:2659:47: warning: suggest braces around empty body =
in an =E2=80=98if=E2=80=99 statement [-Wempty-body]
>    mb_debug(1, "mballoc: %u PAs left\n", count);
> ---
> diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
[]
> @@ -48,7 +48,7 @@ extern ushort ext4_mballoc_debug;
>  		}							\
>  	} while (0)
>  #else
> -#define mb_debug(n, fmt, a...)
> +#define mb_debug(n, fmt, a...)		do { } while (0)

Ideally, this section should be something like below
so the !CONFIG_EXT4_DEBUG case still verifies that
the format and argument types match.

This can help avoid people adding debug statements but
not compiling with the proper CONFIG_<foo> variable set.

---

#ifdef CONFIG_EXT4_DEBUG
extern ushort ext4_mballoc_debug;

#define mb_debug(n, fmt, ...)					\
do {								\
	if ((n) <=3D ext4_mballoc_debug)				\
		pr_debug(fmt, ##__VA_ARGS__);			\
	}							\
} while (0)
#else
#define mb_debug(n, fmt, ...)					\
	no_printk(KERN_DEBUG fmt, ##__VA_ARGS__)
#endif
