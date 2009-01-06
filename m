From: "Rohit Sharma" <imreckless@gmail.com>
Subject: Re: Copying Data Blocks
Date: Tue, 6 Jan 2009 22:15:33 +0530
Message-ID: <2d08ef090901060845t85ac2b0i11c684a09d930608@mail.gmail.com>
References: <2d08ef090901060236p46d4d396x797e4bceb24a2a34@mail.gmail.com>
	 <ea11fea30901060524n559a48f1h85bbf27be5b30b50@mail.gmail.com>
	 <5feb302e0901060612p4e114953pb6e297778aa7c0a4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Manish Katiyar" <mkatiyar@gmail.com>,
	ext4 <linux-ext4@vger.kernel.org>,
	Kernelnewbies <kernelnewbies@nl.linux.org>
To: "rishi agrawal" <postrishi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.190]:41451 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbZAFQpe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jan 2009 11:45:34 -0500
Received: by rn-out-0910.google.com with SMTP id k40so5399664rnd.17
        for <linux-ext4@vger.kernel.org>; Tue, 06 Jan 2009 08:45:33 -0800 (PST)
In-Reply-To: <5feb302e0901060612p4e114953pb6e297778aa7c0a4@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 6, 2009 at 7:42 PM, rishi agrawal <postrishi@gmail.com> wrote:
> yes i suppose the donor inode is known
> moreover the receiver inode's number is also known
>
> On Tue, Jan 6, 2009 at 6:54 PM, Manish Katiyar <mkatiyar@gmail.com> wrote:
>>
>> On Tue, Jan 6, 2009 at 4:06 PM, Rohit Sharma <imreckless@gmail.com> wrote:
>> > I want to read data blocks from one inode
>> > and copy it to other inode.
>> >
>> > I mean to copy data from data blocks associated with one inode
>> > to the data blocks associated with other inode.
>>
>> Copying 4K chunk of data itself is a costly operation. and depending

Yes its a costly operation, but if this can be done then
we can definitely copy n blocks at a time.

>> on the size of your donor inode this can be huge . Why do you want to
>> do that ? Do you know the inode of the donor inode ?

For physically relocating a file from one disk to other.

Yes Manish, i know the donor inode and i will create the reciever inode.

Can we do that in kernel space.?
>>
>> thanks -
>> Manish
>> >
>> > Is that possible in kernel space.?
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Regards,
> Rishi B. Agrawal
>
>
