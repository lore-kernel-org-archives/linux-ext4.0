From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH] ext4: use vmtruncate() instead of ext4_truncate() in ext4_setattr()
Date: Wed, 18 May 2011 13:57:41 -0700
Message-ID: <BANLkTikSpoGJrgpbcnxVOuwZv8UPQp1qLg@mail.gmail.com>
References: <20110517225926.8B4A94225B@ruihe.smo.corp.google.com>
	<4DD33AA9.9060104@redhat.com>
	<1C66CCCC-A62E-4277-B3CB-0C82DD6940BA@dilger.ca>
	<BANLkTina0UhBt5nTZaXqBnVV+rQdpf9R4Q@mail.gmail.com>
	<EA5A5AB0-51B8-4C2D-922C-46CD448737E9@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:15679 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab1ERU5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 May 2011 16:57:45 -0400
Received: from wpaz5.hot.corp.google.com (wpaz5.hot.corp.google.com [172.24.198.69])
	by smtp-out.google.com with ESMTP id p4IKvi7B008043
	for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 13:57:44 -0700
Received: from gyd12 (gyd12.prod.google.com [10.243.49.204])
	by wpaz5.hot.corp.google.com with ESMTP id p4IKvItR027390
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 13:57:43 -0700
Received: by gyd12 with SMTP id 12so929139gyd.23
        for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 13:57:43 -0700 (PDT)
In-Reply-To: <EA5A5AB0-51B8-4C2D-922C-46CD448737E9@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 18, 2011 at 1:45 PM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> On May 18, 2011, at 14:32, Jiaying Zhang wrote:
>> On Tue, May 17, 2011 at 10:35 PM, Andreas Dilger <adilger@dilger.ca>=
 wrote:
>>> On May 17, 2011, at 21:19, Eric Sandeen wrote:
>>>> On 5/17/11 5:59 PM, Jiaying Zhang wrote:
>>>>> There is a bug in commit c8d46e41 "ext4: Add flag to files with b=
locks
>>>>> intentionally past EOF" that if we fallocate a file with FALLOC_F=
L_KEEP_SIZE
>>>>> flag and then ftruncate the file to a size larger than the file's=
 i_size,
>>>>> any allocated but unwritten blocks will be freed but the file siz=
e is set
>>>>> to the size that ftruncate specifies.
>>>>>
>>>>> Here is a simple test to reproduce the problem:
>>>>> 1. fallocate a 12k size file with KEEP_SIZE flag
>>>>> 2. write the first 4k
>>>>> 3. ftruncate the file to 8k
>>>>> Then 'ls -l' shows that the i_size of the file becomes 8k but deb=
ugfs
>>>>> shows the file has only the first written block left.
>>>>
>>>> To be honest I'm not 100% certain what the fiesystem -should- do i=
n this case.
>>>
>>> I think it makes sense from a usage POV to discard the blocks after=
 EOF when a truncate is being done. =A0For something like a PVR that is=
 recording a show, but doesn't know the exact total size, it makes sens=
e to fallocate() some estimated amount of space, and then when the show=
 is finished recording it uses ftruncate() of the current size to drop =
the fallocated space.
>>>
>>
>> Indeed we have applications that are doing exactly the same as you
>> described. They always fallocate files to a pre-defined size with
>> KEEP_SIZE flag and if they end up using less than the allocated size=
,
>> they ftruncate files to their written size later.
>
> If XFS is already handling truncate-up and truncate-down differently,=
 I don't mind keeping consistent behaviour with XFS. =A0I had thought a=
bout this also, that truncate-up isn't intending to throw away space wh=
ile truncate-down is. =A0However, I didn't mention it in my email becau=
se I thought the semantics of having different behaviour for truncate-u=
p vs. truncate-down was confusing.
>
> If XFS is already doing this, then it seems that this is at least som=
ewhat expected by applications and/or is more efficient in the long run=
 for the on-disk allocation.
With my patch, it is still a little different from what xfs does in
truncating-up case. As Eric mentioned, when an application fallocates
12k, writes 4k, and then truncates to 8k, on xfs there will be 12k
allocated blocks left, but on ext4 with my patch there will be 8k
allocated blocks left. The reason I think we may want to free any
blocks beyond the truncate size is because there may be situations
that applications are running out of space and want to shrink
fallocated files to a smaller size that is still larger than the
current i_size.

Jiaying
>
>>>> If I go through that same sequence on xfs, I get 4k written / 8k u=
nwritten:
>>>>
>>>> # xfs_bmap -vp testfile
>>>> testfile:
>>>> EXT: FILE-OFFSET =A0 =A0 =A0BLOCK-RANGE =A0 =A0 =A0 =A0 =A0 =A0AG =
AG-OFFSET =A0 =A0 =A0 =A0 =A0 =A0 =A0TOTAL FLAGS
>>>> 0: [0..7]: =A0 =A0 =A0 =A0 =A02648750760..2648750767 =A03 (3560664=
00..356066407) =A0 =A0 8 00000
>>>> 1: [8..23]: =A0 =A0 =A0 =A0 2648750768..2648750783 =A03 (356066408=
=2E.356066423) =A0 =A016 10000
>>>>
>>>> size 8k:
>>>> # ls -l testfile
>>>> -rw-r--r-- 1 root root 8192 May 17 22:33 testfile
>>>>
>>>> and diskspace used 12k:
>>>> # du -hc testfile
>>>> 12K =A0 testfile
>>>> 12K =A0 total
>>>>
>>>> I think this is a different result from ext4, either with or witho=
ut your patch.
>>>>
>>>> On ext4 I get size 8k, but only the first 4k mapped, as you say.
>>>>
>>>> I don't recall when truncate is supposed to free fallocated blocks=
, and from what point?
>>>>
>>>> -Eric
>>>>
>>>>> Below is the proposed patch to fix the bug:
>>>>>
>>>>> ext4: use vmtruncate() instead of ext4_truncate() in ext4_setattr=
().
>>>>>
>>>>> Change ext4_setattr() to use vmtruncate(inode, attr->ia_size) ins=
tead
>>>>> of ext4_truncate(inode) when it needs to truncate an inode so tha=
t
>>>>> if the inode has EXT4_EOFBLOCKS_FL flag set and we are trying to =
truncate
>>>>> to a size larger than the inode's i_size, we will only truncate t=
he blocks
>>>>> beyond the specified truncate size instead of all of blocks beyon=
d i_size.
>>>>>
>>>>> Signed-off-by: Jiaying Zhang <jiayingz@google.com>
>>>>>
>>>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>>>> index 3424e82..3bfad57 100644
>>>>> --- a/fs/ext4/inode.c
>>>>> +++ b/fs/ext4/inode.c
>>>>> @@ -5347,8 +5347,11 @@ int ext4_setattr(struct dentry *dentry, st=
ruct iattr *attr)
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0/* ext4_truncate will clear the flag *=
/
>>>>> - =A0 =A0 =A0 =A0 =A0 =A0if ((ext4_test_inode_flag(inode, EXT4_IN=
ODE_EOFBLOCKS)))
>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_truncate(inode);
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0if ((ext4_test_inode_flag(inode, EXT4_IN=
ODE_EOFBLOCKS))) {
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D vmtruncate(inode,=
 attr->ia_size);
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc)
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto err=
_out;
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0}
>>>>> =A0 =A0 =A0}
>>>>>
>>>>> =A0 =A0 =A0if ((attr->ia_valid & ATTR_SIZE) &&
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-e=
xt4" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ex=
t4" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>>
>>>
>>> Cheers, Andreas
>>>
>>>
>>>
>>>
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
> Cheers, Andreas
>
>
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
