From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: udevd / ext4 issue mounting 2.6.35-rc5
Date: Fri, 23 Jul 2010 09:49:51 -0700
Message-ID: <AANLkTikwQg6ZC-5tAzBExnNSx5J7Zgyc14sPXE7KqLW5@mail.gmail.com>
References: <AANLkTilYEJMD_s5Iupru24WPXasxI_jE8JVJ35Nf8hrN@mail.gmail.com>
	<AANLkTinQKhvnAIa-1qXxIWFHCeE0ajM-07eYOAH1QA_J@mail.gmail.com>
	<AANLkTikY0eeq1Ufs-UOCiHYXu_314HUnw7ESK5ktocWV@mail.gmail.com>
	<AANLkTimNFIc8Ygg4O2NPHCYHk1G3dLBhYA2N9JSeAbdt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
	linux-kernel@vger.kernel.org
To: Daniel J Blueman <daniel.blueman@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39708 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab0GWQuL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Jul 2010 12:50:11 -0400
In-Reply-To: <AANLkTimNFIc8Ygg4O2NPHCYHk1G3dLBhYA2N9JSeAbdt@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 22, 2010 at 2:10 AM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> On 22 July 2010 02:06, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Wed, Jul 21, 2010 at 1:43 AM, Daniel J Blueman
>> <daniel.blueman@gmail.com> wrote:
>>> Hi Luis,
>>>
>>> On 21 July 2010 01:36, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>>> I have been reluctant to boot to 2.6.35-rc due to the large set of
>>>> regression list and the amount of work I needed to actually get do=
ne
>>>> on 2.6.35. Last I checked the regression list it was getting small=
 so
>>>> I gave it a spin today. No luck. I get some bootup error from udev=
d
>>>> and ext2/ext3/ext4, something like this:
>>>>
>>>> EXT3-fs (sda1): error: couldn't mount because of unsupported optio=
nal
>>>> features (240)
>>>> EXT2-fs (sda1): error: couldn't mount because of unsupported optio=
nal
>>>> features (240)
>>>> EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (=
null)
>>>
>>> This succeeded.
>>
>> Heh, OK :)
>>
>>>> VFS: Mounted root (ext4 filesystem) readonly on device 8:1
>>>> Freeing unused kernel memory: 708k freed
>>>> Write protecting the kernel read-only data: 102040k
>>>> Freeing unused kernel memory: 764k freed
>>>> Freeing unused kernel memory: 1796k freed
>>>> udevd: failed to create queue file: No such file or directory
>>>> udevd: error creating queue file
>>>
>>> It looks like you need to enable:
>>>
>>> CONFIG_DEVTMPFS
>>> CONFIG_DEVTMPFS_MOUNT
>>
>> Thanks, it also turned out that when I upgraded from Ubuntu 9.10 to
>> Ubuntu 10.04 it replaced my own /sbin/installkernel so this was like=
ly
>> another issue. My /sbin/installkernel changes allow for easy initram=
fs
>> installation on Debian/Ubuntu but my patches have been ignored my th=
e
>> maintainer.
>>
>> --- installkernel-ubuntu-10.04 =C2=A02010-07-21 18:03:34.607678010 -=
0700
>> +++ installkernel =C2=A0 =C2=A0 =C2=A0 2010-01-29 13:17:10.000000000=
 -0800
>> @@ -36,7 +36,8 @@
>> =C2=A0# Create backups of older versions before installing
>> =C2=A0updatever () {
>> =C2=A0 if [ -f "$dir/$1-$ver" ] ; then
>> - =C2=A0 =C2=A0mv "$dir/$1-$ver" "$dir/$1-$ver.old"
>> + =C2=A0 =C2=A0#mv "$dir/$1-$ver" "$dir/$1-$ver.old"
>> + =C2=A0 =C2=A0rm -f "$dir/$1-$ver" "$dir/$1-$ver.old"
>> =C2=A0 fi
>>
>> =C2=A0 cat "$2" > "$dir/$1-$ver"
>> @@ -75,5 +76,16 @@
>> =C2=A0if [ -f "$config" ] ; then
>> =C2=A0 updatever config "$config"
>> =C2=A0fi
>> +
>> +LSB_RED_ID=3D$(/usr/bin/lsb_release -i -s)
>> +
>> +case $LSB_RED_ID in
>> +"Ubuntu")
>> + =C2=A0 =C2=A0 =C2=A0 update-initramfs -c -k =C2=A0$ver
>> + =C2=A0 =C2=A0 =C2=A0 update-grub
>> + =C2=A0 =C2=A0 =C2=A0 ;;
>> +*)
>> + =C2=A0 =C2=A0 =C2=A0 ;;
>> +esac
>>
>> =C2=A0exit 0
>>
>> But anyway I also now get another boot failure with:
>>
>> mount: mounting /dev on /root/dev failed: No such file or directory
>> mount: mounting /sys on /root/sys failed: No such file or directory
>
> Hmm...the scripts in the initrd are not doing what is expected -
> perhaps if you didn't use:
> linux$ fakeroot make-kpkg --append-to-version -luis1 --initrd kernel-=
image

I am not using that to build my kernels I just build my kernels with

make
sudo make modules_install install

> ...or if there are eg initrd script modifications on the filesystem
> when it cooked the initd.

I haven't modified any initrd scripts.

> You could just try eg:
> http://archive.ubuntu.com/ubuntu/pool/main/l/linux/linux-image-2.6.35=
-9-generic_2.6.35-9.14_amd64.deb

Going to give that a shot, thanks.

> ...although it will regenerate it's initrd, so may suffer the same fa=
te.

OK we'll see then.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
