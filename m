Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743D13346A5
	for <linux-ext4@vger.kernel.org>; Fri, 29 May 2026 21:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780088996; cv=none; b=Wzyqbc/yu1/Qrbm4cwjP2MGC3K5A0N7iQQfFldQ5s64c00yQsIggFFS3urHuoTR4WxZwduywEdkM9eeQZiq98LJsbW1i27m7iPearXt01SQmxHkm3Kqc90E8QZ3dDXg62OYpsbU+Gic5Y955NBHGKkvTYKKFaV42tFZWg6LCX2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780088996; c=relaxed/simple;
	bh=O5g6xMsaAevqgY/HknheMpshVHdDuxz98nTfkUwVwd0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l9hYmoBYCQ2gKGy7ZI9p+ifeeTe2uECh894HJhtXMk0wvffjs8Ls4FtcOffl3iFc3creXouRJd9HNWGPcN1zWJyAi+2YFmwchk8yoU9USjdDFRad6PuYa8Ds2DBpwYVFWWTFGeiF0v5GYhOQhB8sLWWYw1jUZmcpSpJ3P3EYcjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=oJVKQcRD; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="oJVKQcRD"
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64TKgS4f978924
	for <linux-ext4@vger.kernel.org>; Fri, 29 May 2026 17:09:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=qoTz
	5OByYLW8ASq2hVpbIv/Hf6reoFP/KvxSksZK3HE=; b=oJVKQcRD+34m0jMSKpMl
	jBnema6zmL09G2+2vFmo8x9sHWu2Dkv91PcEJuZtp+kBmypWAuZ+o5Jfln9taBii
	GStJvRHKtxtlf55KXidP4D1OwHeMR2krZeS4FSzBZL84yMHMm9NsWh7aLP8JNu1R
	y0PvsO4Zzarid7swIWV0MYKdml7rWA/zPKL4XbJ0kiP3yC0R95aeXkYbTK6qDJAC
	VDaaWR9Th3JuOOvh/TNf887qgKZlz63+cU1stSEJ2cYNbWaCgFFL+zSNwoOxAWrX
	fixnJwqYyJpFu3zrVGGQwL5sRaFqJn44CRnrrtzpHARDU1AkNlxF8Qrokpdks1lJ
	SA==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4efhmg8bdx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Fri, 29 May 2026 17:09:53 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-8ccebf7e86aso18525506d6.0
        for <linux-ext4@vger.kernel.org>; Fri, 29 May 2026 14:09:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780088993; x=1780693793;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qoTz5OByYLW8ASq2hVpbIv/Hf6reoFP/KvxSksZK3HE=;
        b=hIVPYM4OODwB5W+76cU0tmWgOVJe9tHUjTDp6v/kaCEzgLIylvWe4CFZidpJlCY4FI
         fnZr+tCiiQHdHzaLgMDUa/i/HPxxA0pCRaBWC1AVldDhyI5eNGHSroffSXsUyfYdWdBa
         zeUIuX8SRnPRLPRTq3pqahcJclK5Fk7OycmTgTL2NQLyB0067Cyl9sP9v0HX69MvMV/V
         s5Rog4BFiZ7JjqGIOZIkqD+6jpuBbbSuOvY0v3NtvT9/zkDQ5blEKUDEc5+YE05DFet6
         RV8xxvunpfHclTDM7LoY9VeHspNdXfzJQC4Xiz2HJK2IHO2kGV+9XUIA6/hO0YdGHSP6
         hS6Q==
X-Forwarded-Encrypted: i=1; AFNElJ8ZV0YiqOKsw5ciPzK/2Pzt+XMGGYCYKD9aO99+ciKfCwL0FeKcqx1fxHyVVkjYaZUtCxVySs1kI+t3@vger.kernel.org
X-Gm-Message-State: AOJu0YxDZp7tMG8SFq/d940iOzXv+OpXPbWRVqhWcX0xglWwcvELl6SI
	HobMZm3fKaYVgScTGVIeUBFpK4RCbeVOZ+RkHE6zn6UPjV7Oa8HHqV5aX7qNqwvJcNJ3CtKzAZR
	7Jz1+PYLK3J6wvAhX1o0dtODR0do63qbWD3/jyqoQ7woVCZia5t7+0sbK5BQ=
