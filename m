From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: recovering from backup superblock with uninit_bg
Date: Tue, 14 Jun 2011 11:53:31 +0300
Message-ID: <BANLkTimHDG7p1P4yykQW2ywHG4J3Dfs3qQ@mail.gmail.com>
References: <BANLkTi=Xy0hKvBe2VvO7L6cPvT94A2g+nw@mail.gmail.com>
	<E51F9800-231C-45E0-A013-9DC1749AA00C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38741 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab1FNIxc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jun 2011 04:53:32 -0400
Received: by wwa36 with SMTP id 36so5643370wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jun 2011 01:53:31 -0700 (PDT)
In-Reply-To: <E51F9800-231C-45E0-A013-9DC1749AA00C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 14, 2011 at 11:35 AM, Andreas Dilger <adilger@dilger.ca> wr=
ote:
> On 2011-06-14, at 2:15 AM, Amir Goldstein wrote:
>> Can you help me figure this one out.
>>
>> When I run the test:
>> # mkfs.ext4 /dev/sda5
>> # fsck.ext4 -nf -b 32768 /dev/sda5
>>
>> The results are a total chaos.
>>
>> Apparently, when opening an fs from a backup superblock,
>> all _UNINIT flags are cleared:
>>
>> First fsck rightfully complains that the group desc checksums are wr=
ong.
>> Then, is complains about many errors in phantom inodes, because the =
inode
>> bitmap and tables are treated as initialized, but they aren't (see s=
nip below)
>>
>> Any idea what was the purpose of clearing the _UNINIT flags?
>> Or how and if this should be fixed?
>
> The reason that the _UNINIT flags are cleared is that they cannot pos=
sibly
> be correct in the backup superblocks, and it is far more reliable to =
check
> all of the inode table blocks for inodes, as old e2fsck used to do.

Right, so in this case do the checksums need to be wrong by design?

>
> However, you shouldn't have garbage data in your inode table in the f=
irst
> place. =A0mke2fs will normally do the inode table zeroing, unless it =
detects
> that the kernel supports the "lazyinit zeroing thread". =A0At that po=
int, it
> expects the kernel to proceed to zero all of the unused blocks in the
> filesystem at mount time. =A0If this isn't happening, it is a bug.
>

The test was: mkfs; fsck.
There was no mount in between.
I am testing a 16TB fs on a loop device, so I am mounting with -o noini=
t_itable,
so my image file won't grow.
I may as well pick up your patch to skip zeroing of the journal,
as that is mainly what my image file contains now.

Thanks,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
