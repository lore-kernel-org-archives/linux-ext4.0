From: darxus@chaosreigns.com
Subject: Re: Weird filesystem corruption from wayland / radeon / chromium
Date: Tue, 4 Sep 2012 22:48:48 -0400
Message-ID: <20120905024848.GK19158@chaosreigns.com>
References: <20120903220213.GE19158@chaosreigns.com>
 <20120904032919.GJ5066@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from panic.chaosreigns.com ([64.71.152.40]:43670 "EHLO
	panic.chaosreigns.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab2IECss (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Sep 2012 22:48:48 -0400
Content-Disposition: inline
In-Reply-To: <20120904032919.GJ5066@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/03, Theodore Ts'o wrote:
> On Mon, Sep 03, 2012 at 06:02:13PM -0400, darxus@chaosreigns.com wrote:
> > [732715.730069] EXT4-fs error (device sda1): ext4_ext_search_left:1275: inode #21374007: comm flush-8:0: ix (10742) != EXT_FIRST_INDEX (0)
> > [  496.347230] EXT4-fs error (device sda1): ext4_ext_search_left:1275: inode #21374007: comm flush-8:0:ix (10742) != EXT_FIRST_INDEX (0)

> That also seems fairly hard to credit, so I'm going to hope you didn't
> actually run e2fsck to fix the file system corruption....

Ran fsck, reproduced it again.  With chromium on X, no wayland involved.
Just loaded up chromium and started playing a youtube video.  Different one
than last time.  No idea if the youtube video was necessary.  Verified
filesystem was writeable before running chromium, then it wasn't.  

[ 4043.097706] EXT4-fs error (device sda1): ext4_ext_search_left:1275: inode #21374007: comm flush-8:0: ix (10742) != EXT_FIRST_INDEX (0) (depth 1)!
[ 4043.097711] Aborting journal on device sda1-8.
[ 4043.097873] EXT4-fs (sda1): Remounting filesystem read-only
[ 4043.097883] EXT4-fs error (device sda1) in ext4_da_writepages:3033: IO failure
[ 4043.098011] EXT4-fs (sda1): ext4_da_writepages: jbd2_start: 962 pages, ino 21374007; err -30

Same inode again:

$ sudo find . -inum 21374007 -print
./home/darxus/.cache/chromium/Default/Cache/data_3

This was after, from another partition, with this partition
unmounted, doing a smartctl long test, and forced fsck of the
partition, which came back clean (and I created a file named
smart-and-fsck-are-happy-with-this-partition.txt on that partition to
make sure I wasn't getting them confused - it's still where I expect it)
(and updating my backups, and unmounting my backup partitions).

I guess I'm glad it wasn't wayland.  I'm still... very curious what it
could possibly be.


I tried catting the file (Cache/data_3) to /dev/null before running
chromium, and I'm pretty sure I remembered to verify the filesystem was
still writeable after that.

This is ubuntu chromium-browser package version
18.0.1025.168~r134367-0ubuntu0.11.10.1.  Maybe a bad interaction between it
and my Radeon drivers?  (Radeon, not fglrx/catalyst.)


What now?

-- 
"I would believe only in a God that knows how to Dance." - Nietzsche
http://www.ChaosReigns.com
