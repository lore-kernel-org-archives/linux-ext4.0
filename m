Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82618371860
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 08:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027743; cv=none; b=lZD7VBSXqK/4CPREqOntHCOmOjp+pWZbrA6WBUOiJfYv4/DCauOz1LeoOin0ESLDJoipPvaauA4O0wFkjUREtj0NKw4YV0gDcrkbiKSdRSrW35tgP3r9kIiU5C6wAhUskFNEdF6foqMSBV0SehiSCdueHQftaYVFHq7tUkiatSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027743; c=relaxed/simple;
	bh=sZG2eexUBDvxgaq6ysoGTc36spnht+MNulg2i1alcXU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rKkiumgttTPWyluZ24Wz2RbQYWIxym872L1apNugroSr7R2Fa9m1hg6fvEEz1yzV25TFFcgpi3U/jHoUMEEV6VPPVR/47QJf7ZTyV28M3UV1OrMXb0JoYjC+0iql3csXXqyDSFcFjaXMz2qwyFbnogcxBcOWBUl6F+LiyYDso0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pPiRgpa+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UFjQ5zIi; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pPiRgpa+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UFjQ5zIi"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68A5Gxt74142710
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 08:09:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	P7BTTddhf4N5PrxHybbjlwH7viQ1O+pT1zz2AMFb7tw=; b=pPiRgpa+i0kXlw4m
	fqepclc9pletqlBQvxnlcD3vbXxI7ffdS3JSAZ6LpjwntoyNwWtXmEKxEQjxoxKU
	i20i/xkYq+Qbakow9oTJDl44ledqUtNTXWv5ptACP/Owae0VzEI/2LWcDzrlQ+z8
	Qi2lygGNGUGeHjBcEtx4ceEaPzvtRmWlqiB3fYBhcbirDV2hBWcVjvFdnGlWkFyx
	06jgq3AIN2EOUIvox3B40s0qrSTx5K+RUgg0OmNad4cAqA5D97+upvOD5bxaPJTH
	wftptOlTkGJJIl1i9KCxulqNDdbgsnWcdfzGH3aFk8upu0uiTXqwd0SEFfCw45yA
	fJjunQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gkcyd2rg5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 08:09:00 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-92eebb130dcso123606785a.1
        for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 01:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789027740; x=1789632540; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P7BTTddhf4N5PrxHybbjlwH7viQ1O+pT1zz2AMFb7tw=;
        b=UFjQ5zIiTxL2Hhr3U9xhbMULcTapKWRVYybuHlT2X0v0jCvZxI0vwM1uorHFX/gOwj
         xmx8gmErQc2DCycx8KyWcKWC24eH+14A4SWzYAY9m2zcIJCRtzxlC1UCSSaf+vUkR5fT
         n898IhLQ54zAPXhiOq2RSU0aYZKlwmBJiOcUUz3ccJWIC4z4+s+eZQfediDuZEOhmiLw
         F4QCHU565iSXfMOUSdfs3kkWsycmZQj/JLto8X8iPp2Y2F+Fj45+1OY+4yjLMWY649ii
         7EzigQE7uqODhSzTOdmJe9B03/HKgwsn4YPoS0qp+ZosWyA3tDv1P7UiuQASGe05tJYy
         wFfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789027740; x=1789632540;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P7BTTddhf4N5PrxHybbjlwH7viQ1O+pT1zz2AMFb7tw=;
        b=hFuoFXIaOFMURLFX7ON3yzfUIVbGpjepmRWX1hyeAbfP9pIC5+h/K5mD605j+0AnB/
         3HJ5liVz1FmxUHlVtIVk41bgHRhVervS791fePoFzYUaKe7wL7wPRrIjXJli/13bXe3r
         +BAOvcSp0RCey/9Fz2+6kRL+83Y7Q1/dSuAfDnzv3tuJE0dav2ZUJ1B6QAGJNkz2qV80
         Ml80RZu6p86GBN8B2p8mS13cm6OyLUmaXJUrNde7He4EU1j0vVvmyGHsLL0Hy6gQO9T3
         Sb7Ux2BMJpeuqRXsti189YdcjRED/GIRE0K/Z/Agi/hoGyJHR0t45/6+gFg77zHnHmX0
         pxLQ==
X-Forwarded-Encrypted: i=1; AKwUvBwAwQeQQo3abQs8AgZzhr6nhe+gVhd6zXI+SngG2CV4sQuPv6OlVd3qXh4TqnF4IvhzuBBzSWyVtEZA@vger.kernel.org
X-Gm-Message-State: AFuF++kyZsvgsZpGuW6tZDIINkutTXKVPt0sLUpNXFmMhsuinjWzjHKh
	jsSNTVdCh0Ee1dRSdInowmdijR2mcsy4XYp1QKcsY8qmgTqQl1VUqtPYCDwWSqKdLnDK4gHr+dd
	Xaqp9oh85gFJuPG9GQwo+Dm08wUkoKLglBx1v/SI5vHFMWcdWspvxXR53LVPgKuZ8
