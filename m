Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795645141;
	b=tr4cbPdEhpKUHkRdai1BR3yrAB/Ym0ixa5IOATPm+Id0uh1URBeLr6mypjyyGPfLwUUG
	 cqcKeYom/y0eefcL2rxikNqUAQ88BzCzuRCFy+FfqjoGqFHdGFLPU/CEPolgyTK8ZzZXe
	 yI9BKF3lDNmu8jeMnHXJnxARP5h3AReaEy7MXY7IZCmb/Yz7nCK7lAt893fghjsA8CO7n
	 Q6rpQ8qItCh0A74Pb7g1A6+eRwH+gObbl+ClzsLLOupQjPd/nXaFjizlDlzc9vsZ6LkpJ
	 0uCZjqX90X9R+3r5zFq9X13qqh+Ksk71PZOhNIytbS02WT4e6XNPmEBeMiW1uU2eFew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795645141;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Mailer;
	bh=aKRTtm62UDdZcQ54J0I40J/JAeENeSlNH7NrIsStsO4=;
	b=Tok/UB+F0EwxNlx49GtqKv8YkNpdPUe9k0hT8Y2VpcvjR/G+d+o2eiX6zvYIRhPo4xqQ
	 0gvWdRfj5pVde5fAOU6W9jYBeyo7MHoyofBV+yAckgpQYqZS/bzlKlqzN4Ib+DC96ZxBb
	 g5ZrtBaznyv9EoLAdQlQuzSDY971BvSXbZDUwkkfKrX/GUSAqX3KXxTXxnRCEk0zQiAV/
	 QKgZ/aWe87OeMiMiiS0vSSsiVZxg5AWf8xyLyrU72r7U9Dl2ydqUZSMURVmCtfrSqgxxq
	 FgPktkYt9fYy0q+PYp32+tr1tHzUKHvPgsR/bXr4HMXBRRJhkMAdKFp9iGjVoC8SGbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LU8ZmNYE;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929FB606A321
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 22:19:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 929FB606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LU8ZmNYE
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-3282db206d3so1241119eec.0
        for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 14:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795645141; x=1796249941; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aKRTtm62UDdZcQ54J0I40J/JAeENeSlNH7NrIsStsO4=;
        b=LU8ZmNYEa8Il91B0WjRYOgvdWYw4XvQqggs7fajTqPBNeaI43qn5T9VJYMg4J+ejTb
         TwUYv3rIpHc3TFonssrAHgkL/T667IhTGvreXvL0T0ZnJEaq0LfGq5v4FxhLkGoR+1Bq
         hTPdJ7S9EX+ly+/0KbQMcNGTWztPNsO3KZUkEz8Vx/05Hqc0GxtfqAKOQenaqVwVKKYz
         c9+dafLvOBUlRjcTXdrE9KEYzclKS+njcpYiRREjV1cgnxjg/cY2pGBwTPtDEoRIopNP
         uQoN5td4n8zStse7AMCATlc3dKTR8m6FDAoRse/+OwbRae7P103gkxf6sNevMteJm7oW
         EPmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795645141; x=1796249941;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aKRTtm62UDdZcQ54J0I40J/JAeENeSlNH7NrIsStsO4=;
        b=qURrkOVAU0QqC4rGhGhlr4upUbf9BspaFZkmL0OJWhKJ6thikzUrCHmKQ6u70Vb8kz
         YLm8wK1emxhvMgp1hsB+cCnocIJiyJQdW5Ldb8ptuyq7rzEJRKPqMzj1jJe9BqiiUS94
         z07irX/O6xHC+IAPYQLA1nNpmbi31Er98gUzVAPG1gTh/znP41V8/zIB50JAjQ2c0pw9
         HNvOAyd+5QsHDw+srd7XrnO4H8hxB8zEhTuc3RS7+FE/gZdTxMW+NugI2mxu4/hqD53f
         PevPt6QkMM7dh9b3xIk0zEkn/O+z1+C9kGrhKJfgz8tpYVhxn1EX9LxA6Gy62SuPFJrA
         Aimg==
