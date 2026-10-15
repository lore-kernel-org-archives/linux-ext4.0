Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADF33DBD5E
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 02:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792031733; cv=none; b=DQaQC/Cq5HOkWg5MawbMsYLwTSHoQlfwSvYbj3PC3etb08MRIm8XxnstZhZ7GUbdrQ/tLyfiL2kEoinNpNhiFaA3nUYV673mSylk73TQMp+4TvfrDUM44F0y7HbKnbI0XyhbqYdDmjuM7c8nmGuuUWivf38A50ivEugwUxDGg00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792031733; c=relaxed/simple;
	bh=HuGeJoAQEA7iwbIiLxJv53njPzZ3n0LkR9Yw7d+krrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hl0KNcDrPUJbWpQGKSAfJiF1n/GKo+3mRnBygDboxL6JuHr1/pEHyMr9oMXR170aqidN6P+3VG9PwNLAwkKnMX2yl3CsaywORpaPKGMkcCOTc26WwUmH61tC3fCWm32b0UjhH2+JVYsvjAZrU50g/z8p2vdDV3TtWPLq7pr6ijU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DFO3X0IK; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DFO3X0IK"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3a813079a55so3977832a91.0
        for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2026 19:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792031730; x=1792636530; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HuGeJoAQEA7iwbIiLxJv53njPzZ3n0LkR9Yw7d+krrI=;
        b=DFO3X0IKNgTSyoBkih4W9uj9sRv8v+MhgvfHjvQzJNayEqXQy4gKrHyjOjIPusKzgA
         hYrvLT7TZY2Rbl8m+sT6+8Svhqwi+ZS/dqeuW0GhThqGjYkVvEb74eZWh0gYYhXdUnQK
         /ba3qCIHaNPEN6VcsAnVTxbIp77nCAFe06twS+E8HqVJsIrHmcQS872h/D7qroffARqx
         dTI3tTFvB8D+XqMR0dilPvvF+MPlzQ1LSaGChNMlxzDciW752vL47JU60UdhAeM/CC9u
         Npas3LQ5C/UDFawFjH+pZMdA7LP+EOp7vGTZ0JunPtOhF7N4W0rVhkl8Q+Nd54sXvzNa
         o2qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792031730; x=1792636530;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HuGeJoAQEA7iwbIiLxJv53njPzZ3n0LkR9Yw7d+krrI=;
        b=Qbns+FPBbgDqhZxr1vQ01GfJS+8xNhN8c4FIFJFRKNkUtRaH86L5/ONyKJJhSwv105
         qWqrKsQ7iJl+w+TyRAviC/vZO1BFTiDLJpdqUAbyno35MqPYMRqelzqaXRepZbbfakh/
         yKDZ189oV6IgESCVoDfLEph3bbXVjX0Kny69pauByWtVJO3kD53bNrkptjIS3zZtlFzb
         1E3t0xTAseGyTjHqslOKM8RRJS0u0K5GIveGtp1JVfX1Cnc4McT8+dExc+upcgKTiVU+
         NR5k/CuvY6lVVG78ucV2PWg/pKeofFJO8IAt5TiHJuK4zhPXfy2o5jHQQ942ZAe+fhD8
         M5bw==
X-Forwarded-Encrypted: i=1; AKwUvBxzxaV5jdKCaX+Q77NEw+FHL4NBFnNqUq8q+VzjMYnGfD42x9OTR03a8cX4JDztiH/yfbLXrO78vcvi@vger.kernel.org
X-Gm-Message-State: AFq9FYLM8+U5yMc5uMCY5HK5LpJC5nCXwKlcjPc5basj+OUqBTgWGLNJ
	Tj4zKLW3KdmscN+g1hsisTVHeb2Hr4t6FB1sKwsQno5v7+q+o/6i5Auw
X-Gm-Gg: AYBFou3cbopUHRgz+yBC0an+bgRd7mIz6GOW562CeCZCNA5dfPYq+cQqw0OUfQzIBi8
	mDoeoRuqwUyk2lqC8siN5pmX8CnboZ8ncKB9xN5KDWacxRRGy7p+QRY9OPJZMFkpjXy3UUCKdxp
	qPD3US4OMJxScULFYJqlV7POsh6LBlk1mrC1D/OO5kwOpIhF5w7dWdvvFm6EnXTA90a2Wo117JB
	G9AfMuw4zNIx1cKEwKBNJTIhYkmUH8DM1IT3UaFB6Oxx5RjmAlO9prGg1bTl1YJveotDaHx8JLp
	tQl7Nn0ROVQpgqt6rDnhUXt2vlYkvv3+wYUkMMnGyfKYOGMFz6yY4fYzTDq+cyeTOXWSp7ouiUz
	0xBp1OaSQ4PINi7fTNNtSykBJz+LjxLgHzByBQnyHhZFqjoSX8AiMDA4MuRoWGG0S3fM63fGwrl
	fm7VX6Dh5WTxCB8U/e7AJHkHfiflSlg9LL3U7XzE1gj5Jr+EUNnPgUvpiY7f8JHFo=
X-Received: by 2002:a17:90b:1844:b0:3a6:d2ac:74ce with SMTP id 98e67ed59e1d1-3ab3a9a8da3mr10311790a91.19.1792031730350;
        Wed, 14 Oct 2026 19:35:30 -0700 (PDT)
Received: from ubuntu.. ([138.199.21.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac943e821csm1940875a91.8.2026.10.14.19.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 19:35:29 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.com>
Cc: Qiliang Yuan <odys.yuan@gmail.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5] jbd2: fix shrinker scan budget accounting in jbd2_journal_shrink_scan()
Date: Thu, 15 Oct 2026 10:35:23 +0800
Message-ID: <20261015023342.ping-jbd2-v5@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001-fix-jbd2-shrink-scan-nr-scanned-v5-1-5348b51efce2@gmail.com>
References: <20261001-fix-jbd2-shrink-scan-nr-scanned-v5-1-5348b51efce2@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi Ted, Jan,

Friendly ping on this -- it's been about two weeks since v5 with no
review feedback yet. This reverts jbd2_journal_shrink_scan() to the
sc->nr_scanned-based SHRINK_STOP check from v1, which Jan had
reviewed, after v3/v4's nr_shrunk-based attempt turned out to
conflate "this batch was unproductive" with "nothing left to
reclaim."

Let me know if anything's still needed on my end.

Thanks,
Qiliang
