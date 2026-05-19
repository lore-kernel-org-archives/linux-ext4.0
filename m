Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DD047F2E1;
	Tue, 19 May 2026 10:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779184995; cv=none; b=pMC59VjS/mrJMwue+CxvmuqwWGr8y4hdFHmAj+2HmJQWDyvPC7CDUFoKaG/o6r7Cum1nw9QF18L5anfqzMGniSbmlOkl0R2MJcLZGkGtudAVkYSckL+DcVd3t/rxnNW/Wm0AzJSPOoFeWeyK4Lftk2jblYEFh2wcxH/nB0ljs9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779184995; c=relaxed/simple;
	bh=Y/cwXAJKt7TlZFG4m+t6mKtWkELFassu+Lxca9auZS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HOi5s4Wkk4QLxUZGkAVMqkxDKUzXVuzCKgzYx1GdMsruVSvuVbDVfEEYimIeIGHS4FzbaHWcx+wPl0xgXdUmx01p1bafh0HmiD4zkwREceKYFO+Vq4lrVMPt2ajo27/lKenbTQ689rrzGbZ0VUlBC7eSTuhahQjbRSefBwh6/2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lAoEkqHu; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lAoEkqHu"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64IIaP2H3919898;
	Tue, 19 May 2026 10:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=d5ZB/3vqc6Cgmj/G8slQCioDxMYrdq
	RdN3NXjefHkTw=; b=lAoEkqHuCCiD4fo3x/yoDKwpdWM8iz24RdsjGHBUiMxa+N
	Cnvct3PZkFPAnYkD+S+4f+CIufiW9JRiIwJ0p+Trq5bGrk/FIh2V8rgqEuyIZy8K
	CGLjfBMf0lQg4cLJq8yDTOn5coIYa+vdbGlwrXCcfSOmwz4nKcaO2JxoicUVwpE5
	6/PJQQjSBol3ERqjeLoCzrdIU5VvZCJ5UmgERePtgcF2qg/kfLKa7Mv0ZABGYc0t
	MfhMdW8k/OCHv3W4u5j4eUkYiLAb3lKNBwhWzsncHY2dLbW+MIh4fmBqX0mcRXRM
	51Bz7VrOoUcOX3wrZrAHPc0OUsDOLPMOE+x03WZw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h8mmabu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 10:02:34 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64J9sK5u026568;
	Tue, 19 May 2026 10:02:34 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e72wq279u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 10:02:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64JA2VDU42336658
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 May 2026 10:02:31 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 34DB120040;
	Tue, 19 May 2026 10:02:31 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E151420043;
	Tue, 19 May 2026 10:02:27 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 19 May 2026 10:02:27 +0000 (GMT)
Date: Tue, 19 May 2026 15:32:25 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 06/23] ext4: pass out extent seq counter when mapping
 da blocks
Message-ID: <agw1MQOjH7_SCn0w@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-7-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-7-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 0JjvtTLSxR8frq_oxafmYyUmFNcFIWa_
X-Authority-Analysis: v=2.4 cv=GYMnWwXL c=1 sm=1 tr=0 ts=6a0c353b cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=FhX2KHmN5wzvCLpOKaEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: Tl9rxgZIU5hhewzeLvaUCe5U3ezPe5AN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDA5NCBTYWx0ZWRfX4xztaV1GN0/7
 uVrSi+ZANoBH1njVthOTdaCD8t7OuDx9xrejacfMM6L64FcPwxh2GJf6jU9rWdDQTjjzKwbuhc2
 QNq24bNbStIFZgF95TrxsG/8lwGQYpC8u4VvpXTVnjkAR8NacXIzcWuEvM3h5T8BwTmEx0yHiX5
 vTb9sP49w1+xB/X7462giGU0AkrD4Q5nfP3/tsM1zea/iBeQfVvTQNk7aCXxTSt/xrE3eNDzljU
 SEIbCNBhS4uTlrvaskgpgZHkc86iYIeuT18OmI5LhJv/YiThaKZpPg/yPky5h2gNRG1abRoWL6w
 qCaNPrRo1H4R9oh6BcrrPkk80rbGyijPTRmiUcM6VKz6LgiT7hift1xPb4k9JpU0fy5TUy2OPwM
 i+AoNnDasYFY/kGYQa/7d24INg5BWEosJ7a7lKgSMtTDduvyeDPL+F0e+ujsRcI4g7goKF3HBSi
 l5S0hL1yKI/SGEvdwKg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190094

On Mon, May 11, 2026 at 03:23:26PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> The iomap buffered write path does not hold any locks between querying
> inode extent mapping information and performing buffered writes. It
> relies on the sequence counter saved in the inode to detect stale
> mappings.
> 
> Commit 07c440e8da8f ("ext4: pass out extent seq counter when mapping
> blocks") added the m_seq field to ext4_map_blocks to pass out extent
> sequence numbers, but it missed two callsites within
> ext4_da_map_blocks(). These callsites are on the delayed allocation
> path, which is also used in the iomap buffered write path. Pass out the
> sequence counter to ensure stale mappings can be detected.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Looks good,

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
Ojaswin

> ---
>  fs/ext4/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 6c4d9137b279..39577a6b65b9 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1929,7 +1929,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
>  	ext4_check_map_extents_env(inode);
>  
>  	/* Lookup extent status tree firstly */
> -	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, NULL)) {
> +	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
>  		map->m_len = min_t(unsigned int, map->m_len,
>  				   es.es_len - (map->m_lblk - es.es_lblk));
>  
> @@ -1982,7 +1982,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
>  	 * is held in write mode, before inserting a new da entry in
>  	 * the extent status tree.
>  	 */
> -	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, NULL)) {
> +	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
>  		map->m_len = min_t(unsigned int, map->m_len,
>  				   es.es_len - (map->m_lblk - es.es_lblk));
>  
> -- 
> 2.52.0
> 
