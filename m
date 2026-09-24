Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD28541DEC9
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 23:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790291554; cv=pass; b=b0lzteU+YaB43CKneWRTCHHc2M+AVTrnOexZ1BdVk2eE7jIaqgUFv42cOXoZB0bKQhTTmBIMEAUc33pyy8Fz5GvJIfEEkqQ8FdGm7hyPlCebypr3Z0CId1aNHPaOQ07xSKiVMGnZYkCrkqyDkDIWYIo/YnTgYHriDdLER3gwmLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790291554; c=relaxed/simple;
	bh=i5gtPL45/HsWqgNnaIaxvWIYAE5RMDtissUXKYWjbRg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qWibdXNDez6TxgNnWGBDPWOyh+y6Mv9SVN3YWAS+KVeyRxySpUAI3di62cp8uW74yjuDf/k6+w5Uvlawi4IPK5SwqFLfmYi3k7hBWPl6JOWEnxACLOxh/j7+nNHyf83Bl+OlraOnM3ptg9mmlOQfdzhD6LjM/AKiNMU2SpfQRjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MNhn+6bQ; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MNhn+6bQ"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f6c7a56so42048466b.1
        for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 16:12:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790291551; cv=none;
        d=google.com; s=arc-20260327;
        b=eunFco7FXa8YlnJNrmVINO4tgxke7uO6J+dLTUsX9ofCa2tlCs7WXPUAcV5r8/LC2H
         azbCiFDEBBifBTfCx+rq5jXSzDD/3XRowuzwOZb1lof0mH4eS62Oouagn4ytl508G7ra
         U6C/xzXkVd95HCh1eR1F6z9YdA6yk8EKngiOhpIWbx1eeT7XhspFOPGqh/bxj9xhEpr7
         H7wuCMH4hbMUaf31iPFyoABHMLEhn322xyFutV2imGNQQdD2ME5oRm2miB7C3LSJnVX8
         hRMcwPz6vTDG/9ltuOWxvyokOgm+54yc7PxShu5NaFepVX0Rj6Dv+4qoyovts+0jUedQ
         DssQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1/GtmCck+btFeib66fipBTabB87VzP8LLtE6Qx5AZ/Y=;
        fh=sJUaQDtV92IHW9MqzZwVTJfHovuHdfhmvTGXamoFLVU=;
        b=TbHVRsm6wpR1R337yvMG9o9Darka/D9NRFY7QVnuy69FvJQIYCl6rxrwVK0SsLuCjk
         psREFWlNxTtYUHm/nmLZVug8oK9vFdhhGcdY/5DIW+bAB8YuIof/onLIDyal1eRMEERm
         nzZD3CkacRkOW5kwn8OUo+9pQN1GNsLX/MwcRzmFM5mOVow3H7SRemfSXfypDIp0RTyM
         LbMNp/XCvUUr2/4jKwmawrwjdPzS/xf/UwzZzbCWBHn4So4sqOHHsYtNAXAHK4K0o9pI
         e0w6S/FV9lmOEqPIwQIIPKbGItNeUmUH9dAs/EK1ok6DW9Q6ZXp068O9xw1EAqBsrS5s
         C8Dw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790291551; x=1790896351; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1/GtmCck+btFeib66fipBTabB87VzP8LLtE6Qx5AZ/Y=;
        b=MNhn+6bQ0yOwUi7nD6sQIuImLP3dhxaCTGS8dOraKPpILKFlSAkUGE3t4ALNV+KO9Q
         /YU+LtmbbQkpU4iiaBwJgqyWJQh4Xc5wZqldJV6GaIQvRo7eCbQxqIfb7PVDjkXIa7Bp
         7LI1OBOZEb5rgbfLu0eOtxGDw/wihzA4pcYUPoba1k91jZiLyqKwGbcNkHiguyiDuuf3
         h6bxvZ2rvSaeRHTBpuP3msEQqCYBau1I5OWIfkx9/xmqYRzwJ/03CjSzFDJnS8AEBcVH
         s4LMyEZVErV1aRicdWUXf6Y3wEPkcOeDky8CLY0bO7rryhOpKdhL0Hscv50Oitv9sLOG
         s88w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790291551; x=1790896351;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1/GtmCck+btFeib66fipBTabB87VzP8LLtE6Qx5AZ/Y=;
        b=DkHw2caBY/lSV+4e8IGImIibThQDLq7X4faqbH+twMPSUWqPe5f0J36EhPCzEe0rwa
         0TgTST5mJrVNUoGSnbAj8fH3JjhDDoQrs9Pzoxur6eEn99ddVwrOzpusAFNigF8dglPc
         eHBuUxSufZb3DLUbI/zgw+P/0UXvLoKhXibZo/leUlAbZx9OBXAFXZMYmTYVG7JYJjrp
         6DqA2hHK2S6usFk6KSr9JexCc/6BEKh8ug92FSO/3CWouJZMK6T/zjOJ15pMc+iavKhw
         wsJGVHhFpteviJY4PjumDxyWCl6DY88UTX8sxO1/TjUXQmlXGbDpQC0aQ5+rlpr0Mapq
         +pXg==
