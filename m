Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.139.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794249458;
	b=fBFhg0K/kYRRxphwQKzT6vXXx/9DbWybIcymVke3yLBGL2AkVceBk82zneJyoHzXJksB
	 m9vT4dnqAfI5Bj/zd4haSLRwYM+ek8PPGohCBNlVA+QRzcImkhePHiy47ykhYmUv05y6S
	 AOAmPesq+OUDS5xwzR8+DjJsGDJDmsKSnFBvc1EyDLmCIGPvhjNXytLiPSPrL+4gywjEG
	 XAmb4HRtH+YJUHydTMwc6gr365rRYKCL8+pNH73GddfAFVHbnMj/7jwbTzdvdBtK+dZ02
	 S4XB9QeGay9bVdXBGxtgxmhLlL9ub45gazCj8JYHrMxUJSBADTTK3xrqxfBGoIw75dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794249458;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=gQWTo3YG2SkoMfnNaAKg/+Z4r1WHLc60eAAlSKMJVuk=;
	b=BUQoM+IJzurZCwUWLRQaEVxYkT9GXbTEYiPdOmvKJk/tUWgo1vUG5SvEGOPUf+pE0Q+M
	 c8La36WCb4eA0zIAKw4lqy/iSmOQp/7ew4/f9/ZhhWrelPoGSH9hHO0+x/V4gqwORAvXb
	 GjzKXx1YuPjtOXaRYHQ3eet/zgvH93aQpPAhIA0JuCqKaHfxOr/VGsKPFvtxqrtt4/eb0
	 BLl+mwk4yj8H7WnQPpiuOEC/7wGnqRDsaqpb5iFJqufMI6b5Ij2/0JYhP4TcG4oHbWYNC
	 bZ/WO3ZDiEDyp4W82GHiAkqKMvXpUjLyZuTPfnHXA6whythMiVWdemQJxdbWgo7gaOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=hEGrzXMk;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=nlhzqxUr;
	arc=none smtp.remote-ip=148.163.139.74
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538CD606A31C
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2026 18:37:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 538CD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=hEGrzXMk;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=nlhzqxUr
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A9HYrrV2928341
	for <linux-ext4@vger.kernel.org>; Mon, 9 Nov 2026 13:37:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=gQWT
	o3YG2SkoMfnNaAKg/+Z4r1WHLc60eAAlSKMJVuk=; b=hEGrzXMkOGM79q+eIdlN
	bTCWWlnY2PfeTY4s3cMCb7D3NBGF1ZnmHU1JPiF/VWcpeFrOJVVCTt2V8SfgIhE9
	gLJg4bRDQAfhger9vg1nqfLN3/n/VyKzQDRMcwGmMziP0gF2c0fBBGK6kNGipFWD
	sO2vsKKXzL06GtKPS8/8Rsm5F/5kKUwIunLKAuI88qHBXpP26iU1GbE607fPvlaV
	Iu3FqLa/flAkgS2ScNFSuKzIcyaexj7HN4p6kfCadVcef19UFqtV/u9HpF10HosT
	Qe7vkqNC2MrAEFRnI5WaWk2CE7gA+PRd1WTPMDCn9n6I+oLbQUaNMG9zr6TXwKIL
	Tw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hujjg0m2f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 09 Nov 2026 13:37:35 -0500 (EST)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-943e8ff02d0so124168985a.2
        for <linux-ext4@vger.kernel.org>; Mon, 09 Nov 2026 10:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794249455; x=1794854255; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gQWTo3YG2SkoMfnNaAKg/+Z4r1WHLc60eAAlSKMJVuk=;
        b=nlhzqxUrI0fI7/fbDMyAzVd70Zt76jatity3GeLCzTcjGYZW0FjNLTNnAkhjmj4YJb
         DKRVGedQqIiL57xWEB3B3E6XbB0F9MvrT+FlgdcGOWXHuJg1YzLjDtGUUi8mNJmW41p6
         RSSlxAl/+umrf1WMwb7r0t00XLZ7NOt9VOVxGKsfcGGb4BjFa3lST8/3lp7Jyom5UV2g
         S7UY5JT8CgpaOQvrbAfAFxNCLNMOn6h+soKKPhOAxzL+lVqNNstiIFcbzkVXS0pIl45q
         2e0HUsAt1U6IWIov54YpLUXFcVQE1VcJK4jYORhGWUYcdNA3hwJivoWdMnEO0SuqvKyo
         b18g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794249455; x=1794854255;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gQWTo3YG2SkoMfnNaAKg/+Z4r1WHLc60eAAlSKMJVuk=;
        b=e1cQB81hDwEFMrl8Yce2JRGtiViKn7++U36Zw1qkIK6ynqL5fZu+H6+6CFnrLFvLcW
         rUbBOYyC3BOTXcSXndyEPF6YvgWNJWZyifKv9rV36ssEQxIrFHiGTyuYL0Qmr1Lwwzla
         3MGzEURAPpVmqIlIUey13V3oCTRaRxDQ2ehIvJfAvTkbKj4iplCeX9sJuqJuXsJHGAV0
         EWLvXifgfU5whxwZ4tNHaRkkhcTYZ4RASeyAm27w6VIfCQbykCcg9MTPnoGqeDnRdAnK
         +YOeS8htW9+vy8I2BqYPCXiRPyqslGBGcKoFxEvvhKOZ8QJCAqolSiED2bVXVPt2lLLO
         Erug==
