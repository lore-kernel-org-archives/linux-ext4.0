Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F291DA62E
	for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2026 14:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784902636; cv=none; b=dmw8lU/5u4uhiGaNRu5umQwb/ZkRjqz2HpKoTPQ+/BP2iL+zESQJDqmHMebyqLzqWowR3T2MbV4i2Sm44bLU46zpVcpPiyKbQY1YGF8JGo4vBTnA/giB+8eeZtxfgNp8lxyzj9vrmdXMgqw3jOzQOf3mlh2s2dH12lpIJP22M18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784902636; c=relaxed/simple;
	bh=K0P2A4ke5xWo/sYd8EkZChv4Y+SnzhSlyuYBQw3ccfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4Et8AI3VgC5BVurcjFDLZjGfZHHZep56EHJ7hxPyQDW3wA5fF8f70cZPoXl0NmCa8WZZBNjlJ67CHZzKSP2I3aPX6dw8z+WHres8MltUEcoNvwlzeonbe4A78GivW56C3CqkTZqAfPFSnwotguQxfhB41BFG7B/7DuobKO7S8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aBY5MYTP; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aBY5MYTP"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-930f72317a6so37955585a.3
        for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2026 07:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784902634; x=1785507434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VJ3zA63AAiUBP2Wllc8EOHaRvaq+RtVwiSTRNH9bZts=;
        b=aBY5MYTPrHHx7EeYYjIks0yWv7xld9vlH5io+iy2w6L2V8KGZce9DumqYyjcdyjsIq
         bKuR7EtqVOfpI/Pgg6oeFkVJSqfOWCWqdiiyaA9QjkfPbZfLemAFbrWoKvkd0P4yU7wb
         Qd4hOpTaSaKt5yelBKzfW5Xbfurk3iiM8v6skX7S24nDD1LoZ16Baa6fMfFeR6aXkuIh
         hZ7JzKbpOlYSAY8WfcuO0CHV0UE063bC+mAZi7+t8Vxr7e9DgqnT+Cu4LX72MAwKsMAu
         0YULqAH3DPD/h9AnBkWnOg1muGzzxYwHWBigcjH2Na+w7n8rvEkPK5a97/B9w9nmOqdk
         RfVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784902634; x=1785507434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VJ3zA63AAiUBP2Wllc8EOHaRvaq+RtVwiSTRNH9bZts=;
        b=LYL0GzElzlZc7VAyCw3sMQh4xkTwTECY14tPGL/5Gywf2crhBN2NE2f0DBUPjIR6+c
         AhSaZiJzpIRqCGABYApZSrDsvGUZb3LdlrAqrdsNU7PcEzXqm4sFTnuOqiR7oS76+Gkp
         DmDDNRVtkXQrsIZK4HwLc5OPPD/ZEyQOVd1ZUxcbBKGpu7mXsu3Jm+2REhE1r7UinLl6
         BxACqGSLuZSLx9kOmviqoPv/ZyR3yaVwq39DjwFG0rDW8qMrkxDfIthdLUH7w3XqK+Iq
         x6Pf3dlzIV9uq/J968CRj2hnk2Xuzw6TF3MHFwcNgNScEJd4XtwfBk30swNkbalLzxyU
         nJ2g==
X-Gm-Message-State: AOJu0Yxc6RX0xAGDfV52ClJrfQrORCKzyvGFLuH+xHijgfBBXovtOTM9
	SbHE64YB+STjkLxNzaXH8QqVWXjVOun7GwkrqKV/WCZ5YXBMegUwh0Ru
