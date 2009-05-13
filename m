From: ranjith kannikara <ranjithkannikara@gmail.com>
Subject: Re: Help to edit inode content
Date: Wed, 13 May 2009 09:41:22 +0530
Message-ID: <20aa8c370905122111x6bc80d4ave0c857fafd8d9e0a@mail.gmail.com>
References: <20aa8c370905120847j4b19175akbdcafc0db2004567@mail.gmail.com>
	 <3e8340490905120856w62c6c5cexa247937bf7e84002@mail.gmail.com>
	 <20aa8c370905120902o71ab9adflb8619e2a9ae343d0@mail.gmail.com>
	 <20090512200310.GP3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Bryan Donlan <bdonlan@gmail.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:26263 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbZEMELW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 May 2009 00:11:22 -0400
In-Reply-To: <20090512200310.GP3209@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2009 at 1:33 AM, Andreas Dilger <adilger@sun.com> wrote=
:
> On May 12, 2009 =A021:32 +0530, ranjith kannikara wrote:
>> On Tue, May 12, 2009 at 9:26 PM, Bryan Donlan <bdonlan@gmail.com> wr=
ote:
>> > On Tue, May 12, 2009 at 11:47 AM, ranjith kannikara
>> > <ranjithkannikara@gmail.com> wrote:
>> >> I am a computer science engineering student. We have started a pr=
oject
>> >> to make an application to recover deleted files from an ext3
>> >> filesystem. For that we have a doubt . Can we edit the inode cont=
ent?
>> >> ie the recovery will be robust if we could edit the inode content=
s and
>> >> give the pointer address manually or through a code. The inode is
>> >> being created in the kernel mode and is it possible to edit those
>> >> contents if the code is allowed to have the kernel mode permissio=
ns..?
>>
>> But we would like to know whether it is possible to edit the inode
>> because it will make the recovery easy and robust. ie he know the
>> details of the inode of the file which had been deleted is it possib=
le
>> to edit the content of that inode with the pointers of the deleted
>> file.?
>
> Are you asking whether it is possible to modify the on-disk structure
> of the ext3 inode? Generally that is NOT allowed because it will of
> course break all existing filesystems if not done with extreme care.
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>
Hi,
Actually I was asking the same. whether it is possible to edit the
inode content of a disk or the image of a disk. Did you mean that it
is not possible at all. Is there any method to edit the inode content
and use the edited inode for a file, If we can ensure high care.
because such a method will be the most robust one in the recovery of
deleted file.

Regards
ranju.

--=20
http://www.ranjithkannikara.blogspot.com/
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
