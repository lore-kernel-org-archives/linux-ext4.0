Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357753126C5
	for <linux-ext4@vger.kernel.org>; Tue, 10 Feb 2026 11:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770722429; cv=none; b=trOgOWr1NNIbX/i+3s1f2fjmd9pTWAONdUpGdpWXuo2bChWdakZ4MMhHvhHR7a5f8G2asFo8UjBs4kJbNPlihWdytZDNpunn4kvQ1z6660kkxRKDGBVV+lHN6e7AqzkzkgUrUYcqBxFsj0pCBCULC4Ld9027Gr6KZxBTkpaAnRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770722429; c=relaxed/simple;
	bh=j3HyW4LMMymtf2pSBuEavarTKrsLnN+jzqepRee7yn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vo7mSIE87TDyRWj4qpKt13gagTfMGP5+aVh2EgVyfDFyF2wVbE7bgTl+z8lwsv0cObUn/+zoyAamhLUEu2w6QvnuTkkfP/Az1MgCrXViColBzEe8soZkFEt5W9qOiEWh+jDQhdq620OLEEBvCnUDj9pN2/laLX4kZiDfHdlT5HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=u6Li9Y31; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+Lg88gX2; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=u6Li9Y31; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+Lg88gX2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="u6Li9Y31";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+Lg88gX2";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="u6Li9Y31";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+Lg88gX2"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6EC903E6E7;
	Tue, 10 Feb 2026 11:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770722426; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HSCIZgKerfQRy2cVXP7ap6RS8hN3RG2Knw2MJGho6OQ=;
	b=u6Li9Y310mesD6JcTJNvIOxURd4Mx4fuoaE140EJxxeVRaJ3N01+1DkFV7jv1TtD8tL0pT
	uLGWyYRtbM7hlyvL0uRDwDFj1atK0ZSHMryILULk9/ji55PFlHsDtAt6jKObh1v6JusWBQ
	OBjfi7KO8Pc9K9aMt5glyal0h5QN3+Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770722426;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HSCIZgKerfQRy2cVXP7ap6RS8hN3RG2Knw2MJGho6OQ=;
	b=+Lg88gX2FTaMTEQoyJOaioQF1/N3LJbj87wXmKR8UF4I++EDkVGKX8axPVW7utJz1rg+TW
	xcUpBnLbbTg6iIAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770722426; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HSCIZgKerfQRy2cVXP7ap6RS8hN3RG2Knw2MJGho6OQ=;
	b=u6Li9Y310mesD6JcTJNvIOxURd4Mx4fuoaE140EJxxeVRaJ3N01+1DkFV7jv1TtD8tL0pT
	uLGWyYRtbM7hlyvL0uRDwDFj1atK0ZSHMryILULk9/ji55PFlHsDtAt6jKObh1v6JusWBQ
	OBjfi7KO8Pc9K9aMt5glyal0h5QN3+Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770722426;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HSCIZgKerfQRy2cVXP7ap6RS8hN3RG2Knw2MJGho6OQ=;
	b=+Lg88gX2FTaMTEQoyJOaioQF1/N3LJbj87wXmKR8UF4I++EDkVGKX8axPVW7utJz1rg+TW
	xcUpBnLbbTg6iIAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 530D33EA64;
	Tue, 10 Feb 2026 11:20:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wPIzFHoUi2ktLwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Feb 2026 11:20:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 09090A0B47; Tue, 10 Feb 2026 12:20:26 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: fstests@vger.kernel.org
Cc: <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] generic/646: Fix failure without a journal
Date: Tue, 10 Feb 2026 12:20:20 +0100
Message-ID: <20260210112025.28444-3-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260210111707.17132-1-jack@suse.cz>
References: <20260210111707.17132-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 

The test uses fs shutdown. Without journalling the filesystem isn't
guaranteed to be consistent after shutdown so not much we can test
there.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 tests/generic/646 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/generic/646 b/tests/generic/646
index b3b0ab0ace56..1e3f0cd54087 100755
--- a/tests/generic/646
+++ b/tests/generic/646
@@ -19,6 +19,7 @@ _begin_fstest auto quick recoveryloop shutdown
 
 _require_scratch
 _require_scratch_shutdown
+_require_metadata_journaling
 _scratch_mkfs > $seqres.full 2>&1
 
 _scratch_mount
-- 
2.51.0

