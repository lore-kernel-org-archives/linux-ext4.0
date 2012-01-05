From: Ganesh Patil <patil.ganesh170@gmail.com>
Subject: Re: kmalloc question.
Date: Thu, 5 Jan 2012 14:05:56 +0530
Message-ID: <CAN2Q5rvDMM9U8dG=kDtuKHmRCXHuFJf+EOpDQsb_6zBOhhxyhA@mail.gmail.com>
References: <CAN2Q5ruw_sMPvK9hH_t_8aEKVD7rNh22g3bQU7T2uY_tSYQT3Q@mail.gmail.com>
	<FA050017-9C33-438A-BF4F-5914317C8849@mit.edu>
	<CAN2Q5rsihkdYiZEgakCBjoCo1kP-ru8P6i8uzckFK8OiFDLY+w@mail.gmail.com>
	<CAOQ4uxj1Q70ta9J6YjbVhh+P2OTL03+KU12ybg4av=v=r_+sCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52088 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816Ab2AEIf5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jan 2012 03:35:57 -0500
Received: by eaad14 with SMTP id d14so172055eaa.19
        for <linux-ext4@vger.kernel.org>; Thu, 05 Jan 2012 00:35:56 -0800 (PST)
In-Reply-To: <CAOQ4uxj1Q70ta9J6YjbVhh+P2OTL03+KU12ybg4av=v=r_+sCA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thank you sir.

On 1/5/12, Amir Goldstein <amir73il@gmail.com> wrote:
> Hi Ganesh,
>
> I am glad to learn that ext4 snapshots has become a "hot" research subject
> in Pune.
> However, I must say:
> 1. this is not the place to ask such basic questions.
> 2. your question shows that you are missing a lot of background before you
> can
> approach this kind of project.
>
> The answer in kernel memory (slab), BTW, which has nothing to do with root
> filesystem.
>
> Amir.
>
> On Wed, Jan 4, 2012 at 5:50 PM, Ganesh Patil
> <patil.ganesh170@gmail.com>wrote:
>
>> Hello sir,
>>
>>         I am B.E(computer)student from Pune university (India) .my
>> final year project is "File system level snapshot in ext4 "  so have
>> to take snapshot of particular file system and place somewhere(on same
>> filesystem or on another filesystem) .in snapshot we are going to copy
>> only inode of file in to another inode. as inode size in particular
>> filesystem   is fixed so we cant get inode from filesystem(if
>> filesystem filled more than half) so finally we come to decision that
>> we will create one structure which has fields same as that of original
>> inode. so we will allocate memory dynamically using kmalloc
>> function.but we require that allocated memory cant be destroy till we
>> manually not destroy it.because of that I am asking from where kmalloc
>> allocates memory block(from current file system,or from kernel
>> space(root filesystem) or from RAM(heap area)).
>>
>> On 1/4/12, Theodore Tso <tytso@mit.edu> wrote:
>> >
>> > On Jan 4, 2012, at 9:22 AM, Ganesh Patil wrote:
>> >
>> >> where allocate kmalloc function memory?
>> >
>> > Sorry, I can't parse your question.
>> >
>> > -- Ted
>> >
>> >
>>
>>
>> --
>> Regards,
>> Ganesh Patil.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>


-- 
Regards,
Ganesh Patil.
