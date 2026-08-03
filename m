Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E40439A05D;
	Mon,  3 Aug 2026 06:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785738952; cv=none; b=LnBVM5BoK06L5V10km4cXY9uIDy5lDKhfYwmYpLFGTUoBbSDWGztZ9DCWtPCEoFnEJeizz1kC847jfu2tV3njBcsbdSk9WoAvsdP59XPO7MMy3+C3x6xV8WT4Xdd9yhP6DQEnEoLTrjq3Ke2hXlMLcw+ii8KBVQdzTPtdID6mP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785738952; c=relaxed/simple;
	bh=b7GhfLIgunin+XrKbAWb3E/EVQU56E1j2UsGr2I2hQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uhDgf7tYpP6pmLsgpElILRN3pMxamvZKFryfPDBClOajpif2KhssnNTuQWuBwhicKq9/TRUNFgW7QvwPvT0TBYiS2JIKQqK2L/64t8izENWlAX3IAGMZZFJOMj+uUqpY2sIKNd9+f1tkkFuRbUkQ7ta6UlPtd1OYH3gf7jAZmJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WSlt4dv7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WSlt4dv7"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 672LlTRA2563836;
	Mon, 3 Aug 2026 06:30:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=PVf4BiR/GDsrpYxxKaTjnyJAceg/Jv
	Eb8yHgw3/K0wY=; b=WSlt4dv7uTtwlQSVIA+6Ohoi9r0MLxiEnM5dBeulVORfiJ
	4RSzttDSXJ9fml5JUayGwASmS2QTC9zwKJSIWgpgQHBLvbPbkHg3MRA3MQIpXUr+
	gmGMAighuxeGeBKK1t96iwhvDnun+uNm3kAEUGOWHxS4CPo8jMr5FTTveRc8Yh8v
	dhYpa49m5zSdjbGE9tUjETQmuYYCqM5pw8BW8nc4D6D09KGxByfBBP4cYbNDgNie
	RYCZoeCeAvrSlvq8v4mK9hKkQWZVVDbak2KZFl5akmSjlE5xis+XyDigXMwQddzI
	JwrjgvZ7ahlCG2KTcpIMoh1QJMVBOvs25PZwJ6ug==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8fqf5mh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 06:30:06 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6736QL5f024714;
	Mon, 3 Aug 2026 06:30:05 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsugvv4wa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 06:30:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6736U3eJ34996572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Aug 2026 06:30:03 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE3912004E;
	Mon,  3 Aug 2026 06:30:02 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4C0EB20040;
	Mon,  3 Aug 2026 06:30:00 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  3 Aug 2026 06:30:00 +0000 (GMT)
Date: Mon, 3 Aug 2026 11:59:57 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        yi.zhang@huawei.com, yizhang089@gmail.com, chengzhihao1@huawei.com,
        yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH 2/2] ext4: protect WRITE_ZEROES written extents with
 orphan list
Message-ID: <anA1Zbwr4yXcK12E@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260729085918.3336221-1-yi.zhang@huaweicloud.com>
 <20260729085918.3336221-3-yi.zhang@huaweicloud.com>
 <amyP2KXXgLUC0_aC@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <c02696f0-308f-4bee-b7b3-95d702fa441a@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c02696f0-308f-4bee-b7b3-95d702fa441a@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: fg75q4ZaU6HtfC4zWmxXWRPiC2rOwAlH
X-Proofpoint-ORIG-GUID: 3zMWp_CH48Jj8z5v51Pm-37RYaIH_yiO
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDA1NCBTYWx0ZWRfX2dNcKFzvI9Il
 0wLjYWrx8mv/2Ji60ZpGE9/iDDcJbSOLOwDgVeBD3vEEqF/ljE0rRtO6JyHkXwRP3Ro1M5LZvfJ
 mwLbmYMs5FYXQRogNU3ML1UKgcmIr44=
