Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7813E3D98;
	Tue, 28 Jul 2026 19:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785266260; cv=none; b=JT6/pah6vKH8gwlpsloHayxiVvjAKm1w9ztuS0g0ML3QfgkMkiOATwLGgcOuqvVc4jJ8RtvJGKh0Y0MDNeH2W+BHTV0ahoPocLra4sUD9AClIBIUolYd72/Kex5/2vkws4PZYKFEVUn93jW/RlFPqxcZ9K1anjp+YgDqNkIQgXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785266260; c=relaxed/simple;
	bh=bxQcgn4kjvQ8IjbvrLNqI4cId4DJhvGbQOAbHRf5Jik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VGk6ZqcZBUHO9NxRVnFiWlGgQ9QWOGCvmtF14DdkEkqTYHTYl8CwDBQ+j0N4pGzRlzKMqmS0q+UOezrDf2hc+apPtveo8chCHjNBfLHqDjCmqfIvUECdgy8NsfbfDHeM6/1jMhledjgbm57KYYlwXjvIjAyOoWNsi2hY8XZcQGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=etvAT9Bc; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="etvAT9Bc"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SIHhb21968960;
	Tue, 28 Jul 2026 19:17:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=KzpewINUyKRgxzEHP8VWOPgtM8rJUe
	qH0fVf1tJOtd0=; b=etvAT9BcKkRi63rKjDslHMKVuUdU0DTaEApa9Fey45aqgy
	Jcf5S69okgvdinzMNWyXvSj188INNPYd9U8Q8DwNt272DU5ZG3T0vKiQRCUIDerI
	vjHgIV+9PTz9MAJLug4v3mSXeVzVgaQD3P+esn+0fayaQgbT5Jwe1p2Ad2RNv3BY
	MNhgfZmhPjtmnElhGIJyfXsLXH/72HqqAHFVVeA+ren3RhmWbUVcAxACFainpWJW
	mS19BxnICcjwiw0cxWpgZ/B3GxRv3GfgtigQBNV6FR8DKAqLuH6lPCDNVYZPLc+x
	pNACjrYY6EQcE7jAzospavZDzfFPOmDfxG0ck6KQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuwcxj6v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 19:17:11 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66SJBFhm018212;
	Tue, 28 Jul 2026 19:17:10 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fn9pgbbp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 19:17:10 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66SJH8C133489170
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jul 2026 19:17:09 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E586520043;
	Tue, 28 Jul 2026 19:17:08 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 54F1620040;
	Tue, 28 Jul 2026 19:17:06 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.23.195])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 28 Jul 2026 19:17:06 +0000 (GMT)
Date: Wed, 29 Jul 2026 00:47:03 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        linux-kernel@vger.kernel.org, Baokun Li <libaokun@linux.alibaba.com>,
        Disha Goel <disgoel@linux.ibm.com>
Subject: Re: [PATCH] ext4: turn off DAX on new files when encryption is set
Message-ID: <amkAL232Q2O649r3@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260723085648.1500357-1-ojaswin@linux.ibm.com>
 <kekum3d7vakufwz75guyr5mzn6w4rujmssyom5qynpbxucbqpf@f4va7cswqspx>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kekum3d7vakufwz75guyr5mzn6w4rujmssyom5qynpbxucbqpf@f4va7cswqspx>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: eDIRIN8qLn-uAfmb3wxY5NQ9uIxSmp4Z
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDE2MyBTYWx0ZWRfX2BkJd+oOmifD
 OWyf24kDI1MhuYfbWYlnGeoUN3UvTmDuRTrFy6ERnMXWxhm/Vrq2uzQz3Tqkx1tph6wHtiN1/aZ
 weE4R24qjxhomZ1mRC/Fp6OVfRvzib4=
X-Authority-Analysis: v=2.4 cv=E/z9Y6dl c=1 sm=1 tr=0 ts=6a690037 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=iox4zFpeAAAA:8 a=21NmYU05mdO41x32-gwA:9 a=CjuIK1q_8ugA:10
 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDE2MyBTYWx0ZWRfX/aApQ3yZgS6W
 qLTrbZ2j56sN9D9foLQuSb9oNYxhPxbaAjnUcnMH7CiusqIuRkZVYpqXCP1pS6VMTPal/iNdbqC
 iLEPfg+oYjy8Sy7+hvazrKgzVkTc52xG7QEht1F/w/MDicAj5HKDfWXtMiX75W5Tv5uvS4U0Las
 mW/s21xCflSEL4CisSwcbcJS0uezNoInxq9BztOI9Leg+3rkilpluCeURHY55PyjpZs4Yc4YPch
 SD5bX0e08Lr7ZRfvecvHWmkfEJN7hcaAbWsQgi0OsmdcubkMAUiaaKewserhwTCdJvVhCFDMQ9l
 I0BDWfGcwKqkmu+6K805d7MXBjtzj+kQEPSfpt0jBiaiSrAAmTfx7k1725H2fx0ylKDKfoi+Urz
 XJR7DC7+lWjP4gBSFURUQQfII25mSrMXrdAZByqbo6rgvqPfugU6NDHHFDBehAx6eeVAkOmHa1Q
 TLOEYx/EfOeE46+zpGA==
X-Proofpoint-GUID: 33RBjoRw52tAkQb66LTi73H7CbzkzJX-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_05,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607280163

