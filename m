Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF718337B87
	for <linux-ext4@vger.kernel.org>; Wed,  1 Apr 2026 07:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775029188; cv=none; b=FYiHB5L/D0SV3RyTbihz/Zmuoy6Ct9nhDNrfSA+/mMhsO11FOjby+reQcQtfFmaWyXfaziixruojbLMMWzesohYSjM8j4gkx7JP/D1T4UmA5a3FsYAzQZbFnQBu/hfsb5g+K1AyNQhUKh1oSNJQoMRCw93CI2eFlZwI1uD3xmk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775029188; c=relaxed/simple;
	bh=jz3trRIk7aMWns/AtRrObQSWbhOeYvPgD3ILd+R/yFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cPC9k7zmHUNjEt8ZYYv98iRMBlPjL5kpYXxWXHurI4GnykwtjOvH8TvYCNJBa3RZf91ceOMR1vPGLRpaSHj2EjdyFUTLNURXSdr5iu4Sur/7tlMHFZLm3yjhW3dG4OhiCPgAIrW9h0l7U3jVkM758wDKwTwI5YDqcGIFG9Qd6FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HU1GCoC6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HU1GCoC6"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62VJXn3i371620;
	Wed, 1 Apr 2026 07:34:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=UlHoFEL9JcoQlmj2BZYeDUk1NyHJXX
	1ksYP9PMCDrYo=; b=HU1GCoC6cgYODZP6g+uEfTH5+cGxFg/mJw7waKB7HF+06T
	7qARz0Cy6kpk252xUW+w99UzbgLurAOKbKUOyN4DEngz1iKDMikQev2ucc0wB0oT
	KLyn1zv5+xi8N74sabiOlX3zgSvsM1s8/1PZYAySZSece7EVZifEi2GBVh9TXhZ4
	A5WshF7NLtB2lL2X6dbvTJ72+ptr24NYmKdLQD+tz8LcumqhU5+Skx2oPPsrcxNb
	t2SxpFscOVllJmyca9JwVykoH8exmSs2esC5bqtjvMCs535fMaeB8G41z0fcPLf1
	WcuapGhx7cgyQc1kvCdrmX3DOccnUP2Z51Hu4Ppg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d65dced42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Apr 2026 07:34:34 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 631663u6022227;
	Wed, 1 Apr 2026 07:34:33 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d6tan4jcs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Apr 2026 07:34:33 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6317YVEm31392300
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 1 Apr 2026 07:34:31 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 939BB20043;
	Wed,  1 Apr 2026 07:34:31 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1197120040;
	Wed,  1 Apr 2026 07:34:30 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.209.181])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  1 Apr 2026 07:34:29 +0000 (GMT)
Date: Wed, 1 Apr 2026 13:04:27 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Ye Bin <yebin@huaweicloud.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        jack@suse.cz
Subject: Re: [PATCH v5 3/5] ext4: fix the error handling process in
 extents_kunit_init).
Message-ID: <aczKg-uy6VOcmeew@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260330133035.287842-1-yebin@huaweicloud.com>
 <20260330133035.287842-4-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330133035.287842-4-yebin@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=RsjI7SmK c=1 sm=1 tr=0 ts=69ccca8a cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=F9T97wiOuVO1fs2Q_SgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: -Ay8-5zvt090UnnKfh9VShRAhVuw5tdo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAxMDA2MyBTYWx0ZWRfXyMicisR/7sAr
 B3lTlsqc92u82AAUdLxhnhswn86fox5topMntjEuJPLMu5DLuXc6ZcOkC3NE5I3+5IyhOFO0JQs
 JnaBYTsV7ZWJHC4TbLBkLSXJ9wV+B1G7hcCePc7ZzSW8kdKhpGoKm9oOeePKEejpDKs1TxN0P+6
 015Ryy34vrDEH92PxUCWXlOM6KTNVatrsoTLOfWJAerF328KlExic0h3IL8W/cZmAJD7et3dqFG
 egOC+B2o+fM2YXlbZgz4wBArqPEwkauwsKs7kX7sEnl8ZSkzdby/93COTlP3f4Id8nDRKp0VgNM
 xJmWA3uiWYDfE2CeXXWoJLxC/q8iyLvjVAeZCoYVNUtVz4rP2lTpx+UoSHfWYTFyKOZ5PmJcK7d
 mgGS+wNC5dMBnwp+8qwoLjFEoOywkZYBZi/GqWjILa3z9bzawCwhOg6kgXY7cUQIUY7g8Kxj+Sy
 ZIpDZ1UpeZFur8U4/JQ==
X-Proofpoint-ORIG-GUID: -Ay8-5zvt090UnnKfh9VShRAhVuw5tdo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-01_02,2026-04-01_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 malwarescore=0 spamscore=0 clxscore=1015 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2604010063

On Mon, Mar 30, 2026 at 09:30:33PM +0800, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> The error processing in extents_kunit_init() is improper, causing
> resource leakage.
> Reconstruct the error handling process to prevent potential resource
> leaks
> 
> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> Signed-off-by: Ye Bin <yebin10@huawei.com>

Looks good now, feel free to add:
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

