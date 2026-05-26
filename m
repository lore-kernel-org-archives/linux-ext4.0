Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B783FFAA2;
	Tue, 26 May 2026 17:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779815572; cv=none; b=onMSJfjNn+9bTq+fqiTaR7AbX/485qW4/vp483Lj77rO7O9N6ivAAo3s3wbtfw5VeTmESL6IJBLnZlPokWgWLU6i9KO+78XTrPRJRr5+SvyC5gJ+j0PaklZnYHIZb/80VROYrhfHBwIL9Vz45AHwKzETFhEY3YEyzDZTFXOPSNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779815572; c=relaxed/simple;
	bh=5DQAm7sw3AgE1fMdxJJnxVbZ6OJi1pO1+0w4oVEXiuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sUMoh4xQWy27hBju5nv1oGq/Wy4JDIA8TanQbmYDVi+LXs6pLilflmER5mnHwyOw5JruopEVEm3D10+yBqFHxbL/uvdG2BywK0NYJ/O+S+7H48P/9TomyOOwF7RwMnGvdYjvoGcWXwF5gQwOgDUM0yWtV4p2riq1vonhJW1ynIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZN9St+2y; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZN9St+2y"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64QDV6Ei4180069;
	Tue, 26 May 2026 17:12:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=plOwnj7k8i0tZuoMDZ4j5rsVTAHqHQ
	sA2ZvADMgQ+Dw=; b=ZN9St+2y11H2yz8/9TvPxxYEqkjKsXizXc18fjHYCyTnpj
	N6s8S/BLuq/NFnpIsE2POoqpjBGQBl8ZS9HEMp/ugD/ZD170W66bT+p8+/hn0cs9
	7KfiCYMDrOW30hYne2w4LVeaP0ShzQpFcW3ENqZNgqFVlPZdEwLDfRAZroX62IVe
	u/XNGfi568spwL9k+y58MR/nhkgqGYT+lCkT+p5OA7DlM0aQvocIqdEQymKRzH6q
	x74iOG/7RA+bUBJyjj15jiHT4hVF//seXBdHROw8oyUofXiSiolWe6HFoPZRO78b
	Zj26y+szeCQDWW6kgO/x04G2d13adLjlICT1Xsgw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eb4pdcdbp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 May 2026 17:12:14 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64QH98E7004216;
	Tue, 26 May 2026 17:12:13 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ebrsga73b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 May 2026 17:12:13 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64QHCBJ740829210
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 May 2026 17:12:11 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8149320043;
	Tue, 26 May 2026 17:12:11 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8EAFD20040;
	Tue, 26 May 2026 17:12:06 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.18.153])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 26 May 2026 17:12:06 +0000 (GMT)
Date: Tue, 26 May 2026 22:41:23 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yizhang089@gmail.com>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        jack@suse.cz, ritesh.list@gmail.com, djwong@kernel.org,
        hch@infradead.org, yi.zhang@huawei.com, yangerkun@huawei.com,
        yukuai@fnnas.com
Subject: Re: [PATCH v4 04/23] ext4: add iomap address space operations for
 buffered I/O
Message-ID: <ahXUO0pZgRS59Icn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-5-yi.zhang@huaweicloud.com>
 <agwtJq5-B2E-t7zT@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <236657df-71f2-446d-b44b-39865219a850@huaweicloud.com>
 <agyVb1U0US8PVgqo@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <51b3f8d5-b90f-49fe-b93e-171268db9ff8@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51b3f8d5-b90f-49fe-b93e-171268db9ff8@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=OdqoyBTY c=1 sm=1 tr=0 ts=6a15d46e cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=i0EeH86SAAAA:8
 a=UqtRoQCeoNweiAdQEEsA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: cT9kEXNmp5A7jj6dMbO0IAC1gBQB_xGG
X-Proofpoint-ORIG-GUID: 0XSqh8rCIWWoFDaj_xVkudpcUzH9z_ZQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDE0OSBTYWx0ZWRfX1X9UVXyJIciZ
 Xgmi3wCiHWPxpol6wqvPEL1Yvd+5i7nxx5eBTaMfhOR99AeynRym++aJm6utiUnnpfoZXEL8Up8
 1lGm6ArlLPpCDwPYYrRzAxsuPIT//0OIZPidh/c2OXuoUl4d8j36AbxBX5QVdVbl4C8Z1UgLr6d
 pPKZ9FPsXu+z4vAaHRYzdrh1xeTjJVUw/DDsr3QfU/BoZvGRjvwQ9snP8LCBgDK0mTYdq6IyOeO
 6kcmgnot8sIED7dBQhK46V5fJIS74Sp3mz8WXCdB6y3Uc2Z+NdBjUV897/Veeux1kiVjtNLDXHr
 UlQlp0oEeo7WM5NbIQp7BzLLbjG6qUaT32op6RJclN9zrybByUntCvtcZi5A0FxGjbsQvRk1dWz
 AtiYot9pyU9YhxDMhKD1lwfT52CJFIHCgOBrVg3FVW+/wgKe5a3HBPmkXKnNJPSE5UAO4QHDoRO
 2Kdq5FWHvJ3L3IzL3lg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-26_04,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605260149

