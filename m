From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: bigalloc and max file size
Date: Mon, 31 Oct 2011 11:53:42 -0700
Message-ID: <4EAEEEB6.8010102@oracle.com>
References: <51BECC2B-2EBC-4FCB-B708-8431F7CB6E0D@dilger.ca> <5846CEDC-A1ED-4BB4-8A3E-E726E696D3E9@mit.edu> <EB03FF23-73BC-4FDC-B991-5EB3FEEB8DAE@whamcloud.com> <B327AF5F-B58A-43A2-BCB2-D0345F550D43@mit.edu> <97D9C5CC-0F22-4BC7-BDFA-7781D33CA7F3@whamcloud.com> <E0A4425F-9C68-4929-83CD-9B2CA3F87979@mit.edu> <4EAA2217.5020002@tao.ma> <A0C1821A-B597-4617-BD14-B638143DC3C2@mit.edu> <4EAE780D.3090005@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@MIT.EDU>,
	Andreas Dilger <adilger@whamcloud.com>,
	linux-ext4 development <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <bzzz@whamcloud.com>,
	"hao.bigrat@gmail.com" <hao.bigrat@gmail.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:50209 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933864Ab1JaSyY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Oct 2011 14:54:24 -0400
In-Reply-To: <4EAE780D.3090005@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/31/2011 03:27 AM, Tao Ma wrote:
> On 10/31/2011 06:15 PM, Theodore Tso wrote:
>> On Oct 27, 2011, at 11:31 PM, Tao Ma wrote:
>>
>>> Forget to say, if we increase the extent length to be cluster, ther=
e are
>>> also a good side effect. ;) Current bigalloc has a severe performan=
ce
>>> regression in the following test case:
>>> mount -t ext4 /dev/sdb1 /mnt/ext4
>>> cp linux-3.0.tar.gz /mnt/ext4
>>> cd /mnt/ext4
>>> tar zxvf linux-3.0.tar.gz
>>> umount /mnt/ext4
>> I've been traveling, so I haven't had a chance to test this, but it =
makes no sense that changing the encoding fro the extent length would c=
hange the performance of the forced writeback caused by amount.   There=
 may be a performance bug that we should fix, or may have been fixed by=
 accident with the extent encoding change.
>>
>> Have you investigated why this got better when you changed the meani=
ng of the extent length field?   It makes no sense that such a format c=
hange would have such an impact=85.
> OK, so let me explain why the big cluster length works.
>
> In the new bigalloc case if chunk size=3D64k, and with the linux-3.0
> source, every file will be allocated a chunk, but they aren't contigu=
ous
> if we only write the 1st 4k bytes. In this case, writeback and the bl=
ock
> layer below can't merge all the requests sent by ext4. And in our tes=
t
> case, the total io will be around 20000. While with the cluster size,=
 we
> have to zero the whole cluster. From the upper point of view. we have=
 to
> write more bytes. But from the block layer, the write is contiguous a=
nd
> it can merge them to be a big one. In our test, it will only do aroun=
d
> 2000 ios. So it helps the test case.

Am I missing something but you cannot zero the entire cluster because
block_write_full_page() drops pages past i_size.

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commitdiff;h=3D5693486bad2bc2ac585a2c24f7e2f3964b478df9
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
