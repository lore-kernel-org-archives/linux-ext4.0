From: Aditya Kali <adityakali@google.com>
Subject: Re: can we simplify the quota matrix in ext4?
Date: Tue, 21 Jun 2011 23:35:17 -0700
Message-ID: <BANLkTi=HediBCi82dYck6ufokqASqeUOyg@mail.gmail.com>
References: <4E00E6DE.9060208@redhat.com> <E794C3E7-985B-4A6F-B763-C7BBB14061FE@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:48848 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab1FVGfw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Jun 2011 02:35:52 -0400
Received: from hpaq1.eem.corp.google.com (hpaq1.eem.corp.google.com [172.25.149.1])
	by smtp-out.google.com with ESMTP id p5M6Zk1E023824
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jun 2011 23:35:51 -0700
Received: from pzk2 (pzk2.prod.google.com [10.243.19.130])
	by hpaq1.eem.corp.google.com with ESMTP id p5M6ZcJC005135
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jun 2011 23:35:44 -0700
Received: by pzk2 with SMTP id 2so342112pzk.9
        for <linux-ext4@vger.kernel.org>; Tue, 21 Jun 2011 23:35:38 -0700 (PDT)
In-Reply-To: <E794C3E7-985B-4A6F-B763-C7BBB14061FE@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 21, 2011 at 12:24 PM, Andreas Dilger <adilger@dilger.ca> wr=
ote:
> On 2011-06-21, at 12:45 PM, Eric Sandeen wrote:
>> I was looking at
>>
>> 62d2b5f2dcd3707b070efb16bbfdf6947c38c194 ext4: Always journal quota =
file modifications
>>
>> and was thinking - if we always journal, why do we still have all th=
e mount options etc for journaled quota?
>>
>> I guess without -o usrjquota=3Dfoo we don't journal right from mount=
 time, and there are a few other paths that get skipped, but those seem=
 like details...
>>
>> It seems that ideally - and perhaps this is hindsight - ext4 should =
have defaulted to journaled, QFMT_VFS_V1 quotas only... is there any re=
ason not to?
>
> This would be the ideal situation for Lustre as well. =C2=A0The remai=
ning issue,
> AFAIK, is that e2fsck needs to do quota accounting internally so that=
 there
> is never a need to run a quotacheck on the filesystem.
>
> Since e2fsck is already traversing all of the inodes, this is no extr=
a effort
> to keep a handful of bytes (inode count, blocks count) for each user.=
 =C2=A0I
> believe there was someone at Google working on this? =C2=A0Haven't se=
en any output
> so far, however.
>
I have the changes for fixing quota usage during e2fsck with support
for QFMT_VFS_V1 format. Currently, I am using tune2fs to create the
quota inodes and set the superblock fields. On the next mount of the
filesystem, the kernel should automatically enable quotas for the
inodes that are specified in superblock.
I will send the patches out for review soon (hopefully this week).

>> I'm still not very well versed in vfs quota, but does it seem possib=
le to
>> move in this direction? =C2=A0It seems odd that we should still be s=
upporting
>> unjournaled, vfsold-format quotas in ext4 these days. =C2=A0What's t=
he point?
>
> I totally agree.
>
>> If it seems possible to move in this direction within the exiting qu=
ota
>> framework I'd be interested in trying to get it done.
>>
>> Thanks,
>> -Eric
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
>
> Cheers, Andreas
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Thanks,
--
Aditya
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
