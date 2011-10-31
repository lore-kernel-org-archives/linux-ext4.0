From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: bigalloc and max file size
Date: Mon, 31 Oct 2011 06:15:23 -0400
Message-ID: <A0C1821A-B597-4617-BD14-B638143DC3C2@mit.edu>
References: <51BECC2B-2EBC-4FCB-B708-8431F7CB6E0D@dilger.ca> <5846CEDC-A1ED-4BB4-8A3E-E726E696D3E9@mit.edu> <EB03FF23-73BC-4FDC-B991-5EB3FEEB8DAE@whamcloud.com> <B327AF5F-B58A-43A2-BCB2-D0345F550D43@mit.edu> <97D9C5CC-0F22-4BC7-BDFA-7781D33CA7F3@whamcloud.com> <E0A4425F-9C68-4929-83CD-9B2CA3F87979@mit.edu> <4EAA2217.5020002@tao.ma>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@whamcloud.com>,
	linux-ext4 development <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <bzzz@whamcloud.com>,
	"hao.bigrat@gmail.com" <hao.bigrat@gmail.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:58285 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932508Ab1JaKP1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Oct 2011 06:15:27 -0400
In-Reply-To: <4EAA2217.5020002@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Oct 27, 2011, at 11:31 PM, Tao Ma wrote:

> Forget to say, if we increase the extent length to be cluster, there =
are
> also a good side effect. ;) Current bigalloc has a severe performance
> regression in the following test case:
> mount -t ext4 /dev/sdb1 /mnt/ext4
> cp linux-3.0.tar.gz /mnt/ext4
> cd /mnt/ext4
> tar zxvf linux-3.0.tar.gz
> umount /mnt/ext4

I've been traveling, so I haven't had a chance to test this, but it mak=
es no sense that changing the encoding fro the extent length would chan=
ge the performance of the forced writeback caused by amount.   There ma=
y be a performance bug that we should fix, or may have been fixed by ac=
cident with the extent encoding change.=20

Have you investigated why this got better when you changed the meaning =
of the extent length field?   It makes no sense that such a format chan=
ge would have such an impact=85.

-- Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
