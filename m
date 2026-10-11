Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B97F35C68E;
	Sun, 11 Oct 2026 09:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791710908; cv=none; b=UNRfZRpdrVy7ie6m2AWOYmFKBRhmLBlxFUIn89M67XU8qEwfn+8GW7ZG46fXc+NFc8IYHCGDO3btYD0nBhDrLPGBIzPW0ja2e+g+sWWCKZyTD0J3y55vgreEnWSYtfBWomo21h2HcaIUzZZoya2FRNwKdvkcm5HlpsCeeKA1/iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791710908; c=relaxed/simple;
	bh=apBavCwJZgnYMcVLbCpCZz0jMabA0xIZYtVykYnWjTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BMKPDDGg756WepMhvN7SPxFdQ2kp7koEMAntsM/ECtHIMn7hscu/Nv3M+UYgSijvkdczO0u6uqZB2JZ9mqq9OUiZ025TxBpQuyDuxyl+kzjJM9H3y1Yjb50RWM5FCjZzXGPW7zA8MXuATMI4r5RI+uL8X7KSe39dSL2PwH57Qzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=O3bZYRVp; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="O3bZYRVp"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69B8Eghr956546;
	Sun, 11 Oct 2026 09:27:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=bgFxKTAtwqckfClwi9Bxeeg9y8zQth
	X9t85iQJAQbBk=; b=O3bZYRVpZ88c9tCGKq2qJrTfHd2prfMZD20woQtivkjpWr
	dI8Yoz8q3xylwZ+//3BWSdS7wcQRA7JI+qm+W+qc8JA5eqWGRJZgfI68rtYAJQDc
	Dm/B6pKa7XoJvxJI4rbtlFW8qJjBkOn8j+PNYNlF7zh6VDFQovkQFjwmPVKK/fI9
	dJEr9/vFAWDNfl/CFK6zjKdpA4aAjtY/4WC3IvoRWXXdW98Wd/PZjQ73LDQCqNNN
	kTP7+j19JOCOUbCmRENhB4weGk266nZurU61DWCCnI092hY6ZVTUjtDvgVuVVFHr
	uOYTJZ81LT2/B1TWQEcOcRAt+GwvNUsB+OyzgMWg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7dv34g8u-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 11 Oct 2026 09:27:42 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69B852os3685898;
	Sun, 11 Oct 2026 09:27:41 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h816gs06d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 11 Oct 2026 09:27:41 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69B9Rdnt50397604
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 11 Oct 2026 09:27:39 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 97AAE20043;
	Sun, 11 Oct 2026 09:27:39 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5CACA20040;
	Sun, 11 Oct 2026 09:27:35 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.27.122])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sun, 11 Oct 2026 09:27:35 +0000 (GMT)
Date: Sun, 11 Oct 2026 15:00:08 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yizhang089@gmail.com>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        jack@suse.cz, ritesh.list@gmail.com, djwong@kernel.org,
        hch@infradead.org, yi.zhang@huawei.com, chengzhihao1@huawei.com,
        yangerkun@huawei.com, wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v7 27/31] ext4: set DISKSIZE_GROW_PENDING after zeroing
 unaligned EOF block
Message-ID: <astXIFUKStEIdozU@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-28-yi.zhang@huaweicloud.com>
 <asn-qfh9uWnabkJb@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <2fb2df2f-090c-4b24-9636-d28454a51d1d@gmail.com>
 <aspCa7EpqXoEhuN6@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <bf9a1b23-0473-4623-952b-b3a407e9b7a3@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf9a1b23-0473-4623-952b-b3a407e9b7a3@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: -P3hpNeY7joHsm4OwSUSSVxkYrStB0Dl
