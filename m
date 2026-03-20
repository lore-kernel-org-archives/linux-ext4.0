Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1BE40DFB6;
	Fri, 20 Mar 2026 00:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773965334; cv=none; b=eD897GymiJY9GLEDz1reN/EGmsqoFYcLE0X9Zr54VaSpcM/d79b6IHApvwSZhZ2i2yQnl1xCtEoAgRYbtDANoiZIaEgITbk5UMTvnAPEESMRYM7WpJTMIcVtLZs+mbAydCMvRNnxNNXCtoV7cmsOYgB5zP56M7gS6PFincH/A4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773965334; c=relaxed/simple;
	bh=cI23oACrE3PC4QlPacXJHV7xiyASOofmgMHiwGwNN4w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NoLBRvtwpQ95ENhlMtJQ9mGPpv7HvboIlH2TFkpOrdazTu+cr7W76g29mLKXNKm1S0TpKK5RTZDZdw8QxrD2AGbGWNg6K/r9pCSalz8iqbsJYkdAS8GAdqrnNKWB+gSfWUKqW533PRS8Se7Ji4f4q4+TCvbF1GZMlHz3Re82jYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=SZwsB9Gf; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=o+OIaXuE; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="SZwsB9Gf";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="o+OIaXuE"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 1D33C1D001CE;
	Thu, 19 Mar 2026 20:08:52 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 19 Mar 2026 20:08:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to; s=fm1; t=1773965331; x=1774051731; bh=QCXruPa3di
	eMrUupTBIqnyN1CQd6edaGU2kYQq4ghp4=; b=SZwsB9GfKGegVRUd2uSkRA53p0
	8wVUfgdNlGhbmIpQyvmC8ZRrQAgDtWbKHR7GSBZ+pFmup4KWF0u+9sZtQ1GEMJb4
	jsyiZ2MoYtVgzV/Z2NsJtoYh3E+etFJBsGtudrRwaqoUkMMaLDNMOHNHWCIh1sS/
	sfol3mmZi+u4dS1P0XJAcm3557ndBKtOqghzz+rlJzvj37Na7j3ifKcxpLXOJIcn
	9jHBR769bTQlkI+0Yl4IuAG3llevsydzofQ+qv1aNZ/Y60MpcMfVxlFTgyxH1nb8
	S4FT0zkcH9k+Zd4oj6f6FR8n3WcfmcgLIlFbE0Kea8PUCvTGlBbwPt4E/9QA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1773965331; x=1774051731; bh=QCXruPa3dieMrUupTBIqnyN1CQd6
	edaGU2kYQq4ghp4=; b=o+OIaXuEbDZnMkQOyywJUtqO3X+yE3RG0pMXGK+qVeuP
	azNUkDcUh6Nd+qKBSSuh8WDPXQX+YAnA0gozIDaXfObU10rGWSvp9Qe+fbyAQ5lc
	S70qpb5HdlwcbBSiEpt3Uyw/IS5umfdcZmtssLj20OUyTCnBuKCcIz+FoBEgtgyV
	x1CO9ZXAD2fY1NW1K0B1jvA/ntQty7YpYYUmZMpU0rZrV0B4EGNQgfF/SbqnFb7K
	5dziKIxbIbu0uEw5TVN8u4ReNbdxv7RPfOd21euPqslOfZ9ZnwGlwQaBWOPYJwam
	pk8yXPTH+rC3TBHTchkCA1Lgd7P4uKz+Q0MG1MTZeA==
X-ME-Sender: <xms:E5C8acJhkTw300L97UG3R_KNP-TYsxI51Fiql0CpPYBaI28dEo_r8A>
    <xme:E5C8aVdbgKYcqnTIMMArzaIkdGnZei-qhI4fRaB6vYczsjIMH0HIfucxfkZfsPjfK
    jPXIYG_ygms0GQ0OpgxjTIlKsV2y1hS4QW_QIM45GK_ijMQRQ>
X-ME-Received: <xmr:E5C8aT_dYEPJRxZ_GuZUKvh7FKUWHsO1m7oELtR7EgFNA6WbPZ19jG3U_4JMlefvLoA1a8l7ZOc7GrEa8SqYmedsPS87U_uoynoBQA2APd7C>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdekgeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnefgmh
    hpthihuchsuhgsjhgvtghtucdluddtmdenucfjughrpefhvfevufffkfforhgggfestdek
    redtredttdenucfhrhhomheppfgvihhluehrohifnhcuoehnvghilhgssehofihnmhgrih
    hlrdhnvghtqeenucggtffrrghtthgvrhhnpeektdelueeludfhfffhudfgkeetffejledu
    uedvhffhheekheffteeuvdekvdeffeenucffohhmrghinhepshgrshhhihhkohdruggvvh
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehnvghi
    lhgssehofihnmhgrihhlrdhnvghtpdhnsggprhgtphhtthhopeeipdhmohguvgepshhmth
    hpohhuthdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqvgigthegsehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepjhgrtghksehsuhhsvgdrtgiipdhrtghpthhtohepthih
    thhsohesmhhithdrvgguuhdprhgtphhtthhopehhrghrshhhrggushhhihhrfigrughkrg
    hrsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprgguihhlghgvrhdrkhgvrhhnvghlsegu
    ihhlghgvrhdrtggr
X-ME-Proxy: <xmx:E5C8aarsSN4xdm80PmKh5pFB2Ku35Y1NTUuaa_qiAgpNF4cyWfcZOQ>
    <xmx:E5C8aQD3bdCn4MNzIygnxHIytRkIsBOyMJDV32wyBG-onCcUaQIjHA>
    <xmx:E5C8aUwvij3ZIgqNsY5cy4Cj8e2dIMm-7iJcM42samc2oThVP7IthA>
    <xmx:E5C8aV1HqMdOFx1sdyfeiPBmPdptk5EJ8p0lwjca699Ea-39AWK9zg>
    <xmx:E5C8acgkeFEy3uHxookM8lassEZuSsXpmAbggCz9OKMf9v1P2oT7rx3B>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Mar 2026 20:08:49 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc: linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: 
Date: Fri, 20 Mar 2026 11:03:15 +1100
Message-ID: <20260320000838.3797494-1-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This new version
 - includes some reviewed-bys
 - adds an explanation to second patch of why ext4_fc_eligible() was
   placed where it was in one case
 - modifies the last patch (but keeps the Reviews - hope that is OK)
   to keep the changes to ->i_nlink in __ext4_link
    https://sashiko.dev/#/patchset/20260317224638.3809014-1-neilb%40ownmail.net
   points out that removing it for the replay path might not be correct,
   and I cannot now see any reason to move those changes (ext4_inc_count() 
   and drop_nlink())

From previous email:

My particular interest in changing ext4 is to remove the use of
d_alloc().  I will want to deprecate d_alloc() as it doesn't fit the new
model well.

The use of d_alloc() in ext4 is incidental to the actual task at hand.
The code really wants to pass around a parent directory and a name, and
only uses the dentry because that seems convenient.  As these patches
show the code actually becomes simpler when we avoid the dentry.

NeilBrown

 [PATCH v2 1/3] ext4: split __ext4_add_entry() out of ext4_add_entry()
 [PATCH v2 2/3] ext4: add ext4_fc_eligible()
 [PATCH v2 3/3] ext4: move dcache manipulation out of __ext4_link()
