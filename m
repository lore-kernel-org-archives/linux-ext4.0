Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026888;
	b=EymuFdbjmQ5LlHPX61KgtYi2GzfAYovZWf5z5iPqZH2KBYfY3Tgv0D+9PNjmtGXoIzAr
	 qILGSp8khIky04laczNh4rF1O+WgHYmnDpfI5UhIHJS1mDjr+CA4S/yAUVi/k4n1ZkjE9
	 2gts1tlwSiGvsUq8SNtdL/9pF4ZA+knCSolJtqIgScjuVITZApt1heFQIfEGog2zin6cD
	 CQJaWKDatar+XhqK9vN8f3+YREMRhedQLNxx5hiCEimwdXJXAViwcUH95b0YFZ4Nzn0PD
	 cL1DGE9hIBupwSsyNejLTEw+E3+EmeIepba+XJam8t/0aFdBxf1ChepfuQsTC5rIjiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026888;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-TM-AS-GCONF:X-Proofpoint-Reinject:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=xPEjyOvnzE5uVFbes5Etw3Lk1KRIxrL48p0Z1gF0reE=;
	b=wInNc2DtOwg7Mk7IvaBdiCpnYZuY3Js72YIgmCZ/0WNFBi5YvSo+wYYZ52f90udGpx+F
	 MEtesQhjjBYh+fcTbilRfunv3wQi4lIoFsUeJAdBAgjED+MMobRH5N/EX/+4+MuiHAjS2
	 miE25xs/IWmigs+GVkelsVcMyXa7NmCFv8jvkxn3h0AweFkTNpt5zrFAY2SL28nUSKDyf
	 0CBkJ+7PXbZtZdWsARs3VKGjpJsPNyYxRomOT0fovXHjwRkVZ3ANGgsQTpuICWNaWxYON
	 coAvdGb5zQOjVd8N4z+915aBvpiRUIzaV1Tq1ZkasskUJArnJHzF2Io9DFGtYPFyhZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=Y3g8m4sa;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA54606A31C;
	Wed, 18 Nov 2026 18:34:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BA54606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=Y3g8m4sa
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AIHQAPD1730192;
	Wed, 18 Nov 2026 18:34:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=xPEjyOvnzE5uVFbes5Etw3Lk1KRIxr
	L48p0Z1gF0reE=; b=Y3g8m4sa0X98iocQO6+PZhG8V45yF20v/l4ef7ph4AdtvR
	//UH96yhN0t7h7yDoTjrNqMI6ATUqa4Mx03hQTRJZlY237pGo2Exi7veNKscVMS5
	zGyMHaUTOui1Xk5ELYYUcX0mzdjqwhYe2g8bfwPqTOuARBJ+JNza2WEdcii7mN0h
	mym3bMSdDcKRt6Np5l1KPUpj6HXB/wVypH9GaXuh/fq5Em7C9T1MrIQI3oWIb1vd
	6G9es6w7sFXtZPzdfCHtvrCyH8/fdO9olGS865PirRvV5ZufloNKoJLzr7+pee/i
	FtO06x8iStByV90b13InN1XWfrzwSJQAZ2cgIMkQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j105vkx9p-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 18 Nov 2026 18:34:20 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AIHK28c1223884;
	Wed, 18 Nov 2026 18:34:19 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j067ngyun-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Nov 2026 18:34:19 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AIIYHR528377520
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Nov 2026 18:34:18 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D46412004B;
	Wed, 18 Nov 2026 18:34:17 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7707520040;
	Wed, 18 Nov 2026 18:34:14 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.217.202])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 18 Nov 2026 18:34:14 +0000 (GMT)
Date: Thu, 19 Nov 2026 00:04:11 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
        "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Baokun Li <libaokun@linux.alibaba.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        guolingxing <guolingxing@tju.edu.cn>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        regressions@lists.linux.dev
Subject: Re: [REGRESSION] ext4: silent data loss when a split at I/O
 completion gets ENOSPC
Message-ID: <av3vo2D8kScEa7PW@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <d400205a-0d3d-4ec3-a916-6c0a085841b4@linux.dev>
 <d8ac3185-44c8-41e7-9cbf-3d1baa27f272@huaweicloud.com>
 <av1Z_RLuH4vd0Wyi@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <1102a630-de07-4494-aea2-207e5b84e2a0@huaweicloud.com>
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
In-Reply-To: <1102a630-de07-4494-aea2-207e5b84e2a0@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: UzaQ9KGXv5dZuaEgjNVNMxQMkSQvT6dl
X-Authority-Analysis: v=2.4 cv=HL9WhYtv c=1 sm=1 tr=0 ts=6afdefad cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=OsLIXnufb0XZ1Ij3xFEA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: MmTx4Hn6WSET6TcyW4kwzEDvUHgkXrU6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDA3MyBTYWx0ZWRfX5iwQaIHF0YqL
 mQJ1T5Eeafz/OdRbugQ8nCcCvuT/+nHamqdGl96Q2omdXUIhQY+EsIRSQFc/Zs3CbWLiLry5RnI
 GbkYra4R16Phibu5cfWmHqG/4fh/Bkv4+5Oxfy6QFacCm6lFI/ShIFSYzzGA+/yPh2C/MX0oIvl
 VKFz3Q3Jc8cquPWuv5gjBHaGZIe+w1bW9LxvvxpJUKiqMIYKPu9RAMKHokbNhD+WSl6jHncsXTZ
 oCAXGqCfUqMk38zIyn6eR1A0JWLxYRGHMXgqVqYVF51MKC+pCPvYpKxzrTjNGvJmgXez9N7hYnd
 IPch6ptmFFEYXzJoHIDUNJHtYZBEcU4tb6KiXHziXDPyBUBapHx/DveM3UHRELd1oa5sqcvGThO
 eQzwz22SMZy7PchKHBfch9ctYMNVwOj0ggmaFgZz3D2BhsLRcD48Z0AFDVcncpwuKLOsBuMBJfP
 2wLJWNmtezSxoPjrM1A==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDA3MyBTYWx0ZWRfX3P56apC+DVQO
 GMeIXJA860wFl+dJHQpGZBmjRuXFizTnqgZvq3X5PkAm1cCxhVnGdzzAAPesZEwQxDkhh+o288C
 RvET/hcGTk8OJALSGZg1W13T8LH16Hc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-18_05,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 spamscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611180073

