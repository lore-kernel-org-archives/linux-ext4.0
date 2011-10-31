From: Tao Ma <tm@tao.ma>
Subject: Re: bigalloc and max file size
Date: Mon, 31 Oct 2011 18:27:25 +0800
Message-ID: <4EAE780D.3090005@tao.ma>
References: <51BECC2B-2EBC-4FCB-B708-8431F7CB6E0D@dilger.ca> <5846CEDC-A1ED-4BB4-8A3E-E726E696D3E9@mit.edu> <EB03FF23-73BC-4FDC-B991-5EB3FEEB8DAE@whamcloud.com> <B327AF5F-B58A-43A2-BCB2-D0345F550D43@mit.edu> <97D9C5CC-0F22-4BC7-BDFA-7781D33CA7F3@whamcloud.com> <E0A4425F-9C68-4929-83CD-9B2CA3F87979@mit.edu> <4EAA2217.5020002@tao.ma> <A0C1821A-B597-4617-BD14-B638143DC3C2@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@whamcloud.com>,
	linux-ext4 development <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <bzzz@whamcloud.com>,
	"hao.bigrat@gmail.com" <hao.bigrat@gmail.com>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:44062 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932689Ab1JaK1r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Oct 2011 06:27:47 -0400
In-Reply-To: <A0C1821A-B597-4617-BD14-B638143DC3C2@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/31/2011 06:15 PM, Theodore Tso wrote:
>=20
> On Oct 27, 2011, at 11:31 PM, Tao Ma wrote:
>=20
>> Forget to say, if we increase the extent length to be cluster, there=
 are
>> also a good side effect. ;) Current bigalloc has a severe performanc=
e
>> regression in the following test case:
>> mount -t ext4 /dev/sdb1 /mnt/ext4
>> cp linux-3.0.tar.gz /mnt/ext4
>> cd /mnt/ext4
>> tar zxvf linux-3.0.tar.gz
>> umount /mnt/ext4
>=20
> I've been traveling, so I haven't had a chance to test this, but it m=
akes no sense that changing the encoding fro the extent length would ch=
ange the performance of the forced writeback caused by amount.   There =
may be a performance bug that we should fix, or may have been fixed by =
accident with the extent encoding change.=20
>=20
> Have you investigated why this got better when you changed the meanin=
g of the extent length field?   It makes no sense that such a format ch=
ange would have such an impact=85.
OK, so let me explain why the big cluster length works.

In the new bigalloc case if chunk size=3D64k, and with the linux-3.0
source, every file will be allocated a chunk, but they aren't contiguou=
s
if we only write the 1st 4k bytes. In this case, writeback and the bloc=
k
layer below can't merge all the requests sent by ext4. And in our test
case, the total io will be around 20000. While with the cluster size, w=
e
have to zero the whole cluster. From the upper point of view. we have t=
o
write more bytes. But from the block layer, the write is contiguous and
it can merge them to be a big one. In our test, it will only do around
2000 ios. So it helps the test case.

Thanks
Tao
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
