From: Vivek Haldar <haldar@google.com>
Subject: Re: [PATCH] ext4: do not normalize block requests from fallocate.
Date: Mon, 16 May 2011 10:18:33 -0700
Message-ID: <BANLkTikWG_+aeVZUpBcfbqVoKvjRq4tbgQ@mail.gmail.com>
References: <1305321545-17214-1-git-send-email-haldar@google.com>
	<alpine.LFD.2.00.1105161135260.3670@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:8836 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1EPRSh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 May 2011 13:18:37 -0400
Received: from hpaq11.eem.corp.google.com (hpaq11.eem.corp.google.com [172.25.149.11])
	by smtp-out.google.com with ESMTP id p4GHIZIg008151
	for <linux-ext4@vger.kernel.org>; Mon, 16 May 2011 10:18:35 -0700
Received: from qwi4 (qwi4.prod.google.com [10.241.195.4])
	by hpaq11.eem.corp.google.com with ESMTP id p4GHEbVr000748
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 16 May 2011 10:18:34 -0700
Received: by qwi4 with SMTP id 4so2708118qwi.29
        for <linux-ext4@vger.kernel.org>; Mon, 16 May 2011 10:18:33 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1105161135260.3670@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

EXT4_GET_BLOCKS_* and EXT4_MB_HINT_* are different flag spaces and
should not be mixed. ext4_ext_map_blocks should not be using
EXT4_MB_HINT_*, it only uses EXT4_GET_BLOCKS_*.

On Mon, May 16, 2011 at 2:39 AM, Lukas Czerner <lczerner@redhat.com> wr=
ote:
> On Fri, 13 May 2011, Vivek Haldar wrote:
>
>> Currently, an fallocate request of size slightly larger than a power=
 of
>> 2 is turned into two block requests, each a power of 2, with the ext=
ra
>> blocks pre-allocated for future use. When an application calls
>> fallocate, it already has an idea about how large the file may grow =
so
>> there is usually little benefit to reserve extra blocks on the
>> preallocation list. This reduces disk fragmentation.
>>
>> Tested: fsstress. Also verified manually that fallocat'ed files are
>> contiguously laid out with this change (whereas without it they begi=
n at
>> power-of-2 boundaries, leaving blocks in between). CPU usage of
>> fallocate is not appreciably higher. In a tight fallocate loop, CPU
>> usage hovers between 5%-8% with this change, and 5%-7% without it.
>
> Hi Vivek,
>
> the patch looks good, but I do not understand why you are introducing
> new #define when you can simply use EXT4_MB_HINT_NOPREALLOC and then =
in
> the ext4_ext_map_blocks() just do :
>
> ar.flags |=3D (flags & EXT4_MB_HINT_NOPREALLOC)
>
> and you do not need to introduce new condition. Am I missing somethin=
g ?
>
> Thanks!
> -Lukas
>
>>
>> Signed-off-by: Vivek Haldar <haldar@google.com>
>> ---
>> =A0fs/ext4/ext4.h =A0 =A0| =A0 =A02 ++
>> =A0fs/ext4/extents.c | =A0 =A05 ++++-
>> =A02 files changed, 6 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 076c5d2..e606d34 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -512,6 +512,8 @@ struct ext4_new_group_data {
>> =A0 =A0 =A0 /* Convert extent to initialized after IO complete */
>> =A0#define EXT4_GET_BLOCKS_IO_CONVERT_EXT =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 (EXT4_GET_BLOCKS_CONVERT|\
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0EXT4_GET_BLOCKS_CREATE_UNINIT_EXT)
>> + =A0 =A0 /* Don't normalize when fallocat'ing */
>> +#define EXT4_GET_BLOCKS_NO_NORMALIZE =A0 =A0 =A0 =A0 0x0020
>>
>> =A0/*
>> =A0 * Flags used by ext4_free_blocks
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index e363f21..f02dd52 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -3304,6 +3304,8 @@ int ext4_ext_map_blocks(handle_t *handle, stru=
ct inode *inode,
>> =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* disable in-core preallocation for non=
-regular files */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ar.flags =3D 0;
>> + =A0 =A0 if (flags & EXT4_GET_BLOCKS_NO_NORMALIZE)
>> + =A0 =A0 =A0 =A0 =A0 =A0 ar.flags |=3D EXT4_MB_HINT_NOPREALLOC;
>> =A0 =A0 =A0 newblock =3D ext4_mb_new_blocks(handle, &ar, &err);
>> =A0 =A0 =A0 if (!newblock)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out2;
>> @@ -3549,7 +3551,8 @@ retry:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_map_blocks(handle, inode, &=
map,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 EXT4_GET_BLOCKS_CREATE_UNINIT_EXT);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 EXT4_GET_BLOCKS_CREATE_UNINIT_EXT |
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 EXT4_GET_BLOCKS_NO_NORMALIZE);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret <=3D 0) {
>> =A0#ifdef EXT4FS_DEBUG
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(ret <=3D 0);
>>
>
> --
>



--=20
Regards,
Vivek
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