On Wed, Nov 18, 2026 at 06:48:50PM +0800, Zhang Yi wrote:
> On 11/18/2026 3:55 PM, Ojaswin Mujoo wrote:
> > On Tue, Nov 17, 2026 at 07:37:10PM +0800, Zhang Yi wrote:
> >> On 11/16/2026 10:27 AM, Jose Fernandez (Anthropic) wrote:
> >>> Ojaswin's cover letter [1] explains how, since commit ea96cb5c4ae3
> >>> ("ext4: don't split extent before submitting I/O"), the split of an
> >>> unwritten extent at I/O completion can get ENOSPC. [1] stops the zeroout
> >>> from hitting other writes in flight, and [2] reports the failed
> >>> conversion to fsync(). Neither gives the split its block, so data is
> >>> still lost.
> >>>
> >>> LLM agents working with me found that it happens with default options
> >>> on a filesystem that is not full, and ran the tests. write() and fsync()
> >>> return success, and after the pages are evicted part of the file reads
> >>> back as zeros.
> >>>
> >>> Under a load built to run the allocator dry (QEMU without KVM), 42 of
> >>> 72 files lost data at ea96cb5c4ae3, none of 72 at its parent and none
> >>> of 48 on v6.18.63. On mainline at 23c62304dde2 32 of 72 did. With [1]
> >>> rebased on it 42 of 72 still did, now as failed conversions in dmesg.
> >>> With [1] and [2] fsync() failed with ENOSPC on 47 of 72, and the other
> >>> 25 read back intact.
> >>>
> >>
> >> Hi Jose!
> >>
> >> I'm sorry for causing this regression. The cause of this problem is that
> >> the transaction freeing the file's space has not yet been committed and
> >> thus cannot be returned to the mb allocator, so the extent cannot be
> >> split at endio time to allocate space for metadata. This is easily
> >> reproduced in scenarios with frequent file creation and deletion, even
> >> though there is still plenty of free space on disk.
> >>
> >> I think the solution should be based on Ojaswin's counting approach in
> >> [1] or the PENDING_CONVERSION solution we discussed, and then, after
> >> extent splitting fails, try to flush the journal and retry. My idea is
> >> roughly as follows:
> >>
> >> 1. For the iomap buffered I/O path and the DIO path, this is relatively
> >>    simple. We just need to add journal flush and retry logic in
> >>    ext4_iomap_finish_ioend() and ext4_dio_write_end_io().
> >>
> >> 2. For the traditional bh buffered I/O path, we cannot flush the journal
> >>    in ext4_convert_unwritten_io_end_vec(), because this may lead to an
> >>    ABBA deadlock with data=ordered mode. The journal process needs to
> >>    wait for ordered folio writeback, but this folio may contain some
> >>    ranges that need to be converted, and if we flush the journal after
> >>    the conversion fails, it will form a mutual dependency with journal
> >>    flushing. Therefore, we have to fall back to splitting before issuing
> >>    I/O, and when splitting fails, flush the journal and retry via
> >>    jbd2_journal_force_commit_nested() in ext4_do_writepages().
> >>
> >> 3. Split the workqueues used at the end of iomap and bh writeback to
> >>    avoid deadlocks. Because the filesystem may simultaneously have
> >>    different inodes going through the bh path and the iomap path, if the
> >>    iomap completion worker is flushing the journal, it may need to wait
> >>    for the folio of another inode going through the bh path to finish
> >>    conversion, and that conversion worker still needs to be handled on
> >>    the same wq, thus causing a deadlock.
> >>
> >> The current bh buffered I/O handling flow cannot be unified with the
> >> other two, which is indeed not ideal. However, once data=ordered mode is
> >> sunset in the future, we should be able to unify them. What do you all
> >> think of this solution? Any better ideas?
> >>
> >> Thanks,
> >> Yi.
> > 
> > Hey Zhang, thanks for the poc, it looks largely okay. I agree that this
> > seems to be the right way forward although its unfortunate to have to
> > revert back the unwrit to unwrit split. Hopefully we can move completely
> > switch to iomap soon enough. 
> > 
> > On the extent status cache for zeroout approach, i'm currently fixing a
> > few bs < ps bugs I'm seeing in it and would clean it up and post it as
> > v2. My idea is to keep the first patch disabling zeroout and rest of
> > them implementing the es changes and renabling it. 
> 
> Hi Ojaswin,
> 
> Yeah, this makes sense to me. Looking forward to your v2. I'll re-adapt
> this POC based on your patch afterwards. :)
> 
> > We can just backport
> > the first patch. Along with your poc fixes here also backported to 7.0
> > i believe we should be good to go.
> > 
> 
> Sorry, I don't quite understand. As far as I know, 7.0 is already EOL, so
> why does this still need to be backported to this version?

Ahh right I just noticed. There's no longterm kernel since 6.18. Cool
then, we don't even need a backport for now which is nice.

Regards,
ojaswin
> 
> Thanks,
> Yi.
> 
> 
