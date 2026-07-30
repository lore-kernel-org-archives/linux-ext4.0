Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4C7388E72;
	Thu, 30 Jul 2026 08:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785400552; cv=none; b=MRDYFAGYA9HUGEZQbnTUQeQ+J37xqcmBdyAR02SPrUonJgkNBsiVQWGb0TdHm7R1rAefZmIZ6Oh+keKimo8IXpTZkPQLMb1jTLoRFqy+qTm8dNASbg6noFJNC2uYaZx0fzGUBSupcWsGlft2fyEVdIhs//Z1SjmZx+uTA4aop9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785400552; c=relaxed/simple;
	bh=xaxlG/oWA0FxTGGCGfiMcbfIv6r+NBaSJd7SLNwt3aY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JWC+vxgUg9EBzGiKxsfhp0R9KzbbhBiGFsdk3pacu42fe5yKa/XZR8W4ak3MSkFW8jakdxFuCLQtyZ+TvL4kFbPAfDr6tlJY5Ch9XM00B7IdTRqtudCxcylDZdEoXNgxQFmpbpoOjUb9HdFbKvBdirCWDhZ/TbyNOk7j1mxo+MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Cth57m4d; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Cth57m4d"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U6lkmO2268116;
	Thu, 30 Jul 2026 08:35:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=MlWd5G
	VdlqKj8QVlVNsx6OH184YBIogwmawOpFRcBNA=; b=Cth57m4dYXonq3pN3MTikt
	SW7l4pZ8stxP1ITvneaNBwOvjgwpMtBECTnqL2TdauBxzFdbB4NOtT9gafcs331G
	myldA31vk9xRzwzGA2oYUHXj4H5dPGs8FlwQbSxX0O2i3WJQwoSQ6uqh7IkypM89
	4qvwYpA194ehMcMXBYXlp7o6wL3/Se4MyZycCQRomvPu4HS93R8oAfpyQxXTP2V7
	zyg//S47Lxccq90MLpsw49myA/tarhBHa1jfkYYup7L9ePTjePr/4oo0gFpxrj9M
	GnGAEXZcwc0ox8bklLOQwlEPK8pky7qBg5SsHKBkdgi4EAhmDwamph+1u6TSycbA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuw7ptc0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:35:33 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66U8QKDD026719;
	Thu, 30 Jul 2026 08:35:32 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fn7fqjpjy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:35:32 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66U8ZUAs42467796
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 08:35:30 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 858BA2004B;
	Thu, 30 Jul 2026 08:35:30 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D9E3120043;
	Thu, 30 Jul 2026 08:35:28 +0000 (GMT)
Received: from [9.123.9.194] (unknown [9.123.9.194])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jul 2026 08:35:28 +0000 (GMT)
Message-ID: <3686bf0f-1fd9-4699-a1b2-88dce3787906@linux.ibm.com>
Date: Thu, 30 Jul 2026 14:05:27 +0530
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: turn off DAX on new files when encryption is set
To: Eric Biggers <ebiggers@kernel.org>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        linux-kernel@vger.kernel.org, Baokun Li <libaokun@linux.alibaba.com>
References: <20260723085648.1500357-1-ojaswin@linux.ibm.com>
 <kekum3d7vakufwz75guyr5mzn6w4rujmssyom5qynpbxucbqpf@f4va7cswqspx>
 <20260727194350.GC1021387@google.com> <20260727201339.GD1021387@google.com>
Content-Language: en-GB
From: Disha Goel <disgoel@linux.ibm.com>
In-Reply-To: <20260727201339.GD1021387@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: wRYWAYBPhFbO0EvPrKwRHEr29diLIuBy
X-Proofpoint-ORIG-GUID: yqtKqoX1zlzuFE8119x1bZK3D8Mr01P7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA1OSBTYWx0ZWRfX9y5WM8KJQLbX
 5rse5H8hgk1vwatJEEpSeUsDrYmYxoUkNArKI5MvhPjrNxhRjEKiIMDrnOLUp5nE99gIXEjmvYq
 T3RLCkTorLLlEpWEi24UGiWfPCIQ2NMziaL9iY+O/lWJ4iIfPwfgIhjM331ahmEPBZrI8OSwPE/
 Ra8MDE1tQUYi7LVkqGbsBORmxTjwFxT7A0Ue6N2aqk7A8+pbUeNzMUD8ed/VaCBjf/JTaTXl49L
 YzE4e+AogHg0QoTDbruFgBLmWI6YJp+78cvuflqjTPdekg/Vcpe3rmIEECEJA8DSCvFCfu6s2Mr
 9DzdGxrzlxMLGknhydKAKPHtz7Hz30p/Ar+5kftgWfns43iKsJfc8F+aFxjKyCVqncig/CRMStG
 Eldwjj3OzUbovvdR6aG9g+J7IGW45ckjvBxax6/1SbAeQnn/rwMFfX6Ydlz8UhzPSSXd8wIFPoQ
 ceBnF6Jdton5/if1Pbg==
