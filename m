Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4C43E8C5A
	for <linux-ext4@vger.kernel.org>; Wed,  8 Jul 2026 20:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783543764; cv=pass; b=AljVxIqOWZm+cBkTa7F8rMe+siyothqZhw7BXYzeY6y/MwnVvJN0NzMxH9muoQNAI+Dl7L233jcUd77fH0n8qZqCzRW8v7xczZjAqp1SbxLWzaGgTrz/25GZJkh8ObkHtWXtIdgGGHHXbw4hsk3aJhvDzRYxvslL2qEdzJ6YMEE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783543764; c=relaxed/simple;
	bh=Q9VW6dWLsKZN9qsm4oRde88bufG6z6b2KVMtuc1sieo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NksQCUohw6TIvlj47Ut69HNPdt+6aQAko3jdlM8cVgx81djVzoXvGCVIudsU8Bcq8Npx/l7WRTev7ua32l4bgrJIeJrOWnO+mn3Meg2diP//hoR53rE3T8UCk65nnDtMoPBbDv9Hlh6onjWeOvEmagERASyxjubnwCjwhumhgrM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J6YI35d4; arc=pass smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J6YI35d4"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47de0093c42so1168376f8f.3
        for <linux-ext4@vger.kernel.org>; Wed, 08 Jul 2026 13:49:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783543761; cv=none;
        d=google.com; s=arc-20260327;
        b=frpMzhGKE+Qzq2e09RKqSXrNAsM67iIjkFYFt3ewdPeF5BWp2jE7Ed0JRyjNP22gqt
         nO3w0lMTl4EmVBfub4Rf6H3eYKz6dNmqTGURl9xh52AaRD2tbL9t6ufQ3Wbu3iDFJgvA
         3HokfTQxPWHw8N47QhOohkgi0xW5MKTUQd2a79/crVwC/3av9FYvLtWdxjATp/PouYqf
         NwQkvDqBryMXVQi4vAcCFKIDlUSr3bfXY8V3xDQ4dTs421MLZiJeKxTFCg7wvZRpKLCX
         pZNhOGEs5WWgezain2+PvolFHlxacxl9N16ZEy0QAkC3TtIJzwYEX4Iq+akISsWt/R/k
         F5Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q9VW6dWLsKZN9qsm4oRde88bufG6z6b2KVMtuc1sieo=;
        fh=KBPBxs5NTZrX191kCIJgKBpgeULMcZ8CueA9lSqVkik=;
        b=owsex2/dQmZWLTYRrf/nmNtT3R7t71XV5jvnk5J+VgYoNsNQnAnw6K7t3vLX7O2LwE
         rL8XIuSoTMnWAmBW0dUTtLuvKHjo6I3Vzej9UTVA2dOaxxr1Wse0QJ20zW2wDe69AXaf
         6prfOkvGhEaXDtaV24QWZXrvDwcnZqBgCcRs1MTnu/L5fQcLZi9lxW4aOMK/l2mKeKoU
         YYxpaFV80mgej+22OJ88S2mDp+nchf3zJn+GtbdcbBhVym0kCrfptaSvI2q4GW8BY4hu
         ++VVTcoU/o841DHcc/rdpaZjsFnTdcvozdQoVqIIi/6CdRf/EJBWhb/QMX/UJJOrrSnP
         0kHA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783543761; x=1784148561; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q9VW6dWLsKZN9qsm4oRde88bufG6z6b2KVMtuc1sieo=;
        b=J6YI35d4A591y/l9NV+Z0NQvnoPUQbpRN8Whh9nwKsuE5uIsFRhwicE5lsSaX9SW+E
         Di+WL2TwrbqJ/0H7Nr5HJnC/3YMrSeXN/ygtovw2u7gMqtdOCmkfpLvrYv/ROXE8w4cE
         QpkTY6N5Xi4BScXm6jseBFnoOZMDjOW5nCqANjxyyrPi3V3fRHUp6Puso7TfhsIwe9vO
         MOR6wrS3qy0zcvJ3yxZ0DJG2NgX40A1doEjW60MlFFLm728bTAwC5MuTROKaxYGHP0Lf
         3lDH3c9jWHE+fWaYLIttP0mHGLmT0UV72dftoUNPsN0759LG/3yRdb/5C4g9XjDJUWZV
         SAfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783543761; x=1784148561;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q9VW6dWLsKZN9qsm4oRde88bufG6z6b2KVMtuc1sieo=;
        b=oZAYn0q17B5Q342/v0Aq3k/YSO4YDk/ebqRgek5jzP0NaFczE6qo38nvbqYyERc1V5
         JftC9lG879bawZxL3WW0+PBbAS5hw7tv/XHDcdfnnkSt6YsUWzWVAep6qiOvC0tgm8PQ
         Izd+MlU/zfvuzClCzdoK+CS2oU4PXlgOQuSunUzDHzv+GIysBBh2BdmSOeC2ecMyuom9
         t6d+CxmE6xI61seuTc2ACuaZJ3/0fPwXwDtERqegUJe+PNH35VkoWJjAbimr0T7FXobs
         B80VbR9RIiNqVMqOBivqkOcFdj3fakH7VFh+ridXsvjLcH4mAZRazt8bNpyudVzN5PT8
         /SPQ==
