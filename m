Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5B7221739;
	Tue, 28 Jul 2026 19:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785267346; cv=none; b=nPINSEygHtdB07B7xQxTqxoDUQyH1bALSBca/hrlAfaZDq06OV3xmxqZR1dsZldt/+pzxFypaGU0aB39nwJlTGDPb5V3ckWWSq5qvNkikpe1q/hEreehDjFz16c3YEiJRJlVYUMH7zk1Yjb+c/kr3OSisR48QjB61VQEeyOmsks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785267346; c=relaxed/simple;
	bh=meEjwhxQfSlEkJOBKpnC2cwHx0TcsRqq+G2TGBLLY5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q2LDTHj9yyPBaInyVku9l65twef6RHA3DHuhSrDDVCrKi5uhKTZ2zSk0PvcKbQqyEBeHQdDE4Py4FMUJCMMm+Sv0rREAcQ8ev1wX7JLq7Zn2RQrEXIXN0meM/pn+E++7lDH7U327kJKvxpaf4l+F4KKTWtwsRRAMoavuyaoTgfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=erXdXL0X; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="erXdXL0X"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SIHZvs1959450;
	Tue, 28 Jul 2026 19:34:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=sHBQdvAJcb4/PFMIFXMNOjRaz+AGcs
	5EFMYsdc26HXM=; b=erXdXL0XQF4KLPAn9LLJyEgh/LclgMbqJqF6KEfnccdc4V
	lsZiSCHwJSzt38yhEJIUmo3Fk+23ehu5szJtDbLu2f8D3+szb9ZC/3ByuzMkt1Iz
	m84GdUDdJMoa5dklPpFce+vD0Yc38m60lUYYH8rMjjMMuBj2Yww/dHqIqybQO5P/
	Xz7IKRcrkp8hANCYkUwrQZV3CGOL5VU3CscqkFXTXqpDWHr/IurZmEQ3Uzty2VVa
	H+fckeKcjcIojWC4q8mLQq9tx7wvUGAf65/pjADUGjU0sY46UUzCV/WcvHlzo/gf
	ShLC3fmuCGa+u9I6HQsaZ8IMeT+1ZHAkzh8sWIHw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0xq8px-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 19:34:26 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66SJQH3Y030933;
	Tue, 28 Jul 2026 19:34:25 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fna5y3ap3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 19:34:25 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66SJYNV927984166
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jul 2026 19:34:23 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9AEEE20043;
	Tue, 28 Jul 2026 19:34:23 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3449E2004B;
	Tue, 28 Jul 2026 19:34:20 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.23.195])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 28 Jul 2026 19:34:19 +0000 (GMT)
Date: Wed, 29 Jul 2026 01:04:17 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-ext4@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        linux-kernel@vger.kernel.org, Baokun Li <libaokun@linux.alibaba.com>,
        Disha Goel <disgoel@linux.ibm.com>
Subject: Re: [PATCH] ext4: turn off DAX on new files when encryption is set
Message-ID: <amkEOds5Z_EvC9tt@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260723085648.1500357-1-ojaswin@linux.ibm.com>
 <kekum3d7vakufwz75guyr5mzn6w4rujmssyom5qynpbxucbqpf@f4va7cswqspx>
 <20260727194350.GC1021387@google.com>
 <20260727201339.GD1021387@google.com>
 <647oon5c5duh2eo7trkxxrs5czlmjxsavjokrzyngozemcaxza@j5rfa5wsyu27>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <647oon5c5duh2eo7trkxxrs5czlmjxsavjokrzyngozemcaxza@j5rfa5wsyu27>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: IRR1DjW1KHDx75FZrNRG4Mp2LqKG5cwk
X-Proofpoint-ORIG-GUID: E7gnemRSbc9zc0eBn5tcx35AQjD3-QDo
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDE2NiBTYWx0ZWRfX4yCQD+aUeTCQ
 lUF6JHHtTTWZcT/52EnYxlR0KVk1IF1NrUAjF75+zs0biCp+RLGXkQG7RBYJyBaGbxVtFq1lvKA
 faqFFn68tbzJqzVXxbYz7FHVe6mxsG8=
