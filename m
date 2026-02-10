Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB6D30C60D
	for <linux-ext4@vger.kernel.org>; Tue, 10 Feb 2026 11:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770722436; cv=none; b=PtDd7ioJiSGNGyG/SrNY2dcjBC5G8Mz5HLRB7USofJ6kCEwdz6gt1Vz30MNBCb4DcMe7Lz1azv+1IP+S08iO5XTUqjCqv/Xp++GRtiDjAXpVXFOwMk+bXmEa5Ys1qqQhTDTd8pF6Uv/oEgTYD45HjWH1SNwQHp4PJ/4w+atQiEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770722436; c=relaxed/simple;
	bh=2xe2R5Ol+ucUj8qLTHtzQaWKWRvcM+zBx4mXVtaln2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUBm09VtEBMTuPHoHEBJ8RGoR9jsfVGUHSFGts9QM7JfImDDXuOg0yA920D1Qb/hNt735gvOXg6xgqjoVCIb19m4j6phO8saNS1/EekOK1gfu4da/VMs4Hoz32ue8B0gt6fBIju0Yu3+MZHtSFDFLsO7HuGUkUdthUSf1+wEKhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7B7A95BD43;
	Tue, 10 Feb 2026 11:20:26 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B6363EA66;
	Tue, 10 Feb 2026 11:20:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9IdNFnoUi2kyLwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Feb 2026 11:20:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 112FFA0B56; Tue, 10 Feb 2026 12:20:26 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: fstests@vger.kernel.org
Cc: <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] generic/705: Fix failure without a journal
Date: Tue, 10 Feb 2026 12:20:21 +0100
Message-ID: <20260210112025.28444-4-jack@suse.cz>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Score: -4.00
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 7B7A95BD43
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Flag: NO

The test uses fs shutdown. Without journalling the filesystem isn't
guaranteed to be consistent after shutdown so not much we can test
there.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 tests/generic/705 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/generic/705 b/tests/generic/705
index 9c27fbbc389b..23f06d699dfa 100755
--- a/tests/generic/705
+++ b/tests/generic/705
@@ -12,6 +12,7 @@ _begin_fstest auto shutdown
 
 _require_scratch
 _require_scratch_shutdown
+_require_metadata_journaling
 _require_command "$FILEFRAG_PROG" filefrag
 _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount
-- 
2.51.0

