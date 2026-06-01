Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327703E92AF;
	Mon,  1 Jun 2026 18:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780337790; cv=none; b=WGG20CrhwAhyql0sUL3+EtQwAtwdOinPk20ZJXYxZUw5v/Cjmi5lUBgX2DD30reprmO6Z3+Z116ARjKGQYfLqlVAzuV4p44gZCOEcSaLrE7EsCRhXLVXYShDqyDoFV7N/Lj2NCbymFacJH+af63/eKlv2uwI8KaxlkorrvzuUMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780337790; c=relaxed/simple;
	bh=+JZyxlnLG4yIm70Uiq+bt3twBwDF+C0+1D1CZSIdPrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z6Th6fMoGNEyAf+UZ26+BfkVy0ZDkOq7OsA8wwt59qxE1zp5hkNIB2IvHMWmiqX1CPIIPZPbNZRxQ1NFvw7C1DI0gbMo2ov60jcnd1z2XcIjmnU32PaMrJpoLPcKA3Ov6glzHZACWCjYrs8wy7XJpP0thmLZ2NmzDJs0DPu9+9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lW2eNM/w; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lW2eNM/w"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651EvxA61089524;
	Mon, 1 Jun 2026 18:15:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=LNsjzM
	q8G3pWFZrXjeqUMsYuArLy17edPoMYskzNxhA=; b=lW2eNM/wM31wIVizk/LWZs
	l2rSStyo+SyYEZFTqMOFKRnBNREgXQyyDBFi0INndlfAEmQ/lhtyOO5se+bhVbcX
	UVjZb/A4hyBPKo46W1nCT9v3s2PGAX+rN/7ZpgRX3JTl5i7PvRNhr186ZyWQjsim
	6VOE+VtuH955UqgcQtWt0ZeUsNFUA3Fvokd0BxZ3I2OYFuFLMbcZ3sVep/uC5wBd
	eNAr2nJIuOsl+p19DkCrrhFtb0J0f8If5mmPpFIBQzjMbZVpge2fN5myu5mOskOs
	ScIC6jM9AfeH4UbxsEghGR3/RjQbxJVg+Vco/FwxBZ52nyv1YXqwqlaTH5Ow/WQA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efqjq2992-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 18:15:46 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 651I9CbV007810;
	Mon, 1 Jun 2026 18:15:45 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4egcwy76yg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 18:15:45 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 651IFik947579400
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Jun 2026 18:15:44 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F9ED2004E;
	Mon,  1 Jun 2026 18:15:44 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EA1720043;
	Mon,  1 Jun 2026 18:15:39 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.223.138])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  1 Jun 2026 18:15:38 +0000 (GMT)
Date: Mon, 1 Jun 2026 23:45:35 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yizhang089@gmail.com>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        jack@suse.cz, ritesh.list@gmail.com, djwong@kernel.org,
        hch@infradead.org, yi.zhang@huawei.com, yangerkun@huawei.com,
        yukuai@fnnas.com
Subject: Re: [PATCH v4 17/23] ext4: submit zeroed post-EOF data immediately
 in the iomap buffered I/O path
Message-ID: <ah3MR1gYMm3nKe5f@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-18-yi.zhang@huaweicloud.com>
 <ahb0fqVCige08_--@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <7c24dc47-0c3e-4ee9-b113-f9ca9f3a6ebf@huaweicloud.com>
 <ah1MG1b89ELKM-Fl@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <cc458b0f-4637-4313-a2cd-45db4cdaa250@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cc458b0f-4637-4313-a2cd-45db4cdaa250@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 3REOHdx0yr39mVksNo6b04WLeJtsTteF
X-Proofpoint-GUID: 16w4JrV8--xwYKPvaQaINq0o4QFuLVWO
X-Authority-Analysis: v=2.4 cv=bcVbluPB c=1 sm=1 tr=0 ts=6a1dcc53 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=i0EeH86SAAAA:8 a=6kKhVdQ7HoyBn60NsQAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDE3OSBTYWx0ZWRfX+eUqUAhteCt0
 ageqal2PRpyBiDNd8wc1bkcNfWsedWSwFzblB4+5+XRYd+lHJuQThMGdrJ6LQ0MhmYqlhnwMCLq
 NpFiEursv2xAsIDFCwrqST6zRtr2HM7pwQeEGXNDlHEpMFuD5y9EQDFCLS9MFBAeJvG/4UiZ3Fa
 Y6SlVEoXO57vQr/MRDKl5vMIMfp7O8wndMW0C3KpTSQ4MWURMsHIcGngm232FVhiqXd22qh4W6Y
 tu/JxOnG7mLntjSWO0AO1Zf0nOZqegGZTAW9zVWibf5ECywxOxwoSm7DlZxQ1hHFE1jYN5or2v0
 DHlYwKW0CLMvCdEA168BpD2HmtpNfhOrlmVPM8WbG+HL+mhwplh2c2cbobXmadrPh+HbQJ/m/49
 oERVXi0vQC0TOGNBnBi6iZ3Fd9XDsqT3gz4nyjLIjAV2Vtzm7SWVjm6i8Am5aE4kA+vVVuPDRGW
 8+PbcQwpPbQkpSnW3Aw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_05,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 adultscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606010179