X-Authority-Analysis: v=2.4 cv=SKFykuvH c=1 sm=1 tr=0 ts=6a6b0cd5 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=JKVybEi45UZxgy7gOqIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA1OSBTYWx0ZWRfXw97hYlArJ92p
 NtBPXlYc5yKD1j2Ef2/CiMP9AAZECDS0loLnCauXWN4ZuOJJUIJUgDjrRner1GmAZBYmnW1Qx65
 1UxsEPnBqV9hKg6NYq84zM6XYaUBy9E=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_02,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300059

On 28/07/26 1:43 am, Eric Biggers wrote:
> On Mon, Jul 27, 2026 at 07:43:50PM +0000, Eric Biggers wrote:
>> On Mon, Jul 27, 2026 at 09:06:23PM +0200, Jan Kara wrote:
>>> On Thu 23-07-26 14:26:48, Ojaswin Mujoo wrote:
>>>> Currently, when setting the S_ENCRYPTED flag on a new regular inode in
>>>> a -o dax=always mounted FS, we seem to be erroneously retaining the S_DAX
>>>> flag. This is because the newly created inode ends up with the following:
>>>>
>>>>    __ext4_new_inode()
>>>>      ext4_set_inode_flags(init=true) // sets S_DAX
>>>>        fscrypt_set_context()
>>>>          ext4_set_context()
>>>>            ext4_set_inode_flags(init=false) // sets S_ENCRYPTED but
>>>>                                                doesn't clears S_DAX
>>>>        ext4_set_aops
>>>>          inode->i_mapping->a_ops = &ext4_dax_aops;
>>>>
>>>> Due to the S_DAX flag, the excrypted inode gets ext4_dax_aops and it
>>>> silently ends up bypassing encryption completely. This is reflected in
>>>> multiple xfstests failures like generic/548. To fix this, ensure we disable
>>>> S_DAX correctly when S_ENCRYPTED is being set on a newly created inode. It
>>>> is safe to change DAX state there because ext4_set_aops() later can
>>>> correctly detect S_DAX unset and assign the correct aops.
>>>>
>>>> The fix was actually the intended behavior however it seemed to have
>>>> silently changed in 043546e46dc7.
>>>>
>>>> Fixes: 043546e46dc7 ("fs/ext4: Only change S_DAX on inode load")
>>>> Reported-by: Disha Goel <disgoel@linux.ibm.com>
>>>> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
>>>> ---
>>>>   fs/ext4/crypto.c | 15 +++++++++++----
>>>>   fs/ext4/inode.c  | 10 ++++++----
>>>>   2 files changed, 17 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
>>>> index f41f320f4437..2d409114e02e 100644
>>>> --- a/fs/ext4/crypto.c
>>>> +++ b/fs/ext4/crypto.c
>>>> @@ -134,6 +134,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
>>>>   {
>>>>   	handle_t *handle = fs_data;
>>>>   	int res, res2, credits, retries = 0;
>>>> +	bool init = S_ISREG(inode->i_mode);
>>>
>>> Hum, I have some comments: IMHO the change is confusing because the meaning
>>> of 'init' argument of ext4_set_inode_flags() doesn't mean the first setting
>>> of flags any longer. And the reliance on ext4_set_context() getting called
>>> in a safe place exactly for regular files is rather subtle as well.
>>>
>>> Also does the change to ext4_set_inode_flags() really work? As far as I'm
>>> reading the ext4 crypto implementation, I don't see where we'd be setting
>>> EXT4_INODE_ENCRYPT for inodes with already enabled encryption (where we
>>> load the context from xattrs through ext4_get_context()) and thus DAX would
>>> still get enabled for such inodes? What am I missing?
>>
>> Maybe __ext4_new_inode() should set the encryption flag on the inode
>> earlier?  Currently it decides whether the inode will be encrypted, then
>> calls ext4_set_inode_flags(), then calls fscrypt_set_context() (and thus
>> ext4_set_context()).  That last step sets the flag and calls
>> ext4_set_inode_flags() *again*.
>>
>> I don't remember if there's a reason for that redundancy, but it might
>> just be for historical reasons.  ext4_set_context() is called in two
>> different cases: when a new inode is created and it's encrypted from the
>> beginning, and when FS_IOC_SET_ENCRYPTION_POLICY is executed on an empty
>> directory.  The latter does have to set the encrypt flag there.
>>   
>> - Eric
> 
> Here's an idea.  I haven't tested it though.
> 
> Note that this would align ext4 closer with f2fs, which already sets the
> encrypt flag before it calls fscrypt_set_context().

Hi Eric,

I have tested it in my setup. All failing encryption tests in the
generic group passed.

> 
> diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
> index f41f320f4437..c4bfe18fd527 100644
> --- a/fs/ext4/crypto.c
> +++ b/fs/ext4/crypto.c
> @@ -144,7 +144,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
>   	if (inode->i_ino == EXT4_ROOT_INO)
>   		return -EPERM;
>   
> -	if (WARN_ON_ONCE(IS_DAX(inode) && i_size_read(inode)))
> +	if (WARN_ON_ONCE(IS_DAX(inode)))
>   		return -EINVAL;
>   
>   	if (ext4_test_inode_flag(inode, EXT4_INODE_DAX))
> @@ -163,6 +163,14 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
>   	 */
>   
>   	if (handle) {
> +		/*
> +		 * ext4 should have set the encrypt flag on the inode already,
> +		 * and it should not have enabled inline data.
> +		 */
> +		if (WARN_ON_ONCE(!IS_ENCRYPTED(inode)))
> +			return -EINVAL;
> +		if (WARN_ON_ONCE(ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)))
> +			return -EINVAL;
>   		/*
>   		 * Since the inode is new it is ok to pass the
>   		 * XATTR_CREATE flag. This is necessary to match the
> @@ -170,21 +178,10 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
>   		 * function with the credits allocated for the new
>   		 * inode.
>   		 */
> -		res = ext4_xattr_set_handle(handle, inode,
> -					    EXT4_XATTR_INDEX_ENCRYPTION,
> -					    EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
> -					    ctx, len, XATTR_CREATE);
> -		if (!res) {
> -			ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
> -			ext4_clear_inode_state(inode,
> -					EXT4_STATE_MAY_INLINE_DATA);
> -			/*
> -			 * Update inode->i_flags - S_ENCRYPTED will be enabled,
> -			 * S_DAX may be disabled
> -			 */
> -			ext4_set_inode_flags(inode, false);
> -		}
> -		return res;
> +		return ext4_xattr_set_handle(handle, inode,
> +					     EXT4_XATTR_INDEX_ENCRYPTION,
> +					     EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
> +					     ctx, len, XATTR_CREATE);
>   	}
>   
>   	res = dquot_initialize(inode);
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index a40cb27f8116..3848244af77a 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -997,6 +997,8 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
>   		err = fscrypt_prepare_new_inode(dir, inode, &encrypt);
>   		if (err)
>   			goto out;
> +		if (encrypt)
> +			i_flags |= EXT4_ENCRYPT_FL;
>   	}
>   
>   	err = dquot_initialize(inode);
> @@ -1306,6 +1308,7 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
>   	ei->i_extra_isize = sbi->s_want_extra_isize;
>   	ei->i_inline_off = 0;
>   	if (ext4_has_feature_inline_data(sb) &&
> +	    !(ei->i_flags & EXT4_ENCRYPT_FL) &&
>   	    (!(ei->i_flags & (EXT4_DAX_FL|EXT4_EA_INODE_FL)) || S_ISDIR(mode)))
>   		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
>   	ret = inode;

-- 
Regards,
Disha

