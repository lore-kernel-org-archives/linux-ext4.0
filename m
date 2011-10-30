From: Coly Li <i@coly.li>
Subject: Re: bigalloc and max file size
Date: Sun, 30 Oct 2011 13:37:59 +0800
Message-ID: <4EACE2B7.9070402@coly.li>
References: <51BECC2B-2EBC-4FCB-B708-8431F7CB6E0D@dilger.ca> <5846CEDC-A1ED-4BB4-8A3E-E726E696D3E9@mit.edu> <EB03FF23-73BC-4FDC-B991-5EB3FEEB8DAE@whamcloud.com> <B327AF5F-B58A-43A2-BCB2-D0345F550D43@mit.edu> <97D9C5CC-0F22-4BC7-BDFA-7781D33CA7F3@whamcloud.com> <E0A4425F-9C68-4929-83CD-9B2CA3F87979@mit.edu>
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
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:46994 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751119Ab1J3F2P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Oct 2011 01:28:15 -0400
In-Reply-To: <E0A4425F-9C68-4929-83CD-9B2CA3F87979@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011=E5=B9=B410=E6=9C=8828=E6=97=A5 05:42, Theodore Tso Wrote:
>=20
> On Oct 27, 2011, at 11:08 AM, Andreas Dilger wrote:
[snip]
> One could argue that I could add a patch which disabled the bigalloc =
patch, and then make changes in the next merge window, but to be comple=
tely honest I have my own selfish reason for not wanting to do that, wh=
ich is the bigalloc patches have also been integrated into Google's int=
ernal kernels already, and changing the bigalloc format without a new f=
lag would make things complicated for me.   Given that we decided to lo=
ck down the extent leaf format (even though I had wanted to make change=
s to it, for example to support a full 64-bit block number) in deferenc=
e to the fact that it was in ClusterFS deployed kernels, there is prece=
dent for taking into account the status of formats used in non-mainline=
 kernels by the original authors of the feature.
>=20
Hi Ted,

=46orgive me if this is out of topic.
In our test, allocating directories W/ bigalloc and W/O inline-data may=
 occupy most of disk space. By now Ext4
inline-data is not merged yet, I just wondering how Google uses bigallo=
c without inline-data patch set ?

Thanks.

--=20
Coly Li
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
