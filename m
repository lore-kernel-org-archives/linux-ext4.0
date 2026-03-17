Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F00385521;
	Tue, 17 Mar 2026 22:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773787622; cv=none; b=RWpW50CQ/Rv6pfk8vQlzxTMA8nkT24V5yCxfnxgJKm6o8jc9P2s0L48PxE1sLkUqZK8GnIQvO5lZhxC0zUC0IQsiqbm8MYrZKeQ9jDGqbZchIGZXmCBEB2FVUdrfQguYTajqUNBJPXvUydW3TZq3zjOvPaU4ivM+K0O7F5+3DWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773787622; c=relaxed/simple;
	bh=VORvEoN6wjsVG0iDrJwoEOPPLHRp9+QvVe9zL1/IGNY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JsodJJoTI89E5B6phKBQfnleiKke/yTw6hF81OtG4vUBGbejNjqjORVW9wn46PUEAwJ2xysL4jKU50Zyu8Xpp+DtW39OzvAchxtcYmxNK9po+tyCQ7mGOU1mYqy++57zAIuc4IJFV1wJJgz/zgbw4yEpI0eCB7UinknMt7rpclg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=H13c4ABx; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=y73wI6rH; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="H13c4ABx";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="y73wI6rH"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 8A954EC00AB;
	Tue, 17 Mar 2026 18:46:59 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 17 Mar 2026 18:46:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to; s=fm1; t=1773787619; x=1773874019; bh=3qr32Rfv0n
	toCm/br1efl0+GktTADeY+cc9iL8SI3Kw=; b=H13c4ABxbl/DWH3ibZvZ4MpQk+
	fW4vlLv60HR70kPgxJQNqELyO8vY4gKu7RgQnXxN06v3A1QOKez48HGnQxul/Yi6
	ec+S6BYq+TMjtbSia+GZHLIzo64ZVZ22LOlqH2pW7Z1CVKh/Tpc/BSOXfuLbeEnD
	YGahm0kym+Ty2pqKscYy6XjxkMp7/ABLPlsscqa037uig2J/FVyGCttjVwnjokUP
	xd5j22KURJwmAi88WbE3Or1B+2Bw+m7FsloJoeL+VMtVmY0gEmzTt0/ETY+lPM6v
	v5uPoBKReO0Re2ad3uEMNI/wpk2zB5rRhcWzQp8YVwS8KSge4mTDfbahK5cA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1773787619; x=1773874019; bh=3qr32Rfv0ntoCm/br1efl0+GktTA
	DeY+cc9iL8SI3Kw=; b=y73wI6rHdi/DPxWqOtVVi+P5DaUX453b9ZHHSjZUzvRS
	OQ63upkboUhf6mnE4GIijOao9OEUS8UOomPx9+CEJS7BKIT01glG7E5UblEB13EN
	UqxwkVuYckxleeFlZYeSt2VMlHo7VelucWO1lfoxGR7yE8Hb41d2XqZHTOX8MDyj
	nDmwebZ2WGD3miMbnSdRUUHR346HRbrITV/BC7fdFIL4uH++MYcPn8rXNRuQnMCK
	HgKwhBBMmGiG6HH+HsJIhIQJcCvJnymT+W4MDdNDF2vUiUr6xalvFfrpFRDLGb/f
	DQIQAbX7Rus2/QEEIAYRL6DF9NTnZFYWy/glPYhrRA==
X-ME-Sender: <xms:49m5aULNCWJjrt0F4_hd3Dsoi8UCyVcUCKodX6ctesRMeOs8yjoKMg>
    <xme:49m5aRRugzaDhBNgjkqJbnHCA7wZN3CMJlOcv-wXV-NYFclj14RcO91XbXE2FrMsu
    RE2355semFLAXzjdmLzNEMBDE_kPjhXeyvm74E_EJYNEXyWZPM>
X-ME-Received: <xmr:49m5aTswSCHe2vMfnNV5wLQA3dhGow8x1defOOQxGX_zQjmEaC-cjYu4Q5GD03qK1GIg_uCtws944KLXqTU0ASP1Uaz630dbkPIznvdBe10j>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftddvgeelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkfforhgggfestdekredtre
    dttdenucfhrhhomheppfgvihhluehrohifnhcuoehnvghilhgssehofihnmhgrihhlrdhn
    vghtqeenucggtffrrghtthgvrhhnpeegteefgedttddviefggeeuveefleellefgjeeufe
    eukedtleeiieekvedtleevleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpehnvghilhgssehofihnmhgrihhlrdhnvghtpdhnsggprhgtphhtth
    hopeehpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdhfshguvghv
    vghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqvgigth
    egsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhgrtghksehsuhhsvgdr
    tgiipdhrtghpthhtohepthihthhsohesmhhithdrvgguuhdprhgtphhtthhopegrughilh
    hgvghrrdhkvghrnhgvlhesughilhhgvghrrdgtrg
X-ME-Proxy: <xmx:49m5aSbTrv319AgVSs5qoRiqR-tBO8wsE_H-EvZrpT_sDWixM4WnZg>
    <xmx:49m5aZFMnafheSB4JvJlzJb5oZigUQIsZcENBfw4cZf8NEtfNnd6Lg>
    <xmx:49m5aWw6M00KLQmJNm33EaySw9UHQ0bxTAZwJurTYu46Mufe_Spx4A>
    <xmx:49m5ablXykz12YC8g_EscoeqhnWaTfgHjWvdCXgonj2dAtLoPQJ73Q>
    <xmx:49m5abt5NrdSsWLE8SaTkC2TkKLfkEnOZx46BBPzDIz-FPiqCHFvrSqa>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Mar 2026 18:46:57 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/3] ext4: remove use of d_alloc()
Date: Wed, 18 Mar 2026 09:39:48 +1100
Message-ID: <20260317224638.3809014-1-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a revised version of the ext4 patches from my recent patchset
for revising directory locking.  My particular interest in changing ext4
is to remove the use of d_alloc().  I will want to deprecate d_alloc()
as it doesn't fit the new model well.

The use of d_alloc() in ext4 is incidental to the actual task at hand.
The code really wants to pass around a parent directory and a name, and
only uses the dentry because that seems convenient.  As these patches
show the code actually becomes simpler when we avoid the dentry.

The second patch here isn't needed.  I thought it would be, wrote it,
then found it didn't directly help.  However I think it is still a nice
simplification so I left it.  If you don't want it, please drop it.

Thanks to Jan Kara for his initial review which helpped me see some
problems with my initial attempt more clearly.

NeilBrown

Note: these patches are quite independant of the rest of that big
patchset, except for the late removal of d_alloc().  They can safely
land indepenantly if you would like to take them now in the ext4 tree.

 [PATCH 1/3] ext4: split __ext4_add_entry() out of ext4_add_entry()
 [PATCH 2/3] ext4: add ext4_fc_eligible()
 [PATCH 3/3] ext4: move dcache manipulation out of __ext4_link()
