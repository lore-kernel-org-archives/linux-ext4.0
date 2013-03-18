From: "Dr. Tilmann Bubeck" <t.bubeck@reinform.de>
Subject: Re: Use EXT4_BOOT_LOADER_INO for boot loader GRUB?
Date: Mon, 18 Mar 2013 14:26:25 +0100
Message-ID: <op.wt48ybxow201t7@cnd0370px4.ent.rt.verigy.net>
References: <51023FEA.7000802@reinform.de> <20130126184927.GB20005@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw1.reinform.de ([82.141.45.9]:42755 "EHLO gw1.reinform.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab3CRN0n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Mar 2013 09:26:43 -0400
In-Reply-To: <20130126184927.GB20005@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,

I sent a patch implementing your idea from below at 2013-02-23 to the  
mailing list. It has received a

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Is there anything more to do to get this accepted? I am willing to do more  
cleanups, if you request them.

Thanks!
   Tilmann


On Sat, 26 Jan 2013 19:49:27 +0100, Theodore Ts'o <tytso@mit.edu> wrote:

> On Fri, Jan 25, 2013 at 09:18:50AM +0100, Dr. Tilmann Bubeck wrote:
>> The basic problem is, that GRUB needs a safe place to store
>> (currently 32k) for its boot loader "core.img". That place should be
>> simple to find from the primary boot code ("stage1") and the place
>> should be safe for user intervention.
>>
>> QUESTION:
>>
>> You have reserved a special inode #5 called "EXT4_BOOT_LOADER_INO".
>> Is this inode currently used or supported by kernel or user land?
>> What is the idea of this inode?
>
> It was basically for something exactly like this.  :-)
>
>> PROPOSAL:
>>
>> I can think of using that inode to store the file "core.img" of
>> GRUB. That file is used by GRUB to boot and the block list of that
>> file is stored in GRUB when using "--force" to override the above
>> error.
>>
>> ext2/3/4 must make sure, that the block list of that file never
>> changes. I propose an additional EXT4 ioctl to tell ext4, which file
>> to store in EXT4_BOOT_LOADER_INO.
>
> What I'm thinking about is a new ioctl that would swap the i_block and
> i_blocks array of the BOOT_LOADER_INO and the file descriptor.  That
> is, if there were any blocks attached to the boot_loader_ino, they
> would become attached to the inode associated with the file
> descriptor, and the blocks associated with that inode would be
> attached to inode #5.
>
>> Probably there must be more changes to e2fsck and friends.
>
> Actually, no changes to e2fsck would be necessary.  The original plan
> was that boot loader inode would be installed while the file system is
> unmounted.  But it's already the case that blocks associated with
> inode <5> are already accounted for by e2fsck.
>
>       	      	      		       - Ted


-- 

Mit freundlichen Gruessen,
   Tilmann Bubeck

+-------+-------------------------------------------------------------+
|       | dr. tilmann bubeck               reinform medien- und       |
|       |                                  informationstechnologie AG |
| rein  | fon  : +49 (711) 7 82 76-52      loeffelstr. 40             |
| form  | fax  : +49 (711) 7 82 76-46      70597 stuttgart / germany  |
|    AG | cell.: +49 (172) 8 84 29 72      fon: +49 (711) 75 86 56-10 |
|       | email: t.bubeck@reinform.de      http://www.reinform.de     |
|       +-------------------------------------------------------------+
|       | pflichtangaben nach paragraph 80, AktG:                     |
|       | reinform medien- und informationstechnologie AG, stuttgart  |
|       | handelsregister stuttgart, HRB 23001                        |
|       | vorstand:     dr. tilmann bubeck (vorsitz)                  |
|       | aufsichtsrat: frank stege (vorsitz)                         |
+-------+-------------------------------------------------------------+
