Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.139.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794372855;
	b=y1pGgu2S6M5r8dYj2LirMnIbp0aQIui2L8TjvXD3vLaltcmiTviUQp34babM6wFwHI8l
	 7cdYPpFefW49ZRAIeY/IQcPghihdodr0zzRZxy+enLvQ+NlbkbLzO6+jDgm+L9J8eHuXF
	 CH0jG56zf8IdrSqOJkjnzzA+9QH+hAVpVquBevVG8dPuCAt+t9h6kCz2KWsm0SQY9QCLV
	 sw4UAyXEQzppES8HHMdrfnxfxL1VlvlxxCVWEow0USZwkYhZedp9/9TfRmub4/ijOl6Iu
	 qmbRw3Xl2A3BvfeAH5w8aKS1VVmZlWurwzygz1Pe4aEhYM5cLRnnGDOPsORrA5gAEig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794372855;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=NtAaZR2KETUPEE3Is5MRv41jGaiQEz+irF5G1JKk/ec=;
	b=bSoZ25kXOrDLlJ4KhO+li8m+GuIKRdLXRXzcf4VO6MjmkR7oVCY5NjrrehWB7o081is5
	 s/3vM0ptRuScspWwBRpyA5jYVsg9wtmqEnJmEBkZVeOaZa8VoV+fzapRX5kv9VH6Nobs+
	 ndHFnqJRm3EmBCB22pwmNQGtjcHEO5Nifb09VtxlCKtHoRFUnCmXYXI6g5AQMylXrDuJ+
	 BY4YStaL0jTN8qP18/ho0Dv8uhvfwXchzXjdb4rLIUM7NLHECE2hxgoSm9dRlZZfN3qXK
	 G1UPS1uDRQom4rpNjivFvv1KKeCgX/zwXaXVJttjkJ7YYC27+gZhwubvnCDmMR6VGhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=FeWaRpX0;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=DDIgG29a;
	arc=none smtp.remote-ip=148.163.139.74
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F1A606A320
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 04:54:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7F1A606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=FeWaRpX0;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=DDIgG29a
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AB3WaZ13156958
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 23:54:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=NtAa
	ZR2KETUPEE3Is5MRv41jGaiQEz+irF5G1JKk/ec=; b=FeWaRpX0JFJDqtJwU4br
	PaM4+1C15DtKoY/DjVy4KXDvPyfn+XruGroIDSNDyivz3zErdljr5btTtBNzLpTI
	ZxUlFjl8LhJZgbup0ow0vs76gL0HebhujdS8F9zVGr6xi7disWPs5Jw9Rr9jURaV
	64m7PBpFNjUk/wFc71DZ+QWMSjDLhz44ttgjmZRxdOi+gLJxclT8PQDbc3ScCSLT
	LRpAV/z6kaszEuHAItSZ5lEF/924KuNSvk0juChL9Fk3VNoe/h52JNdLMERXquTD
	3hq3X8b1GGpa73mmPxPNnZykEq8zWZRqCIe76YYzB+lREDhZdRyMIkppFg+lI3R9
	xQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hvdjk9278-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 23:54:13 -0500 (EST)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-5338c59f90dso49488051cf.1
        for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 20:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794372853; x=1794977653; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NtAaZR2KETUPEE3Is5MRv41jGaiQEz+irF5G1JKk/ec=;
        b=DDIgG29awOKMhYcYIs4QIXvig+LhNHeRIot2PHx5iCbjeSgTADb72R/6hE2a+Sa4zT
         3nktoqVZI5nNGcz1Gk5YAjqWKBvDMRoOf+fWKPM3bodg2SkzfEc/CXO8g2LpoE441KrH
         fXP3aYnFmq8pN3CBDMe6dYD4cuBEJsINtERvMPpysWsZA5OGNWVGG5YOj+NfHsxYi4fN
         2UKZS3uQ8N3zAqtbXNGjFCGgOZmWGFrTGlYLhKqATWE/Vx4nBm2cmh0Pqzwa1380ZDyz
         fQNAepN0ZRRbXwDfmIlHBJh4YTISDeaVjaNkI7HO5KWtEkpW/K4xA8sOa+ct+0AXkvA0
         C0aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794372853; x=1794977653;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NtAaZR2KETUPEE3Is5MRv41jGaiQEz+irF5G1JKk/ec=;
        b=vR+Jqpe5kVS0my80jIAl6+VhL54j663tTEjb5X8ZWl2q6h/aIibZS7a4W/cXoxgDDO
         cQnIyL4MmfHdPTz7iRcmwu2jDclnlUeuCqb6G2CLN9kvu1JvMVB+FmZTaFnJW73RjgFu
         T7AuaKxm5wQOrGkhSqxd8f/JmBTyUEvHjizCBOnUWohwdGr5NdI01sQVvQShbqSrYe+y
         O8b7EJfSUgQrCweAZGKpP+2dhJ6l+lYoQb4o8RQur8+kyCP+temf9VjBAfFuYhrdaLgK
         +YCbcipdGUmqn/4rcOi48aOqQVNGna1u5wAtQX/AH1ZzB2um0fu0Q0fnotMi9EADeS9/
         o3CQ==