X-Authority-Analysis: v=2.4 cv=K8cS2SWI c=1 sm=1 tr=0 ts=6a70356e cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=i0EeH86SAAAA:8 a=VnNF1IyMAAAA:8 a=iFGIIU8KwMnqUIUZtnYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDA1NCBTYWx0ZWRfX6PBLvQr6v3wN
 6jzEItAi7J6XzwX4W60OuFHFt8/GjS5tiwBIfI5Q0EJa5x3ErtJFesRE3C16090pnWpgTJyfvzg
 /X0B2hhUQn3y/Fgx8iI8oIpFq1pUJ4vp/wyQN9GjL8aCbsSADOcbkmxZ87968xKJoW/p0AX2Is2
 98nDuEqlCA3tv5J1xUguvdn7lv6/v5IdJYn4jijsLb7Nhc36XYuRFe0rliuFGb+mA5fkoY6fG0c
 XTvKOEPnJXiPM0m1DK/WNO8GvNy0TLmUtR3AgpTK38gBmzUL1Xs5xWX5jleNPtLi0u66JbAw4EI
 W1AhIp/81A4/nnOZeKGmQz+XWsx5U640k+SWPXVZMHXfWHq4oeawl13JbxF1S2wCYGqsZs6LO/J
 KGC6HwWLB5DE+7oZOWasWr1Vo/BQDL9W3mcVVvy9BOrdQNzLUuPDpxTeG+916tU/d4WzoDJsNa+
 Is3PC7qKHCGMrPvYRMA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608030054

