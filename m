Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B839F30CD82
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2026 19:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779911218; cv=none; b=RlVI3hqxPSE6KlKMHXq/j+ZA9O6TJnk4Nsw8ZIntiyMCTJdO1GnukeLtu3dbYJBw5btiQVg39KPe2YHT9NRrlbBN3jpbhwsQGvd05UGUSVV9VoCboGSKahha4dsbcRcpu/j+mTA5O2zeA3G50y5XQx23S2W8jAIcQJxA2G/4omc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779911218; c=relaxed/simple;
	bh=Qo5oSVPWhALtXNm3HWU/xW24f9FA40Oy2imH/s2Ulww=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=lMY+NNSFfj6d/U2O14ddTq4OsXfMwXeZNuzPL6XNM+IdDHsyyyTvBEWdpZS4K8TklkPSbIZSbyvWEVq4yW2/72D1Y2zATS6dFburN8eaYqObTYlma/kRWuE/J8PprJqtwomgmDSAOB7dGZcoQuAsnmZAC+5hv0XBTs+yYwui83U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=h7gWqfkf; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="h7gWqfkf"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-36936dcf19dso6153941a91.0
        for <linux-ext4@vger.kernel.org>; Wed, 27 May 2026 12:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1779911216; x=1780516016; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NBREJ5Nt325/SQvA29idZI84oT5rKMGuXogaRknW0N4=;
        b=h7gWqfkf3cnp42OXfipw4GI6RmA+jR5k+sRa1sbdFANvWCbhDYrl8/aKU09V6Olna0
         QZ6q2Tw5o1lnKslKFuN+lOjWV7uaij2sH+xBMwQHaqmTT9xRP3J7Un4C1cVzn1Pj6NIw
         SYqd1h1jwM+lfKP88JQU3toJqzPSBwSdQkNvXAe6iCgyLD9UlaZ3nsERoNH5QPEIB2jK
         8ROi4YjX7Nml8HlTu7vgME+3xn2u01scwPRltWI3xkUZR8hpE+8quuyIPay4oy2seNso
         5f8qLsYLXrzn005qiMlA3sOfyXmk48OSs8JoGtIPs9fpdp+qZ6N4JFCYvzEQzVNSSCbo
         HBiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779911216; x=1780516016;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NBREJ5Nt325/SQvA29idZI84oT5rKMGuXogaRknW0N4=;
        b=XwHGntaJWeZcn3xGX7tiwJ1Z2OOtSL8YlEvu0VJ56Xkfn79qPfm/0Nbe107cl7riVk
         KraHM7wZPcGPjduNlFzhu07LpkS1r4kuhT1idPqnyYTODGpyznIwWB20Pvk942j1EoZo
         Pdpb/Ae62HeEftAY1wSCqFHSFFBmNbNh6C/xLEj8MiQrlftrXlADSSjRC2l7cTmrpSa3
         c7XXdItFSPR9kzo5Ha+FVTN/FcrDj+yxFqTnGYs/zbzXN8pKF4Hl2X3Wp7UVYqJyBDFV
         4Y25QtXQIuk3l/ANDZd46lNdM9FTmdNu419eXqIND0xOo3BsdupAT3WZmg19VTGWWK9D
         KOJA==
X-Forwarded-Encrypted: i=1; AFNElJ/JZ0TPho267lneBMtUCRVwezWoDFZnaJXouwywNhu40hv2I3O9GQi87AJnLI6HCk/DsMH0ezoIhAtC@vger.kernel.org
X-Gm-Message-State: AOJu0Yxvg9C4Izo0JujjtIGBMog8J2f0UCzjPqoETr1KYBR3gje1kw3p
	5NNooY+z2NFFmL3B4LXezGuw6XZ8I2yvQY/LrI5jcq27TVcyeUwm/S6hmWVFymM2bek=
X-Gm-Gg: Acq92OF8baWdcOEFY0QZAJv4NoBjqUxr4nSvNWRvenxRPX4wZxowCekn3pqLzzmBunQ
	3shG2QuDZdqzQ3MUCEBlxic8cnk6LY5FvydqWL6FeaBj9oaGl6OOFKAtuUKmZ7IMVQqnm3qWMTI
	qb2ef3Ph6+7+q0pWEkByc3ky0IIip3Xz7T+gbWs+BoBQxQ69h9Yh1EuDfz+Sk83ULOBxvw0P2M9
	jfS4NoK9FnC7gCg4UYfBF3SuvOBld3fE/v1aavqKtbfY+a5q1ci7hnq4dKAxJzQ5QXsXnHHwNp4
	MsN+IAuNOmMNzghYSsDx8Z2Sgxf/kT70jzeZQ5o1qahZWmRvi1DfDHZMIaOyOz+p+oq5+6ZW2jX
	u37OOrtDj1kYUAOUNDDF9pcvzCOEY+VDS96ZrLoFc1SEyQKjVpojHySIae9tYesb6yo/2roJNSH
	gEIlqDQ3n1XAfhOIhgvD+a40Qz2U+4ppfBmSKmqq79ihSANqRDv9+Z0EJJFKAvw9GM/37x7n02g
	Ug0qSUTlrmrXh0w
