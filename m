From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: breaking ext4 to test recovery
Date: Thu, 31 Mar 2011 12:22:40 -1000
Message-ID: <9FF11C19-1C9F-4CF4-80C3-CDF0FB8D5E47@dilger.ca>
References: <25B374CC0D9DFB4698BB331F82CD0CF20D61B8@wdscexbe08.sc.wdc.com> <4D91E39A.3000800@redhat.com> <20110329143305.GA6057@bitwizard.nl> <63C35C25-AC8A-49AC-B1C4-CC1FDC13F3A5@whamcloud.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>,
	Eric Sandeen <sandeen@redhat.com>,
	Daniel Taylor <Daniel.Taylor@wdc.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:38192 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab1CaWWr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Mar 2011 18:22:47 -0400
In-Reply-To: <63C35C25-AC8A-49AC-B1C4-CC1FDC13F3A5@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-03-31, at 12:11 PM, Andreas Dilger wrote:
> There is a patch we have in the Lustre version of e2fsprogs called "ibadness" that has e2fsck track the number of errors hit for each inode, and if an inode exceeds a threshold of errors then e2fsck will offer to clear the inode instead of making small fixes to turn a garbage inode into something that looks half correct.

http://git.whamcloud.com/?p=tools/e2fsprogs.git;a=blob_plain;f=patches/e2fsprogs-ibadness-counter.patch;hb=8dd11ed9bdf0914d57d78d0c387bd21f747c1d29

> One of the tests that we developed for this feature was to write both random garbage into the filesystem, as well as copying data blocks from one part of the filesystem to another. This is much more difficult to fix because there may be random inode blocks that have what looks like valid inodes in them, but they are in the wrong location.

This one is already in the e2fsprogs upstream "f_random_corruption", though it could stand some improvements.

> When/if we get proper block checksums this kind of corruption would be easily detected, because the checksum (which hopefully includes the block number) would be wrong even if the data looks sane. 
> 
> Cheers, Andreas
> 
> On 2011-03-29, at 4:33 AM, Rogier Wolff <R.E.Wolff@BitWizard.nl> wrote:
> 
>> On Tue, Mar 29, 2011 at 08:50:18AM -0500, Eric Sandeen wrote:
>>> Another tool which can be useful for this sort of thing is
>>> fsfuzzer.  It writes garbage; using dd to write zeros actually
>>> might be "nice" corruption.
>> 
>> Besides writing blocks of "random data", you could write blocks with a
>> small percentage of bits (byte) set to non-zero, or just toggle a
>> configurable number of bits (bytes). This is slightly more devious than just
>> "random data".
>> 
>> If you try to verify the integrity of a block full of random data, you
>> can quickly determine that it is completely bogus (I don't think that
>> e2fsck already exploits this as I've seen it get this wrong).
>> 
>> If you have an indirect block, and it contains: 
>> 
>> 00000  72 6f 6f 74 3a 78 3a 30   3a 30 3a 72 6f 6f 74 3a   root:x:0:0:root:
>> 00010  2f 72 6f 6f 74 3a 2f 62   69 6e 2f 62 61 73 68 0a   /root:/bin/bash.
>> 00020  64 61 65 6d 6f 6e 3a 78   3a 31 3a 31 3a 64 61 65   daemon:x:1:1:dae
>> 00030  6d 6f 6e 3a 2f 75 73 72   2f 73 62 69 6e 3a 2f 62   mon:/usr/sbin:/b
>> 00040  69 6e 2f 73 68 0a 62 69   6e 3a 78 3a 32 3a 32 3a   in/sh.bin:x:2:2:
>> 00050  62 69 6e 3a 2f 62 69 6e   3a 2f 62 69 6e 2f 73 68   bin:/bin:/bin/sh
>> 00060  0a 73 79 73 3a 78 3a 33   3a 33 3a 73 79 73 3a 2f   .sys:x:3:3:sys:/
>> 00070  64 65 76 3a 2f 62 69 6e   2f 73 68 0a 73 79 6e 63   dev:/bin/sh.sync
>> 00080  3a 78 3a 34 3a 36 35 35   33 34 3a 73 79 6e 63 3a   :x:4:65534:sync:
>> 00090  2f 62 69 6e 3a 2f 62 69   6e 2f 73 79 6e 63 0a 67   /bin:/bin/sync.g
>> 
>> You can see that the block numbers that are represented here are all
>> bad. In this case, one of the options should be to discard the whole
>> indirect block. If you happen to find a few "valid" block numbers
>> here, they are likely to be bogus. It is counterproductive to check
>> those for duplicate allocation, or to mark them as used if they happen
>> to be free.
>> 
>>  Roger. 
>> 
>> -- 
>> ** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
>> **    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
>> *-- BitWizard writes Linux device drivers for any device you may have! --*
>> Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
>> Does it sit on the couch all day? Is it unemployed? Please be specific! 
>> Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