X-Forwarded-Encrypted: i=1; AL+hErFq0LcjABIHYm7tcKOI0EiP+djLqgu6plXA1gJNUZK11bZVv+BTY/ZgTBZ/6aKlZJycjdCMZklx0HM+@vger.kernel.org
X-Gm-Message-State: APuU4Z93sBlO/j9JIpWMLuEBKGk1/svlN8IxFFE+NLkzo+LjVVbq2ocz
	0p4/h+c0g6sBsFTLzV2586bDZb/ues7hj+uGY7KpFsNRCmt9YVB2NI5N
X-Gm-Gg: AZFdTZcyKl+MR25wqBg36FtlTtE9vDKt8U912bKqkVYMya3uRDtAVXME5GwzvRuYbhw
	5swVmZpErm8Xu+pFeBbdZslTceo/OiKai7LWUh0A+VY6akICn7+4lc6JN6vdYA3VtrJzkBW3Rne
	t9s45ZLfX+NwyQx7xj+Hws9BHMbawKmWdJ0bKZ5FygYNgye9SQAiFfjoslODozBKyQe2WnucB0w
	PSiHvstXI7YTGdkT7eyddX8kMv/442wG0ZGe7BUDdAQccnUcxo9sPJYzWerfEZzvTd3iNIR7IQn
	fULLVbdWxJtCX6LT5LHVkTPsh8nzDKdIMJo6tZLnpDBQojkxIgbhPm+w1+0YQUY0TlhX8imUYA3
	DAC/NDKp6jolgZkD9+Np1dDXOTiNYEuRWR5uMpAjhCEhMcAFTAwaHpwjstS/5tX5nORUWkgxg6h
	yBN9X3Jz6kz7zWkYGJkiVqDz5BYgjS3wqm1DMQK52FFsnHavHZgfhybJkf4fK5kHMisIPy3yD3p
	Xe35cDtqsJr8GKYox4WN+PnmTDWQXsNqT3gD6PHN3aLKsrmWxh1V2DQGJInbbEOkmes2SxsD0Ts
	8ryCWvb8xBbtn+3hxa9phOY9ZQ==
X-Received: by 2002:a05:693c:8951:10b0:386:b4a1:d92a with SMTP id 5a478bee46e88-386b4a1daa3mr9731399eec.1.1795645140431;
        Wed, 25 Nov 2026 14:19:00 -0800 (PST)
Received: from [127.0.1.1] ([2603:c021:8021:f000:0:1865:8c38:18fc])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm47487514eec.25.2026.11.25.14.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 14:18:59 -0800 (PST)
From: TAKANO Mitsuhiro <takano32@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd2: Document the h_invalid flag of a handle
Date: Wed, 25 Nov 2026 22:18:58 +0000
Message-ID: <179564513831.2536897.4907315692095561152@gmail.com>
In-Reply-To: <ylfq77loldtcc3nogxtqkwxlnqnqp5d3nvyrl3kezjtxcnpojg@ujgcfjxe7gkd>
References: <20261125184027.2402549-1-takano32@gmail.com> <ylfq77loldtcc3nogxtqkwxlnqnqp5d3nvyrl3kezjtxcnpojg@ujgcfjxe7gkd>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: kpatch-send.py

Hi Honza,

thanks for the wording.  I am withdrawing this one rather than sending a
v2: the same warning is already fixed in the ext4 tree by Amit Patole's
patch, applied as commit 008aad6508e3.  My duplicate check looked for my
own posts and for the subject I had written, so it missed his.

If you would rather have the comment read the way you wrote it than the
way it stands in 008aad6508e3, say so and I will send a one-line
follow-up on top of that commit.  Otherwise please drop mine.

Thanks,
TAKANO

