Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405774D8D8D
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812171; cv=none; b=A1XifIbgPbAbxLu3NAbZ83RtpKlNEbN2TFIBDuws7z8DCzEr9rr5KyZkuPgpnYt+ZqZnxjtN2tjddblaEqKJHn3IeG+6P2CEUdKflajztiSeGJAq18tUJDXJTz6kNzLXo2pU2iP6pxBxlkmg2v3xhaNt0uAg6BdWW4q4E7CnVbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812171; c=relaxed/simple;
	bh=+pn5bjdjoy+UWj+kSHEWHhc/KgGZ0pzxMvA/FkBvgBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YRqe0LPROfsPisxvVrnY2WICld/oC6j58HglyItX7SMxJjWBXKIiV9Tqd8weNq90YUkLkGxtKvLEjSnvfDxFadafA6giIVPGj4UCX5gUyZ+DYqML62ynOA0BTq4Idm+I9Heti6wCgSJ9g2c0Ua5UbJNZe9uBKW9I0xajQw9M12A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=bxyS7q0v; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="bxyS7q0v"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND92m2017899
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812145; bh=YtflLmZgtsBgKA8Jno2II5Vvtp+LdXw6u+dElHc/GgQ=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=bxyS7q0v2fHY1iAmwWIuVazTRpd2Sux4R2NVA6bKrFsakZY+LbDdWAR08koEfDzcm
	 L2JQ7a8Rb13Jv1Fe65DBcpsXD/cv7dOcRDSVcgAqTnjutRbCCEjwiakPPIl9FHcZvX
	 Rpj6jTtxh6SDcSRibSn9Xz/V2KYYOIkLaMrd4eZKbOw6EviFn4lhE3czEd/otyGR2Z
	 SzZgja3CsZOq76Zop3N+MS0HoTKozQGxoxX2fVwYf5X9HBeXVjWV12Gg1Dm7Ld8vbJ
	 J6ezGeIO9d7XTwHeHa/cu6TlKPhC3Qs8Ddex0M0LR3ZcAv6tkmKDLNmlJRup1oFnEP
	 T4S/UmuNqn/KA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id BE8B62E3F1B; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>,
        Joshua Crofts <joshua.crofts1@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Baokun Li <libaokun@huawei.com>
Subject: Re: [PATCH v2] ext4: use str_plural() instead of custom macro
Date: Thu, 23 Jul 2026 09:08:43 -0400
Message-ID: <178481171750.796182.15054987791148619877.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260713-remove-plural-macro-v2-1-424e1536ac10@gmail.com>
References: <20260713-remove-plural-macro-v2-1-424e1536ac10@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 13 Jul 2026 07:41:29 +0200, Joshua Crofts wrote:
> Remove the custom PLURAL() macro and use str_plural() from
> string_choices.h instead.

Applied, thanks!

[1/1] ext4: use str_plural() instead of custom macro
      commit: fef5265969773387cbeb79803de4834e4bbd1d4f

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