On Mon, Jun 01, 2026 at 08:22:09PM +0800, Zhang Yi wrote:
> On 6/1/2026 5:08 PM, Ojaswin Mujoo wrote:
> > On Sat, May 30, 2026 at 10:53:24AM +0800, Zhang Yi wrote:
> > > On 5/27/2026 9:41 PM, Ojaswin Mujoo wrote:
> > > > On Mon, May 11, 2026 at 03:23:37PM +0800, Zhang Yi wrote:
> > > > > From: Zhang Yi <yi.zhang@huawei.com>
> > > > > 
> > > > > In the generic buffered_head I/O path, we rely on the data=order mode to
> > > > > ensure that the zeroed EOF block data is written before updating
> > > > > i_disksize, thus preventing stale data from being exposed.
> > > > > 
> > > > > However, the iomap buffered I/O path cannot use this mechanism. Instead,
> > > > > we issue the I/O immediately after performing the zero operation
> > > > > (without synchronous waiting for performance). This can reduce the risk
> > > > > of exposing stale data, but it does not guarantee that the zero data
> > > > > will be flushed to disk before the metadata of i_disksize is updated.
> > > > > The subsequent patches will wait for this I/O to complete before
> > > > > updating i_disksize.
> > > > > 
> > > > > Suggested-by: Jan Kara <jack@suse.cz>
> > > > > Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > > > 
> > > > I think we discussed that we may not need to do this [1] but I guess
> > > > you've decided to make the tradeoff of issuing the IO to avoid having to
> > > > wait for bg flush to complete the tail page zeroing
> > > > 
> 
> I'm glad to hear that, thanks.
> 
> > > 
> > > Yes. For truncate up and append fallocate, originally i_disksize would
> > > be updated immediately, and the change would be persisted via the
> > > journal within default 5 seconds. But now, if the tail page is not
> > > committed immediately, the update to i_disksize will be delayed by about
> > > 30 seconds, and persistence will be postponed to around 35 seconds. I'm
> > > not sure what impact this change might have — I just don't really want
> > > to introduce it.
> > 
> > > For normal append writes, the impact is minimal, unless we call
> > > sync_range to sync the portion of data that extends beyond EOF.
> > 
> > Hmm while trying to retain the behavior for falloc and truncate up,
> > we end up changing it for append writes :) But anyways, I understand
> > your reasoning and don't have any strong opinions against it. I'll let
> > Jan pitch in since he had some comments around this.
> > 
> > > 
> > > In addition, if the zeroed page is not issued here immediately, the
> > > logic will become more complex because we need to more careful about the
> > > order of write-back IOs to prevent deadlock issues caused by mutual
> > > waiting.
> > 
> > You mean an endio completion waiting for ordered IO to complete but
> > ordered IO writeback is somehow waiting for this endio completion? Is that
> > actually possible?
> 
> Well, after thinking it over more carefully, it seems this is
> impossible, I cannot think of a scenario that could trigger this kind of
> issue. The generic writeback process always executes writeback in folio
> index order, so there would be no situation where a later data I/O
> depends on an earlier ordered I/O. Even if both kinds of IOs are placed
> in the same ioend, there should be no problem. I was confused and
> overthinking it.
> 
> From this perspective, if we can accept that truncate up and fallocate
> will have longer persistence time by default(I guess this is
> acceptable), we can avoid writing back zeroed data immediately. To
> achieve this, we only need to consider the case of sync file range. :-)

Yeah, I think during writeback we will have to submit the ordered data
if we are writing back data beyond the i_disksize. 

If this is straightforward enough to implement, I think this approach
would be a safer choice cause we will avoid overheads due to small,
random ordered IOs overworking the writeback layer.

