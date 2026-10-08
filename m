Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E763CB2D5
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 19:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791487253; cv=none; b=AZ2xWRF1fGEWqb0S9LTVvYNQerq8m8CjyhRjMz4kZPe7UNx4GEEKTImd1iAdUvd/mmPOFtvUHUjKjMJ4B9psZAlgBYYUh0Dd6eNSU5iqKy1hlxAynBY9XtxHW684ynaX3AFy2F9RIKdVzSN7PlOCR18E5s0tAuafS9kcCCaNNAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791487253; c=relaxed/simple;
	bh=IVuC9lIbYtCumDz9NXJI6wI15tp2jdUI7u+AEMRRHNY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mMKTA+9+PEV2xWzW33KkFmR7ti02DuGhYDVD77HEK0osYzSUagY0eUrxRexKvseg4EWt8q0oOZDuwwgukSfF9rL705MQJiw1G2qUvzm3wWD9qL7Soa82/+zjrR7j/b7y+8+qvtmzu0mwPflMa2xKHmEByUDla2cOwAZCoxoJZ5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=LGRmq+YA; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="LGRmq+YA"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-3518cbe59b0so681573eec.0
        for <linux-ext4@vger.kernel.org>; Thu, 08 Oct 2026 12:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1791487252; x=1792092052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dn0FkaOSqhp1JsE8t2flY8RphMMxPkCr1WEYWQMbOsE=;
        b=LGRmq+YApwl2UXrqhLGOmR+OZs2818jbVdpm2qWKdLmY2PCBN/415+ynLD+aNLfxB8
         vxY4h+ufC1saJ5LZUPZtUhUxcKxWm8PigdS1uMhjITIsTWTzU6b7XZhDfLZ0JIPmhwyO
         dZFFhA5vozk9xMMgvOOzqBeQgCOpntXvrLmzv7NVp4hGGIAWY669bUWkHY2jGrj62EP4
         7UKwz/wc8HzszvvsNsC+VbZe7Kzjci7h3thzQHl06eEm7fx8+Xe4/zBLtxnBYYyhVhro
         +AzC+j7ibLb0JCETL0YA/42ekxWNz2FN3T+RSCHKps/+w8uHNk+/MuWaIUKa3yDd5If6
         KEkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791487252; x=1792092052;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dn0FkaOSqhp1JsE8t2flY8RphMMxPkCr1WEYWQMbOsE=;
        b=A4XOKrDHX+2VtgyMdew9M+9ZbkzmQAu7wLT3U8s8g6m+wCktOCsZnK6tKQY/FodkWp
         AInQzdfnLKyH6qJRExHS3bYmOr4LI5qEwXXsyWJIM0gWbYZCCZsypGQnOrKEpguX4AQp
         mrTklUKS+FFX3Tq/PEA1UzurZlgfF46Wpqv2dQZEnVlfxBcO9Jl/AcLPBfiotE4bjyzx
         EvHfeTtx9x1xoj8qQuZLEK5V6vGHTxplzMOyekLZKFmzuX2bmwtBEsYJ4jMxgl5JENOJ
         NT9wqC+rp1tXFIrDlKDjxJ6+afOQ+4mxHiZo8FeWh7j+pAJY3sN4Rho4nvndaoEIQep2
         +rSQ==
X-Forwarded-Encrypted: i=1; AKwUvBxUQPYwfWspqs48f/oGp/3V8MdP+IO+cRfjM7kg/+/pBxpEq3bc9A+wukxbt/MRIbnZjck+Obu199Og@vger.kernel.org
X-Gm-Message-State: AFuF++norHrdIT1MYiAUno0oZXSs+S0um3DObZ6eiUNzC+BaGJy7KShO
	VGQKRrxb9Rw0Zkbx1TAzrhJ0YzzC9e7eybw8r8y54WE0R+pIPKQ4uUxmwtnLUkZOXy0=
X-Gm-Gg: AYBFou2XZdEXv0rnT1YYUES013c8duF6tyvtBXD0KwTlZCcdoEz2qgUDK4U/yB1BVLP
	yQJri9dqQmm52f0l6gpPrMlZt/6BTV44QAnrOlbwzGdnBCiel6TRSTihVKIkkJ6wxfcw7MHLWMX
	0eoyyX3/MqAWT6SKUJfmI2MZ2BkTLNqLc5i4saBF/KnU1iyK9x4Qu0m4iJbK3tz7Beku5A3QPRc
	Cr+yhOmHogzau3a/hcBV8/ipaVMWTByLqbtGg92XKfsB8ynJDEvVzjDUaV2IEi6H017mmzPEk1v
	WQZnx+X2/CeeZMFqOF0TCDagLHnPZ7IFxYiw/MupGwPTTAgg+HMCmPC7/exJYUb05drOcuhHc/R
	+1zPrYJoNe9JLD1s0fq1MqCcNUktttvdXefZfHFuHbvPNptqxXtcEumFEKoyzZe28tXuUuudsBg
	xmgAp3nInvwAdTk9D7sQQM0ekFvbzE6zmS/7eUWyX8KLY0Qp72gq+Tto4tJQSY72zE6UooUolH1
	7kO+lnDRCLpikYjQyYKbFocyGQLoU9M7JoLimzS1kkwfdLsbhtm4ebzNSiuDjbCfJMnME4=
X-Received: by 2002:a05:7300:ec8a:b0:351:2200:1cde with SMTP id 5a478bee46e88-3536c4bee0emr284571eec.8.1791487251418;
        Thu, 08 Oct 2026 12:20:51 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:bc88:5ec1:4f8a:5b23])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca329d9sm104325eec.5.2026.10.08.12.20.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 12:20:50 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: stable@vger.kernel.org
Cc: Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Max Kellermann <max.kellermann@ionos.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6.6.y 0/2] jbd2: backport CVE-2026-89566, CVE-2026-89567
Date: Thu,  8 Oct 2026 15:20:44 -0400
Message-ID: <20261008192048.98833-1-artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha, and maintainers,

I'm working through the smaller CVE backports still missing from 6.6.y.
These 2 upstream changes belong together for CVE-2026-89566,
CVE-2026-89567. They must be applied in this order because the later change
depends on or completes the earlier one.

The complete series is already present in 6.12.y, 6.18.y, and 7.2.y.
These fixes also affect 6.1.y, which will need a separate backport; this
series is only for 6.6.y.

Could you please consider this series for 6.6.y?

Thanks,
Artem Dinaburg

Series:
  1. jbd2: check need_resched() when skipping busy checkpoint buffers
  2. jbd2: bound shrinker scans by examined checkpoint buffers

base: v6.6.157 (79643295eba17affbd16ca97f3ef04c90266b28c) plus stable-queue
revision 958ddf240a33ef26b1771be944f0ea6c3b597472
