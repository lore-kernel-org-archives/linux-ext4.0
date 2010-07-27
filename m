From: Stefan Bader <stefan.bader@canonical.com>
Subject: Re: udevd / ext4 issue mounting 2.6.35-rc5
Date: Tue, 27 Jul 2010 14:34:52 +0200
Message-ID: <4C4ED26C.5030502@canonical.com>
References: <AANLkTilYEJMD_s5Iupru24WPXasxI_jE8JVJ35Nf8hrN@mail.gmail.com> 	<AANLkTinQKhvnAIa-1qXxIWFHCeE0ajM-07eYOAH1QA_J@mail.gmail.com> 	<AANLkTikY0eeq1Ufs-UOCiHYXu_314HUnw7ESK5ktocWV@mail.gmail.com> 	<AANLkTimNFIc8Ygg4O2NPHCYHk1G3dLBhYA2N9JSeAbdt@mail.gmail.com> 	<AANLkTikwQg6ZC-5tAzBExnNSx5J7Zgyc14sPXE7KqLW5@mail.gmail.com> 	<AANLkTimTdy2DmcdXtgFvtREMX8bMADk73Oz5bwpeHw6H@mail.gmail.com> <AANLkTi=9Y+v6ikUi=UH1BNKgcOFfp13Q1YowjJVrRSA9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
	linux-ext4@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:40742 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab0G0Me4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jul 2010 08:34:56 -0400
