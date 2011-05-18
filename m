From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH] ext4: use vmtruncate() instead of ext4_truncate() in ext4_setattr()
Date: Wed, 18 May 2011 13:32:52 -0700
Message-ID: <BANLkTina0UhBt5nTZaXqBnVV+rQdpf9R4Q@mail.gmail.com>
References: <20110517225926.8B4A94225B@ruihe.smo.corp.google.com>
	<4DD33AA9.9060104@redhat.com>
	<1C66CCCC-A62E-4277-B3CB-0C82DD6940BA@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:55031 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab1ERUc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 May 2011 16:32:56 -0400
Received: from wpaz24.hot.corp.google.com (wpaz24.hot.corp.google.com [172.24.198.88])
	by smtp-out.google.com with ESMTP id p4IKWsou008652
	for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 13:32:54 -0700
Received: from yxa15 (yxa15.prod.google.com [10.190.1.15])
	by wpaz24.hot.corp.google.com with ESMTP id p4IKWhDR022047
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 13:32:53 -0700
Received: by yxa15 with SMTP id 15so706526yxa.9
        for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 13:32:52 -0700 (PDT)
In-Reply-To: <1C66CCCC-A62E-4277-B3CB-0C82DD6940BA@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 17, 2011 at 10:35 PM, Andreas Dilger <adilger@dilger.ca> wr=
ote:
> On May 17, 2011, at 21:19, Eric Sandeen wrote:
>> On 5/17/11 5:59 PM, Jiaying Zhang wrote:
>>> There is a bug in commit c8d46e41 "ext4: Add flag to files with blo=
cks
>>> intentionally past EOF" that if we fallocate a file with FALLOC_FL_=
KEEP_SIZE
>>> flag and then ftruncate the file to a size larger than the file's i=
_size,
>>> any allocated but unwritten blocks will be freed but the file size =
is set
>>> to the size that ftruncate specifies.
>>>
>>> Here is a simple test to reproduce the problem:
>>> 1. fallocate a 12k size file with KEEP_SIZE flag
>>> 2. write the first 4k
>>> 3. ftruncate the file to 8k
>>> Then 'ls -l' shows that the i_size of the file becomes 8k but debug=
fs
>>> shows the file has only the first written block left.
>>
>> To be honest I'm not 100% certain what the fiesystem -should- do in =
this case.
>
> I think it makes sense from a usage POV to discard the blocks after E=
OF when a truncate is being done. =A0For something like a PVR that is r=
ecording a show, but doesn't know the exact total size, it makes sense =
to fallocate() some estimated amount of space, and then when the show i=
s finished recording it uses ftruncate() of the current size to drop th=
e fallocated space.
>
Indeed we have applications that are doing exactly the same as you
described. They always fallocate files to a pre-defined size with
KEEP_SIZE flag and if they end up using less than the allocated size,
they ftruncate files to their written size later.

Jiaying

>> If I go through that same sequence on xfs, I get 4k written / 8k unw=
ritten:
>>
>> # xfs_bmap -vp testfile
>> testfile:
>> EXT: FILE-OFFSET =A0 =A0 =A0BLOCK-RANGE =A0 =A0 =A0 =A0 =A0 =A0AG AG=
-OFFSET =A0 =A0 =A0 =A0 =A0 =A0 =A0TOTAL FLAGS
>> 0: [0..7]: =A0 =A0 =A0 =A0 =A02648750760..2648750767 =A03 (356066400=
=2E.356066407) =A0 =A0 8 00000
>> 1: [8..23]: =A0 =A0 =A0 =A0 2648750768..2648750783 =A03 (356066408..=
356066423) =A0 =A016 10000
>>
>> size 8k:
>> # ls -l testfile
>> -rw-r--r-- 1 root root 8192 May 17 22:33 testfile
>>
>> and diskspace used 12k:
>> # du -hc testfile
>> 12K =A0 testfile
>> 12K =A0 total
>>
>> I think this is a different result from ext4, either with or without=
 your patch.
>>
>> On ext4 I get size 8k, but only the first 4k mapped, as you say.
>>
>> I don't recall when truncate is supposed to free fallocated blocks, =
and from what point?
>>
>> -Eric
>>
>>> Below is the proposed patch to fix the bug:
>>>
>>> ext4: use vmtruncate() instead of ext4_truncate() in ext4_setattr()=
=2E
>>>
>>> Change ext4_setattr() to use vmtruncate(inode, attr->ia_size) inste=
ad
>>> of ext4_truncate(inode) when it needs to truncate an inode so that
>>> if the inode has EXT4_EOFBLOCKS_FL flag set and we are trying to tr=
uncate
>>> to a size larger than the inode's i_size, we will only truncate the=
 blocks
>>> beyond the specified truncate size instead of all of blocks beyond =
i_size.
>>>
>>> Signed-off-by: Jiaying Zhang <jiayingz@google.com>
>>>
>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>> index 3424e82..3bfad57 100644
>>> --- a/fs/ext4/inode.c
>>> +++ b/fs/ext4/inode.c
>>> @@ -5347,8 +5347,11 @@ int ext4_setattr(struct dentry *dentry, stru=
ct iattr *attr)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0/* ext4_truncate will clear the flag */
>>> - =A0 =A0 =A0 =A0 =A0 =A0if ((ext4_test_inode_flag(inode, EXT4_INOD=
E_EOFBLOCKS)))
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_truncate(inode);
>>> + =A0 =A0 =A0 =A0 =A0 =A0if ((ext4_test_inode_flag(inode, EXT4_INOD=
E_EOFBLOCKS))) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D vmtruncate(inode, a=
ttr->ia_size);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto err_o=
ut;
>>> + =A0 =A0 =A0 =A0 =A0 =A0}
>>> =A0 =A0 =A0}
>>>
>>> =A0 =A0 =A0if ((attr->ia_valid & ATTR_SIZE) &&
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>
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