On Mon, Aug 03, 2026 at 09:31:53AM +0800, Zhang Yi wrote:
> On 7/31/2026 8:06 PM, Ojaswin Mujoo wrote:
> > On Wed, Jul 29, 2026 at 04:59:18PM +0800, Zhang Yi wrote:
> >> From: Zhang Yi <yi.zhang@huawei.com>
> >>
> >> In ext4_alloc_file_blocks(), the WRITE_ZEROES path converts unwritten
> >> extents to written in one transaction, while i_disksize is updated to
> >> cover them only in a later transaction. A crash in between leaves
> >> written extents beyond i_disksize on disk, which fsck will complain
> >> about.
> >>
> >> To fix this, add the inode to the orphan list in the same handle that
> >> does the conversion, and remove it once i_disksize has caught up.
> >> Also add a sanity check to ensure conversion does not extend beyond EOF.
> >>
> >> Since ext4_alloc_file_blocks() is called from the fallocate() path,
> >> partial allocation is safe. On partial conversion failure, advance
> >> i_disksize only up to the boundary of successfully converted blocks, so
> >> that orphan cleanup sees a consistent state. Document this behavior in
> >> the function comment.
> > 
> > Hi Yi,
> > 
> > Look good,
> > 
> > Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> 
> Hi, Ojaswin,
> 
> Thank you for the review!
> 
> > 
> > Just a small question below:
> >>
> >> Reported-by: Jan Kara <jack@suse.cz>
> >> Closes: https://lore.kernel.org/linux-ext4/3f6ao5amv7glbgigndtegcucgo3n34ij3lau6l3da3hgdxgn3v@ev66wv3r5umt/
> >> Fixes: f4265b8d32c4 ("ext4: add FALLOC_FL_WRITE_ZEROES support")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> >> ---
> >>  fs/ext4/extents.c | 78 ++++++++++++++++++++++++++++++++++++++++++-----
> >>  1 file changed, 70 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> >> index 1ab1a6e2ed83..a3dde7ba0d23 100644
> >> --- a/fs/ext4/extents.c
> >> +++ b/fs/ext4/extents.c
> >> @@ -4571,6 +4571,22 @@ int ext4_ext_truncate(handle_t *handle, struct inode *inode)
> >>  	return err;
> >>  }
> >>  
> >> +/*
> >> + * Pre-allocate blocks for the range [@offset, @offset + @len). Allocated
> >> + * blocks are marked as unwritten by default. If EXT4_GET_BLOCKS_ZERO is
> >> + * set, the allocated blocks are zeroed on disk and their extents are
> >> + * converted to written state.
> >> + *
> >> + * When @new_size is nonzero, the caller intends to extend the file, and
> >> + * the file size should be updated to the end of the allocated blocks.
> >> + *
> >> + * Allocation may partially succeed due to some non-fatal issues. In that
> >> + * case, i_disksize (and i_size) is advanced up to the successfully
> >> + * processed portion of the range.
> >> + *
> >> + * Return 0 on success, or a negative error code on failure or partial
> >> + * failure.
> >> + */
> >>  static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
> >>  				  loff_t new_size, int flags)
> >>  {
> >> @@ -4585,6 +4601,7 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
> >>  	loff_t epos = 0, old_size = i_size_read(inode);
> >>  	unsigned int blkbits = inode->i_blkbits;
> >>  	bool alloc_zero = false;
> >> +	bool orphan = false;
> >>  
> >>  	BUG_ON(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
> >>  	map.m_lblk = offset >> blkbits;
> >> @@ -4659,19 +4676,49 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
> >>  
> >>  		if (alloc_zero &&
> >>  		    (map.m_flags & (EXT4_MAP_MAPPED | EXT4_MAP_UNWRITTEN))) {
> >> +			ext4_lblk_t converted;
> >> +
> >> +			WARN_ON_ONCE(map.m_lblk + map.m_len >
> >> +				EXT4_B_TO_LBLK(inode, new_size ?: old_size));
> >> +
> >>  			ret = ext4_issue_zeroout(inode, map.m_lblk, map.m_pblk,
> >>  						 map.m_len);
> >> -			if (likely(!ret))
> >> -				ret = ext4_convert_unwritten_extents(NULL,
> >> -					inode, (loff_t)map.m_lblk << blkbits,
> >> -					(loff_t)map.m_len << blkbits, NULL);
> >> -			if (ret)
> >> +			if (unlikely(ret))
> >>  				break;
> >> +
> >> +			handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
> >> +						    credits);
> >> +			if (IS_ERR(handle)) {
> >> +				ret = PTR_ERR(handle);
> >> +				break;
> >> +			}
> >> +
> >> +			ret = ext4_convert_unwritten_extents(handle,
> >> +					inode, (loff_t)map.m_lblk << blkbits,
> >> +					(loff_t)map.m_len << blkbits,
> >> +					&converted);
> >> +			if (ret)
> >> +				map.m_len = converted;
> >> +
> >> +			/*
> >> +			 * If blocks beyond i_disksize are converted, add
> >> +			 * the inode to the orphan list and advance the epos.
> >> +			 */
> >> +			if (new_size && converted) {
> >> +				ret2 = ext4_orphan_add(handle, inode);
> >> +				ret = ret ? ret : ret2;
> >> +				orphan = true;
> >> +			}
> >> +
> >> +			ret3 = ext4_journal_stop(handle);
> >> +			ret = ret ? ret : ret3;
> >>  		}
> >>  
> >>  		map.m_lblk += map.m_len;
> >>  		map.m_len = len_lblk = len_lblk - map.m_len;
> >>  		epos = EXT4_LBLK_TO_B(inode, map.m_lblk);
> >> +		if (ret)
> >> +			break;
> >>  	}
> >>  
> >>  	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> >> @@ -4687,11 +4734,23 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
> >>  	if (epos > new_size)
> >>  		epos = new_size;
> >>  
> >> -	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
> >> -	if (IS_ERR(handle))
> >> -		return ret ? ret : PTR_ERR(handle);
> >> +	handle = ext4_journal_start(inode, EXT4_HT_MISC, 2);
> >> +	if (IS_ERR(handle)) {
> >> +		/*
> >> +		 * The conversion has successfully completed. Not much to
> >> +		 * do with the error here so just cleanup the orphan list
> >> +		 * and hope for the best.
> >> +		 */
> >> +		if (orphan && inode->i_nlink)
> >> +			ext4_orphan_del(NULL, inode);
> >> +		ret2 = PTR_ERR(handle);
> >> +		goto out;
> >> +	}
> >>  
> >>  	ext4_update_inode_size(inode, epos);
> >> +	if (orphan && inode->i_nlink)
> >> +		ext4_orphan_del(handle, inode);
> >> +
> > 
> > So I believe the i_nlink check is incase the inode is already at i_nlink
> > = 0 before the fallocate() was called and hence mostly already on the
> > orphan list. We need to skip deletion from the list as inode eviction
> > will handle cleaning it up, right?
> 
> Yes, after ext4_evict_inode() has reclaimed all the file blocks, the
> inode will be cleared from the orphan list.

Cool, thanks for confirming :)

Regards,
ojaswin

> 
> Thanks,
> Yi.
> 
> 