In-Reply-To: <AANLkTi=9Y+v6ikUi=UH1BNKgcOFfp13Q1YowjJVrRSA9@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/27/2010 01:43 AM, Luis R. Rodriguez wrote:
> On Fri, Jul 23, 2010 at 10:56 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Fri, Jul 23, 2010 at 9:49 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>> On Thu, Jul 22, 2010 at 2:10 AM, Daniel J Blueman
>>> <daniel.blueman@gmail.com> wrote:
>>>> On 22 July 2010 02:06, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>>>> On Wed, Jul 21, 2010 at 1:43 AM, Daniel J Blueman
>>>>> <daniel.blueman@gmail.com> wrote:
>>>>>> Hi Luis,
>>>>>>
>>>>>> On 21 July 2010 01:36, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>>>>>> I have been reluctant to boot to 2.6.35-rc due to the large set of
>>>>>>> regression list and the amount of work I needed to actually get done
>>>>>>> on 2.6.35. Last I checked the regression list it was getting small so
>>>>>>> I gave it a spin today. No luck. I get some bootup error from udevd
>>>>>>> and ext2/ext3/ext4, something like this:
>>>>>>>
>>>>>>> EXT3-fs (sda1): error: couldn't mount because of unsupported optional
>>>>>>> features (240)
>>>>>>> EXT2-fs (sda1): error: couldn't mount because of unsupported optional
>>>>>>> features (240)
>>>>>>> EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
>>>>>>
>>>>>> This succeeded.
>>>>>
>>>>> Heh, OK :)
>>>>>
>>>>>>> VFS: Mounted root (ext4 filesystem) readonly on device 8:1
>>>>>>> Freeing unused kernel memory: 708k freed
>>>>>>> Write protecting the kernel read-only data: 102040k
>>>>>>> Freeing unused kernel memory: 764k freed
>>>>>>> Freeing unused kernel memory: 1796k freed
>>>>>>> udevd: failed to create queue file: No such file or directory
>>>>>>> udevd: error creating queue file
>>>>>>
>>>>>> It looks like you need to enable:
>>>>>>
>>>>>> CONFIG_DEVTMPFS
>>>>>> CONFIG_DEVTMPFS_MOUNT
>>>>>
>>>>> Thanks, it also turned out that when I upgraded from Ubuntu 9.10 to
>>>>> Ubuntu 10.04 it replaced my own /sbin/installkernel so this was likely
>>>>> another issue. My /sbin/installkernel changes allow for easy initramfs
>>>>> installation on Debian/Ubuntu but my patches have been ignored my the
>>>>> maintainer.
>>>>>
>>>>> --- installkernel-ubuntu-10.04  2010-07-21 18:03:34.607678010 -0700
>>>>> +++ installkernel       2010-01-29 13:17:10.000000000 -0800
>>>>> @@ -36,7 +36,8 @@
>>>>>  # Create backups of older versions before installing
>>>>>  updatever () {
>>>>>   if [ -f "$dir/$1-$ver" ] ; then
>>>>> -    mv "$dir/$1-$ver" "$dir/$1-$ver.old"
>>>>> +    #mv "$dir/$1-$ver" "$dir/$1-$ver.old"
>>>>> +    rm -f "$dir/$1-$ver" "$dir/$1-$ver.old"
>>>>>   fi
>>>>>
>>>>>   cat "$2" > "$dir/$1-$ver"
>>>>> @@ -75,5 +76,16 @@
>>>>>  if [ -f "$config" ] ; then
>>>>>   updatever config "$config"
>>>>>  fi
>>>>> +
>>>>> +LSB_RED_ID=$(/usr/bin/lsb_release -i -s)
>>>>> +
>>>>> +case $LSB_RED_ID in
>>>>> +"Ubuntu")
>>>>> +       update-initramfs -c -k  $ver
>>>>> +       update-grub
>>>>> +       ;;
>>>>> +*)
>>>>> +       ;;
>>>>> +esac
>>>>>
>>>>>  exit 0
>>>>>
>>>>> But anyway I also now get another boot failure with:
>>>>>
>>>>> mount: mounting /dev on /root/dev failed: No such file or directory
>>>>> mount: mounting /sys on /root/sys failed: No such file or directory
>>>>
>>>> Hmm...the scripts in the initrd are not doing what is expected -
>>>> perhaps if you didn't use:
>>>> linux$ fakeroot make-kpkg --append-to-version -luis1 --initrd kernel-image
>>>
>>> I am not using that to build my kernels I just build my kernels with
>>>
>>> make
>>> sudo make modules_install install
>>>
>>>> ...or if there are eg initrd script modifications on the filesystem
>>>> when it cooked the initd.
>>>
>>> I haven't modified any initrd scripts.
>>>
>>>> You could just try eg:
>>>> http://archive.ubuntu.com/ubuntu/pool/main/l/linux/linux-image-2.6.35-9-generic_2.6.35-9.14_amd64.deb
>>
>> Fun, so that kernel actually works but the one I am building from
>> wireless-testing.git does not. The curious thing is it doesn't boot
>> even if I remove my 802.11 module... so something is fishy. This is
>> likely a config issue. After booting with the above kernel though I
>> generated a new one with
>>
>> make localmodconfig
>>
>> and then enabled my 802.11 modules. Still, no luck.. Going to reset my
>> tree, I had manually merged Linus' latest stuff in but I don't think
>> this should matter.
> 
> That didn't work, but it seems this was just my config, the same
> config worked on older kernels but I am not motivated enough to figure
> out what I actually did enable which fixed this. But just for the
> record
> 
> config which did not work:
> 
> http://bombadil.infradead.org/~mcgrof/configs/2010/config-issue/config-old.txt
> 
> config which worked:
> 
> http://bombadil.infradead.org/~mcgrof/configs/2010/config-issue/config.txt
> 
> The diff:
> 
> http://bombadil.infradead.org/~mcgrof/configs/2010/config-issue/diff-34-35.patch
> 
>   Luis
> 

Hm, I hope I did not miss some info in the threads above, but have you tried to
use the config in /boot/ as a base for your new config with make oldconfig?
I think to remember make modules_install purges all existing modules under
kernel before installing the new ones. So likely there is something essential
going away when rebuilding the initrd. The messages sound like basic root fs is
not there, so it misses all the mount points. But I admit to be too lazy to walk
all the config.

-Stefan
