Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099700;
	b=NOSWrAEnHLvQ7aVdAsYitah38tDUlOU81rAfj6lhA/jFbgaJUoO1uyooFgLrZm19oRQh
	 2A4WkQtS2go/iT4huv9yWHR7XCZeR7+egwk8/H0qh7g6oZNY0YWGtI9NQ865neAux4a3t
	 g0UBcittttZy4r6q+sUTvacowPtI5O7z91YmGmQYXhUbAb5lFJMI9rGYGHlhug2/eeXvF
	 /yGZYY8/rXifuqGHJKNf6e5Is5bQTZnH/mWsPo64PST0onxV8yVvfd7GW4/IPEtoU+oOx
	 S/6dTuCvdOjZ5qEz6TAXIEzec6UBDBmTgqxuWDe/4fIRlxu5j2PsbF0nYQ8/0jO+Vfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099700;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=h7r1E7scEOZyuEDqeKSZiyFQf8svUCXCQ1Iye9mf1m4=;
	b=oowRpbmm0+pUcIyUOQCnsFaK/ESMFd9wVuV6uJBTWawX9dIzC7KsgHXXeRXJ55p/E3N8
	 iTx+1BnwWRVzDpQlz0GqNIgchy5ds2LnTFTyUOPOkWN+XE6nzsgwclZ+PgvkBuZGqV6jO
	 QJPB5ua4Z7QqHboaC96GfDPEqOtzGFVyL6JDavz+uLz2McOR5bJFoRfHJxgn+J/Z+/THl
	 QFFKNwGmv53VaQmxT5lPZUrzLBxfE192h0/byQ/nWolcdpX0KOLkJEU7SOnC1INR/8A3E
	 vpSOqEWiaFPEq99I6C0OhJZk3iBGxp7tXa0LGkZIYPuWFG7eRsiEXVBJTDrDhtRR0eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=i1eVo3r4;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CDD606E132
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18CDD606E132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=i1eVo3r4
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElas0017906
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099661; bh=h7r1E7scEOZyuEDqeKSZiyFQf8svUCXCQ1Iye9mf1m4=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=i1eVo3r4Xfak0Ogxi/JAK9R1CwdmU8IQja/93C+wUyNTLJnPESWSbGbMwZdj7gKt6
	 mmxHWMTVzb6NR4SbrtDifcjm/oru2leHpp5yOLKAUrUJcRVzRYp3Stu8x/2nv+Sg2a
	 5gM5W7m7oC8AiXaNOiCCkAz5/aTM05+l0dYB77+hdfCDvhqO4UT3j5wlc+1mEvXu8L
	 5NlTgsfCEfao4kUg0OkoXnvoDO340/AG+q4GDXRSkBygZbDLX6T5rHIMx9WqFD7qLn
	 0eRyzl6DWsM2J7J456B3CmUPTgELG0fvHJTCxDS42DFb9q24QmrbfYiPPnOHiSgK6V
	 zmmfP0ffQR+1w==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id DD8362E0153; Thu, 19 Nov 2026 09:47:32 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Daejun Park <daejun7.park@samsung.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Li Chen <me@linux.beauty>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ext4: skip holes when shrinking the extent tree in fast commit replay
Date: Thu, 19 Nov 2026 09:46:44 -0500
Message-ID: <179509948696.1938961.4627256967174030888.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261007-ext4-fc-replay-shrink-v1-1-0e45fc03030d@samsung.com>
References: <20261007-ext4-fc-replay-shrink-v1-1-0e45fc03030d@samsung.com>
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


On Wed, 07 Oct 2026 09:41:31 +0900, Daejun Park wrote:
> ext4_ext_replay_shrink_inode() walks the extents of an inode from block
> 0 up to the given end and tries to merge each one with its neighbours.
> When the walk is in a hole that follows an extent, ext4_find_extent()
> returns that extent, and the walk moves on by a single block. Replay
> calls it up to i_size after every ADD_RANGE and DEL_RANGE tag, so the
> time recovery takes is proportional to the number of tags times the
> number of hole blocks below i_size.
> 
> [...]

Applied, thanks!

[1/1] ext4: skip holes when shrinking the extent tree in fast commit replay
      commit: 3b74728368f72f7ba3c73f964798e203ba1b56eb

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
