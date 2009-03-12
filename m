From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: BUG at fs/ext4/mballoc.c:3295
Date: Thu, 12 Mar 2009 12:07:51 -0500
Message-ID: <49B94167.4070409@redhat.com>
References: <49B93E44.8070109@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58784 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879AbZCLRIK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Mar 2009 13:08:10 -0400
In-Reply-To: <49B93E44.8070109@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thiemo Nagel wrote:
> Hello,
> 
> the following can be observed reproducibly with 2.6.29-rc7 when filling 
> up a very small (2MB) file system:
> 
> dd if=/dev/zero of=/file/inside/small/filesystem
> 
> hangs, dmesg output is:
> 
> [  602.831279] EXT4-fs: barriers enabled
> [  602.862751] EXT4-fs warning: mounting fs with errors, running e2fsck 
> is recommended
> [  602.864165] kjournald2 starting: pid 5414, dev loop0:8, commit 
> interval 5 seconds
> [  602.864318] EXT4 FS on loop0, internal journal on loop0:8
> [  602.864325] EXT4-fs: delayed allocation enabled
> [  602.864348] EXT4-fs: file extents enabled
> [  602.864669] EXT4-fs: mballoc enabled
> [  602.864674] EXT4-fs: recovery complete.
> [  602.869466] EXT4-fs: mounted filesystem loop0 with ordered data mode
> [  623.000911] JBD: barrier-based sync failed on loop0:8 - disabling 
> barriers
> [  633.432299] ------------[ cut here ]------------
> [  633.432329] kernel BUG at fs/ext4/mballoc.c:3295!

I don't see it:

# dd if=/dev/zero of=2mbfile bs=1M count=2
# mkfs.ext4 -F 2mbfile
# mount -o loop 2mbfile mnt/
# dd if=/dev/zero of=mnt/file
dd: writing to `mnt/file': No space left on device
1917+0 records in
1916+0 records out
980992 bytes (981 kB) copied, 0.0162723 s, 60.3 MB/s

is this more or less what you did?

-Eric
