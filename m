Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9CD19ABC6
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812164; cv=none; b=Zhs168rJqBjU8/EmdMFe6QL6uf1QTLEgpHgKJHta8iP6VsbfYtnf8CdZO2hO1ebhd4NUEEROgG8vCI1cvD12TgY9ziEvf527UuhcH/Lt0+gw6+6VMAT8h7KuXqe4UtdiDMAk228tpHygQIo+QA4gr/YlOlcJKtlJYf0oq4qb0q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812164; c=relaxed/simple;
	bh=KLmxIKwXsRrbAezIV0RszYYF+yhBD1KGB0Lurz7PxqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pgM9rlw1LqUFOYe2xxVUsKAB5JYFu8yobtmmmqcxuUc7enkq6ecjKOX7owinUWnWwscRBRbNIxDJdLlWknOlFPl3DNGKTbByE5N4AJO7EfVl0oaMQy9TghtRYKcHTbjnDr1+G46Pzj9u/vuTlS24jxdIeWdxQyhvmR5AYp7rD0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=RE4pVsLr; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="RE4pVsLr"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND8xpT017843
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812142; bh=qpxXzhV1Ly+RmD/tg+fRgwgVDW42keKTNNLTljYZgiY=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=RE4pVsLr8N6JElmGV+tcThSgJZzhmNzjtNL1P+SNmAJtngx2TE/La8ddJXlsLTOq7
	 vEi1IuhRkvnTol5j5kgnOZlQlx7zVmiXPrgIQxtixf1yLo8j0Lr77uHNAkWhgprK2F
	 9A8wUw/BdcMYkdvhkutwaV9tma4VxfhbWdbL4anOXzDb0sJTlSqMKpeyebMpjUgFTT
	 YCqWFcEUM0pG7iJ9nNGbqtYDynaPKT1vQfEGYFOzKbY1/Vwwn5KUq4oR1FSEczAS9S
	 5tUseQQaT8apYspaic4TUbZrZJM4gUvEarC2O4PWVsHxuk6J9smDbMq3Gc/ujM01+Z
	 UTIaJ6uzmmTFg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id A699B2E3F10; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Guanghui Yang <3497809730@qq.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ext4: propagate errors from fast commit range replay
Date: Thu, 23 Jul 2026 09:08:36 -0400
Message-ID: <178481171746.796182.106726034351899659.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <tencent_E3622146846A84C75C31C7D32AC4D5AD0605@qq.com>
References: <tencent_E3622146846A84C75C31C7D32AC4D5AD0605@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 08 Jul 2026 08:12:04 +0000, Guanghui Yang wrote:
> ext4_fc_replay() stops replaying fast commit tags only when a tag
> handler returns a negative error. However, ext4_fc_replay_add_range()
> and ext4_fc_replay_del_range() currently return 0 from their common
> exit paths even after internal failures.
> 
> This hides errors from ext4_fc_record_modified_inode(),
> ext4_map_blocks(), ext4_find_extent(), ext4_ext_insert_extent(),
> ext4_ext_replay_update_ex(), and ext4_ext_remove_space(). As a result,
> a failed ADD_RANGE or DEL_RANGE replay can be treated as successful and
> the replay code may continue with subsequent fast commit tags.
> 
> [...]

Applied, thanks!

[1/1] ext4: propagate errors from fast commit range replay
      commit: d8b8dd3530bf41e14b118702cdaf9de64bb96885

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
