Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913D930C60D
	for <linux-ext4@vger.kernel.org>; Tue, 10 Feb 2026 11:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770722440; cv=none; b=lumY97cnx07XJ9/krtlUpiH4OPmp9ITpcFGuZb6+1T9VbS/a1fWa0XD3YJSmcqfBhMzo+OCXYN8OSufHBtPjOftkk8BGgWhmzYBbesXTgLd6+mHPaZR4Es4aZHBojactEPKux3jIskPVYLjvD1epL3Hq6yc6ZwEToUNA63ipf68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770722440; c=relaxed/simple;
	bh=c782gc+6OZfd0uQudYyXxyFOT7+Bzqeb7g79s4I73Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QAugAJ1RctyYjGKAeJjk3LhfgSIXOF/Zh8Kz6NuXVAbLRVfDFJzFOFJLUCY54mWnNaIW38UmlRGD+BVoFnzz6t7ZC88TPlPicJgxw7m4JLpP14nMCWRrA4ZSAYtMdkNgv9iSMowaUruVoRJYDGg2l7yCM01UQAFZcx0VT5TKfrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=R6CupUUv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RNLSGlBq; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=R6CupUUv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RNLSGlBq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="R6CupUUv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RNLSGlBq";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="R6CupUUv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RNLSGlBq"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7646C3E717;
	Tue, 10 Feb 2026 11:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770722426; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0OsfhvcK7esczrvoFnsXRveEs6UesAd6DLxUWWAQqpw=;
	b=R6CupUUvGQOk9DqBYlF3lfw4ANOzKK4EUufZ0yXgcGfOMKdRR3CsZCF0+hZpbC2FC3T12i
	LXzocRUXVmQT1+O1r20XfkX5lH+S8r23Fr8UYy9YoDFTM/dx6+h8ZMnL1qFY5A5kLigtmr
	x3uPcXIGRkP5UfpRkjkMfP3yz4cxpcw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770722426;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0OsfhvcK7esczrvoFnsXRveEs6UesAd6DLxUWWAQqpw=;
	b=RNLSGlBqcG11F5cvPrV4VrJWloLrQ9/MzWUfSCwo78RzshaTZjkToiyF581HTailj+BEG8
	esYVkjUTlCOPPDAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770722426; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0OsfhvcK7esczrvoFnsXRveEs6UesAd6DLxUWWAQqpw=;
	b=R6CupUUvGQOk9DqBYlF3lfw4ANOzKK4EUufZ0yXgcGfOMKdRR3CsZCF0+hZpbC2FC3T12i
	LXzocRUXVmQT1+O1r20XfkX5lH+S8r23Fr8UYy9YoDFTM/dx6+h8ZMnL1qFY5A5kLigtmr
	x3uPcXIGRkP5UfpRkjkMfP3yz4cxpcw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770722426;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0OsfhvcK7esczrvoFnsXRveEs6UesAd6DLxUWWAQqpw=;
	b=RNLSGlBqcG11F5cvPrV4VrJWloLrQ9/MzWUfSCwo78RzshaTZjkToiyF581HTailj+BEG8
	esYVkjUTlCOPPDAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 572153EA65;
	Tue, 10 Feb 2026 11:20:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bbTZFHoUi2kzLwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Feb 2026 11:20:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EFAB4A063A; Tue, 10 Feb 2026 12:20:25 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: fstests@vger.kernel.org
Cc: <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] ext4/051: Fix failure in nojournal mode
Date: Tue, 10 Feb 2026 12:20:18 +0100
Message-ID: <20260210112025.28444-1-jack@suse.cz>
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
X-Spam-Score: -6.80
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid,suse.cz:email]
X-Spam-Level: 
X-Spam-Flag: NO

The test uses fs shutdown. Without journalling the filesystem isn't
guaranteed to be consistent after shutdown so not much we can test
there.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 tests/ext4/051 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/ext4/051 b/tests/ext4/051
index 728ad19bfcec..9fbf0404fec9 100755
--- a/tests/ext4/051
+++ b/tests/ext4/051
@@ -16,6 +16,7 @@ _exclude_fs ext2
 _exclude_fs ext3
 _require_scratch
 _require_scratch_shutdown
+_require_metadata_journaling
 _require_command "$TUNE2FS_PROG" tune2fs
 
 echo "Silence is golden"
-- 
2.51.0

