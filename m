From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH-e2fsprogs] filefrag: fix fm_start in filefrag_fiemap loop
Date: Wed, 3 Jun 2009 09:21:40 +0800
Message-ID: <6149e97b0906021821s315005a7lb1c93b74b7f35489@mail.gmail.com>
References: <1243965783-31950-1-git-send-email-bergwolf@gmail.com>
	 <20090602183513.GK3218@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f109.google.com ([209.85.222.109]:36573 "EHLO
	mail-pz0-f109.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZFCBVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Jun 2009 21:21:38 -0400
Received: by pzk7 with SMTP id 7so7093300pzk.33
        for <linux-ext4@vger.kernel.org>; Tue, 02 Jun 2009 18:21:40 -0700 (PDT)
In-Reply-To: <20090602183513.GK3218@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 3, 2009 at 2:35 AM, Andreas Dilger <adilger@sun.com> wrote:
> Can you please provide some more details of the problem this solves.
Sorry for the late reply.

When used with -v and the targeted file has more than 144
extents(double of the length of fm_extents array provided by buf),
filefrag_fiemap loops and calls fiemap ioctl() multiple times to
calculate the actual number of extents in a file. Each call to fiemap
ioctl() uses  fm_start as the starting logical offset. The patch fixes
fm_start in each loop( except for the first one) and makes the extent
calculation correct for files with more that 144 extents.

To produce the problem, first run filefrag -v on a highly fragmented
file. Then change the buf size in filefrag_fiemap to make it large
enough to have all the extent mapped in a single loop and run filefrag
-v after recompiling. The former will produce a much smaller extent
count because of the false fm_start used in the loop. And the two will
produce different extent output since the 145th extent.

BTW, should I resend the patch to include the above explanation?
>
> On Jun 03, 2009 =C2=A002:03 +0800, Peng Tao wrote:
>> Signed-off-by: Peng Tao <bergwolf@gmail.com>
>> ---
>> =C2=A0misc/filefrag.c | =C2=A0 =C2=A02 +-
>> =C2=A01 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/misc/filefrag.c b/misc/filefrag.c
>> index 6bea2cd..7786646 100644
>> --- a/misc/filefrag.c
>> +++ b/misc/filefrag.c
>> @@ -239,7 +239,7 @@ int filefrag_fiemap(int fd, int blk_shift, int *=
num_extents)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 n++;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>>
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fiemap->fm_start +=3D fm=
_ext[i-1].fe_logical +
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fiemap->fm_start =3D fm_=
ext[i-1].fe_logical +
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fm_ext[i-1].fe_length;
>> =C2=A0 =C2=A0 =C2=A0 } while (last =3D=3D 0);
>>
>> --
>> 1.6.2.GIT
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>



--=20
Cheers,
Bergwolf
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
