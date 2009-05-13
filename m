From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: Help to edit inode content
Date: Wed, 13 May 2009 09:44:50 +0530
Message-ID: <ea11fea30905122114s212922f4g57162eb4dc4771f5@mail.gmail.com>
References: <20aa8c370905120847j4b19175akbdcafc0db2004567@mail.gmail.com>
	<3e8340490905120856w62c6c5cexa247937bf7e84002@mail.gmail.com>
	<20aa8c370905120902o71ab9adflb8619e2a9ae343d0@mail.gmail.com>
	<20090512200310.GP3209@webber.adilger.int> <20aa8c370905122111x6bc80d4ave0c857fafd8d9e0a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@sun.com>, Bryan Donlan <bdonlan@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: ranjith kannikara <ranjithkannikara@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:31043 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbZEMEPJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 May 2009 00:15:09 -0400
In-Reply-To: <20aa8c370905122111x6bc80d4ave0c857fafd8d9e0a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2009 at 9:41 AM, ranjith kannikara
<ranjithkannikara@gmail.com> wrote:
> On Wed, May 13, 2009 at 1:33 AM, Andreas Dilger <adilger@sun.com> wro=
te:
>> On May 12, 2009 =A021:32 +0530, ranjith kannikara wrote:
>>> On Tue, May 12, 2009 at 9:26 PM, Bryan Donlan <bdonlan@gmail.com> w=
rote:
>>> > On Tue, May 12, 2009 at 11:47 AM, ranjith kannikara
>>> > <ranjithkannikara@gmail.com> wrote:
>>> >> I am a computer science engineering student. We have started a p=
roject
>>> >> to make an application to recover deleted files from an ext3
>>> >> filesystem. For that we have a doubt . Can we edit the inode con=
tent?
>>> >> ie the recovery will be robust if we could edit the inode conten=
ts and
>>> >> give the pointer address manually or through a code. The inode i=
s
>>> >> being created in the kernel mode and is it possible to edit thos=
e
>>> >> contents if the code is allowed to have the kernel mode permissi=
ons..?
>>>
>>> But we would like to know whether it is possible to edit the inode
>>> because it will make the recovery easy and robust. ie he know the
>>> details of the inode of the file which had been deleted is it possi=
ble
>>> to edit the content of that inode with the pointers of the deleted
>>> file.?
>>
>> Are you asking whether it is possible to modify the on-disk structur=
e
>> of the ext3 inode? Generally that is NOT allowed because it will of
>> course break all existing filesystems if not done with extreme care.
>>
>> Cheers, Andreas
>> --
>> Andreas Dilger
>> Sr. Staff Engineer, Lustre Group
>> Sun Microsystems of Canada, Inc.
>>
>>
> Hi,
> Actually I was asking the same. whether it is possible to edit the
> inode content of a disk or the image of a disk. Did you mean that it
> is not possible at all. Is there any method to edit the inode content
> and use the edited inode for a file, If we can ensure high care.
> because such a method will be the most robust one in the recovery of
> deleted file.

Sorry , but it is still not clear to me whether you are trying to
change the on-disk structure of the inode or just change the ondisk
*contents* of some deleted inode to recover it.  Can you give an
example of what you are trying to do ?

Thanks -
Manish



>
> Regards
> ranju.
>
> --
> http://www.ranjithkannikara.blogspot.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
