From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: udevd / ext4 issue mounting 2.6.35-rc5
Date: Wed, 21 Jul 2010 18:06:06 -0700
Message-ID: <AANLkTikY0eeq1Ufs-UOCiHYXu_314HUnw7ESK5ktocWV@mail.gmail.com>
References: <AANLkTilYEJMD_s5Iupru24WPXasxI_jE8JVJ35Nf8hrN@mail.gmail.com>
	<AANLkTinQKhvnAIa-1qXxIWFHCeE0ajM-07eYOAH1QA_J@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <kernel-team-bounces@lists.ubuntu.com>
In-Reply-To: <AANLkTinQKhvnAIa-1qXxIWFHCeE0ajM-07eYOAH1QA_J@mail.gmail.com>
List-Unsubscribe: <https://lists.ubuntu.com/mailman/listinfo/kernel-team>,
	<mailto:kernel-team-request@lists.ubuntu.com?subject=unsubscribe>
List-Archive: <https://lists.ubuntu.com/archives/kernel-team>
List-Post: <mailto:kernel-team@lists.ubuntu.com>
List-Help: <mailto:kernel-team-request@lists.ubuntu.com?subject=help>
List-Subscribe: <https://lists.ubuntu.com/mailman/listinfo/kernel-team>,
	<mailto:kernel-team-request@lists.ubuntu.com?subject=subscribe>
Sender: kernel-team-bounces@lists.ubuntu.com
Errors-To: kernel-team-bounces@lists.ubuntu.com
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 21, 2010 at 1:43 AM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> Hi Luis,
>
> On 21 July 2010 01:36, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> I have been reluctant to boot to 2.6.35-rc due to the large set of
>> regression list and the amount of work I needed to actually get done
>> on 2.6.35. Last I checked the regression list it was getting small so
>> I gave it a spin today. No luck. I get some bootup error from udevd
>> and ext2/ext3/ext4, something like this:
>>
>> EXT3-fs (sda1): error: couldn't mount because of unsupported optional
>> features (240)
>> EXT2-fs (sda1): error: couldn't mount because of unsupported optional
>> features (240)
>> EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
>
> This succeeded.

Heh, OK :)

>> VFS: Mounted root (ext4 filesystem) readonly on device 8:1
>> Freeing unused kernel memory: 708k freed
>> Write protecting the kernel read-only data: 102040k
>> Freeing unused kernel memory: 764k freed
>> Freeing unused kernel memory: 1796k freed
>> udevd: failed to create queue file: No such file or directory
>> udevd: error creating queue file
>
> It looks like you need to enable:
>
> CONFIG_DEVTMPFS
> CONFIG_DEVTMPFS_MOUNT

Thanks, it also turned out that when I upgraded from Ubuntu 9.10 to
Ubuntu 10.04 it replaced my own /sbin/installkernel so this was likely
another issue. My /sbin/installkernel changes allow for easy initramfs
installation on Debian/Ubuntu but my patches have been ignored my the
maintainer.

--- installkernel-ubuntu-10.04	2010-07-21 18:03:34.607678010 -0700
+++ installkernel	2010-01-29 13:17:10.000000000 -0800
@@ -36,7 +36,8 @@
 # Create backups of older versions before installing
 updatever () {
   if [ -f "$dir/$1-$ver" ] ; then
-    mv "$dir/$1-$ver" "$dir/$1-$ver.old"
+    #mv "$dir/$1-$ver" "$dir/$1-$ver.old"
+    rm -f "$dir/$1-$ver" "$dir/$1-$ver.old"
   fi

   cat "$2" > "$dir/$1-$ver"
@@ -75,5 +76,16 @@
 if [ -f "$config" ] ; then
   updatever config "$config"
 fi
+
+LSB_RED_ID=$(/usr/bin/lsb_release -i -s)
+
+case $LSB_RED_ID in
+"Ubuntu")
+	update-initramfs -c -k  $ver
+	update-grub
+	;;
+*)
+	;;
+esac

 exit 0

But anyway I also now get another boot failure with:

mount: mounting /dev on /root/dev failed: No such file or directory
mount: mounting /sys on /root/sys failed: No such file or directory

http://bombadil.infradead.org/~mcgrof/images/2010/bleh-boot-2.6.35-rc5.jpg

 Luis
