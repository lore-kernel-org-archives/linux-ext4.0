From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: Re: Copying Data Blocks
Date: Tue, 6 Jan 2009 22:58:13 +0530
Message-ID: <ea11fea30901060928o7967d964pa9af52537e5f14e@mail.gmail.com>
References: <2d08ef090901060236p46d4d396x797e4bceb24a2a34@mail.gmail.com>
	 <ea11fea30901060524n559a48f1h85bbf27be5b30b50@mail.gmail.com>
	 <5feb302e0901060612p4e114953pb6e297778aa7c0a4@mail.gmail.com>
	 <2d08ef090901060845t85ac2b0i11c684a09d930608@mail.gmail.com>
	 <ea11fea30901060913n30c5f410l5e1c91e0c964cb80@mail.gmail.com>
	 <2d08ef090901060916y4c49884dy4b44d6354b11ebb8@mail.gmail.com>
	 <2d08ef090901060925p685506abkdc722c4099b485c7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "rishi agrawal" <postrishi@gmail.com>,
	ext4 <linux-ext4@vger.kernel.org>,
	Kernelnewbies <kernelnewbies@nl.linux.org>
To: "Rohit Sharma" <imreckless@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:9479 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbZAFR2P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jan 2009 12:28:15 -0500
Received: by ti-out-0910.google.com with SMTP id b6so9866024tic.23
        for <linux-ext4@vger.kernel.org>; Tue, 06 Jan 2009 09:28:13 -0800 (PST)
In-Reply-To: <2d08ef090901060925p685506abkdc722c4099b485c7@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 6, 2009 at 10:55 PM, Rohit Sharma <imreckless@gmail.com> wrote:
> We can find out no. of block currently being used by the donor inode,
> The data we read from donor inode has to be in some buffer or page,

Since we know the blocknumber of donor inode, it should be possible to
do a raw read and get the memory address of the data page using
sb_bread() and then accessing bh->b_data . Isn't it ?

Thanks -
Manish

> is there a way we can associate this buffer with the reciever inode
> or write the contents of the buffer to the new inode.
>
>
> On Tue, Jan 6, 2009 at 10:46 PM, Rohit Sharma <imreckless@gmail.com> wrote:
>> On Tue, Jan 6, 2009 at 10:43 PM, Manish Katiyar <mkatiyar@gmail.com> wrote:
>>> On Tue, Jan 6, 2009 at 10:15 PM, Rohit Sharma <imreckless@gmail.com> wrote:
>>>> On Tue, Jan 6, 2009 at 7:42 PM, rishi agrawal <postrishi@gmail.com> wrote:
>>>>> yes i suppose the donor inode is known
>>>>> moreover the receiver inode's number is also known
>>>>>
>>>>> On Tue, Jan 6, 2009 at 6:54 PM, Manish Katiyar <mkatiyar@gmail.com> wrote:
>>>>>>
>>>>>> On Tue, Jan 6, 2009 at 4:06 PM, Rohit Sharma <imreckless@gmail.com> wrote:
>>>>>> > I want to read data blocks from one inode
>>>>>> > and copy it to other inode.
>>>>>> >
>>>>>> > I mean to copy data from data blocks associated with one inode
>>>>>> > to the data blocks associated with other inode.
>>>>>>
>>>>>> Copying 4K chunk of data itself is a costly operation. and depending
>>>>
>>>> Yes its a costly operation, but if this can be done then
>>>> we can definitely copy n blocks at a time.
>>>>
>>>>>> on the size of your donor inode this can be huge . Why do you want to
>>>>>> do that ? Do you know the inode of the donor inode ?
>>>>
>>>> For physically relocating a file from one disk to other.
>>>>
>>>> Yes Manish, i know the donor inode and i will create the reciever inode.
>>>
>>> I am guessing .......will something like this work ?
>>>
>>> ino_t donor_inode_num;
>>> struct inode *donor_inode = FS_iget(sb , donor_inode_num);
>>> struct FS_inode_info * fsi = FSI(donor_inode) ;   // Do the regular
>>> container_of stuff here
>>>
>>> for ( i = 0; i < (donor_inode->i_size + sb->s_blocksize -
>>> 1)/sb->s_blocksize ; i ++ ) {
>>>    // Do a memmove or memcpy here from fsi->i_data[i]
>>> }
>>>
>>> I am not sure though how will you prevent the donor inode from being
>>> changed/resized during this period.
>>
>> I am thinking of remounting ext2 in readonly mode, or i'll change the
>> mount flags to readonly. But i m not sure if internally i can copy the
>> data from one block to other.
>>
>>>
>>> Thanks -
>>> Manish
>>>
>>>
>>>>
>>>> Can we do that in kernel space.?
>>>>>>
>>>>>> thanks -
>>>>>> Manish
>>>>>> >
>>>>>> > Is that possible in kernel space.?
>>>>>> > --
>>>>>> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>>>>> > the body of a message to majordomo@vger.kernel.org
>>>>>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>> >
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>>
>>>>>
>>>>> --
>>>>> Regards,
>>>>> Rishi B. Agrawal
>>>>>
>>>>>
>>>>
>>>
>>
>
