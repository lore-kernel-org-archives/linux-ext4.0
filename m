Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55353F660E
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 11:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774526286; cv=none; b=qtPJ5aML4qbLcIu3P/pMKKGID/41Yzo2oDjSnJKuDjkWuzNJlakBs1FElPzkIIFlLcyVwfFebaI5a1kw4sJ8cIIacjkf0djHh3Cfdz5VwFZk6NRbanDvbny3CBDrGWD/WVrqutEn74j+OJaikldTBEvezlX0i6qv8wfgRwPXkZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774526286; c=relaxed/simple;
	bh=H5X0+gb6SrwYcxBQTHkSSTMNthAGD/c2CN9g+KqTKPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p+phgHJcc9FhX9qBLKneD3GRY+dWOTss35L4mkzhLwsPxTQcihbGK06AnsAz5L24oVTrt25+kkQwZ15HBLDmnCox/uf/L4JTEi0FdddVfsgB+1Yz42zTQrpRbObPu1BWjyO6BldnFes7Itnax+mBqmTVFWgS50q9yhagZrJzfRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=dvUWfiyc; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="dvUWfiyc"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62QBvvAL020397
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Mar 2026 07:57:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774526278; bh=cQHiyP9fTDWUrEico+MSCgsJp4ykyL6ANz6/ooxMrDg=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=dvUWfiycgdxB4mXmJl7IfJ6P6KMx57jyBO7AMSNlgK6AiRInxmuKjyya9RHNNgqMk
	 uyyDpSBNEIhCHVc4aBM6z8FkGrMHBGTw9DbNl6ySfypoazVI5kCSNos/STrzXLBZ48
	 FLlrOevs3MYwTjCFLv692lbluivXRy0TJ234yOpJotqcTNxSUn9WoS7swuxc8lg+GW
	 v+6UlCSl2P1g5JPOeKPO3Hi72ZYgGmnIkUcPeHsIAuDzhaBP3TaXICcrjKCzeYtr68
	 7cZAvughF2pH/0dPgaOmejE3ypNy2GoVRXxOBmDqZ76udDA1JDy1FR9tGeXe/wDbT0
	 Tc0vpE+EXmUXA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id E5F232E00D6; Thu, 26 Mar 2026 07:57:56 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Free Ekanayaka <free.ekanayaka@gmail.com>
Subject: Re: [PATCH 0/2] ext4: nojournal mode fixes
Date: Thu, 26 Mar 2026 07:57:43 -0400
Message-ID: <177452625027.1205486.15690177737370190788.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211140209.30337-1-jack@suse.cz>
References: <20260211140209.30337-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 16 Feb 2026 17:48:42 +0100, Jan Kara wrote:
> here are two ext4 fixes for nojournal mode. The first fix is fixing handling of
> uninitialized inodes in recently_deleted() used in nojournal mode which was
> leading to occasional fstests failures for me (which became much more likely
> after the second patch due to timing changes). The second patch fixes a bug in
> ext4_fsync() which was not properly writing out inode metadata in nojournal
> mode. It is kind of a band aid but proper solution is going to be rather
> intrusive and practically unbackportable so I think having it is worth it.
> 
> [...]

Applied, thanks!

[1/2] ext4: Make recently_deleted() properly work with lazy itable initialization
      commit: cec4673c65d709a0c0354c0a0bbbba5cb7508a9c
[2/2] ext4: Fix fsync(2) for nojournal mode
      commit: 3a0fb9e501707760341b5f4562e0f8409bed126a

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