X-Gm-Gg: AR+sD12wgRMyEyiq/bgqX6PMFKgt0wbihpBVnx3w8/tNiOxb9uEd6jQwtXpjYYXQw1F
	Z1MGHrPrdXElNkiYphzn3Cz7DLVNweGbk6s/FKlfu4/5F6y42pFkBNDW2wVmUqKHCFSk3p/8Tqm
	zCB91ygD5sXVAcLe0N9libwBe/5hYazLFMBSBZBPsBkrNjt1ngwS0ao4DJyUeY9sW2HkWSC+P9p
	/e/vAerweAtedWcEv6kG8aPJi4clMckm4de30WIKH24C/EJEEkdtWp5ZS8VVwBlidFk2kha8kyz
	Z1yCckqqq/oI6zK36jcbBnxGFrQgDlsbefnIoCB6rMSLVr0mQQWU2HWjzaEo7tMiehkO1y3B1PK
	lnPyK7bRaRvqIQE0KZQs6ER2xUhhwhQXeKo+OP/IA+rKiWuaBxEt3XphwKHrLWrxmMEEJ2ulC3H
	DtwnS9+Go4o5dYoCxwz91tBph2n1njq+g+32Oo/B3lOkUebl1G6qVqGxkQI0WxzflVDA2vRUNrx
	Q==
X-Received: by 2002:a05:620a:44cf:b0:930:f941:ca74 with SMTP id af79cd13be357-931036eab67mr758335485a.43.1784902633520;
        Fri, 24 Jul 2026 07:17:13 -0700 (PDT)
Received: from Ai-Server.tail94eb8c.ts.net (131-193-45-111.cs.uic.edu. [131.193.45.111])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f68a7fffsm664165685a.11.2026.07.24.07.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 07:17:11 -0700 (PDT)
From: Luyao Bai <bailuyao1997@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Christian Brauner <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: do not WARN when starting a journal on a frozen filesystem
Date: Fri, 24 Jul 2026 14:16:59 +0000
Message-ID: <20260724141659.669079-1-bailuyao1997@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <amNnKl4V7DPrBHX_@mit.edu>
References: <amNnKl4V7DPrBHX_@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Jul 24, 2026, Theodore Ts'o wrote:
> And it's not just fsync().  Any caller of ext4_journal_start() will
> end falling into this codepath, which means most ext4 operations
> happening during a freeze could very well fail with an EROFS error.

Thank you both for the review. The Sashiko findings are correct, and I 
now believe this patch is wrong; please consider it withdrawn.

When I reviewed the change, I took the neighbouring checks as
precedent: the sb_rdonly() check just above and the aborted-journal
check below both fail with -EROFS, so I assumed the frozen case should
be handled the same way. What I missed is that those two are permanent
conditions, for which failing is correct, while a freeze is transient:
callers that legitimately reach this point while frozen should block
until thaw, not get an error. The existing WARN_ON() is diagnostic
only and lets the transaction proceed, so replacing it with a hard
-EROFS changes the behavior of every journal start during a freeze.

The race you point out is also real: the check is lockless, so a task
can pass it during SB_FREEZE_FS, block on the journal barrier held by
ext4_freeze(), and then start its transaction right after the freeze
completes. And the underlying report (dirty pages surviving the freeze
when writeback errors are swallowed during sync) looks like it needs
to be handled in the VFS/writeback path, not here.

> Luyao, I'm curious what (if any) testing you performed before
> submitting this patch?

I ran the syzbot C reproducer under QEMU on a clean mainline build to
confirm the WARNING fires, and again with the patch applied to confirm
it no longer does, plus a build of fs/ext4/ and checkpatch. I did not
exercise fsync-during-freeze or the freeze/thaw transition (e.g. the
fstests freeze tests), which is why the problems above escaped me.

> And I'm curious if some AI / LLM was used in
> the preparation of this patch?

Yes. The patch was prepared with the assistance of LLM-based tooling I
am experimenting with for kernel bug fixing; I reviewed the change,
built it and ran the reproducer myself, and I take full responsibility
for it under the DCO. I should have included an Assisted-by: tag per
Documentation/process/coding-assistants.rst, and I apologize for
omitting it. Future submissions from me will carry the tag.

Thanks again for the careful review, and sorry for the noise.

Luyao