X-Proofpoint-ORIG-GUID: Alm8XiuSMjzNd6UJanpOEIAEkGzEDGwO
X-Authority-Analysis: v=2.4 cv=aqInmiZV c=1 sm=1 tr=0 ts=6acb568f cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=i0EeH86SAAAA:8 a=Vqu5hGL34COpa7mttuoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDExMDAzNiBTYWx0ZWRfX7RKNV+2FNkUc
 RpO7mu0gws/ki7QWRyjo6pKBXKejLHt0xcOY/qK0RIiKtYlR8N0PNrVm+QtM2kbV00ngcbWjRDC
 GDzB/3oYV3yUivUuzlnWdySXE5IEUro=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDExMDAzNiBTYWx0ZWRfX+se852BzQWCs
 HAZhWv3n/n1eIJVSdEDCwjUiTbMZ/xFrtugrEwM05iEq0bWING4SSOfVgD/S8+60/mlk9ZJK5WW
 TRePDYYXIg4wt5b+/P3R+VGUKdIJY9kK6PVFa/zEYSV+3Pv6Hm7NUgk3HqfZiW+VHOgHBHdwMbt
 mxxPlqngHVyfHtpikuly3fqa4FvdUtqEXkh6I5QuUXd6Tu7D298I/ar1bRtbErC3kLe+8ETVBRD
 Q5kw7oXY109q6f6boPSY5S0VtT/8V4RcgL/UrUhi8cAv+ZIyiug0LZW4/xOZztvg+1LtMsUtOGF
 1uM9hTWgxeyyiyWfyTr8kl1Hg5GphegM8+QiBkWSZQz2i8/BCp5dg2oh8mwkJJmEudYEyDeS+nl
 EsGRBOrOQCIbtJQf68GHFOizjaXdffcwrR6tSj7OGVe/fUh4XACyJ4NNcIdbYU5nCCswUdgG2cR
 UaFWzyDFNwZaIntFRMw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-11_03,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 spamscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610110036