X-Forwarded-Encrypted: i=1; AL+hErGSVUG9uDqqU1NdcUsQf6G57CJNKIhIPBsUjuFHMOeTumuxwJ5yQSJdPsnstWaMBKylEN/ZPBglEorh@vger.kernel.org
X-Gm-Message-State: APuU4Z8wtC7HNIgWjrmHSrb1n7EBhj4vc0XBttHWH7rWhgoOdeVWtC8d
	6GKL0krJmVg+Wnd/5odzDCJhR66fvPUo6kglNh7chmahwGPEZHDhNcIaB/WzxQ64w1tPmFrWqs+
	1JGRXmgnom8hUC787o4mcd1c9JbyqzSfHnt8bgJ/AFl6ihd+NeKe0+7Q0eis=
X-Gm-Gg: AYBFou2LRz+ylp4LGc24boSsFeaWphalejpHTUPYFcIRpZ5AQUBdEmVfbx8m82L+2Jm
	8SlzwI5QyBmaKLqChpOZmxZjyWji32g8gfqaJGD55x/qZ0WTqU1i7dB+178La+ohAcGR/PnD2AW
	zrzhJT3GU4xUZo5BpKhJ6uTiN4K8TgmdByxGmQuov2rpIkApe6+GA3FyY3jw4Ry5r7MTYLcI/4f
	UzyAeS8rPbc8nWI6kyeDhSpqlg3psNAXgzTFtu++6dfvs3Wa0cfkw8i2E67WdeKmmJKtmp+AzTu
	uGNl4XiUqjBG2jwppouwtWmdhre+kd2IIzRdsTL3MhVigDc8TYPSxBmcl0e+LxUQV4+YgI7oDkc
	zxhLqo5BeuVGVC95NVkaCQJyKPw+ttGa00yDiaiyoHrd+rIeQ86xe88BetPQaT6juJrv+SfgskN
	9tSenC9AxLnJxcdiG5JfLJ1Q==
X-Received: by 2002:a05:622a:506:b0:535:1d5b:a7fa with SMTP id d75a77b69052e-556c08d6ce1mr16074631cf.14.1794372852723;
        Tue, 10 Nov 2026 20:54:12 -0800 (PST)
X-Received: by 2002:a05:622a:506:b0:535:1d5b:a7fa with SMTP id d75a77b69052e-556c08d6ce1mr16074451cf.14.1794372852302;
        Tue, 10 Nov 2026 20:54:12 -0800 (PST)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550af60493sm41888591cf.4.2026.11.10.20.54.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 20:54:11 -0800 (PST)
Message-ID: <a2ba8655-eaa0-40cd-ac3d-d768b18192c6@columbia.edu>
Date: Tue, 10 Nov 2026 23:54:10 -0500
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
Subject: Re: [PATCH v7 05/11] fs: validate atomic writes after O_APPEND and
 limits
To: Chris Mason <mason@kernel.org>, tytso@mit.edu, cem@kernel.org,
        david@fromorbit.com, jack@suse.cz, djwong@kernel.org,
        josef@toxicpanda.com, hch@lst.de, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        brauner@kernel.org
References: <20261110190417.32650-1-mason@kernel.org>
 <20261110190417.32650-7-mason@kernel.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20261110190417.32650-7-mason@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: MVbQ7Avfr7h8PTMOM36ubizZEpDM3YgL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAxOSBTYWx0ZWRfXxZfQ0ByCiK+f
 XEJN9Mvtu80n18A3mvufPT1dDr4ExjOgkl9RRT3CWkxRihf9XEp20S/iWQhH555lRZ4lHDxHtc4
 GWhkKAOPRcWyEQqe1aJmw67vpvUG/zSG+dGAcCzoUb6Of4lGInihXju823ZSwo/TU8YSwRHcYL0
 7T0GB32GJp+Tha2MJ3+Tsa6sz4UYdcCapNATPxJc15lIx3e1TYrETN1Z1fsNLjrLzbbXw9JIk5z
 dDVSNOiwXO1HetEHRumLmQeLbKbTYQz4nGqf+QRXsCk/zw2/wVQXrZ19xeMDrfrYW4muLm6K/sY
 SiBYP8kjeeWQoU7uSL23FlU5QggRBfUzWhVBABZv9ttAzjqLfKaqtIkfIKgTtTjya8m+TnW5Zg/
 O3xjmZgDcYE3gr6rYc23ULvuxtW2yDE85xlsqTiEm0CGJPJ6kQSJInkfmER//tmfvd3frapW5cW
 AOSZfBw5uzOZwKCkq5w==
X-Authority-Analysis: v=2.4 cv=V/boQuni c=1 sm=1 tr=0 ts=6af3f4f5 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=VwQbUJbxAAAA:8 a=mm-HGR4lrNp9vsEGGOYA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAxOSBTYWx0ZWRfXywyd4eI9lKBn
 aYL+Wp8Nzd4QzASerau72p1gh8MmIQM/fKfBaw4urpsCfJUCnCcXpJHyffjxZE7WmspMaK0sZtK
 42zmpxal4aV+NCPr7vO1OBBRKZxZafdY2dXcybNhw4kJkcBqrC9I
