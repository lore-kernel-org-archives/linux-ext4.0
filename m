From: Coly Li <i@coly.li>
Subject: Re: bigalloc and max file size
Date: Mon, 31 Oct 2011 17:35:16 +0800
Message-ID: <4EAE6BD4.9080705@coly.li>
References: <51BECC2B-2EBC-4FCB-B708-8431F7CB6E0D@dilger.ca> <5846CEDC-A1ED-4BB4-8A3E-E726E696D3E9@mit.edu> <EB03FF23-73BC-4FDC-B991-5EB3FEEB8DAE@whamcloud.com> <B327AF5F-B58A-43A2-BCB2-D0345F550D43@mit.edu> <97D9C5CC-0F22-4BC7-BDFA-7781D33CA7F3@whamcloud.com> <E0A4425F-9C68-4929-83CD-9B2CA3F87979@mit.edu> <4EACE2B7.9070402@coly.li> <F1D09DA1-3E1E-4D31-9F26-4AADAAF7A91D@mit.edu>
Reply-To: i@coly.li
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@whamcloud.com>,
	linux-ext4 development <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <bzzz@whamcloud.com>, Tao Ma <tm@tao.ma>,
	"hao.bigrat@gmail.com" <hao.bigrat@gmail.com>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:41231 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932438Ab1JaJZZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Oct 2011 05:25:25 -0400
In-Reply-To: <F1D09DA1-3E1E-4D31-9F26-4AADAAF7A91D@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011=E5=B9=B410=E6=9C=8831=E6=97=A5 03:49, Theodore Tso Wrote:
>=20
> On Oct 30, 2011, at 1:37 AM, Coly Li wrote:
>=20
>> Forgive me if this is out of topic.
>> In our test, allocating directories W/ bigalloc and W/O inline-data =
may occupy most of disk space. By now Ext4
>> inline-data is not merged yet, I just wondering how Google uses biga=
lloc without inline-data patch set ?
>=20
> It depends on how many directories you have (i.e, how deep your direc=
tory structure is) and how many small files you have in the file system=
 as to whether bigalloc w/o inline-data has an acceptable overhead or n=
ot.
[snip]
> I'm not against your patch set, however; I just haven't had time to l=
ook at them, at all (nor the secure delete patch set, etc.) .   Between=
 organizing the kernel summit, the kernel.org compromise, and some high=
 priority bugs at $WORK, things have just been too busy.  Sorry for tha=
t; I'll get to them after the merge window and post-merge bug fixing is=
 under control.

Hi Ted,

In our test, bigalloc without inline-data dose not work very well with =
deep directory structure, e.g. Hadoop or Squid,
because small directories occupies all disk space. That's why I asked t=
he question. Thanks for your patient reply, it
makes sense for me :-)

Back to our topic, Ext4 doesn't have too much on-disk incompatible flag=
-bits now. If we get current bigalloc code merged
now, we have to use another incompatible bit when we merge cluster/chun=
k based extent patch set. Further more, we
observe performance regression without cluster-based-extent on file sys=
tem umount (as Tao mentioned in this thread).
IMHO, without inline-data and cluster-based-extent, current bigalloc co=
de is a little bit inperfect for many users.

Bigalloc is a very useful feature, can we consider making it better bef=
ore getting merged ?

Thanks.
--=20
Coly Li
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
