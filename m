From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: Help to edit inode content
Date: Wed, 13 May 2009 09:58:59 +0530
Message-ID: <ea11fea30905122128y5f72e6at49ad95d89480bb01@mail.gmail.com>
References: <20aa8c370905120847j4b19175akbdcafc0db2004567@mail.gmail.com>
	<3e8340490905120856w62c6c5cexa247937bf7e84002@mail.gmail.com>
	<20aa8c370905120902o71ab9adflb8619e2a9ae343d0@mail.gmail.com>
	<20090512200310.GP3209@webber.adilger.int> <20aa8c370905122111x6bc80d4ave0c857fafd8d9e0a@mail.gmail.com>
	<ea11fea30905122114s212922f4g57162eb4dc4771f5@mail.gmail.com>
	<20aa8c370905122123l23c02994q7fc41bd8b529342e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@sun.com>, Bryan Donlan <bdonlan@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: ranjith kannikara <ranjithkannikara@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:48830 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZEME3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 May 2009 00:29:18 -0400
In-Reply-To: <20aa8c370905122123l23c02994q7fc41bd8b529342e@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2009 at 9:53 AM, ranjith kannikara
<ranjithkannikara@gmail.com> wrote:
> On Wed, May 13, 2009 at 9:44 AM, Manish Katiyar <mkatiyar@gmail.com> =
wrote:
>> On Wed, May 13, 2009 at 9:41 AM, ranjith kannikara
>> <ranjithkannikara@gmail.com> wrote:
>>> On Wed, May 13, 2009 at 1:33 AM, Andreas Dilger <adilger@sun.com> w=
rote:
>>>> On May 12, 2009 =A021:32 +0530, ranjith kannikara wrote:
>>>>> On Tue, May 12, 2009 at 9:26 PM, Bryan Donlan <bdonlan@gmail.com>=
 wrote:
>>>>> > On Tue, May 12, 2009 at 11:47 AM, ranjith kannikara
>>>>> > <ranjithkannikara@gmail.com> wrote:
>>>>> >> I am a computer science engineering student. We have started a=
 project
>>>>> >> to make an application to recover deleted files from an ext3
>>>>> >> filesystem. For that we have a doubt . Can we edit the inode c=
ontent?
>>>>> >> ie the recovery will be robust if we could edit the inode cont=
ents and
>>>>> >> give the pointer address manually or through a code. The inode=
 is
>>>>> >> being created in the kernel mode and is it possible to edit th=
ose
>>>>> >> contents if the code is allowed to have the kernel mode permis=
sions..?
>>>>>
>>>>> But we would like to know whether it is possible to edit the inod=
e
>>>>> because it will make the recovery easy and robust. ie he know the
>>>>> details of the inode of the file which had been deleted is it pos=
sible
>>>>> to edit the content of that inode with the pointers of the delete=
d
>>>>> file.?
>>>>
>>>> Are you asking whether it is possible to modify the on-disk struct=
ure
>>>> of the ext3 inode? Generally that is NOT allowed because it will o=
f
>>>> course break all existing filesystems if not done with extreme car=
e.
>>>>
>>>> Cheers, Andreas
>>>> --
>>>> Andreas Dilger
>>>> Sr. Staff Engineer, Lustre Group
>>>> Sun Microsystems of Canada, Inc.
>>>>
>>>>
>>> Hi,
>>> Actually I was asking the same. whether it is possible to edit the
>>> inode content of a disk or the image of a disk. Did you mean that i=
t
>>> is not possible at all. Is there any method to edit the inode conte=
nt
>>> and use the edited inode for a file, If we can ensure high care.
>>> because such a method will be the most robust one in the recovery o=
f
>>> deleted file.
>>
>> Sorry , but it is still not clear to me whether you are trying to
>> change the on-disk structure of the inode or just change the ondisk
>> *contents* of some deleted inode to recover it. =A0Can you give an
>> example of what you are trying to do ?
>>
>> Thanks -
>> Manish
>>
> Ok, I will
> I want to edit the contects of some deleted inode to recover the file=
=2E ie
> I have a file 'foo' with inode 123. and the inode have the direct and
> indirect data pointers in it.
> Now i deleted the file and is trying to recover it.
> I somehow could get what was the content,which is the pointers in the=
 inode.
> Now I would like to edit the inode 123 so that it will contain the
> above pointers and will be the same deleted file itself.

Ok... then it is not what Andreas is concerned about. You should be
able to change it using the debugfs tool. See the command
"modify_inode" in it.

Thanks -
Manish



>
> I hope now its clear and you can help me.
> Regards
> Ranju.
>>
>>
>>>
>>> Regards
>>> ranju.
>>>
>>> --
>>> http://www.ranjithkannikara.blogspot.com/
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>>
>>
>> --
>> Thanks -
>> Manish
>>
>
>
>
> --
> http://www.ranjithkannikara.blogspot.com/
>



--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
