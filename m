From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [GIT PULL] ext4 updates for 3.9
Date: Wed, 27 Feb 2013 16:44:50 +0100
Message-ID: <20130227154450.GA23402@x4>
References: <nsxr4k2kdwv.fsf@closure.thunk.org>
 <20130227124727.GA225@x4>
 <20130227153435.GB5609@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:51195 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab3B0Poy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Feb 2013 10:44:54 -0500
Content-Disposition: inline
In-Reply-To: <20130227153435.GB5609@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013.02.27 at 10:34 -0500, Theodore Ts'o wrote:
> On Wed, Feb 27, 2013 at 01:47:27PM +0100, Markus Trippelsdorf wrote:
> > Just booted todays Linux tree and got the following errors:
> > 
> > ...
> > Feb 27 13:33:31 x4 kernel: EXT4-fs (sda): mounted filesystem with ordered data mode. Opts: (null)
> > ...
> > Feb 27 13:33:32 x4 kernel: EXT4-fs error (device sda): ext4_find_dest_de:1657: inode #70647809: block 14164000: comm cupsd: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2569822761, rec_len=3837, name_len=1
> > Feb 27 13:33:32 x4 kernel: EXT4-fs error (device sda): ext4_find_dest_de:1657: inode #70911401: block 15213579: comm pdnsd: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2000846358, rec_len=36782, name_len=120
> 
> Is this reproducible? 

Haven't checked yet, because I got scared.

> Is there anything special about your system?  How much memory do you
> have?  What kind of device is /dev/sda?  What sort of workload did you
> have running on your system before the failure?

There is nothing special about my system. /dev/sda is a standard SATA
drive: 
 Model Family:     Seagate Barracuda Green (AF)
 Device Model:     ST1500DL003-9VT16L
The error happens during boot.
I use ECC memory.

> Also, can you send us the output of "debugfs -R "stat <70647809>"
> /dev/sda" so I can confirm that block 14164000 really is assigned to
> inode 70647809?  The one potential cause of this error I can think of
> that might be related to recent changes in ext4 is if the extent
> status tree had the wrong logical-to-physical mapping cached for the
> directory inode.

Inode: 70647809   Type: directory    Mode:  0755   Flags: 0x80000
Generation: 4138624941    Version: 0x00000000:0000000d
User:     0   Group:     0   Size: 4096
File ACL: 0    Directory ACL: 0
Links: 13   Blockcount: 8
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x50ab80de:2c77d5bc -- Tue Nov 20 14:08:46 2012
 atime: 0x50aa5519:c556886c -- Mon Nov 19 16:49:45 2012
 mtime: 0x50ab80de:2c77d5bc -- Tue Nov 20 14:08:46 2012
crtime: 0x50aa4a81:06bc6fd0 -- Mon Nov 19 16:04:33 2012
Size of extra inode fields: 28
EXTENTS:
(0):282599456

-- 
Markus