On Wed, May 20, 2026 at 10:49:50AM +0800, Zhang Yi wrote:
> On 5/20/2026 12:53 AM, Ojaswin Mujoo wrote:
> > On Tue, May 19, 2026 at 08:35:51PM +0800, Zhang Yi wrote:
> > > On 5/19/2026 5:28 PM, Ojaswin Mujoo wrote:
> > > > On Mon, May 11, 2026 at 03:23:24PM +0800, Zhang Yi wrote:
> > > > > From: Zhang Yi <yi.zhang@huawei.com>
> > > > > 
> > > > > Introduce initial support for iomap in the buffered I/O path for regular
> > > > > files on ext4.
> > > > > 
> > > > >    - Add a new inode state flag EXT4_STATE_BUFFERED_IOMAP to indicate the
> > > > >      inode uses iomap instead of buffer_head for buffered I/O
> > > > >    - Add helper ext4_inode_buffered_iomap() to check the flag
> > > > >    - Add new address space operations ext4_iomap_aops with callbacks that
> > > > >      will use generic iomap implementations
> > > > >    - Add ext4_iomap_aops to ext4_set_aops() when the flag is set
> > > > > 
> > > > > The following callbacks(read_folio(), readahead(), writepages()) are
> > > > > provided as placeholders and will be implemented in later patches.
> > > > > 
> > > > > Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > > > > Reviewed-by: Jan Kara <jack@suse.cz>
> > > > 
> > > > Hi Zhang, looks good to me. Just a questions below:
> > > 
> > > Hi, Ojaswin! Thank you for the review of this series.
> > > 
> > > > > ---
> > > > >   fs/ext4/ext4.h  |  7 +++++++
> > > > >   fs/ext4/inode.c | 32 ++++++++++++++++++++++++++++++++
> > > > >   2 files changed, 39 insertions(+)
> > > > > 
> > > > > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > > > > index 94283a991e5c..1e27d73d7427 100644
> > > > > --- a/fs/ext4/ext4.h
> > > > > +++ b/fs/ext4/ext4.h
> > > > > @@ -1972,6 +1972,7 @@ enum {
> > > > >   	EXT4_STATE_FC_COMMITTING,	/* Fast commit ongoing */
> > > > >   	EXT4_STATE_FC_FLUSHING_DATA,	/* Fast commit flushing data */
> > > > >   	EXT4_STATE_ORPHAN_FILE,		/* Inode orphaned in orphan file */
> > > > > +	EXT4_STATE_BUFFERED_IOMAP,	/* Inode use iomap for buffered IO */
> > > > >   };
> > > > >   #define EXT4_INODE_BIT_FNS(name, field, offset)				\
> > > > > @@ -2040,6 +2041,12 @@ static inline bool ext4_inode_orphan_tracked(struct inode *inode)
> > > > >   		!list_empty(&EXT4_I(inode)->i_orphan);
> > > > >   }
> > > > > +/* Whether the inode pass through the iomap infrastructure for buffered I/O */
> > > > > +static inline bool ext4_inode_buffered_iomap(struct inode *inode)
> > > > > +{
> > > > > +	return ext4_test_inode_state(inode, EXT4_STATE_BUFFERED_IOMAP);
> > > > > +}
> > > > > +
> > > > >   /*
> > > > >    * Codes for operating systems
> > > > >    */
> > > > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > > > index b1ef706987c3..178ac2be37b7 100644
> > > > > --- a/fs/ext4/inode.c
> > > > > +++ b/fs/ext4/inode.c
> > > > > @@ -3908,6 +3908,22 @@ const struct iomap_ops ext4_iomap_report_ops = {
> > > > >   	.iomap_begin = ext4_iomap_begin_report,
> > > > >   };
> > > > > +static int ext4_iomap_read_folio(struct file *file, struct folio *folio)
> > > > > +{
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > > +static void ext4_iomap_readahead(struct readahead_control *rac)
> > > > > +{
> > > > > +
> > > > > +}
> > > > > +
> > > > > +static int ext4_iomap_writepages(struct address_space *mapping,
> > > > > +				 struct writeback_control *wbc)
> > > > > +{
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > >   /*
> > > > >    * For data=journal mode, folio should be marked dirty only when it was
> > > > >    * writeably mapped. When that happens, it was already attached to the
> > > > > @@ -3994,6 +4010,20 @@ static const struct address_space_operations ext4_da_aops = {
> > > > >   	.swap_activate		= ext4_iomap_swap_activate,
> > > > >   };
> > > > > +static const struct address_space_operations ext4_iomap_aops = {
> > > > > +	.read_folio		= ext4_iomap_read_folio,
> > > > > +	.readahead		= ext4_iomap_readahead,
> > > > > +	.writepages		= ext4_iomap_writepages,
> > > > > +	.dirty_folio		= iomap_dirty_folio,
> > > > > +	.bmap			= ext4_bmap,
> > > > > +	.invalidate_folio	= iomap_invalidate_folio,
> > > > > +	.release_folio		= iomap_release_folio,
> > > > > +	.migrate_folio		= filemap_migrate_folio,
> > > > > +	.is_partially_uptodate  = iomap_is_partially_uptodate,
> > > > > +	.error_remove_folio	= generic_error_remove_folio,
> > > > > +	.swap_activate		= ext4_iomap_swap_activate,
> > > > > +};
> > > > 
> > > > So one question, for ->release_folio() we are using
> > > > iomap_release_folio() instead of ext4_release_folio() here which doesnt
> > > > make the jbd2_journal_try_to_free_bufferes() call. IIUC this function
> > > > seems to be trying to clean up already checkpointed buffers.
> > > > 
> > > > I wanted to check if ->release_folio() can be called for folios with
> > > > ext4 metadata buffers? (from my limited understanding of
> > > > shrink_folio_list() -> filemap_release_folio() it seems we can) And if
> > > > it can be called, is it okay to skip the
> > > > jbd2_journal_try_to_free_buffers call?
> > > 
> > > Here, in ->release_folio(), folio->mapping points to inode->i_data (the
> > > file's pagecache), not the block device's pagecache. ext4 metadata
> > > resides in the block device's pagecache, which is at a different layer
> > > than this release_folio callback. So we don't need to call
> > > jbd2_journal_try_to_free_buffers() in the iomap path here.
> > 
> > Hi Yi,
> > 
> > Thanks for clarify and yes, thats what I was missing! So this
> > ->release_folio() is only for data folios. So I guess the
> > jbd2_journal_try_to_free_buffers() is mostly to handle data=journal
> > case?
> 
> Yes, that's my understanding as well. Meanwhile, the comment for the
> jbd2_journal_try_to_free_buffers() function looks quite outdated and
> needs to be updated.

Looks good, thanks for explanation and fixing it.

Regards,
ojaswin

> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 4885903bbd10..239bcf88ed1c 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -2139,38 +2139,23 @@ static void __jbd2_journal_unfile_buffer(struct
> journal_head *jh)
>  }
> 
>  /**
> - * jbd2_journal_try_to_free_buffers() - try to free page buffers.
> + * jbd2_journal_try_to_free_buffers() - try to free folio buffers.
>   * @journal: journal for operation
>   * @folio: Folio to detach data from.
>   *
> - * For all the buffers on this page,
> - * if they are fully written out ordered data, move them onto BUF_CLEAN
> - * so try_to_free_buffers() can reap them.
> + * For each buffer_head on @folio, if the buffer has a journal_head but
> + * is not attached to a running or committing transaction, try to remove
> + * it from the checkpoint list.  This is needed for data=journal mode
> + * where data buffers are journaled: once they are checkpointed, the
> + * journal_head can be detached and the buffer freed.  If any buffer is
> + * still attached to a transaction, the folio cannot be released and we
> + * bail out.  Otherwise we call try_to_free_buffers() to detach all
> + * buffer_heads from the folio.
>   *
> - * This function returns non-zero if we wish try_to_free_buffers()
> - * to be called. We do this if the page is releasable by
> try_to_free_buffers().
> - * We also do it if the page has locked or dirty buffers and the caller
> wants
> - * us to perform sync or async writeout.
> + * For data=ordered and writeback modes, data buffers never have
> + * journal_heads, so this degenerates to a plain try_to_free_buffers().
>   *
> - * This complicates JBD locking somewhat.  We aren't protected by the
> - * BKL here.  We wish to remove the buffer from its committing or
> - * running transaction's ->t_datalist via __jbd2_journal_unfile_buffer.
> - *
> - * This may *change* the value of transaction_t->t_datalist, so anyone
> - * who looks at t_datalist needs to lock against this function.
> - *
> - * Even worse, someone may be doing a jbd2_journal_dirty_data on this
> - * buffer.  So we need to lock against that.  jbd2_journal_dirty_data()
> - * will come out of the lock with the buffer dirty, which makes it
> - * ineligible for release here.
> - *
> - * Who else is affected by this?  hmm...  Really the only contender
> - * is do_get_write_access() - it could be looking at the buffer while
> - * journal_try_to_free_buffer() is changing its state.  But that
> - * cannot happen because we never reallocate freed data as metadata
> - * while the data is part of a transaction.  Yes?
> - *
> - * Return false on failure, true on success
> + * Return: true if the folio's buffers were freed, false otherwise
>   */
>  bool jbd2_journal_try_to_free_buffers(journal_t *journal, struct folio
> *folio)
>  {
> 
> Thanks,
> Yi.
> 
> 
> 