X-Gm-Gg: AYBFou1bOzTnXIfhNIBF1Nxako6y0kt0n2lWFJSkCnAxq8nZz49fYxrzw66CdD3F/rR
	B8PA5cA/G84coZszSxFNX2Gp8UgQhpvB7tCGRZlUFYhucbfktEousU5b/Udp/0acJDy10YnOvLw
	eeZOf4+r2U96Cjs8bneo1m399p0UQQP4oEbR8/Sy1P71mfP+S62sIFEbhSenUmuG0lQa5paxcwb
	YOpJsGk347Udhevl17xGfntOApYElJTQoddh4I5JzrAIvZm31QXGRRYaKe/cv+Vy0ViRlh2OqPy
	SHXU95p2SrR62OkcCL/dP9gaSN4Dw8ziWN/Gx1iqYmSg3Huwd8lpMKdQgEmlxvJPs6rahk1jAIG
	y6LGWd2xX5RHQCHpnKJBCDQ==
X-Received: by 2002:a05:620a:4409:b0:939:8bc:8826 with SMTP id af79cd13be357-93991702d25mr3092766085a.2.1789027739692;
        Thu, 10 Sep 2026 01:08:59 -0700 (PDT)
X-Received: by 2002:a05:620a:4409:b0:939:8bc:8826 with SMTP id af79cd13be357-93991702d25mr3092763385a.2.1789027739269;
        Thu, 10 Sep 2026 01:08:59 -0700 (PDT)
Received: from [192.168.202.12] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a993d6611asm1966906a12.25.2026.09.10.01.08.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 01:08:58 -0700 (PDT)
Message-ID: <e77d4410-e7fa-4885-9d9f-6dd09fb7cebb@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 10:08:55 +0200
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] buffer: fix NULL dereference of bh->b_folio in
 __bh_submit()
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
        Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        Srikanth Aithal <Srikanth.Aithal@amd.com>,
        Luca Weiss <luca.weiss@fairphone.com>, Jan Kara <jack@suse.cz>
References: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: fBtrEkl2RaRLu5C5BAbKBgn-9hCw_VeR
X-Authority-Analysis: v=2.4 cv=ef+o7LEH c=1 sm=1 tr=0 ts=6aa2659c cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=zd2uoN0lAAAA:8 a=6H0WHjuAAAAA:8 a=SRrdq9N9AAAA:8 a=EUspDBNiAAAA:8
 a=xELAsZIkk1thdxp-Qi8A:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-ORIG-GUID: fBtrEkl2RaRLu5C5BAbKBgn-9hCw_VeR
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDA4OSBTYWx0ZWRfX4fqV/pik0U0k
 ULFJdB/Jlpn9eQ+y3fb7mE3agoDFnZ2Omswse5xUzA8I+StbtBbtplk7ZzAqUbkpndjAA4IOlVV
 nf5pMegDVseA9JbabsFdjmbE7qfb+ac=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDA4OSBTYWx0ZWRfX8mmX79QZrN5H
 tP9Tsygbi0KjvbR33PP5ykqoId/5y6vL9HDj1zxmCICrymk7z1NQePN0xQguGmDEXUO+r/XWQvH
 yCNU2xqabmUIPg90SFFhYGdQvwJznsMVqFPjlddZzqzOJMdNAhcmTJXhfIF9gVRSMtbkHGPFiV/
 JXkL+6s6uvNE/EXafa4Jcc0fsX3GiMFuQtn08Bpb9SyjCXGP9lxWentejbIxbWVIvN6bnA6UiVn
 0UDK4apcKidU0/E6m7Yo70I68eAhvyipcJCBxHWGsQb++DRqea3JrkDzIH8pbz88PKqpPDy76cu
 5WHxHVw43WaaLhocgsnSXuqpMxT3ICst5OGt+y314feI65B0WAqStXKKf4VJLDFWXa+z5geRl7m
 y96nleOX5GVSENPnbJswzcoHD4bmQXZ6YL3102LsI2BxPthP1C6+ft8MjsMLkkIWlVI7BKNplh8
 ccwy318Yglk0UKlS+ew==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_02,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 phishscore=0 impostorscore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100089

On 9/2/26 3:33 AM, Joseph Qi wrote:
> Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
> writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
> __bh_submit().  But jbd2 shadow buffers have a NULL b_folio since commit
> 5febcba29792 ("jbd2: point the shadow buffer at the frozen data
> directly") made them point b_data at the kmalloced frozen data rather
> than a folio.  Submitting such a buffer during journal commit oopses:
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   RIP: 0010:__bh_submit.constprop.0+0x87/0x120
>   Call Trace:
>    jbd2_journal_commit_transaction+0x932/0x1b10
>    kjournald2+0xb2/0x250
> 
> Hit by the ocfs2-testsuite fill_verify_holes test running with
> data=writeback.
> 
> Dropbehind only applies to buffers backed by a folio, so skip the check
> when b_folio is NULL.
> 
> Fixes: 5febcba29792 ("jbd2: point the shadow buffer at the frozen data directly")
> Tested-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
> Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sm7225-fairphone-fp4
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/buffer.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 427d8a817cd5..f46fa6413032 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1106,7 +1106,8 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
>  
>  	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
>  
> -	if (folio_test_dropbehind(bh->b_folio) && op_is_write(opf))
> +	if (bh->b_folio && folio_test_dropbehind(bh->b_folio) &&
> +	    op_is_write(opf))
>  		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);


-next has been broken for a week+ already, please pick this up..

Tested-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com> # multiple QC boards

Konrad
