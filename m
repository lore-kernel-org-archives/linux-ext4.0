Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B8A35FF50;
	Tue, 24 Mar 2026 01:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774316499; cv=none; b=jgOHZHWgXi+YJCqayE/upl3RUlg4qSIyeTDRnFSO7045kzQYsKD8oTuqoGKUzfouDcuuUQQVBvgD75kdt6XTqu9jfIBBYalMkcfqC/Uhlbbfti92UosmXobo9QdA1edbtpMU38/Oc2+Z+5hD79WBnk8pUeZQ6r3Ph7jbKBzynAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774316499; c=relaxed/simple;
	bh=GpswIbFYYVlQBnSq+Tk81j4O8Y5/C2xuehw61lMLoDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/1CqCMscL/Z7BQ/S6Yvl8TP4VT7h5oJ1bJOcnf/+4dHimmQIBH/DNgos+JIDg4PekJkpKmSGDq0qVyIa0IZj/djod32qNJTLrDLANnGt0EUTas28fOSe0B7yGQ6Fu8wFWpKbRwDwijK7lLQsHNMqoxg4aJOXzfmUf4ZwUWwlUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=onHBe3lf; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="onHBe3lf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1774316445;
	bh=GpswIbFYYVlQBnSq+Tk81j4O8Y5/C2xuehw61lMLoDI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=onHBe3lfNd8pOT8PwF/id1F2c//cowlzecDVO0Rexs5XGS3wPCKtiRkcpUyMBKd8Z
	 zSfJOMkwFcDGluDVuD6gLg+urcd105kgIroSE5PG+HSPPraIG18WhFkvECNxhFoTMw
	 r+hwxtRdmucf6z6GZI/qihAlJIHMsmRaz1imUNY4=
X-QQ-mid: zesmtpgz3t1774316436tf2f38db0
X-QQ-Originating-IP: pSAu+TrXxnYfoOB1eFEsoStcjcQN1XvZjiLvgXwfHNs=
Received: from hongao-PC ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 24 Mar 2026 09:40:30 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 7415584528744268832
From: hongao <hongao@uniontech.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+1ffa5d865557e51cb604@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: skip split extent recovery on corruption
Date: Tue, 24 Mar 2026 09:40:25 +0800
Message-ID: <E4BAF530323E79C3+20260324014025.31601-1-hongao@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <FA074540F4E30F27+20260323015752.60064-1-hongao@uniontech.com>
References: <FA074540F4E30F27+20260323015752.60064-1-hongao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: NULCRwGdozm47mWGiyHLnvltEZ2IqhRbcsW2Ivv/f7LuyywHY10cSgck
	wiGDZvbg89iENsR8kjh02dl2X+71n9vSBDAbpmH7gZd0cDXLhfLBTe1VpZmIWEtmjKRUXz7
	NlxKyEzeZ/4vOtuDYR+o/d4XnFFhB9fxFxqyiTs4usAFUM6sp7AfYZq+FJZ7C/jhhmH2O4J
	7FmloyQhRAmJBYczjp8tQlWt4UWxN/veKCxoqeFW8nJv/lKv4/7eXqhrC/TIFcAe4bKg/8L
	rKVuPStRhum5cJwAdYa1UvBtoylhgtrW2srcacIXFf86wMWPfDaetPMI2gwmLPkmMn8K5qr
	JqlJWtutzltQrbgUBu6Hvtv9NoD9rVkhtcafPbgObwKiwNKO5qGTIAsAXaGImtMeT491mTo
	OuytYWiycjZxHqw9YmfzBxeaK0HWqgoqA6qSBGBHuBxCxgtbcn/DKZyi7j25Sc1P20FriSi
	Yc+57RTTdQMIbS/HBjkZ7oH7wA/38lCeHq6RpgmBQWg6hAboAJ8K8DfGHLybp/wrEJJm3AC
	45+OhH2xkHPGvsAvwQ/22cG0Bf1acOJ/iM+cvAYP1x6tCb57E9z4ItC67HQLwh27TniuWVq
	qp8FpWSEaavYJE22n3qZqEX2rTyhoSFhSdhKam8SlYn6AlzvksOC/aZ5pMVf1nLWYrzN5+B
	aRUjj1lEld9ViikhMzai97YoaBGSaBI6wwr33NL0aezvqhROfBvYdrwjfah8rheapswlpvU
	rK/s0IW6RcZ9i3cE44HAcAqXfGj2Eg+qi0ySfUUBLgfW/kH53d6lPeHRalv84pdKOZ1we+B
	BGQln6hmybBeEOUXRs2W4ABI384j53Is9WqQHckv8gG/43XSHal3fhuIvqaEFLkvOtnXfMa
	zgQM+XQcQcP+bahzkPXr9AFEvaM/obD1jOSr4zEMg4ocsnNkn/wlrXz3QyIf6b9W82qu66r
	gI0U9HOr4RrKhD9cosBCAImBU9sSGIKkVIU9P4WyicBSV5dUCHq+5D9MpA0uWcqpkf02Uf0
	JjGwaY9gm1wiHeF44su5WucBDd7+5STk6IX4/vqkwvOMSSuUA6sd3IZouc4ufKSWmsAh75v
	g==
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

Hi Jan, Yi, Ojaswin,

Thank you for reviewing the patch.

I will send a v2 that moves the p_ext validation before
ext4_ext_get_access(), as Yi suggested.

Also, thanks for the Reviewed-by tags:
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

Regarding Ojaswin's questions:

I do not have a local reproducer at the moment. My analysis was based on
the syzbot report, the crash trace, and code inspection.

For the p_ext == NULL case, a successful ext4_find_extent() only means
that we were able to walk the tree down to a leaf. It does not guarantee
that the leaf still contains a valid extent entry for the target logical
block.

path[depth].p_ext is derived from the extent entries stored in that leaf.
If the leaf metadata is already corrupted, ext4_find_extent() may still
return a non-error path, but p_ext can be NULL because there is no usable
extent entry there anymore.

So in the corruption case, a valid path is not enough to continue the
recovery path safely. Returning -EFSCORRUPTED is safer than
dereferencing p_ext and crashing while trying to repair already-broken
metadata.

Thanks,
Hongao
