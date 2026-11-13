Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794552109;
	b=NnWIl6keSVArQinvLHO96T/UA31JhxRb1IWEsvzDsDfGVBrMt8SUXgHdkbw92d9BDpUr
	 nW9z9OPCj1lQNOSxY33+9kSSlpyjUfQeLfO0uuqetl/28UCTR1YN6RV2SbgdHUuzARkCK
	 lxDtj26JfpUmv51UU/j2SRbWOPmHhKDu1O9pU0mLROvfUpjU+0kpNrN/18pbJREjSF8bo
	 iTtEn1LEVryVEKCNrkqhV8Up1/lsqVPgIIbkMV/vt7WIO8WwrIR8GShWcWNe/Z+2gJL2X
	 DDupa88JK0DAPJYc6LqF93Z/1sDcW7q0jHsagFIx7SH1kfyf3OFy9mxtk31Z9wol9gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794552109;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=PhGKbAErLApZ03gpAakytCwNcdYqB4uSnOIrA1S1EcI=;
	b=Y4QqgqFLE3yWh95yyIN61mtCuD8lZ7brUPfXHvlaZWi1YR6ydKrtd3PlyXQa3aEsp8on
	 QmvTmb+37wQDzrABJjlE1FugV+Jik/RlCSTdi7lRAl9EFQ+hwKbNkN13JRNKgpt3YcTvs
	 NbkPxnj3uldsijG6rY/1lnbiCO5KsE7ZVhlHiRX+bjybDheeqTt7PY/CYg5Y1RZn5VtlH
	 xKMmihjr/zM9Aoy/F0V9TVgL62LTyjU6LE6cQTedqXzcRHk7VbDAyzMCAR34VpVo+XS3p
	 KpthP/mU/Ho8qvDErwGfDlSmmVPBcJ2fxteOnlZTAzGSNNepgiNdg1qY7mZC3ozD5dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=kbd9hk+S;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBD0606A31C;
	Fri, 13 Nov 2026 06:41:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0DBD0606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=kbd9hk+S
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AD6NaNT2248411;
	Fri, 13 Nov 2026 06:40:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=PhGKbAErLApZ03gpAakytCwNcdYqB4
	uSnOIrA1S1EcI=; b=kbd9hk+SK1aZUDXdXthiBAMeexOHhUQ0XkMcQ23UAqZX/l
	CfGseeGLqRfUK+5sOp3JlioqSh2sAwY0KGRrU/OEwCZxaW7TlurE+h1QDIajGWr5
	ALdB7qKU2FXYtvZ2OufDfOYrE27XUG8ii4JRklcXjJMqqqrM/FXXjMD10OPqmulJ
	4UEc+Hg7Tn3LdNTHIutLYhpr2WsU4L3cs0LfP1hLkWrMTsdR4n4RmhcFPBtky5Qn
	5YRIKx78BoPW3EbZbXSbF01dw2EsOP8SyuLFO2r92hDiEKASJRKXT40NH5zTGuDf
	8W4f42KPCrLp4dwDeFJ0wlfr19sIsNGfeZKNNL6g==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hsug6jc89-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 13 Nov 2026 06:40:30 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AD5KT501823387;
	Fri, 13 Nov 2026 06:40:29 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hwjcf1v9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Nov 2026 06:40:29 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AD6eRj527656476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Nov 2026 06:40:28 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D3E3520040;
	Fri, 13 Nov 2026 06:40:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4146B2004B;
	Fri, 13 Nov 2026 06:40:25 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.17.247])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 13 Nov 2026 06:40:25 +0000 (GMT)
Date: Fri, 13 Nov 2026 12:10:22 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] ext4: fix endio zeroout corruption by tracking
 to-be-converted unwritten IOs
Message-ID: <avavp0mLO8WoYo98@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com>
 <fce5c384-3a18-4156-b0eb-a0d584b8b459@huaweicloud.com>
 <avVm8XuQbU4sSIF1@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <167a29b6-32cc-4d98-b664-4b1db1320609@huaweicloud.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167a29b6-32cc-4d98-b664-4b1db1320609@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: nMhtp4Xrn7qm_Eg_OiQXWAe24lD5mEhh