X-Forwarded-Encrypted: i=1; AHgh+RpDfAWc+ieBoXgT8qAFb276KItxF7t8i1Nqr0ScgK0Fiu9/NYzAZpUNW4ynMePSm3jX6JyaFsb07QrM@vger.kernel.org
X-Gm-Message-State: AOJu0YwRThz6dCPJhzZ+eWzd+s+6GmLPyD/EJMnB1xyEcoMAju52vG+V
	2XYqQ5XgkfK727/QWlpw2BFLKjLssdX1PDjrEDhlRwzc93EKJ4k4g3J+WEpF+2yAXXwl0t/G/jR
	BjKFoD30SJ3PR35fmdhvSPyRXOqlyWQ0=
X-Gm-Gg: AfdE7cm4Ayj0vatxS+4H9X7iO+PGCtrBKDzRvts+6HMnuT/LImK+f176/TrN/2/Z7t4
	vhqPLkmU42eMRKMqYz0KoqoLrLC1Lw3SsdyW64rhzSYQkCweT3751YZVr7UK+SjsmDLfM40a7la
	NDN4UQN+AhYspKYDpaZmm7BHPtzvCKzV90sMq3apuu6ExdKXRSY+YHejndFR0q3rr2j8oAXsaWB
	lW8NyosMqj8kWkr4OFozp6/y/ip74Y+b4xqEf0vUBnJtp4NiYQBt69MmcLWdpRMqKorW9fqDabD
	WBCWsPaVttQg2pDp497dkXMhfv9RcXON8dSZqNoo84eB9rGHxucxx1aCFZOi2HM=
X-Received: by 2002:a5d:5f46:0:b0:45e:f439:9def with SMTP id
 ffacd0b85a97d-47df0748abcmr4605746f8f.15.1783543761001; Wed, 08 Jul 2026
 13:49:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260520030357.679687-1-yi.zhang@huaweicloud.com> <20260520030357.679687-6-yi.zhang@huaweicloud.com>
In-Reply-To: <20260520030357.679687-6-yi.zhang@huaweicloud.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 8 Jul 2026 13:49:09 -0700
X-Gm-Features: AUfX_mznUJrD1oBo5FB4GQ9nk03mR1fYO3mPw7ij3a7Di9C6mAcrn22LiWqCwR4
Message-ID: <CAJnrk1Ykp94kZr5tfXrb0j6O=-gLM3vAL0V7ziAxm39oKOmv_g@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] iomap: add comments for ifs_clear/set_range_dirty()
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org, 
	hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 8:15=E2=80=AFPM Zhang Yi <yi.zhang@huaweicloud.com>=
 wrote:
>
> From: Zhang Yi <yi.zhang@huawei.com>
>
> The range alignment strategy differs between ifs_clear_range_dirty() and
> ifs_set_range_dirty(). The former rounds inwards to clear only
> fully-covered blocks, while the latter rounds outwards to mark any
> partially-touched block as dirty. Add comments to document this
> asymmetry in block range calculation.
>
> Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