X-Authority-Analysis: v=2.4 cv=dYuwG3Xe c=1 sm=1 tr=0 ts=6a690442 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=iox4zFpeAAAA:8 a=1EL1tip8WYHS2KxbBgkA:9 a=CjuIK1q_8ugA:10
 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDE2NiBTYWx0ZWRfX6zDMiX90jhG3
 tTiqjYzaMtI9XEh/N/K6OKRpYBYEnjjOUFn8vLk/7Gb5jvdsu13AY2ca0mD91d7G5AmPKnhRGQ6
 GIYancD4rHs+SRrrIEVrEAHt7ddGCeWHQAi/fI9G18wtKm3WYY9Lda8Nd/QrrDwj7QU/zWQrh9r
 e2PGLUA2czLXKhkiMvdMJtheInYC3WzCmh9KmI5oX2rzWTCuo+spNJehXp1jgZPz9if1f5H0ilb
 pLFRwBZ+2p/OKsNVl8sABKEtTkM5++ORynmIbiiSbMRXnE9Rk+jQosDvjIZBZZqtPHUCunxDTky
 1TDYQ1BqiPJ6M3cK/NoXwp32l0JIPZFzFZPmQmiCxN1cKacb96+Ng60M/33SxDV57PyAc0Df/CX
 BtpK6vzimVnbrsKDMyAhL9+FQE6ZXnnH1dN/RvvtrNpYwCNOFachXyrNEvd/YnjTrhlXbtgz2PC
 DO7KNLIbRuYDtUWyiiA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_05,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1011 phishscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607280166