X-Gm-Gg: Acq92OHApB/zj+S5RiuQmfS+dTqPtUuBE863R5BW2LtueY1UNfj9mZmWWqhmhdZAEpE
	aQeX1Gtypy6AF28YjzvuseeMfOf32P6FP7EZq9P6ItR+6xut+wYsqHPRj1AYTvZIzyMGp5gqq9X
	QOtQnjr4x6PwYAp3NwKUlsx7JqHByMGOEIQitCximpZDiDI5Hk0s/7e/ROP1XCVTDSDumleZSRM
	DMSODb1Y0WJUHx7g+TGATDfbXfYbuAQZqTVsiSoG1M6ErSS7vR8LcBE4kyfy6h/Pp3CyHiVFWgS
	R21OGFJqPxxlymQoGaldr3YC77lcezlSU/IJBamkXsl/gMF0eMsUHwPME36p3FU6u/P2R91ISi8
	AALgcbuAP9g2OulzPVLRFGtiTSz+kzmkuecu24JSyUroz2MFout1lVQToH8+0xFDJyJNrm5E8a1
	XuzA6M0hk6xlFvAM28G8WeUfigHw==
X-Received: by 2002:ad4:5949:0:b0:8ca:2711:f3ff with SMTP id 6a1803df08f44-8ccf03af60amr16675346d6.22.1780088992833;
        Fri, 29 May 2026 14:09:52 -0700 (PDT)
X-Received: by 2002:ad4:5949:0:b0:8ca:2711:f3ff with SMTP id 6a1803df08f44-8ccf03af60amr16675066d6.22.1780088992447;
        Fri, 29 May 2026 14:09:52 -0700 (PDT)
Received: from ?IPV6:2600:4040:974e:fe00:c8bb:325f:9d37:a5f? ([2600:4040:974e:fe00:c8bb:325f:9d37:a5f])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea0663fesm27208736d6.14.2026.05.29.14.09.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 14:09:51 -0700 (PDT)
Message-ID: <5bdfe6db-b5cd-4b1a-9dc5-50869198b834@columbia.edu>
Date: Fri, 29 May 2026 17:09:51 -0400
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] jbd2: Remove special jbd2 slabs
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Theodore Tso <tytso@mit.edu>
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Mike Rapoport (Microsoft)"
 <rppt@kernel.org>,
        Vlastimil Babka <vbabka@kernel.org>, Jan Kara <jack@suse.cz>
References: <20260528171413.1088143-1-willy@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260528171413.1088143-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=WL9PmHsR c=1 sm=1 tr=0 ts=6a1a00a1 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22 a=JfrnYn6hAAAA:8
 a=VwQbUJbxAAAA:8 a=0wBLy_mAbSS78rUt_ycA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=pJ04lnu7RYOZP9TFuWaZ:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: Vyc6LKhEOhlw7hzQtVzsqSaMemGuacMj
X-Proofpoint-GUID: Vyc6LKhEOhlw7hzQtVzsqSaMemGuacMj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI5MDIxMSBTYWx0ZWRfXzrWDluku6ghB
 475StMhtFkzePCTKfOZU9cAWX6Wx258EGVQna+fEL2++HAZRZyhSFZxoGlfv4NUAnWeNA9mKiX4
 YCfl/Zhpyz/rUXReq2A8DQCGRZIDZpmNvBAReZlOgq2LpG/KoY/T3NGNpIcNRsOWVVDNCd5V3bf
 kccYfXJXPzq+5tVYsLNfRL10xN3CPtHhxPZSX6efdE7XzNMrefgQp6rPk2VSPc2UmNbn36nnmQJ
 eIEdiJYCP+daguYJN3/KQ1V6BsIhA5XrrzZMj0v8qg9FkzqOyNbmBTQRUmuf8aKxeSSV/B5cA4E
 49DONnEjYntbWnflS24lEYKT4Gbt9tLTto3CFa8EZCXk2OlS7Pcea75mgdSzR5WYXdfuIH4Vtnp
 unedDkzCQ23bIggKlNClSVvBvYayFqC1EVwS9WRwsJ0uT6aLEJWSMf7BascPGYxQmKkryaydDB3
 J0pgaO799ZJdCOnStPg==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11801
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=10 spamscore=0 adultscore=0 bulkscore=10
 phishscore=0 priorityscore=1501 impostorscore=10 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605290211

On 5/28/26 1:14 PM, Matthew Wilcox (Oracle) wrote:
> When jbd2 was originally written, kmalloc() would not guarantee memory
> alignment for the requested objects.  Since commit 59bb47985c1d in 2019,
> kmalloc has guaranteed natural alignment for power-of-two allocations.
> We can now remove the jbd2 special slabs and just use kmalloc() directly.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

FWIW:

Reviewed-by: Tal Zussman <tz2294@columbia.edu>