X-Authority-Analysis: v=2.4 cv=PeVqFShd c=1 sm=1 tr=0 ts=6af6b0df cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=K2Yr91b-bR72nt8C4HQA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: V8k0RFc0pbhAEfHrdE5ZfYwB6mq9jAKf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEzMDAyNCBTYWx0ZWRfX67NqFuSfIIN6
 5SORys6IV/tWMyN9I9LQEOJeOkx1YMs6cFSjin1Bz8TzJUvuXmlo20OGYPcH2TfqtUgZlTcEWmv
 1Djc8m8wtVu4yiSmONq1I9N755c7tkLT4Mf6vzfg9q9bwGRVhh6+GsAAUxtO8UVY16aLme83Upl
 DQoyAT6k0nV7ukoWBaZrru2MXfM1k/FlRAqpBIMYGv5vcTicKbGRIZlzVvDe2YJoLDOYVvmY0nK
 jPvHqrtVCsRmCFUWlxO/sYc+ugjoWdE2+b2XsJI+vcTs5AZqBiCoK0Mfp9sl23ewNah/9E8mih3
 dZxQPdh1i/a+lZS57ZCSODncrUhp0IaGC8ZSLxXkwumuuTfirugeHAcL5/sUXhi26/Oim6MsTr4
 tcZy/H+TLXzlbQt2AoiCbza8bRHsJ5px+EB0TPQFo744clSxjcbhmwkFdiW6wRMpcpKsjPPjpYb
 8QVZVitQFg7kBWzomvQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEzMDAyNCBTYWx0ZWRfX9hKuJvaI/26w
 iEsyYxPRPAK7aCBJUYhyxsc3YcXVguS15fDQwuLRg62jJv7ZThZsG66e4JVIC0abiOPA/oJeMPO
 ncbbjaDy1ugKPepRAZXCGRfrYth4byw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-13_02,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 malwarescore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611130024

On Fri, Nov 13, 2026 at 11:28:46AM +0800, Zhang Yi wrote:
> On 11/12/2026 3:12 PM, Ojaswin Mujoo wrote:
> > On Thu, Nov 12, 2026 at 11:33:35AM +0800, Zhang Yi wrote:
> >> On 11/3/2026 2:26 AM, Ojaswin Mujoo wrote:
> >>> There is a data corruption in the zeroout fallback
> >>> ext4_split_extent_zeroout() when we encounter an error like ENOSPC
> >>> while trying to perform endio extent splitting.
> >>>
> >>> The issue was discovered by Fedora coreos community while using 1kb
> >>> blocks size on a 64kb pagesize arch like powerpc or aarch64 and the
> >>> discussion can be found at [1].
> >>>
> >>> ** The Issue **
> >>>
> >>> The issue can be encountered as follows:
> >>>
> >>> 1. Make an FS with no reserved to root reserved blocks and fill it
> >>>    completely.
> >>> 2. Delete a file so that ext4_sb_info thinks there is free space but
> >>>    mballoc doesnt have any (until txn is committed).
> >>> 3. Now when endio kicks in it eventually reaches:
> >>>
> >>> ext4_handle_unwritten_extents
> >>>   ext4_split_convert_extents
> >>>     ext4_split_extent
> >>>       ext4_split_extent_at
> >>>         ext4_ext_insert_extent
> >>>           ext4_new_meta_blocks  // extent tree split/grow needs a block
> >>>             ext4_mb_new_blocks
> >>>               ext4_claim_free_clusters  // thinks we have free space but mballoc
> >>>                                            has none until txn commit frees it
> >>>               ext4_mb_regular_allocator
> >>>                 // return -ENOSPC
> >>>     // ext4_split_extent fallsback to zeroout
> >>>     ext4_split_extent_zeroout
> >>>       // We try to zeroout surrounding unwritten ranges. This code has a bug
> >>>          where we zero an unwritten extent which could have valid data on disk 
> >>>          whose endio has not yet converted it
> >>>
> >>> The main issue is that zeroout assumes any unwritten extent is valid to
> >>> zeroout but it could actually be a soon-to-be-converted extent holding
> >>> valid data.
> >>>
> >>
> >> Hi Ojaswin,
> >>
> >> Thank you for your analysis! This makes sense to me. I apologize for not
> >> having considered this concurrent scenario earlier and for amplifying
> >> the data loss issue.
> >>
> >>> ** The fix **
> >>>
> >>> The way this series fixes it is by per-inode tracking the no. of
> >>> unwritten IOs that are submitted but not yet converted
> >>> (ei->i_conv_pending_ios). If we end up in the zeroout fallback and see
> >>> there are such IOs existing in the inode, then we don't zeroout and just
> >>> return back the original error. More design notes can be found in
> >>> subsequent patches.
> >>>
> >>
> >> Regarding the solution, I agree that your approach looks like it can fix
> >> this issue, and the idea is fairly straightforward. When zeroing out, if
> >> there is other concurrent I/O, just fall back and return an error.
> >> However, I've been thinking about it over the past few days, hoping to
> >> find another simpler and more elegant solution, but that seems rather
> >> difficult.
> >>
> >> First, due to the map range caching mechanism in the iomap writeback
> >> path and for performance reasons, we probably can't go back to splitting
> >> extents when issuing I/O as before. Moreover, the previous approach also
> >> couldn't completely avoid zeroing the entire unwritten extent when the
> >> I/O completes, so the problem already existed before. It just required
> >> concurrency and had a very low probability. Therefore, I agree that we
> >> need to address this problem head-on.
> > 
> > Hi Zhang, thank you so much for looking into this.
> > 
> > So I agree that it is a tricky issue to solve since we don't want to
> > add too much complexity in the fast path. Actually the first prototype I
> > did for this (back in sep before we started seeing this in distros) was
> > becuase I was working on moving zeroout to the fast path rather than
> > just a fallback and had hit this fairly easily there.
> > 
> > In the first prototype, I took the exact approach you discussed here. A
> > new CONV_PENDING type for extent cache with all the plumbing to ensure
> > we don't lose the status untill the conversion happens. What I reliased
> > was that although this was a much more accurate fix, it needed lots of
> > core changes to es layer, and I ran into several bugs where data got
> > corrupted cause the status was getting lost or not in sync. I did manage
> > to fix most of them but it somehow makes me a bit uncomfortable from the
> > POV of a backport.
> > 
> > The patch for the inital version (v v rough and not cleaned up since
> > Sep) can be found here [1]. 
> 
> Ha, it looks like we're thinking along the same lines, the
> implementation of this POC is largely similar to what I had in mind.
> Thank you for working on this. Feel free to reach out anytime to
> discuss.  :)

