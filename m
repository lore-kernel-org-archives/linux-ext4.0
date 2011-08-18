From: Steven Liu <lingjiujianke@gmail.com>
Subject: Re: a (documented) way to get the Ext2+ filesystem size?
Date: Thu, 18 Aug 2011 10:34:24 +0800
Message-ID: <CADxeRw=pV_6Ey0hQhK2dUkbQMnJwhb+NM4TMxECkZGuuqptrOA@mail.gmail.com>
References: <86aab94mfg.fsf@gray.siamics.net>
	<20110817183101.GC6901@thunk.org>
	<86mxf7yirb.fsf@gray.siamics.net>
	<20110817220953.GD6901@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ivan Shmakov <oneingray@gmail.com>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39861 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab1HRCe0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Aug 2011 22:34:26 -0400
Received: by bke11 with SMTP id 11so1131370bke.19
        for <linux-ext4@vger.kernel.org>; Wed, 17 Aug 2011 19:34:24 -0700 (PDT)
In-Reply-To: <20110817220953.GD6901@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Ivan,


      Do you want use mkfs.ext2 to make a small ext2 image file
     and write the image to mmc or some devices?

     when you write it to block device, the tool can modify the sb info
     about the file system size?

    for example:

           You must cost  60s to write a 64MB ext2 image
           You want to make a 8MB ext2 image
           So you can cost little time to write image to block device
           and use 64MB partition space?


    Is this?




Best Regards?


2011/8/18 Ted Ts'o <tytso@mit.edu>:
> On Thu, Aug 18, 2011 at 01:50:48AM +0700, Ivan Shmakov wrote:
>> >>>>> Ted Ts'o <tytso@mit.edu> writes:
>> >>>>> On Tue, Aug 16, 2011 at 06:37:23PM +0700, Ivan Shmakov wrote:
>>
>> =A0>> How do I get the Ext2+ filesystem size (in blocks)?
>>
>> =A0> I assume you need the exact numbers, so you can't use statfs(2)=
?
>> =A0> What are you using it for?
>>
>> =A0 =A0 =A0 The intent is to process a filesystem image, not a mount=
ed
>> =A0 =A0 =A0 filesystem. =A0It's my understanding that I cannot use n=
either
>> =A0 =A0 =A0 statfs(2) nor POSIX' statvfs(2) in this case.
>>
>> =A0 =A0 =A0 The code I've posted earlier is used in my e2dis [1=963]=
 project.
>
> For this, I'd suggest that you use the ext2fs library. =A0That will t=
ake
> care of byte swapping, etc. =A0It also means that you don't have to
> worry about parsing the extent trees. =A0If you had used the ext2fs
> library before ext4 had shipped, you wouldn't have had to make any
> changes to support extents, since the ext2fs library wraps and
> provides abstract interfaces for most of what you would need for e2di=
s
> project.
>
> Regards,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