X-Proofpoint-ORIG-GUID: MVbQ7Avfr7h8PTMOM36ubizZEpDM3YgL
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11962
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 phishscore=0 adultscore=0 impostorscore=10
 suspectscore=0 spamscore=0 lowpriorityscore=10 bulkscore=10
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611110019

On 11/10/26 2:04 PM, Chris Mason wrote:
> An RWF_ATOMIC write on XFS with reflink can expose stale disk contents
> if O_APPEND or RLIMIT_FSIZE leaves it sector aligned but not block
> aligned.
> 
> XFS and ext4 call generic_atomic_write_valid() on the range that the
> caller passed. But generic_write_checks() changes the range later:
> O_APPEND moves the position, and RLIMIT_FSIZE cuts the length. XFS can
> then fill only a part of a new block, and still map the whole block into
> the file:
> 
>      block size 4096, i_size 512, O_APPEND
>      validated:        0 to 4095
>      written:          512 to 4607
>      new blocks:       0 to 8191
>      stale below EOF:  0 to 511
> 
> The fix used here is to validate an atomic write in
> generic_write_checks(), after its range is final, and to refuse one that
> was cut. XFS no longer picks the path of an atomic write by the
> alignment of the range that the caller passed.
> 
> Fixes: f096207d3276 ("xfs: Validate atomic writes")
> Fixes: 43c696f9d094 ("ext4: Check for atomic writes support in write iter")
> Signed-off-by: Chris Mason <mason@kernel.org>

Assuming my ext4 patches get picked up:

Reviewed-by: Tal Zussman <tz2294@columbia.edu>

> ---
> 
> Notes:
>      v6->v7:
>      - No change.
> 
>   fs/ext4/file.c    |  4 ----
>   fs/read_write.c   | 13 +++++++++++++
>   fs/xfs/xfs_file.c | 17 +++++++++++------
>   3 files changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 50d3c92709c8..e301d4faf1c3 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -802,10 +802,6 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>   		if (len < EXT4_SB(inode->i_sb)->s_awu_min ||
>   		    len > EXT4_SB(inode->i_sb)->s_awu_max)
>   			return -EINVAL;
> -
> -		ret = generic_atomic_write_valid(iocb, from);
> -		if (ret)
> -			return ret;
>   	}
>   
>   	if (iocb->ki_flags & IOCB_DIRECT)
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 676728310899..1b34b7382619 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1775,6 +1775,19 @@ ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
>   	if (ret)
>   		return ret;
>   
> +	/*
> +	 * O_APPEND has moved the position and the file size limits have
> +	 * shortened the write by now, so this is the range to validate.  An
> +	 * atomic write is all or nothing, so refuse it if it got shorter.
> +	 */
> +	if (iocb->ki_flags & IOCB_ATOMIC) {
> +		if (count != iov_iter_count(from))
> +			return -EINVAL;
> +		ret = generic_atomic_write_valid(iocb, from);
> +		if (ret)
> +			return ret;
> +	}
> +
>   	iov_iter_truncate(from, count);
>   	return iov_iter_count(from);
>   }
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index be1f775128d1..153f53f964b9 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -926,12 +926,21 @@ xfs_file_dio_write(
>   	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
>   		return -EINVAL;
>   
> +	/*
> +	 * An atomic write is at least one block long, and generic_write_checks()
> +	 * refuses it unless its final position is a multiple of its length.  So
> +	 * there is no unaligned case to handle for it.
> +	 */
> +	if (iocb->ki_flags & IOCB_ATOMIC) {
> +		if (xfs_is_zoned_inode(ip))
> +			return xfs_file_dio_write_zoned(ip, iocb, from);
> +		return xfs_file_dio_write_atomic(ip, iocb, from);
> +	}
> +
>   	if ((iocb->ki_pos | count) & ip->i_mount->m_blockmask)
>   		return xfs_file_dio_write_unaligned(ip, iocb, from);
>   	if (xfs_is_zoned_inode(ip))
>   		return xfs_file_dio_write_zoned(ip, iocb, from);
> -	if (iocb->ki_flags & IOCB_ATOMIC)
> -		return xfs_file_dio_write_atomic(ip, iocb, from);
>   	return xfs_file_dio_write_aligned(ip, iocb, from,
>   			&xfs_direct_write_iomap_ops, &xfs_dio_write_ops, NULL);
>   }
> @@ -1128,10 +1137,6 @@ xfs_file_write_iter(
>   
>   		if (ocount > xfs_get_atomic_write_max(ip))
>   			return -EINVAL;
> -
> -		ret = generic_atomic_write_valid(iocb, from);
> -		if (ret)
> -			return ret;
>   	}
>   
>   	if (IS_DAX(inode))
> -- 
> 2.55.0
> 