X-Received: by 2002:a17:90b:2d08:b0:36a:f064:d48a with SMTP id 98e67ed59e1d1-36af064eeb6mr10856149a91.4.1779911215911;
        Wed, 27 May 2026 12:46:55 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a7263179bsm15614465a91.1.2026.05.27.12.46.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 May 2026 12:46:55 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v2 1/2] ext4: avoid RWM atomic in
 EXT4_MB_GRP_TEST_AND_SET_READ
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260527090329.2680170-2-bohdan.trach@huaweicloud.com>
Date: Wed, 27 May 2026 13:46:43 -0600
Cc: Theodore Ts'o <tytso@mit.edu>,
 Baokun Li <libaokun@linux.alibaba.com>,
 Jan Kara <jack@suse.cz>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>,
 mchehab+huawei@kernel.org,
 bohdan.trach@huawei.com,
 lilith.oberhauser@huawei.com,
 linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2D89BCA2-8317-4399-B926-7F5094236C1C@dilger.ca>
References: <20260527090329.2680170-1-bohdan.trach@huaweicloud.com>
 <20260527090329.2680170-2-bohdan.trach@huaweicloud.com>
To: Bohdan Trach <bohdan.trach@huaweicloud.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On May 27, 2026, at 03:03, Bohdan Trach <bohdan.trach@huaweicloud.com> =
wrote:
>=20
> EXT4_MB_GRP_TEST_AND_SET_READ uses test_and_set_bit function which
> issues an atomic write. This can cause high overhead due to cache
> contention when multiple threads iterate over groups in a tight loop,
> as is the case for ext4_mb_prefetch(). We have seen this to be a
> problem for Kunpeng 920b CPUs which uses a single ARM LSE instruction
> for this purpose.
>=20
> Avoid this unconditional atomic write by testing the bit first without
> changing its value. This is OK for this use case as this bit is never
> unset.
>=20
> This change significantly reduces costs of fallocate() operations =
which
> trigger linear group scans on large multicore machines where
> test_and_set_bit issues an atomic write operation unconditionally.
>=20
> Signed-off-by: Bohdan Trach <bohdan.trach@huaweicloud.com>

Thanks for the patch.  Definitely the benchmarks in the 0/2 email show
significant gains for the Kunpeng system, and reducing contention makes =
sense
as core counts increase and the likely case is that the bit is already =
set.

That said, I wonder if this should (also/instead) be put into =
test_and_set_bit()
itself, or add test_and_unlikely_set_bit() or test_and_rarely_set_bit()
(or similar) optimized for the case where the bit is likely to already =
be set.

I see in your benchmarking that there is not "apples-to-apples" =
comparisons for
ARM(Kunpeng) vs. AMD on the same storage.  The storage hardware and =
space usage
is different for each test run, and the ARM numbers show only marginal =
gains and
more negative than positive results at all thread counts:

> Benchmark on an existing file system for AMD 9654 (15T FS, 6% space
> used), kernel 7.1-rc3. This shows the performance impact on a mostly
> free file system.
> | thr. |  base | patched |    improv. |
> |      |  perf |    perf |            |
> |------|-------|---------|------------|
> |    1 | 30901 |   31191 | +0.9384810 |
> |    2 | 50874 |   50504 | -0.7272870 |
> |    4 | 66068 |   64108 | -2.9666404 |
> |    8 | 63963 |   61927 | -3.1830902 |
> |   16 | 47809 |   47044 | -1.6001171 |
> |   32 | 42441 |   42326 | -0.2709644 |
> |   64 | 39773 |   39929 | +0.3922259 |
> |  128 | 37065 |   36413 | -1.7590719 |


The performance reduction might be caused by the now double memory =
access on
AMD that is only adding overhead on that CPU implementation?  It would =
be useful
to see the testing on Kunpeng vs. AMD/Intel on the same storage =
device/usage.

That would tell us if it is more appropriate to optimize this in the =
aarch64
test_and_set_bit() rather than in ext4.

Cheers, Andreas


> ---
> fs/ext4/ext4.h | 8 +++++++-
> 1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 56b82d4a15d7..f8eacf1375f8 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3551,7 +3551,13 @@ struct ext4_group_info {
>  #define EXT4_MB_GRP_CLEAR_TRIMMED(grp) \
>  	(clear_bit(EXT4_GROUP_INFO_WAS_TRIMMED_BIT, &((grp)->bb_state)))
>  #define EXT4_MB_GRP_TEST_AND_SET_READ(grp) \
> -	(test_and_set_bit(EXT4_GROUP_INFO_BBITMAP_READ_BIT, =
&((grp)->bb_state)))
> +	(ext4_mb_grp_test_and_set_read((grp)))
> +
> +static inline int ext4_mb_grp_test_and_set_read(struct =
ext4_group_info *grp)
> +{
> + 	return (test_bit(EXT4_GROUP_INFO_BBITMAP_READ_BIT, =
&grp->bb_state) ||
> + 		test_and_set_bit(EXT4_GROUP_INFO_BBITMAP_READ_BIT, =
&grp->bb_state));
> +}
>=20
> #define EXT4_MAX_CONTENTION 8
> #define EXT4_CONTENTION_THRESHOLD 2
> --=20
> 2.43.0
>=20


Cheers, Andreas





