From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: udevd / ext4 issue mounting 2.6.35-rc5
Date: Tue, 20 Jul 2010 17:36:00 -0700
Message-ID: <AANLkTilYEJMD_s5Iupru24WPXasxI_jE8JVJ35Nf8hrN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-kernel@vger.kernel.org,
	Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:41453 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab0GUAgV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jul 2010 20:36:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have been reluctant to boot to 2.6.35-rc due to the large set of
regression list and the amount of work I needed to actually get done
on 2.6.35. Last I checked the regression list it was getting small so
I gave it a spin today. No luck. I get some bootup error from udevd
and ext2/ext3/ext4, something like this:

EXT3-fs (sda1): error: couldn't mount because of unsupported optional
features (240)
EXT2-fs (sda1): error: couldn't mount because of unsupported optional
features (240)
EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 8:1
Freeing unused kernel memory: 708k freed
Write protecting the kernel read-only data: 102040k
Freeing unused kernel memory: 764k freed
Freeing unused kernel memory: 1796k freed
udevd: failed to create queue file: No such file or directory
udevd: error creating queue file

The picture:

http://bombadil.infradead.org/~mcgrof/images/2010/ext4-option-240-fails-2.6.35-rc5.jpg

I then decided to pull Linus' latest but it didn't help either. I
don't recall seeing this reported on the regression list yet.
Essentially I cannot move forward after this happens, even on single
user boot and disabling wireless, which was my main suspect first as
I'm using wireless-testing.git.

I can certainly bisect but first wanted to see if this was already known.


mcgrof@tux ~/wireless-testing (git::sfo-02)$ grep CONFIG_EXT .config
CONFIG_EXTRA_FIRMWARE=""
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set

Let me know if you need more details.

  Luis