On Tue, Jul 28, 2026 at 03:29:32PM +0200, Jan Kara wrote:
> On Mon 27-07-26 20:13:39, Eric Biggers wrote:
> > On Mon, Jul 27, 2026 at 07:43:50PM +0000, Eric Biggers wrote:
> > > On Mon, Jul 27, 2026 at 09:06:23PM +0200, Jan Kara wrote:
> > > > On Thu 23-07-26 14:26:48, Ojaswin Mujoo wrote:
> > > > > Currently, when setting the S_ENCRYPTED flag on a new regular inode in
> > > > > a -o dax=always mounted FS, we seem to be erroneously retaining the S_DAX
> > > > > flag. This is because the newly created inode ends up with the following:
> > > > > 
> > > > >   __ext4_new_inode()
> > > > >     ext4_set_inode_flags(init=true) // sets S_DAX
> > > > >       fscrypt_set_context()
> > > > >         ext4_set_context()
> > > > >           ext4_set_inode_flags(init=false) // sets S_ENCRYPTED but
> > > > >                                               doesn't clears S_DAX
> > > > >       ext4_set_aops
> > > > >         inode->i_mapping->a_ops = &ext4_dax_aops;
> > > > > 
> > > > > Due to the S_DAX flag, the excrypted inode gets ext4_dax_aops and it
> > > > > silently ends up bypassing encryption completely. This is reflected in
> > > > > multiple xfstests failures like generic/548. To fix this, ensure we disable
> > > > > S_DAX correctly when S_ENCRYPTED is being set on a newly created inode. It
> > > > > is safe to change DAX state there because ext4_set_aops() later can
> > > > > correctly detect S_DAX unset and assign the correct aops.
> > > > > 
> > > > > The fix was actually the intended behavior however it seemed to have
> > > > > silently changed in 043546e46dc7.
> > > > > 
> > > > > Fixes: 043546e46dc7 ("fs/ext4: Only change S_DAX on inode load")
> > > > > Reported-by: Disha Goel <disgoel@linux.ibm.com>
> > > > > Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> > > > > ---
> > > > >  fs/ext4/crypto.c | 15 +++++++++++----
> > > > >  fs/ext4/inode.c  | 10 ++++++----
> > > > >  2 files changed, 17 insertions(+), 8 deletions(-)
> > > > > 
> > > > > diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
> > > > > index f41f320f4437..2d409114e02e 100644
> > > > > --- a/fs/ext4/crypto.c
> > > > > +++ b/fs/ext4/crypto.c
> > > > > @@ -134,6 +134,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
> > > > >  {
> > > > >  	handle_t *handle = fs_data;
> > > > >  	int res, res2, credits, retries = 0;
> > > > > +	bool init = S_ISREG(inode->i_mode);
> > > > 
> > > > Hum, I have some comments: IMHO the change is confusing because the meaning
> > > > of 'init' argument of ext4_set_inode_flags() doesn't mean the first setting
> > > > of flags any longer. And the reliance on ext4_set_context() getting called
> > > > in a safe place exactly for regular files is rather subtle as well.
> > > > 
> > > > Also does the change to ext4_set_inode_flags() really work? As far as I'm
> > > > reading the ext4 crypto implementation, I don't see where we'd be setting
> > > > EXT4_INODE_ENCRYPT for inodes with already enabled encryption (where we
> > > > load the context from xattrs through ext4_get_context()) and thus DAX would
> > > > still get enabled for such inodes? What am I missing?
> > > 
> > > Maybe __ext4_new_inode() should set the encryption flag on the inode
> > > earlier?  Currently it decides whether the inode will be encrypted, then
> > > calls ext4_set_inode_flags(), then calls fscrypt_set_context() (and thus
> > > ext4_set_context()).  That last step sets the flag and calls
> > > ext4_set_inode_flags() *again*.
> > > 
> > > I don't remember if there's a reason for that redundancy, but it might
> > > just be for historical reasons.  ext4_set_context() is called in two
> > > different cases: when a new inode is created and it's encrypted from the
> > > beginning, and when FS_IOC_SET_ENCRYPTION_POLICY is executed on an empty
> > > directory.  The latter does have to set the encrypt flag there.
> > >  
> > > - Eric
> > 
> > Here's an idea.  I haven't tested it though.
> > 
> > Note that this would align ext4 closer with f2fs, which already sets the
> > encrypt flag before it calls fscrypt_set_context().
> 
> Thanks! This definitely looks much more obvious than Ojaswin's fix.
> Ojaswin, does this fix work for you?

Hi Jan, Eric, yes I agree this seems to be a better approach and it is
working in my setup. I'll test it a bit more tomorrow but looks good
overall.

Thanks,
Ojaswin

> 
> 								Honza
> 
> > 
> > diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
> > index f41f320f4437..c4bfe18fd527 100644
> > --- a/fs/ext4/crypto.c
> > +++ b/fs/ext4/crypto.c
> > @@ -144,7 +144,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
> >  	if (inode->i_ino == EXT4_ROOT_INO)
> >  		return -EPERM;
> >  
> > -	if (WARN_ON_ONCE(IS_DAX(inode) && i_size_read(inode)))
> > +	if (WARN_ON_ONCE(IS_DAX(inode)))
> >  		return -EINVAL;
> >  
> >  	if (ext4_test_inode_flag(inode, EXT4_INODE_DAX))
> > @@ -163,6 +163,14 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
> >  	 */
> >  
> >  	if (handle) {
> > +		/*
> > +		 * ext4 should have set the encrypt flag on the inode already,
> > +		 * and it should not have enabled inline data.
> > +		 */
> > +		if (WARN_ON_ONCE(!IS_ENCRYPTED(inode)))
> > +			return -EINVAL;
> > +		if (WARN_ON_ONCE(ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)))
> > +			return -EINVAL;
> >  		/*
> >  		 * Since the inode is new it is ok to pass the
> >  		 * XATTR_CREATE flag. This is necessary to match the
> > @@ -170,21 +178,10 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
> >  		 * function with the credits allocated for the new
> >  		 * inode.
> >  		 */
> > -		res = ext4_xattr_set_handle(handle, inode,
> > -					    EXT4_XATTR_INDEX_ENCRYPTION,
> > -					    EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
> > -					    ctx, len, XATTR_CREATE);
> > -		if (!res) {
> > -			ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
> > -			ext4_clear_inode_state(inode,
> > -					EXT4_STATE_MAY_INLINE_DATA);
> > -			/*
> > -			 * Update inode->i_flags - S_ENCRYPTED will be enabled,
> > -			 * S_DAX may be disabled
> > -			 */
> > -			ext4_set_inode_flags(inode, false);
> > -		}
> > -		return res;
> > +		return ext4_xattr_set_handle(handle, inode,
> > +					     EXT4_XATTR_INDEX_ENCRYPTION,
> > +					     EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
> > +					     ctx, len, XATTR_CREATE);
> >  	}
> >  
> >  	res = dquot_initialize(inode);
> > diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> > index a40cb27f8116..3848244af77a 100644
> > --- a/fs/ext4/ialloc.c
> > +++ b/fs/ext4/ialloc.c
> > @@ -997,6 +997,8 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
> >  		err = fscrypt_prepare_new_inode(dir, inode, &encrypt);
> >  		if (err)
> >  			goto out;
> > +		if (encrypt)
> > +			i_flags |= EXT4_ENCRYPT_FL;
> >  	}
> >  
> >  	err = dquot_initialize(inode);
> > @@ -1306,6 +1308,7 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
> >  	ei->i_extra_isize = sbi->s_want_extra_isize;
> >  	ei->i_inline_off = 0;
> >  	if (ext4_has_feature_inline_data(sb) &&
> > +	    !(ei->i_flags & EXT4_ENCRYPT_FL) &&
> >  	    (!(ei->i_flags & (EXT4_DAX_FL|EXT4_EA_INODE_FL)) || S_ISDIR(mode)))
> >  		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
> >  	ret = inode;
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
