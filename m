From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: udevd / ext4 issue mounting 2.6.35-rc5
Date: Wed, 21 Jul 2010 09:43:43 +0100
Message-ID: <AANLkTinQKhvnAIa-1qXxIWFHCeE0ajM-07eYOAH1QA_J@mail.gmail.com>
References: <AANLkTilYEJMD_s5Iupru24WPXasxI_jE8JVJ35Nf8hrN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
	linux-kernel@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTilYEJMD_s5Iupru24WPXasxI_jE8JVJ35Nf8hrN@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Luis,

On 21 July 2010 01:36, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> I have been reluctant to boot to 2.6.35-rc due to the large set of
> regression list and the amount of work I needed to actually get done
> on 2.6.35. Last I checked the regression list it was getting small so
> I gave it a spin today. No luck. I get some bootup error from udevd
> and ext2/ext3/ext4, something like this:
>
> EXT3-fs (sda1): error: couldn't mount because of unsupported optional
> features (240)
> EXT2-fs (sda1): error: couldn't mount because of unsupported optional
> features (240)
> EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (nul=
l)

This succeeded.

> VFS: Mounted root (ext4 filesystem) readonly on device 8:1
> Freeing unused kernel memory: 708k freed
> Write protecting the kernel read-only data: 102040k
> Freeing unused kernel memory: 764k freed
> Freeing unused kernel memory: 1796k freed
> udevd: failed to create queue file: No such file or directory
> udevd: error creating queue file

It looks like you need to enable:

CONFIG_DEVTMPFS
CONFIG_DEVTMPFS_MOUNT

> The picture:
>
> http://bombadil.infradead.org/~mcgrof/images/2010/ext4-option-240-fai=
ls-2.6.35-rc5.jpg
>
> I then decided to pull Linus' latest but it didn't help either. I
> don't recall seeing this reported on the regression list yet.
> Essentially I cannot move forward after this happens, even on single
> user boot and disabling wireless, which was my main suspect first as
> I'm using wireless-testing.git.
>
> I can certainly bisect but first wanted to see if this was already kn=
own.
>
>
> mcgrof@tux ~/wireless-testing (git::sfo-02)$ grep CONFIG_EXT .config
> CONFIG_EXTRA_FIRMWARE=3D""
> CONFIG_EXT2_FS=3Dy
> CONFIG_EXT2_FS_XATTR=3Dy
> CONFIG_EXT2_FS_POSIX_ACL=3Dy
> CONFIG_EXT2_FS_SECURITY=3Dy
> # CONFIG_EXT2_FS_XIP is not set
> CONFIG_EXT3_FS=3Dy
> # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
> CONFIG_EXT3_FS_XATTR=3Dy
> CONFIG_EXT3_FS_POSIX_ACL=3Dy
> CONFIG_EXT3_FS_SECURITY=3Dy
> CONFIG_EXT4_FS=3Dy
> CONFIG_EXT4_FS_XATTR=3Dy
> CONFIG_EXT4_FS_POSIX_ACL=3Dy
> CONFIG_EXT4_FS_SECURITY=3Dy
> # CONFIG_EXT4_DEBUG is not set
>
> Let me know if you need more details.
>
> =A0Luis
--=20
Daniel J Blueman
