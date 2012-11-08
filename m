From: Wilmer van der Gaast <wilmer@gaast.net>
Subject: Re: Bug#692104: linux-image-3.2.0-3-amd64: NULL pointer dereference
  in ext4fs
Date: Thu, 08 Nov 2012 22:25:26 +0000
Message-ID: <509C3156.6090500@gaast.net>
References: <50938953.6010001@gaast.net> <1351866830.13356.100.camel@deadeye.wl.decadent.org.uk> <509440A3.5020604@gaast.net> <20121108153048.GA32709@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070401070104090209090801"
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-ext4@vger.kernel.org,
	692104@bugs.debian.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from roy.gaast.net ([80.101.33.21]:46574 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756707Ab2KHWZf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 17:25:35 -0500
In-Reply-To: <20121108153048.GA32709@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070401070104090209090801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello all,

This crash has happened to me three times now, but the last time is is 
five days ago. Seems to have disappeared as mysteriously as it appeared.

On 08-11-12 15:30, Theodore Ts'o wrote:
> On Fri, Nov 02, 2012 at 10:52:35PM +0100, Wilmer van der Gaast wrote:
>> whether my filesystem is corrupted. I'll make an LVM snapshot and
>> then do a full fsck.
>
That fsck was completely clean by the way.

> Did you perform another on-line resize on the file system before it
> failed?
>
I don't think so. I've done one last weekend, after which I've 
experienced one more crash. I'm quite sure that the last on-line resize 
before I reported this bug is quite long ago though, likely before my 
last reboot.

> It looks like a problem which I ran into (and fixed) when adding
> support for online resizing for>  16TB file systems, [...]

The filesystem is not quite that large, just 45G (from 40G).

I've attached tune2fs output for it just in case it helps. It was 
created back in 2010 already apparently, although as an ext3 at the time.

> you resize it?  If it is this bug, the s_group_info array is allocated
> based on the file system size when the file system is mounted.  So it
> would only be happening after a online resize and before the file
> system is unmounted and/or the system is rebooted and the file system
> is mounted again.
>
Hmm, I'm quite sure a long time (and likely a reboot) had passed in 
between the last resize and the first crash last weekend.

It looked like this crash always happened while handling a close() 
syscall issued by Firefox. I've tried stracing my firefox process to see 
which file was causing it, but the crashes had already disappeared by then.

I'll definitely ping this bug if this happens again.


Thanks,

Wilmer v/d Gaast.

-- 
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +

--------------070401070104090209090801
Content-Type: text/plain;
 name="tune2fs.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tune2fs.txt"

tune2fs 1.42.5 (29-Jul-2012)
Filesystem volume name:   <none>
Last mounted on:          /home
Filesystem UUID:          19e51da3-469c-42fa-b027-34b0bdfc402f
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent sparse_super large_file uninit_bg
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              2931840
Block count:              11796480
Reserved block count:     0
Free blocks:              298830
Free inodes:              2850527
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      593
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8144
Inode blocks per group:   509
Filesystem created:       Sat Mar 27 03:51:14 2010
Last mount time:          Sat Nov  3 20:13:39 2012
Last write time:          Mon Nov  5 00:57:02 2012
Mount count:              2
Maximum mount count:      23
Last checked:             Fri Nov  2 21:55:19 2012
Check interval:           15552000 (6 months)
Next check after:         Wed May  1 22:55:19 2013
Lifetime writes:          61 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       73450
Default directory hash:   half_md4
Directory Hash Seed:      b1345721-aad3-4d1b-9bce-a03b338fe7d3
Journal backup:           inode blocks

--------------070401070104090209090801--