X-Forwarded-Encrypted: i=1; AL+hErE7HnkjKCYT7OIXq/exPv5BTQor+/WZMFUz2ykhXfeTkXmm3VW6cY2ZMc1YNdA5+d15BiP8hKnQxeLa@vger.kernel.org
X-Gm-Message-State: APuU4Z9HfprB32+KPKG0JvrKVe/p8lNTd7KfW+8mQhy6Ori+y5JUnDvX
	OdMDzvU056/avKebmez3rQrmIJJC8RroW4lp9bxBEsZBz/pS5TyYntBQ4EN98vpCfHiD4haDgHJ
	bq4JvSP0l0A+PFTmbfItcD8BYU0xS7a7bRuvvxL7LsfiCCIlxu2ksRBEGmZPg4Wy5g/Y=
X-Gm-Gg: AYBFou2TU9HbyW/dOmtH0WF9HhUyU3Qj8gwcQOzzQJsZ7Oyu/CPMTsfgloZ1L4L/1UN
	KsSXhvWGCfshAKbJ26u1mYqqtf5526GqY7nkrS6BmixpMlxzEkarsK2+sWqpRwMugGYgwN2cxVv
	DFwHar9gLjsU/ezCE8U029ZXEyDFU7Q8jEozMx6qLA1fqE+786aILYFnYmZer7WuDHQ8EaCfTIV
	fr27AkTUByrPJvEMsHYBqhzzag9BbTa+/enOUZKZWtV4EQZRiLtKKplAOeJFnP8sTl9LeGPcgRD
	+a5NPo9dKl7TPA6fnaJUbSDl5JT2VmbVwIgyRS/d8P4iKhl6kWj8DYmxA4oWSKYc18vixijJkql
	pgmnFW2V1JD3wIY7paBTGtk8VpmvC9pt2uASUd2HaeUZEftO9zTbz/BoZv5s5mSdU8EhT6+AAve
	2cM9ms2PgmSlZIxXj3ZABfIBk=
X-Received: by 2002:a05:620a:1b96:b0:946:123a:bdd0 with SMTP id af79cd13be357-9479f30e6a8mr52109185a.48.1794249455429;
        Mon, 09 Nov 2026 10:37:35 -0800 (PST)
X-Received: by 2002:a05:620a:1b96:b0:946:123a:bdd0 with SMTP id af79cd13be357-9479f30e6a8mr52105085a.48.1794249454971;
        Mon, 09 Nov 2026 10:37:34 -0800 (PST)
Received: from [10.207.116.169] (nat-128-59-178-16.net.columbia.edu. [128.59.178.16])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e73c3ddsm36187685a.15.2026.11.09.10.37.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 10:37:34 -0800 (PST)
Message-ID: <99a9c7a2-d2f1-4308-bb4a-67217ed377f6@columbia.edu>
Date: Mon, 9 Nov 2026 13:37:33 -0500
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] generic/810: check that RWF_DONTCACHE I/O drops
 its folios
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>,
        Jan Kara <jack@suse.cz>
References: <20261107-dontcache-test-v2-0-7655bf08d6d1@columbia.edu>
 <20261107-dontcache-test-v2-3-7655bf08d6d1@columbia.edu>
 <avHUTwnSMVCkKVoW@bfoster>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <avHUTwnSMVCkKVoW@bfoster>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA5MDA3NCBTYWx0ZWRfXwiPYab0EAw+C
 IGwY12MhvLnZbgW6FbFoAQFt+ku5N5wjyJHeeRHDlNdGfhZzS4wGdhuF7rjH5EXv1/VSMHhCm28
 e9iMp3qgAHdzzMq20A3894s6aw/Gi6zAdXtOauFPV/cLQFDGD9SsJpHgOqcZMrF+TmnrDcyTabx
 DD9go11BTnVjgpdkuLIzEKN/+tczjFY0X9S5DNFxxR1MUXPpnDxrpDrS3TiqVQWmOBIAjLpwwTg
 JuZxyJkbDazcdkgO1LwvEcxY+7NPQimnnG0RVRpr14R1QLl9grpVBG9r+XTqRVBJSolblUfteBm
 3U9GTqnChrHHqT3QHwkkao900bPXwE1xAW5sjNX0Cl6N3bgZJRaGKm879UFV8YYts6wDVLAnj/x
 e3+SJhFto7C+Y3C1ZmAyzkzIT6r4Hbd/8JDLj8C/xF6bjO0EdAVNET9Ut9mASFVSrHtqKU7sIqx
 IOBD4wInIPiFaTV5p1Q==
X-Proofpoint-ORIG-GUID: Qxr6imreS47k4C65qthrotpxVAVe4ldo
X-Proofpoint-GUID: Qxr6imreS47k4C65qthrotpxVAVe4ldo
X-Authority-Analysis: v=2.4 cv=doFOmFg4 c=1 sm=1 tr=0 ts=6af212f0 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=Gl6UJ28otdLh1ydVN8wMBg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=20KFwNOVAAAA:8 a=LFmhLChh9ExO1iPAI9sA:9 a=QEXdDO2ut3YA:10 a=2EJJ2Fb71GoA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA5MDA3NCBTYWx0ZWRfX8TO36k8z0s12
 FJvZXYbcrdd5ohZcnACPVdH0mseNOCZyDingBcvxIDYj5sWhCmheEqXSYS0SFLaqnVB/xiZBNfI
 u9sU4CUtvUuIsT44/aNhn76vaMy9Fav4T3FzmwtFTWEbxRQt+vOR
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11961
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 impostorscore=10 malwarescore=0 lowpriorityscore=10
 bulkscore=10 priorityscore=1501 clxscore=1015 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611090074



On 11/9/26 9:10 AM, Brian Foster wrote:
> 
> I like it. Thanks for the tweaks!
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
Thanks, and thanks for the review! The end result looks cleaner.
