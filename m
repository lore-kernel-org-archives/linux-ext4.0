From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: udevd / ext4 issue mounting 2.6.35-rc5
Date: Thu, 22 Jul 2010 10:10:39 +0100
Message-ID: <AANLkTimNFIc8Ygg4O2NPHCYHk1G3dLBhYA2N9JSeAbdt@mail.gmail.com>
References: <AANLkTilYEJMD_s5Iupru24WPXasxI_jE8JVJ35Nf8hrN@mail.gmail.com>
	<AANLkTinQKhvnAIa-1qXxIWFHCeE0ajM-07eYOAH1QA_J@mail.gmail.com>
	<AANLkTikY0eeq1Ufs-UOCiHYXu_314HUnw7ESK5ktocWV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
	linux-kernel@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTikY0eeq1Ufs-UOCiHYXu_314HUnw7ESK5ktocWV@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 22 July 2010 02:06, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Wed, Jul 21, 2010 at 1:43 AM, Daniel J Blueman
> <daniel.blueman@gmail.com> wrote:
>> Hi Luis,
>>
>> On 21 July 2010 01:36, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>> I have been reluctant to boot to 2.6.35-rc due to the large set of
>>> regression list and the amount of work I needed to actually get don=
e
>>> on 2.6.35. Last I checked the regression list it was getting small =
so
>>> I gave it a spin today. No luck. I get some bootup error from udevd
>>> and ext2/ext3/ext4, something like this:
>>>
>>> EXT3-fs (sda1): error: couldn't mount because of unsupported option=
al
>>> features (240)
>>> EXT2-fs (sda1): error: couldn't mount because of unsupported option=
al
>>> features (240)
>>> EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (n=
ull)
>>
>> This succeeded.
>
> Heh, OK :)
>
>>> VFS: Mounted root (ext4 filesystem) readonly on device 8:1
>>> Freeing unused kernel memory: 708k freed
>>> Write protecting the kernel read-only data: 102040k
>>> Freeing unused kernel memory: 764k freed
>>> Freeing unused kernel memory: 1796k freed
>>> udevd: failed to create queue file: No such file or directory
>>> udevd: error creating queue file
>>
>> It looks like you need to enable:
>>
>> CONFIG_DEVTMPFS
>> CONFIG_DEVTMPFS_MOUNT
>
> Thanks, it also turned out that when I upgraded from Ubuntu 9.10 to
> Ubuntu 10.04 it replaced my own /sbin/installkernel so this was likel=
y
> another issue. My /sbin/installkernel changes allow for easy initramf=
s
> installation on Debian/Ubuntu but my patches have been ignored my the
> maintainer.
>
> --- installkernel-ubuntu-10.04 =A02010-07-21 18:03:34.607678010 -0700
> +++ installkernel =A0 =A0 =A0 2010-01-29 13:17:10.000000000 -0800
> @@ -36,7 +36,8 @@
> =A0# Create backups of older versions before installing
> =A0updatever () {
> =A0 if [ -f "$dir/$1-$ver" ] ; then
> - =A0 =A0mv "$dir/$1-$ver" "$dir/$1-$ver.old"
> + =A0 =A0#mv "$dir/$1-$ver" "$dir/$1-$ver.old"
> + =A0 =A0rm -f "$dir/$1-$ver" "$dir/$1-$ver.old"
> =A0 fi
>
> =A0 cat "$2" > "$dir/$1-$ver"
> @@ -75,5 +76,16 @@
> =A0if [ -f "$config" ] ; then
> =A0 updatever config "$config"
> =A0fi
> +
> +LSB_RED_ID=3D$(/usr/bin/lsb_release -i -s)
> +
> +case $LSB_RED_ID in
> +"Ubuntu")
> + =A0 =A0 =A0 update-initramfs -c -k =A0$ver
> + =A0 =A0 =A0 update-grub
> + =A0 =A0 =A0 ;;
> +*)
> + =A0 =A0 =A0 ;;
> +esac
>
> =A0exit 0
>
> But anyway I also now get another boot failure with:
>
> mount: mounting /dev on /root/dev failed: No such file or directory
> mount: mounting /sys on /root/sys failed: No such file or directory

Hmm...the scripts in the initrd are not doing what is expected -
perhaps if you didn't use:
linux$ fakeroot make-kpkg --append-to-version -luis1 --initrd kernel-im=
age

=2E..or if there are eg initrd script modifications on the filesystem
when it cooked the initd.

You could just try eg:
http://archive.ubuntu.com/ubuntu/pool/main/l/linux/linux-image-2.6.35-9=
-generic_2.6.35-9.14_amd64.deb

=2E..although it will regenerate it's initrd, so may suffer the same fa=
te.

> http://bombadil.infradead.org/~mcgrof/images/2010/bleh-boot-2.6.35-rc=
5.jpg
>
> =A0Luis
--=20
Daniel J Blueman