X-Forwarded-Encrypted: i=1; AKwUvBwmCO8zan4KJ0c+S1OZvvTOMR5OkGKbBFsyUCgvOx49XuJwgjAbW39aNyfM+lpMTEiGr9o/Pxfk10y1@vger.kernel.org
X-Gm-Message-State: AFuF++mAhCbUVDFMWVjICT2tE7JfElLo84AMmRE9P5DYv8km1ZJrB8Ke
	ABndxX9V+opd+cE/R57ZgnDO7uRtPaumAlvcjge8SQg+pdxE5sSpheuzSZsCBmMp+cLcKH6H00s
	7SRfuH+AKkYXEDbsAxkBYvMKF1NROap/SgYWjAUJd
X-Gm-Gg: AYBFou1qpO+uscJVR9F3Uvvx6zgZBo3uGO1oquxRn2s4JuwnwDaxbYQX0J1HtJ9kCRh
	XLtAcaEMSu1TaxZ737BjI/N9CzRS1xDpx0Gpd0Te9fmfxph8N6lMFnosZkQCiYixdXeNJI/lpBr
	7BOtLx0KYuFe7eai5AdTDlrNnZq7G+TkAshS1pGaUa/CItT+xhIMzXqTIA1/BwjE0EYenzpup20
	Pvd6xR4zH0W7H3atyO2ki/BOsJ5ZAQih0YenEg88MnPvqsDhkxfvtjEAWZLj7rHfRulCqKYEHAR
	rIzUM+63SMvAGS2WdZ7Q3yDv9ct2EWTjqUyWNeED4JTxzassnubtut+UfW8YholUqzvK8Ko+sqI
	U/CWCIMhVm3yPW6XvCg/e
X-Received: by 2002:a17:907:7a8b:b0:c29:3b7e:3a94 with SMTP id
 a640c23a62f3a-c2ac53d2785mr321958666b.38.1790291550387; Thu, 24 Sep 2026
 16:12:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260918025416.604297-1-dhavale@google.com> <2ednz67kpd2ikrnerrmnvol2mdfntgqhakuoiu7x4cnrlpiugm@ojqolvlfmpnj>
In-Reply-To: <2ednz67kpd2ikrnerrmnvol2mdfntgqhakuoiu7x4cnrlpiugm@ojqolvlfmpnj>
From: Sandeep Dhavale <dhavale@google.com>
Date: Thu, 24 Sep 2026 16:12:19 -0700
X-Gm-Features: AclHuK_JnRXmc4okmBH7-69dBKIYOYrVopgPbSH1OLPpNlpiiv03zV98rUrU7KA
Message-ID: <CAB=BE-Svy3yoG+nJ7Z6Us5GG2Rj-7dyCY+EMpR9Y+PtyXUKnCQ@mail.gmail.com>
Subject: Re: [PATCH] ext4: fix race between inline dir conversion and folio read
To: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, kernel-team@android.com, stable@vger.kernel.org, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

>
> Good catch! At least the first paragraph below would be also useful in the
> commit changelog - the realworld impact is important information. But I
> guess Ted can modify the changelog on commit if he wants. Feel free to add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>
>
>                                                                 Honza
>
Hi Jan,
Thanks for the review!

Hi Ted,
Is that something you can add while applying or shall I send v2 with
just updated commit message?

Thanks,
Sandeep.
> > ---
> > Note:
> > This issue was reported by an Android partner encountering kernel panics
> > in ext4_dirblock_csum_verify() ("No space for directory leaf checksum")
> > on 16KB page size kernels mounting a 4KB block size ext4 filesystem.
> >
> > We verified with a standalone reproducer that the race reproduces
> > deterministically on Iteration 0 (< 1s) on both ARM64 (16KB page size,
> > 4KB ext4 blocks) and upstream ext4-tree/dev on x86_64 (4KB page size,
> > 1KB ext4 blocks), and confirmed that this patch resolves the issue.
> >
> >  fs/ext4/inline.c | 1 +
> >  fs/ext4/namei.c  | 2 ++
> >  2 files changed, 3 insertions(+)