On Mon, Jul 27, 2026 at 09:06:23PM +0200, Jan Kara wrote:
> On Thu 23-07-26 14:26:48, Ojaswin Mujoo wrote:
> > Currently, when setting the S_ENCRYPTED flag on a new regular inode in
> > a -o dax=always mounted FS, we seem to be erroneously retaining the S_DAX
> > flag. This is because the newly created inode ends up with the following:
> > 
> >   __ext4_new_inode()
> >     ext4_set_inode_flags(init=true) // sets S_DAX
> >       fscrypt_set_context()
> >         ext4_set_context()
> >           ext4_set_inode_flags(init=false) // sets S_ENCRYPTED but
> >                                               doesn't clears S_DAX
> >       ext4_set_aops
> >         inode->i_mapping->a_ops = &ext4_dax_aops;
> > 
> > Due to the S_DAX flag, the excrypted inode gets ext4_dax_aops and it
> > silently ends up bypassing encryption completely. This is reflected in
> > multiple xfstests failures like generic/548. To fix this, ensure we disable
> > S_DAX correctly when S_ENCRYPTED is being set on a newly created inode. It
> > is safe to change DAX state there because ext4_set_aops() later can
> > correctly detect S_DAX unset and assign the correct aops.
> > 
> > The fix was actually the intended behavior however it seemed to have
> > silently changed in 043546e46dc7.
> > 
> > Fixes: 043546e46dc7 ("fs/ext4: Only change S_DAX on inode load")
> > Reported-by: Disha Goel <disgoel@linux.ibm.com>
> > Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> > ---
> >  fs/ext4/crypto.c | 15 +++++++++++----
> >  fs/ext4/inode.c  | 10 ++++++----
> >  2 files changed, 17 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
> > index f41f320f4437..2d409114e02e 100644
> > --- a/fs/ext4/crypto.c
> > +++ b/fs/ext4/crypto.c
> > @@ -134,6 +134,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
> >  {
> >  	handle_t *handle = fs_data;
> >  	int res, res2, credits, retries = 0;
> > +	bool init = S_ISREG(inode->i_mode);
> 
> Hum, I have some comments: IMHO the change is confusing because the meaning
> of 'init' argument of ext4_set_inode_flags() doesn't mean the first setting
> of flags any longer. And the reliance on ext4_set_context() getting called
> in a safe place exactly for regular files is rather subtle as well.

Hi Jan, thanks for the review. 
Yes I agree the init naming and checking for ISREG is a bit hacky.
> 
> Also does the change to ext4_set_inode_flags() really work? As far as I'm
> reading the ext4 crypto implementation, I don't see where we'd be setting
> EXT4_INODE_ENCRYPT for inodes with already enabled encryption (where we
> load the context from xattrs through ext4_get_context()) and thus DAX would
> still get enabled for such inodes? What am I missing?

Hmm do you mean __ext4_iget() on an already encrypted inode? In that
case raw_inode->i_flags with EXT4_ENCRYPT_FL set will get carried over
to ei->i_flags and we will still get the right aops no? Or do you mean
some other case?

> 
> 								Honza
> 
> > @@ -179,10 +180,16 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
> >  			ext4_clear_inode_state(inode,
> >  					EXT4_STATE_MAY_INLINE_DATA);
> >  			/*
> > -			 * Update inode->i_flags - S_ENCRYPTED will be enabled,
> > -			 * S_DAX may be disabled
> > +			 * Update inode->i_flags, S_ENCRYPTED will be enabled.
> > +			 * If this is a regular inode, then we must be coming
> > +			 * via __ext4_new_inode() as only new inodes can be
> > +			 * encrypted, so we must set the init flag so
> > +			 * S_DAX can be disabled. This is a bit fragile but
> > +			 * seems like the easiest way to make sure we don't let
> > +			 * the DAX flag linger when encryption is enabled as
> > +			 * that result in writes silently bypassing encryption.
> >  			 */
> > -			ext4_set_inode_flags(inode, false);
> > +			ext4_set_inode_flags(inode, init);
> >  		}
> >  		return res;
> >  	}
> > @@ -209,7 +216,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
> >  		 * Update inode->i_flags - S_ENCRYPTED will be enabled,
> >  		 * S_DAX may be disabled
> >  		 */
> > -		ext4_set_inode_flags(inode, false);
> > +		ext4_set_inode_flags(inode, init);
> >  		res = ext4_mark_inode_dirty(handle, inode);
> >  		if (res)
> >  			EXT4_ERROR_INODE(inode, "Failed to mark inode dirty");
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index ce99807c5f5b..a57179655353 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -5113,8 +5113,6 @@ void ext4_set_inode_flags(struct inode *inode, bool init)
> >  	unsigned int flags = EXT4_I(inode)->i_flags;
> >  	unsigned int new_fl = 0;
> >  
> > -	WARN_ON_ONCE(IS_DAX(inode) && init);
> > -
> >  	if (flags & EXT4_SYNC_FL)
> >  		new_fl |= S_SYNC;
> >  	if (flags & EXT4_APPEND_FL)
> > @@ -5129,8 +5127,12 @@ void ext4_set_inode_flags(struct inode *inode, bool init)
> >  	/* Because of the way inode_set_flags() works we must preserve S_DAX
> >  	 * here if already set. */
> >  	new_fl |= (inode->i_flags & S_DAX);
> > -	if (init && ext4_should_enable_dax(inode))
> > -		new_fl |= S_DAX;
> > +	if (init) {
> > +		if (ext4_should_enable_dax(inode))
> > +			new_fl |= S_DAX;
> > +		else
> > +			new_fl &= ~S_DAX;
> > +	}
> >  
> >  	if (flags & EXT4_ENCRYPT_FL)
> >  		new_fl |= S_ENCRYPTED;
> > -- 
> > 2.53.0
> > 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
