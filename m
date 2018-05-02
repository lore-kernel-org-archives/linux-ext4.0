From: Mathieu Malaterre <malat@debian.org>
Subject: Re: [PATCH] fs: Add MODULE_SOFTDEP declarations for hard-coded crypto drivers
Date: Wed, 2 May 2018 10:01:32 +0200
Message-ID: <CA+7wUsxOsU6pw3wGt9VTj=wBf6uW6wTUdydU5jJQw+STVBiJ8Q@mail.gmail.com>
References: <20180406195231.14868-1-malat@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Milan Kupcevic <milan@debian.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Mathieu Malaterre <malat@debian.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180406195231.14868-1-malat@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Apr 6, 2018 at 9:52 PM, Mathieu Malaterre <malat@debian.org> wrote:
> This helps initramfs builders and other tools to find the full
> dependencies of a module.

Replaced by:

https://github.com/torvalds/linux/commit/7ef79ad521367

> Debian on powerpc (ppc32) still uses yaboot as default boot loader. Using a
> default installation (debian-installer) 64bit and metadata_csum feature are
> not setup in ext4. This is discussed in more details at:
>
> https://bugs.debian.org/825110#81
>
> and implemented here:
>
> https://anonscm.debian.org/cgit/d-i/partman-ext3.git/patch/?id=f87dc92157262de1ad8dd3f2343436f08271b4dc
>
> This means that building the kernel as default debian package:
>
>   make ARCH=powerpc XYZ_defconfig
>   make -j8 ARCH=powerpc CROSS_COMPILE=powerpc-linux-gnu- bindeb-pkg
>
> Will lead to the following boot failure (initramfs prompt):
>
>   /dev/sda3: clean, 127679/305216 files, 11128559/1220703 blocks done.
>   [    5.592819] EXT4-fs (sda3): Cannot load crc32c driver.
>   mount: mounting /dev/sda3 on /root failed: No such file or directory
>
> Link: https://bugs.debian.org/819725
> Link: https://salsa.debian.org/kernel-team/linux/blob/master/debian/patches/bugfix/all/fs-add-module_softdep-declarations-for-hard-coded-cr.patch
> Suggested-by: Ben Hutchings <ben@decadent.org.uk>
> Cc: Milan Kupcevic <milan@debian.org>
> Signed-off-by: Mathieu Malaterre <malat@debian.org>
> ---
>  fs/ext4/super.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 185f7e61f4cf..10bda040e78f 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5886,5 +5886,6 @@ static void __exit ext4_exit_fs(void)
>  MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas Dilger, Theodore Ts'o and others");
>  MODULE_DESCRIPTION("Fourth Extended Filesystem");
>  MODULE_LICENSE("GPL");
> +MODULE_SOFTDEP("pre: crypto-crc32c");
>  module_init(ext4_init_fs)
>  module_exit(ext4_exit_fs)
> --
> 2.11.0
>
