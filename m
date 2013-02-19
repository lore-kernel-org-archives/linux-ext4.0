From: "Dr. Tilmann Bubeck" <t.bubeck@reinform.de>
Subject: Re: Use EXT4_BOOT_LOADER_INO for boot loader GRUB?
Date: Tue, 19 Feb 2013 22:15:37 +0100
Message-ID: <5123EB79.4010101@reinform.de>
References: <51023FEA.7000802@reinform.de> <20130126184927.GB20005@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw1.reinform.de ([82.141.45.9]:35718 "EHLO
	mail-out.dmz.loef.reinform.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758582Ab3BSVPk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Feb 2013 16:15:40 -0500
Received: from postfix.loef.reinform.de (postfix.loef.reinform.de [10.1.1.39])
	by mail-out.dmz.loef.reinform.de (Postfix) with ESMTP id 48A9AA83A0
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2013 22:15:39 +0100 (CET)
Received: from mail.reinform.de (mail.reinform.de [82.141.45.14])
	by postfix.loef.reinform.de (Postfix) with ESMTP id AA49E1BC00
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2013 21:27:09 +0100 (CET)
Received: from brain.wid.reinform.de (p3E9E8AFA.dip.t-dialin.net [62.158.138.250])
	(using TLSv1 with cipher ADH-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.reinform.de (Postfix) with ESMTPSA id 8B642BB4F2
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2013 22:15:38 +0100 (CET)
Received: from frodo.wid.reinform.de (frodo.wid.reinform.de [10.2.1.32])
	by brain.wid.reinform.de (Postfix) with ESMTP id 4E4EF882CE
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2013 22:15:37 +0100 (CET)
In-Reply-To: <20130126184927.GB20005@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,

my previous email contains a first implementation of your idea. Did I 
get it right or do you want me something to change?

I can also offer some shell scripts for mass testing the change to a 
fresh ext4 filesystem to ensure, that it does not break anything. I ran 
the script and indeed it does not break anything (as far as I can see).

Kind regards,
  Tilmann

Am 26.01.2013 19:49, schrieb Theodore Ts'o:
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
>        	      	      		       - Ted
>


-- 
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