On Sat, Oct 10, 2026 at 11:54:57PM +0800, Zhang Yi wrote:
> On 10/10/2026 9:49 PM, Ojaswin Mujoo wrote:
> > On Sat, Oct 10, 2026 at 05:50:24PM +0800, Zhang Yi wrote:
> > > On 10/10/2026 5:00 PM, Ojaswin Mujoo wrote:
> > > > On Fri, Oct 09, 2026 at 06:30:28PM +0800, Zhang Yi wrote:
> > > > > From: Zhang Yi <yi.zhang@huawei.com>
> > > > > 
> > > > > In the iomap buffered I/O path, data=ordered mode is not used, so the
> > > > > zeroed EOF block has no implicit ordering with later i_disksize updates.
> > > > > Without the pending state being set, i_disksize can be advanced past the
> > > > > zeroed block before writeback completes, exposing stale data after a
> > > > > crash.
> > > > > 
> > > > > Previous patches added the consumer side of the
> > > > > disksize-grow-pending mechanism: the state bit, clear and wait helpers,
> > > > > and ioend tagging. Now add ext4_iomap_mark_disksize_pending() and call
> > > > > it from ext4_block_zero_eof() after zeroing the tail of the block that
> > > > > straddles i_disksize.
> > > > > 
> > > > > The helper locks the folio, waits for any in-flight writeback on it to
> > > > > complete, then sets EXT4_STATE_DISKSIZE_GROW_PENDING only if the folio
> > > > > is still dirty. Waiting for writeback prevents folio_test_dirty() from
> > > > > returning false mid-writeback, which would cause us to skip the pending
> > > > > state while zeroed data is still in flight. The dirty check then avoids
> > > > > setting the bit when the data has already been written back.
> > > > > 
> > > > > Suggested-by: Jan Kara <jack@suse.cz>
> > > > > Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > > > > ---
> > > > >    fs/ext4/inode.c | 106 ++++++++++++++++++++++++++++++++++++++++++------
> > > > >    1 file changed, 94 insertions(+), 12 deletions(-)
> > > > > 
> > > > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > > > index 9b6916609000c..3bdb5f3b119ab 100644
> > > > > --- a/fs/ext4/inode.c
> > > > > +++ b/fs/ext4/inode.c
> > > > > @@ -4847,6 +4847,89 @@ static int ext4_block_zero_range(struct inode *inode,
> > > > >    					zero_written);
> > > > >    }
> > > > > +/*
> > > > > + * Inodes using the iomap buffered I/O path do not use data=ordered mode.
> > > > > + * Therefore, we mark the inode as disksize-grow-pending after zeroing the
> > > > > + * EOF block. The zeroed block will be submitted before any subsequent
> > > > > + * data.
> > > > > + *
> > > > > + * In the I/O completion path, ext4_iomap_wb_disksize_pending_wait() will
> > > > > + * wait for I/O completion before advancing i_disksize if the write
> > > > > + * extends beyond the zeroed boundary.
> > > > > + *
> > > > > + * When zeroed I/O is in progress, operations that extend i_disksize are
> > > > > + * handled as follows:
> > > > > + *
> > > > > + *  - Truncate up, append fallocate and zero_range:
> > > > > + *    Defer the update. The file size will be updated to i_size by the
> > > > > + *    end_io handler once the ongoing pending I/O completes.
> > > > > + *
> > > > > + *  - Insert range and collapse range operations:
> > > > > + *    Wait synchronously for the relevant I/O to complete before updating
> > > > > + *    i_disksize.
> > > > > + */
> > > > > +static int ext4_iomap_mark_disksize_pending(struct inode *inode, loff_t from)
> > > > > +{
> > > > > +	struct folio *folio;
> > > > > +
> > > > > +	folio = filemap_lock_folio(inode->i_mapping, from >> PAGE_SHIFT);
> > > > > +	if (IS_ERR(folio))
> > > > > +		/* Already in writeback and cleared? */
> > > > > +		return PTR_ERR(folio) == -ENOENT ? 0 : PTR_ERR(folio);
> > > > > +
> > > > > +	/*
> > > > > +	 * Ensure that in-flight writeback, possibly started after
> > > > > +	 * iomap_zero_range() unlocked the folio, has completed. Without
> > > > > +	 * this wait folio_test_dirty() below may miss the zeroed data
> > > > > +	 * (writeback clears PG_dirty), causing us to skip the
> > > > > +	 * disksize-grow-pending tracking and potentially expose stale
> > > > > +	 * on-disk data.
> > > > > +	 */
> > > > > +	folio_wait_writeback(folio);
> > > > > +	WARN_ON_ONCE(folio_test_writeback(folio));
> > > > > +
> > > > > +	/*
> > > > > +	 * If the zeroed range does not overlap the existing on-disk tail
> > > > > +	 * block, the zeroed data lies beyond the currently on-disk data
> > > > > +	 * and will be written back before i_disksize is advanced past it,
> > > > > +	 * so no stale data can be exposed.
> > > > > +	 *
> > > > > +	 * Checking i_disksize here (after folio_wait_writeback()) is
> > > > > +	 * necessary and safe. If a delalloc writeback of this folio was
> > > > > +	 * in-flight, it could be raced by a concurrent mmap write which
> > > > > +	 * corrupts the tail block beyond i_size but the i_disksize is not
> > > > > +	 * advanced. folio_wait_writeback() has waited for its completion
> > > > > +	 * and the ioend has advanced i_disksize accordingly. If writeback
> > > > > +	 * had not started, we don't need to mark any pending state because
> > > > > +	 * any future writeback will carry the pagecache content that now
> > > > > +	 * includes the zeroed data, so no stale data can appear on disk
> > > > > +	 * even without the pending tracking.
> > > > > +	 */
> > > > 
> > > > Hey Zhang,
> > > > 
> > > > So in continuation for our discussion at [1], thanks for the info and
> > > > yes I think the race mentioned there cannot happen. But I was still
> > > > trying to look at this path for my own understanding and there's another
> > > > sequence of events I'd like to discuss with you. Mostly the same from
> > > > last but what if the writeback moves after
> > > > ext4_iomap_makr_zero_pending():
> > > > 
> > > >       Initial state: i_size = i_disksize = 2k
> > > > 
> > > >       1. pwrite(4k,6k)
> > > >         - ext4_block_zero_eof(2k,4k)
> > > >             set inode state DISK_SIZE_GROW_PENDING
> > > >         - i_size=6k, i_disksize=2k
> > > >       2. writeback(2k,4k)
> > > >         - submits a GROW_IO ioend for 0,4k
> > > >         - i_size=6k, i_disksize=2k (unchanged)
> > > >       3. pwrite(8k,10k) - part 1
> > > >         - ext4_block_zero_eof(6k,8k)
> > > >         - zeroes 6k,8k
> > > >         - ext4_iomap_mark_zero_pending(from=6k)
> > > >           - folio is unlocked and not under writeback yet
> > > >           - keeps DISK_SIZE_GROW_PENDING set
> > > >         - iomap_write_iter not called yet...
> > > >       4. mmap write at (6k,8k)
> > > >         - I dont see anything stopping this?
> > > >         - i_size is still 6k so this is eof write.
> > > >       5. writeback(4k,6k)
> > > >         - submits IO for 4k,8k
> > > >         - i_size=6k, i_disksize=2k (unchanged)
> > > >       6. ioend for 2. (2k,4k)
> > > >         - clears DISKSIZE_GROW_PENDING
> > > >         - GROW_IO so i_disksize updated
> > > >         - i_size=6k, i_disksize=6k
> > > >       7. ioend for 5. (4k,8k)
> > > >         - DISKSIZE_GROW_PENDING is cleared
> > > >         - i_disksize=6k,i_size=6k - no updates
> > > >         - 4k,8k converted written - data beyond EOF from 4.
> > > >       8. 3. continues
> > > >         - enter iomap_write_iter
> > > >         - pagecache_i_size_extended()
> > > >           - page_mkwrite(6k folio) and mark dirty
> > > >           - zero 6k,8k
> > > >         - i_size=10k, i_disksize=6k
> > > >       9. writeback(8k,10k)
> > > >         - DISKSIZE_GROW_PENDING cleared so just submit (8k,10k)
> > > >       10. ioend for 8.
> > > >         - DISKSIZE_GROW_PENDING cleared so no waiting
> > > >         - i_size=10k, i_disksize=10k - updated
> > > >         - if we crash now, 6k,8k non-zero data exposed
> > > > 
> > > > I looked at the code surrounding ext4_iomap_mkwrite() and
> > > > ext4_buffered_write_iter() and I don't think there's any sort of
> > > > serialization against this sequence right? Or am I missing something
> > > > again :)
> > > > 
> > > 
> > > Hi Ojaswin,
> > > 
> > > If I understand correctly, your scenario is essentially a concurrent
> > > mmap write and append write, that is, a post-EOF mmap write is performed
> > > after the append write does the EOF zeroing but before i_size is
> > > advanced, right?
> > > 
> > > The scenario can be simplified as follows:
> > > 
> > >    Initial state: i_size = i_disksize = 2k
> > > 
> > >    1. pwrite (4k,6k)
> > >      - ext4_block_zero_eof(2k,4k), zero 2k,4k and dirty folio
> > >      - iomap_write_iter not called yet... so i_size is still 2k
> > >    2. mmap write at (2k,4k)
> > >      - i_size is still 2k (so this is still an EOF write?)
> > >    3. writeback (0,4k) since it's dirty
> > >      - submits I/O for (0,4k), data is written to disk
> > >    4. 1 continue and then writeback
> > >      - i_size=6k
> > >      - submits I/O for (4,8k)
> > >      - i_disksize=6k, 2k,4k non-zero data exposed
> > 
> > Yep, looks right.
> > > 
> > > Actually, I think we don't need to consider this kind of concurrent
> > > scenario, since it is undefined behavior in itself. Even if we
> > > don't write this part of the mmap data back to disk, we can still
> > 
> > It will be zeroed again when i_size grows in iomap_write_iter()
> > -> pagecache_isize_extended() but yeah a mapped reader might be able to
> > read it before that happens.
> 
> In fact, for our current scenario, pagecache_isize_extended() is a
> no-op, since blocksize equals PAGE_SIZE, so it will no longer zero out
> the post-EOF data written by mmap. What pagecache_isize_extended()
> zeroes is the data in the folio that doesn't belong to the block
> containing the current EOF when blocksize is smaller than folio size,
> whereas ext4_block_zero_eof() zeroes the post-EOF part inside the tail
> block. Their responsibilities are not the same.
> 
> So in the scenario you describe, the data written by mmap will remain in
> memory for a long time, and this is not a small window. Since we don't
> care about this concurrent scenario, puting ext4_block_zero_eof() before
> the write is safe.

