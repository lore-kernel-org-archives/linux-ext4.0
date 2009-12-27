From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: 2.6.33-rc1: kernel BUG at fs/ext4/inode.c:1063 (sparc)
Date: Mon, 28 Dec 2009 02:02:52 +0300
Message-ID: <a4423d670912271502n13957e8boc168fdc75444dc09@mail.gmail.com>
References: <a4423d670912241428n6917d2adsad887548612cf8ce@mail.gmail.com>
	 <a4423d670912241449y2da43d5fi3e5a18c114b84178@mail.gmail.com>
	 <87hbrfdylc.fsf@openvz.org>
	 <a4423d670912251133u795338a4wd32d5cdef8c36c75@mail.gmail.com>
	 <87eimir4yk.fsf@openvz.org>
	 <a4423d670912271232y5bb928f7wb667ca71f1a93f8a@mail.gmail.com>
	 <20091227225216.GB4429@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: tytso@mit.edu, Alexander Beregalov <a.beregalov@gmail.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.or
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:46537 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbZL0XCy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Dec 2009 18:02:54 -0500
In-Reply-To: <20091227225216.GB4429@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/12/28  <tytso@mit.edu>:
> On Sun, Dec 27, 2009 at 11:32:25PM +0300, Alexander Beregalov wrote:
>> >> I will try to crosscompile the kernel with Ted's patch on another host.
>>
>> Here is output of 2.6.33-rc2 plus Ted's patch
>>
>> EXT4-fs (sda1): inode #1387643: mdb_free (1) < mdb_claim (2) BUG
>
> OK, can you give me the output of:
>
> debugfs /dev/sda1
> debugfs: stat <1387643>
> debugfs: ncheck 1387643
> debugfs: quit

Cleaning of CCache does not help.

debugfs 1.41.9 (22-Aug-2009)
debugfs:  stat <1387643>
Inode: 1387643   Type: regular    Mode:  0644   Flags: 0x0
Generation: 2004186252    Version: 0x00000000:00000001
User:  1000   Group:  1003   Size: 11028803
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 21576
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x4b37d65c:04b0870a -- Mon Dec 28 00:49:16 2009
 atime: 0x4b37d65a:2803e3e5 -- Mon Dec 28 00:49:14 2009
 mtime: 0x4b37d65c:04b0870a -- Mon Dec 28 00:49:16 2009
crtime: 0x5ad6374b:2803e3e5 -- Tue Apr 17 22:04:59 2018
Size of extra inode fields: 28
BLOCKS:
(0-11):172032-172043, (IND):165412, (12-1035):172044-173067,
(DIND):165380, (IND):165381, (1036-2047):173068-174079,
(2048-2059):188416-188427, (IND):165414, (2060-2692):188428-189060
TOTAL: 2697

debugfs:  ncheck 1387643
Inode   Pathname
1387643 /home/alexb/linux-2.6/kernel/built-in.o


~/linux-2.6 $ rm kernel/built-in.o
~/linux-2.6 $ sync
~/linux-2.6 $ kmake
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  LD      kernel/built-in.o
  LD [M]  fs/btrfs/btrfs.o
fs/btrfs/relocation.o: file not recognized: File truncated