> 
> Regards,
> Yi.
> > > 
> > > > However, I think one side effect might be many threads calling the
> > > > writeback mechanism to issue zero IOs which might not scale well. I
> > > > don't know if it'll be a huge problem though, I guess it's a sort of
> > > > thing we will have to deal with in case we see it in real world
> > > > workloads.
> > > > 
> > > 
> > > I agree with you. However, I suspect that unless we run some specific
> > > benchmark tests, it should be difficult to encounter a large number of
> > > post-EOF append writes and truncate up operations in real-world usage
> > > scenarios — and I haven't come across such scenarios yet. For
> > > simplicity, I'd like to proceed with this implementation for now. If we
> > > do run into actual problems later, we can consider not issuing I/O
> > > directly here, but instead: 1) find the ordered block in
> > > ext4_sync_file() and perform writeback; 2) ensure writeback ordering
> > > for normal background writeback as well — otherwise, there is a risk of
> > > deadlock (mutual waiting). What do you think?
> > 
> > Yes sounds good Yi, we can deal with performance tuning later.
> > 
> > Regards,
> > Ojaswin
> > 
> > > 
> > > Cheers,
> > > Yi.
> > > 
> > > > [1] https://lore.kernel.org/linux-ext4/yhy4cgc4fnk7tzfejuhy6m6ljo425ebpg6khss6vtvpidg6lyp@5xcyabxrl6zm/
> > > > 
> > > > > ---
> > > > >   fs/ext4/inode.c | 66 ++++++++++++++++++++++++++++++++++++++++---------
> > > > >   1 file changed, 55 insertions(+), 11 deletions(-)
> > > > > 
> > > > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > > > index 239d387ffaf2..e013aeb03d7b 100644
> > > > > --- a/fs/ext4/inode.c
> > > > > +++ b/fs/ext4/inode.c
> > > > > @@ -4742,6 +4742,32 @@ static int ext4_block_zero_range(struct inode *inode,
> > > > >   					zero_written);
> > > > >   }
> > > > > +static int ext4_iomap_submit_zero_block(struct inode *inode,
> > > > > +					loff_t from, loff_t end)
> > > > > +{
> > > > > +	struct address_space *mapping = inode->i_mapping;
> > > > > +	struct folio *folio;
> > > > > +	bool do_submit = false;
> > > > > +
> > > > > +	folio = filemap_lock_folio(mapping, from >> PAGE_SHIFT);
> > > > > +	if (IS_ERR(folio))
> > > > > +		/* Already writeback and clear? */
> > > > > +		return PTR_ERR(folio) == -ENOENT ? 0 : PTR_ERR(folio);
> > > > > +
> > > > > +	folio_wait_writeback(folio);
> > > > > +	WARN_ON_ONCE(folio_test_writeback(folio));
> > > > > +
> > > > > +	if (likely(folio_test_dirty(folio)))
> > > > > +		do_submit = true;
> > > > > +	folio_unlock(folio);
> > > > > +	folio_put(folio);
> > > > > +
> > > > > +	/* Submit zeroed block. */
> > > > > +	if (do_submit)
> > > > > +		return filemap_fdatawrite_range(mapping, from, end - 1);
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > >   /*
> > > > >    * Zero out a mapping from file offset 'from' up to the end of the block
> > > > >    * which corresponds to 'from' or to the given 'end' inside this block.
> > > > > @@ -4765,8 +4791,10 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
> > > > >   	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
> > > > >   		return 0;
> > > > > -	if (length > blocksize - offset)
> > > > > +	if (length > blocksize - offset) {
> > > > >   		length = blocksize - offset;
> > > > > +		end = from + length;
> > > > > +	}
> > > > >   	err = ext4_block_zero_range(inode, from, length,
> > > > >   				    &did_zero, &zero_written);
> > > > > @@ -4781,18 +4809,34 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
> > > > >   	 * TODO: In the iomap path, handle this by updating i_disksize to
> > > > >   	 * i_size after the zeroed data has been written back.
> > > > >   	 */
> > > > > -	if (ext4_should_order_data(inode) &&
> > > > > -	    did_zero && zero_written && !IS_DAX(inode)) {
> > > > > -		handle_t *handle;
> > > > > +	if (did_zero && zero_written && !IS_DAX(inode)) {
> > > > > +		if (ext4_should_order_data(inode)) {
> > > > > +			handle_t *handle;
> > > > > -		handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
> > > > > -		if (IS_ERR(handle))
> > > > > -			return PTR_ERR(handle);
> > > > > +			handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
> > > > > +			if (IS_ERR(handle))
> > > > > +				return PTR_ERR(handle);
> > > > > -		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
> > > > > -		ext4_journal_stop(handle);
> > > > > -		if (err)
> > > > > -			return err;
> > > > > +			err = ext4_jbd2_inode_add_write(handle, inode, from,
> > > > > +							length);
> > > > > +			ext4_journal_stop(handle);
> > > > > +			if (err)
> > > > > +				return err;
> > > > > +		/*
> > > > > +		 * inodes using the iomap buffered I/O path do not use the
> > > > > +		 * data=ordered mode. We submit zeroed range directly here.
> > > > > +		 * Do not wait for I/O completion for performance.
> > > > > +		 *
> > > > > +		 * TODO: Any operation that extends i_disksize (including
> > > > > +		 * append write end io past the zeroed boundary, truncate up,
> > > > > +		 * and append fallocate) must wait for the relevant I/O to
> > > > > +		 * complete before updating i_disksize.
> > > > > +		 */
> > > > > +		} else if (ext4_inode_buffered_iomap(inode)) {
> > > > > +			err = ext4_iomap_submit_zero_block(inode, from, end);
> > > > > +			if (err)
> > > > > +				return err;
> > > > > +		}
> > > > >   	}
> > > > >   	return 0;
> > > > > -- 
> > > > > 2.52.0
> > > > > 
> > > 
> 