Ohh right, I always thought it zeroes withing the block as well but just
noticed the early return. I think that function cares more about data
over holes which can occur when bs < ps.

Thanks for pointint it out and for the discussion. The reasoning makes
sense to me. I'll continue reviewing the patches that are left and
provide my comments.

Regards,
ojaswin

> 
> Cheers,
> Yi.
> 
> > 
> > > read it from memory, right? What ext4_block_zero_eof() needs to do
> > > is zero out the post-EOF stale data written by the mmap before the
> > > append write.
> > 
> > Okay got it so we care more about not exposing data that was
> > previously on disk rather than a race with mmap. We do have some
> > xfstests that seem to care about the later as well (like generic/363)
> > but I get that the race is a very small window here and needs us to
> > crash at a specific time. Plus its a parallel mmap written data rather
> > than stale data so hopefully it's harmless even if a bit of it is
> > exposed after crash.
> > 
> > Thanks,
> > ojaswin
> > 
> > > 
> > > Thanks,
> > > Yi
> > > 
> > > 
> > > > Regards,
> > > > ojaswin
> > > > 
> > > > [1] https://lore.kernel.org/linux-ext4/179153611724.860602.5266334742364847927.b4-ty@b4/T/#m72e1710d172cf7699b6f05e29a270e45951800b0
> > > > > +	if (from >= round_up(READ_ONCE(EXT4_I(inode)->i_disksize),
> > > > > +			     i_blocksize(inode)))
> > > > > +		goto out;
> > > > > +
> > > > > +	/*
> > > > > +	 * Mark the inode as disksize-grow-pending. The zeroed block will
> > > > > +	 * be written out by the generic writepages cycle or any other
> > > > > +	 * syncing operation.
> > > > > +	 *
> > > > > +	 * Multiple overlapping unaligned EOF writes should not happen,
> > > > > +	 * because we only mark the pending state after zeroing the on-disk
> > > > > +	 * EOF block, and i_disksize can only be updated after the previous
> > > > > +	 * zeroed pending block has been written back or the dirty folio
> > > > > +	 * has been discarded.
> > > > > +	 */
> > > > > +	if (likely(folio_test_dirty(folio) &&
> > > > > +		   !ext4_test_inode_state(inode,
> > > > > +					  EXT4_STATE_DISKSIZE_GROW_PENDING)))
> > > > > +		ext4_set_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING);
> > > > > +out:
> > > > > +	folio_unlock(folio);
> > > > > +	folio_put(folio);
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > >    /*
> > > > >     * Submit and wait for the pending zeroed EOF block range to complete
> > > > >     * if the given range [@offset, @end) fully covers it.  Must be called
> > > > > @@ -4923,21 +5006,20 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
> > > > >    	 * truncating up or performing an append write, because there might be
> > > > >    	 * exposing stale on-disk data which may caused by concurrent post-EOF
> > > > >    	 * mmap write during folio writeback.
> > > > > -	 *
> > > > > -	 * TODO: In the iomap path, handle this by tracking the ordered range
> > > > > -	 * and updating i_disksize to i_size after the zeroed data has been
> > > > > -	 * written back.
> > > > >    	 */
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
> > > > > +			err = ext4_jbd2_inode_add_write(handle, inode, from,
> > > > > +							length);
> > > > > +			ext4_journal_stop(handle);
> > > > > +		} else if (ext4_inode_buffered_iomap(inode))
> > > > > +			err = ext4_iomap_mark_disksize_pending(inode, from);
> > > > >    		if (err)
> > > > >    			return err;
> > > > >    	}
> > > > > -- 
> > > > > 2.52.0
> > > > > 
> > > 
> 
