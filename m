Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09D6391505
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 06:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786690342; cv=none; b=Qc/pl40/BkAGew4ioPSDtdVUiZ03DVLsdovaX/MK1bDKzW+0ZfxpFnM9eMNNqwmkX5B52ELDzzUZmeKMIN1jz/lnitx7mA9UkYmOrvsUIRoW3/CN+uMAgtj4Ys1+tzpN+pYFIzEQSo+HtH7YeyrZhOL7dbWAVbXEU/gIaLlIOBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786690342; c=relaxed/simple;
	bh=OfejapEDIUUgc9D6y8hKt79YBdWiBHNHBqfDBHp7sGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oHMwh2LApWAUIlNNcYkWNZU+FHh1Z/95+p/Booi2kWfOcH9FJwrtT9yt4Z20erPPM6YZYF5VmSNWELGHobknLPjdwZgcZQgKQnfrEYBzJAc0JsG9dm0BonvzwIRlFeN3o6OdUdmX2cBfr0V/+vSMNYZlgwuNb81eEGKcz+m2hBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LEvEbP56; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LEvEbP56"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67E4W6Ra3237725;
	Fri, 14 Aug 2026 06:51:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=/MZzQjl0b7gv05rWVDxaTFEHo7aRt+
	pGnelsOgxlFy4=; b=LEvEbP56OV/nkvel72RW49G/mX+I1Hqlbj7EFOfU1YX03F
	wLHfaaiC/K2znsraZ9N1xq21ikRXlHUQSPfBLK/EDbchPC52LWu9GIrslqrCelfc
	d7PlHQS+DpWrzmp4/xSv+NzciF/dVt7chrqEYlH0TpxLzVhb5DKGj50dqwEXN0sQ
	F0jRZPnVyowj9GcuXicC9oDfWatuBeCkWNrvKPDTOiGNw9SXAUwCFovT9VqIY2ZJ
	KC7n8JukOARHyPo759hdn3ShR7kOHbCu7WbGWQD0tEgnTKiJfIzGXR4G0YOmf/zt
	MRmYOz0BB8JGDI1jOe3fCsfCD/BnEYC4pgad7tAw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fyb243u0q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 06:51:39 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67E6fQKp025736;
	Fri, 14 Aug 2026 06:51:38 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g1rpv9046-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 06:51:38 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67E6pafI29033084
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 06:51:36 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 98C952004B;
	Fri, 14 Aug 2026 06:51:36 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B87D20043;
	Fri, 14 Aug 2026 06:51:34 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.211.225])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 14 Aug 2026 06:51:34 +0000 (GMT)
Date: Fri, 14 Aug 2026 12:21:30 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        Baokun Li <libaokun@linux.alibaba.com>, Zhang Yi <yi.zhang@huawei.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH 0/3] ext4: Fix credit estimates for extent tree
 modifications
Message-ID: <an66zNiouBCgpS9M@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260805153202.29814-1-jack@suse.cz>
 <178632560650.1021605.3694902133748235095.b4-ty@b4>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178632560650.1021605.3694902133748235095.b4-ty@b4>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=XqfK/1F9 c=1 sm=1 tr=0 ts=6a7ebafb cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=u686NsfUSKt0vBQ46HYA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDA1MCBTYWx0ZWRfX7zY8ocxOgkbX
 5+xZc6BR/4pSn1qHP5W34bxzqPALQymkjpDoYdY/9K3Vg0z3xAproUS5HEkz3IFlVOEUmsXDonZ
 tdrSOyQOCPg9GTYTGvq7Aw60KwjVd/FWoPpRL3OErSgefh0crSyrGoLxhacLflXzH4ooSTfmrGE
 3NJG6Xhm0LVdtLX6BPCXYM180Vh5FCtGUkp2kOyj2z7/t2718bQ6lbJ70OE6M8FzmnK1lCVJlDT
 nd31Vyjsgwtmv78mVBRqatEC5qIHfru5SODHt1bSR1fGbz+z/9iEq8vReFTxavYd4gEWJt2BUpy
 lLsnKITxaIYh0qTW/Lf6PQOPMM5bm0KAplgBBAsEYOyJI8tYpo7fGdm4yHtAc4xB+fAswrLTDwy
 0c8MICBB301nX/MVklh5uPBlINFzCdpCxdF0nlLsJgbJcLcEUeQIPxfHrJAT/0wTuJg+XtIRmo+
 RILvkd2Gay8x6eIPO7Q==
X-Proofpoint-ORIG-GUID: O_efxMzPptU7FAnH7Akdkxjt6vsoGlFj
X-Proofpoint-GUID: ZnTomiMKq2zKHzBrFVYXCB4VZ-zIiCTB
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDA1MCBTYWx0ZWRfXzWLhWcsGwBkz
 0kpcgOyAn75XB0OzmZwf0ZO3XZN9jWKSKpmNAQ1A7MY+SWZYxyRaLHa4LItGfv/SISR9cn8gdUo
 fFw/JevD2a4+iVRmcohHeIR/dZLkYcY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_02,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608140050

On Sun, Aug 09, 2026 at 09:33:48PM -0400, Theodore Ts'o wrote:
> 
> On Wed, 05 Aug 2026 17:35:46 +0200, Jan Kara wrote:
> > This patch set fixes credit estimates for extent tree modification during
> > convertion of unwritten extents on writeback completion. Otherwise we are
> > occasionally seeing assertion failures during extent conversion in end io
> > completion callback due to insufficient transation credits.
> > 
> > Honza
> > 
> > [...]
> 
> Applied, thanks!
> 
> [1/3] ext4: Teach ext4_meta_trans_blocks() about number of allocated extents
>       commit: 25b2a7e8d420c49fc46f25b6f953603e4dae1dbf
> [2/3] ext4: Fix transaction overflow during writeback
>       commit: 46e8e31771f4f1c5e1cdec37a889a6730e42e9f1
> [3/3] ext4: Fix estimate extent index blocks in ext4_ext_index_trans_blocks()
>       commit: 9091c97be34083587a75db174aab51551d8e8543
> 
> Best regards,
> -- 
> Theodore Ts'o <tytso@mit.edu>

Hey Ted,

I just noticed that the RVBs were not picked in your ext4/dev branch. I
think they got missed somehow.

Regards,
ojaswin