Of course, thanks! 
> 
> > 
> > I'll address your below ideas on how/if i implemented them in [1]
> > 
> >>
> >>
> >> Here's a rough idea I'd like to share:
> >>
> >> 1. Add an in-core extent status flag, something like
> >>    EXTENT_STATUS_PENDING_WRITTEN.  Like EXTENT_STATUS_DELAYED, these
> >>    entries would be must-keep.  The idea is to mark ranges for which
> >>    we've submitted I/O over an unwritten extent but haven't done the
> >>    conversion yet.  It would just be an extra flag on top of
> >>    EXTENT_STATUS_UNWRITTEN; the zeroout paths would be the only thing
> > 
> > I added a CONV_PENDING es type rather than flag. I did start with the
> > flag over UNWRITTEN approach but most places like merging logic care
> > that the type rather than flag and which was causing us to merge
> > UNWRITTEN and CONV_PENDING which we can't allow. So instead of modiying
> > code around merging and other areas I just made CONV_PENDING a separate
> > type.
> > 
> 
> Yeah, it's also fine with me to make it a separate type, whichever is
> clearer.
> 
> [...]
> 
> > I agree that in the long term es cache approach is definitely the way to
> > move forward. I'm just wondering if it would be feasible to backport
> > something like that. Then again if we want to backport only till 7.0,
> > maybe it wont be that big of a deal. 
> > 
> > There are 2 approaches that I can see here:
> > 1. USe this patch set's counter apprach as a stop gap, easy to backport
> > solution which works but is a bit clumsy. With the immediate fix in
> > place, we can take time to test and design the extent status approach
> > correctly and land it as a feature rather than something that needs
> > backport.
> > 
> > 2. Ditch the counter approach and just fix it in one shot with extent
> > status approach like in [1].
> > 
> > I'm happy to work on either of the two, what do you think shall be the
> > right way forward?
> > 
> 
> Personally, although I still think this counting approach is a bit
> hacky, I'm not opposed to using it to fix the problem first.

Got it, I'll take some time to cleanup the es cache version and maybe
start testing it so that we get an idea of how stable it is. In the
meantime lets see if Jan, Ted or ext4 community has any particular
prefernece wrt the approach we should take. 

Regards,
ojaswin
> 
> Best Regards,
> Yi.
> 
