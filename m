Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F727242D9B
	for <linux-ext4@vger.kernel.org>; Mon, 18 May 2026 14:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779115485; cv=none; b=fBIs5A2l2eYn6uDc4EJUnNOnLS5FIjJevOqLHJxtOdcj+T8fmsChlr0g6oDPXNEUDDUGY7ZXjqdNox8a0tTe+N0IVcmJQjkTOhgqpTPq7SxsumZI117bE/P+L93z9UKtXxMMDOy4mKwVRffANfpllVgDuTubrWK6Sd0EgBU+vRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779115485; c=relaxed/simple;
	bh=u1htIQ+cBGbRbD9P6U7xix0lnFYW5IXNgGXzrDz+aWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fPA0MIrIz0h0wRnRwN275+05W7YhqIwNrv2eDMR6TyvVPTqh4C1Mk94RWE7C0Xf7h+beOeyrTz8uMZLNxYb0+3iLR1SDAz/QeqqHJ2nhXSS52L3tvdtx9WDzSSrm8F0UyVW12HFBTQ146vXcplogLtBqQPd3BGONURGHFWk8VnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fRtytCeZ; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fRtytCeZ"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-83d31ac4017so1030931b3a.3
        for <linux-ext4@vger.kernel.org>; Mon, 18 May 2026 07:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779115483; x=1779720283; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5QC+PoU+YwXsRW92BuD7PelfR56JvKbxUHG8raaMFfs=;
        b=fRtytCeZJc3KHI8ohi8X0/fY1f4yrucjpV8tLF7hueQbc7DcIlFk8pXKPDTbwV3e/Y
         ON1zw0N/cmgme+DlpRm8MKUWkg3dJRt0qcHjnrh6F5x2KLVtxymcPzqGHfKrHoDlOCR1
         3UAK24Hm7H2IUeU67cAYZLz25BFK9eReckj+cTijftv2lcsaDQYeekLzhjVd/o64gZlH
         GCfaZOwEncJjd1JSZsnzFJ9Ee7OiGPuFz+MaqCXQhLp4CPpJypHK+ttGMzmqwmKIdN4C
         cVRStWKwlyV+AylL3vNd6cCSqja5EGGhhVykEQg3mrNB2pAidjRq1fWpjaiDmi2xzmhj
         uOsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779115483; x=1779720283;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5QC+PoU+YwXsRW92BuD7PelfR56JvKbxUHG8raaMFfs=;
        b=YaP6mAk4aoboGqd05l9gN1CFsQZ0dOcS/6VqSPo/m11OxmkgkzPdfbVyJIykgUEMMV
         8ITW7oGk36DUtPqR21banW468cSNELea10geQwPhCAZHZamoVKo3ARmFLDEw7lEekguZ
         hYalqb3j9Rcwu3wYo5E9EVAdl/K7DlxLiN43hrs1yivPPvaOF62wuchAYLtrvlQ9IBA+
         p+ZrmFhcd5iFxfKACdbXmRBh/zaema/sneiw2wdsDt1Ducytdlsw2DGmg6Ra3ufehnCA
         xICQMRWIDQdsjFEv8Mp2aaeaayJQgT0jBlbTu2AO9HMOEr1nVCfJubzk+VkUzoA9MJbg
         SCBA==
X-Forwarded-Encrypted: i=1; AFNElJ8UR9XPGVDgHgWXNCrIiTQ/Oqjs5PdmjKrmoBjv+NtJnVg0ripuGGC932eEcvlIAk9KN/Ki9t0LlMEd@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+QQsFIhORCYojpgUeaac4ECCa74+ZFbu1pvo1gFiSEaXxKRjU
	JOYZnvNU6gX1T7du2C82BklBCox0nzc1o/xWSN7NW3gTIX7kNW4eOaxQ
X-Gm-Gg: Acq92OHz0IDS0ab9deVKop64QqN1rlQ28+cP9zKaIN0k8FgWnILCFyIafxFMb8ohCPs
	lYt+Lo9QPRFvgYhfDk8L0azVjlV3w2ycNVdn27U2HQLRiVacvMAKQxWpCBwcHTvXZu94Ld4pb0z
	pIWWmJ0Cvhw0arjbAxhsEGMxCPoGkjExhzxW6d1nygSWZglolvmD/fppPkZwZe6bev8X7Haa4Bv
	Jv5P2griEdGTrEkSj8kp5uITOgXxt+Yw7GYMdLwbD5T5BWyF/vJMoRiaNqlxONQRsrZ/LL9Aux4
	+zhNAXn/SfbkyaWfONNp6JAyflwxnKuTnykRdCzcE2NT4EFSLTxI+W5T8zRU1ma4qB24YO499T6
	dw03DkO0ZEMoCeSS1uz/zYd4xOygbJaRjqQsDtImFlqCgoAWdVocYHPKuA0I6jNbts53R5Jhid3
	Tdee/Or1U396nOyIJ+BRLjlue00rA=
X-Received: by 2002:a05:6a00:2992:b0:82c:e692:1f91 with SMTP id d2e1a72fcca58-83f33df6ca2mr16284317b3a.39.1779115483338;
        Mon, 18 May 2026 07:44:43 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19c5b4bfsm15394428b3a.28.2026.05.18.07.44.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 07:44:43 -0700 (PDT)
Message-ID: <82a93174-6897-46af-8602-d7ac9d2d9dc3@gmail.com>
Date: Mon, 18 May 2026 22:44:39 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 9/9] fstests: btrfs: test UUID consistency for clones
 with metadata_uuid
To: Christoph Hellwig <hch@infradead.org>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs@vger.kernel.org, amir73il@gmail.com, zlang@redhat.com,
 djwong@kernel.org
References: <cover.1777357320.git.asj@kernel.org>
 <d079b3f7cce446b0c5bc0762226957b960c7a3ac.1777357321.git.asj@kernel.org>
 <agK9MC0ufkTJj-zu@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <agK9MC0ufkTJj-zu@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/5/26 13:40, Christoph Hellwig wrote:
> On Tue, Apr 28, 2026 at 02:42:59PM +0800, Anand Jain wrote:
>> Btrfs uses the metadata_uuid superblock feature to change the on-disk UUID
>> without rewriting every block header. This patch adds a sanity check to
>> ensure UUID consistency when a filesystem with metadata_uuid enabled is
>> cloned.
> 
> xfs does the same.
> 
> Can we abstract out the uuid change and generalize the test?

Sure. let me try.

Thanks.
