Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D023AEF50
	for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2026 10:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774433756; cv=none; b=gShJW6gTLY7OfBBoDBTs53MsWV0Ve6qyR2GdViN7uDXlspFXqkMGvnicZEmk/M2OZa9dt5A9kH3pHV7H/acTlH2+40dD92jAoABmNSx4zH91vQdOM/oFOImV4/bQjS6EUuD88+yTWsuOK8z4RFEoLIJlXdhg8oaU9uz4GTDT0DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774433756; c=relaxed/simple;
	bh=dTbxFPey7xSpEexAbeZMQA6ed4XE8QfZT3WtybmGSMY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=mw5TBMrL842TMz7aOgom/X6Knm8Vd2gihlW2YmqTopVKWPVwg4r3zJgywSWWtnMv7AqGiNkdIvgSUpe5Fp6IuzA3/w0j8y/1kQ9WWtVXtpUxn9oW2V5biFN/KAcxtQIyy4fVgA8/aYTZWlkW7WegG1Kyet/ojeM7lKa5njZsRrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b=KZfZlDPw; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b="KZfZlDPw"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82c2239140aso1835609b3a.0
        for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2026 03:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20230601.gappssmtp.com; s=20230601; t=1774433754; x=1775038554; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mAbulfAiOEAPrh906GbXLOqJOMJAMSMFlPNota4Sbhc=;
        b=KZfZlDPw0qnVjy/dNdph6mtgtzPAy8k4qrpyhZC4GsDW6UNt6FUjA1O207xSlcZyNU
         2e0TSTM48MDmZ9s53fRvrHXIDnuQHs/mjdegBE1q1CbA6cxfH6KstCVKlLrjMDsdoieC
         XcXcraLctLcPyP9hVOLoXKztjng9dUS5cpa6jVqdRyKyfdWvyI0u41BgVluYvv7FE3kU
         Cafyqb+R/EcmP4eDjhC5FtoifCUexYsbHTwtZmQszYgYYefN2epoMQEDmYPdj9TfCHFr
         0eq5fvdOQM8GNF181Ep1Ttun0pP4O/GnYTJ+EPWf+Is5w6LMggZOnzDx0RvFHlnzj7Ae
         lRpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774433754; x=1775038554;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mAbulfAiOEAPrh906GbXLOqJOMJAMSMFlPNota4Sbhc=;
        b=KYEWfClAErd5qS/18x5XgOKqdxrH6RRcXZIk57YK+sYLDkznAPQUGNAFkorB1wX/OR
         h+7+Z3RICueWKLNnOI6Bg2EEvhb3sUwIbVqkiOfuZV/LxhWG7cO8fbXMB+xeoXcjEasl
         5dPFppUdTxLRif/Iqic4/p2G/PcmFehX849lYRl852GB9Z8inhpKGGCdgpZaYwb+DZ4A
         Vcdjep7Dxu/fR6ZNrMrLJ29xKRnk+Z0lU0nlONx8cMWHBYBpBHXngbOjprAf/MRDXNy0
         HoawvTS0iyrsd59anJMj9nt4r616Yo8R31/nb7HPzm4AU7DyOXLYESFdb9rBfsjGQZBR
         2g6A==
X-Forwarded-Encrypted: i=1; AJvYcCUSsUh17Pxf0T3JKho0yMuKZGMwEZ9RPne3txdrpg9eg9xcCao1rV0U+7LiAS0P+677Y35b+xL8Gvbi@vger.kernel.org
X-Gm-Message-State: AOJu0YyhSESL+i7kkr3zP+YEsyjATmPvSEX7KdO8GNqWokwhQgftMRJg
	P4UZ3+vfK5qEDoLmDPrc0fBfq7En8m3RLvmcSXbcI27aVoRk9Dy3Sa53FEGaPOQg92lBM1Qh/pS
	JOQa6t3c=
X-Gm-Gg: ATEYQzwjvRQfP1nmRmJJO1icNmDUHpb82K/BLSNwujQQXZMINwFg7Ik/IC63TOwfmUI
	xmJmSH8R+gUNzuDsoS7NHWW+P9LrQD6VdsnMr8NQB/CcFzUneIyw2UtdSbS19GPtrh4/DXZNO4N
	JoQ6VYvsztBnNCvb+Lw1XcREDbvp/aisB2SMlIroxEqJnjZGs4XjlzJLSqKm+OUf1VdvIqLQn6+
	MMcGLKUxMPlllkYN3uQWVIDzbCiGPCh3EQG4QaC4/QwpbP3KxqsYFeNw97dBdS46FQxCdVYIxkZ
	zZUYJ3Edh/1C1GOBCNmDvQq29lCfCxUTaDXovOZXDEb0hPoYUGGzXwTcAFBQoFCnAVSuxAsfFnV
	Ggkpo08X1iZcFF5sRiPUkFNo6RD7C2pO04LTwugePeGnfqI7PjCqjfMOnTqXwOmjgzIhs1eZ2Av
	ieoQMROdn8X5+PExbVL6VoKcu8jja0m7odA3Xe9vJdaW/cZalrxtHXMgHT8YSO/ZxHJG1BhnEb0
	JDQ4A==
X-Received: by 2002:a05:6a00:4398:b0:829:800b:9fe with SMTP id d2e1a72fcca58-82c6dfb397emr2776396b3a.39.1774433754335;
        Wed, 25 Mar 2026 03:15:54 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03bc1e59sm15996602b3a.13.2026.03.25.03.15.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2026 03:15:53 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [RFC 1/1] ext4: fail fast on repeated metadata reads after IO
 failure
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260325093349.630193-2-diangangli@gmail.com>
Date: Wed, 25 Mar 2026 04:15:42 -0600
Cc: tytso@mit.edu,
 linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 changfengnan@bytedance.com,
 Diangang Li <lidiangang@bytedance.com>
Content-Transfer-Encoding: 7bit
Message-Id: <B53E253C-F314-4376-BD9D-58867FC8D3F6@dilger.ca>
References: <20260325093349.630193-1-diangangli@gmail.com>
 <20260325093349.630193-2-diangangli@gmail.com>
To: Diangang Li <diangangli@gmail.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Mar 25, 2026, at 03:33, Diangang Li <diangangli@gmail.com> wrote:
> 
> From: Diangang Li <lidiangang@bytedance.com>
> 
> ext4 metadata reads serialize on BH_Lock (lock_buffer). If the read fails,
> the buffer remains !Uptodate. With concurrent callers, each waiter can
> retry the same failing read after the previous holder drops BH_Lock. This
> amplifies device retry latency and may trigger hung tasks.
> 
> In the normal read path the block driver already performs its own retries.
> Once the retries keep failing, re-submitting the same metadata read from
> the filesystem just amplifies the latency by serializing waiters on
> BH_Lock.
> 
> Remember read failures on buffer_head and fail fast for ext4 metadata reads
> once a buffer has already failed to read. Clear the flag on successful
> read/write completion so the buffer can recover. ext4 read-ahead uses
> ext4_read_bh_nowait(), so it does not set the failure flag and remains
> best-effort.

Not that the patch is bad, but if the BH_Read_EIO flag is set on a buffer
and it prevents other tasks from reading that block again, how would the
buffer ever become Uptodate to clear the flag?  There isn't enough state
in a 1-bit flag to have any kind of expiry and later retry.

Cheers, Andreas

