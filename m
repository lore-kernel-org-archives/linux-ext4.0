From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH] ext4: use vmtruncate() instead of ext4_truncate() in ext4_setattr()
Date: Wed, 18 May 2011 13:38:20 -0700
Message-ID: <BANLkTi=-mHcK529AC=s3aVfEEjoF7Rx-rg@mail.gmail.com>
References: <20110517225926.8B4A94225B@ruihe.smo.corp.google.com>
	<4DD33AA9.9060104@redhat.com>
	<BANLkTi=Yv_q820aHFa2wkCL-PnYNcZdWCQ@mail.gmail.com>
	<4DD42CA1.8050700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:52667 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab1ERUiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 May 2011 16:38:25 -0400
Received: from hpaq11.eem.corp.google.com (hpaq11.eem.corp.google.com [172.25.149.11])
	by smtp-out.google.com with ESMTP id p4IKcNGh022998
	for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 13:38:24 -0700
Received: from yxi11 (yxi11.prod.google.com [10.190.3.11])
	by hpaq11.eem.corp.google.com with ESMTP id p4IKcLHC005386
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 13:38:22 -0700
Received: by yxi11 with SMTP id 11so1287659yxi.1
        for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 13:38:20 -0700 (PDT)
In-Reply-To: <4DD42CA1.8050700@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 18, 2011 at 1:31 PM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
> On 5/18/11 3:28 PM, Jiaying Zhang wrote:
>>
>>
>> On Tue, May 17, 2011 at 8:19 PM, Eric Sandeen <sandeen@redhat.com <m=
ailto:sandeen@redhat.com>> wrote:
>>
>> =A0 =A0 On 5/17/11 5:59 PM, Jiaying Zhang wrote:
>> =A0 =A0 > There is a bug in commit c8d46e41 "ext4: Add flag to files=
 with blocks
>> =A0 =A0 > intentionally past EOF" that if we fallocate a file with F=
ALLOC_FL_KEEP_SIZE
>> =A0 =A0 > flag and then ftruncate the file to a size larger than the=
 file's i_size,
>> =A0 =A0 > any allocated but unwritten blocks will be freed but the f=
ile size is set
>> =A0 =A0 > to the size that ftruncate specifies.
>> =A0 =A0 >
>> =A0 =A0 > Here is a simple test to reproduce the problem:
>> =A0 =A0 > =A0 1. fallocate a 12k size file with KEEP_SIZE flag
>> =A0 =A0 > =A0 2. write the first 4k
>> =A0 =A0 > =A0 3. ftruncate the file to 8k
>> =A0 =A0 > Then 'ls -l' shows that the i_size of the file becomes 8k =
but debugfs
>> =A0 =A0 > shows the file has only the first written block left.
>>
>> =A0 =A0 To be honest I'm not 100% certain what the fiesystem -should=
- do in this case.
>>
>> =A0 =A0 If I go through that same sequence on xfs, I get 4k written =
/ 8k unwritten:
>>
>> =A0 =A0 # xfs_bmap -vp testfile
>> =A0 =A0 testfile:
>> =A0 =A0 =A0EXT: FILE-OFFSET =A0 =A0 =A0BLOCK-RANGE =A0 =A0 =A0 =A0 =A0=
 =A0AG AG-OFFSET =A0 =A0 =A0 =A0 =A0 =A0 =A0TOTAL FLAGS
>> =A0 =A0 =A0 0: [0..7]: =A0 =A0 =A0 =A0 =A02648750760..2648750767 =A0=
3 (356066400..356066407) =A0 =A0 8 00000
>> =A0 =A0 =A0 1: [8..23]: =A0 =A0 =A0 =A0 2648750768..2648750783 =A03 =
(356066408..356066423) =A0 =A016 10000
>>
>> =A0 =A0 size 8k:
>> =A0 =A0 # ls -l testfile
>> =A0 =A0 -rw-r--r-- 1 root root 8192 May 17 22:33 testfile
>>
>> =A0 =A0 and diskspace used 12k:
>> =A0 =A0 # du -hc testfile
>> =A0 =A0 12K =A0 =A0 testfile
>> =A0 =A0 12K =A0 =A0 total
>>
>> =A0 =A0 I think this is a different result from ext4, either with or=
 without your patch.
>>
>> =A0 =A0 On ext4 I get size 8k, but only the first 4k mapped, as you =
say.
>>
>> I agree that truncating to a size larger than i_size is un-specified=
 by
>> POSIX. However, I think the problem with the current behavior is tha=
t
>> we have an inconsistency between file's i_size and its extent tree.
>> Now we have 8k i_size but the file has only 4k space allocated. That
>> can confuse applications.
>
> That's called "a sparse file" right? =A0Apps should not be confused b=
y that ...
But applications don't intend to create a sparse file in this case. The=
y may
create a lot of such files in this way with 'df' showing there is
still plenty of
free space available but as they start writing to these files they will=
 fill up
space and get ENOSPC unexpectedly.

Jiaying
>
> -Eric
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
