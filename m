Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795180046;
	b=T98fDWGem1y/JBBIJqm4TRPTddMDoV8uX3BwxgS6oTjqODoH9O9JFnGVUtXFnE4dvDQ5
	 EX3VUPgiHsBmwxnMTwYYcnAGxxtyspXChLm6tbiIIHGkY5TDAT0t/6tJBusdBK0T+yML/
	 jUpf2354yG//Qo8sRGpdf6foBIxmCaoVS8qCbDlgfc25sjqerT6zQRG4JFWTS1W3s1Fum
	 h+VMTd2imZAgZdglkHFrortc9/xzNFxkOTxpMGSA49KaP7nCRGPuYcE2uSMA3AHv82riZ
	 d9ojmhT7CqLSmvyjHiyNOYV2Bgfn+8FYic7WsGs1swSIm3CG3sjKyOKYoHIrHoGHV1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795180046;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=w2gYpdKwXWil9aD9NeOOchzZTzt6b+o0HGb2JlcVPVM=;
	b=g4aJC0MsygDVd2PE3E6J4pL63pTdnsQj4HhcRHGMO9mw43N7K2W9HFOY7MgUwVS9aw2n
	 c5APLPvB7mETD7DCOWPQVKfJ9Kii346GFupt/F0qJ/a4HkJWDcsO+1/01tOjRqBaqfC4p
	 ODIh8aeQ8n52gQj3mQOkn7eCTcZ0pT/4BrLEHt7itB+lfU9ssxFDvaky++Z2SXe/kM5Dx
	 HzmIrkL7U+cgYZEMUX10I+0+lxOLIbfKQ5v0gPQwf7J0OCDq3wEJ1BBz89NaXl4tSq4Xy
	 +MQd2ciGfQksWHpns/9x5RbjNoJ06p979yBIFi+Qgg7CKD9RBmddJGs/Kb43ZW4kbhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="NfCGkZ/x";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ovw4dRCx;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="NfCGkZ/x";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ovw4dRCx;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B50606A325;
	Fri, 20 Nov 2026 13:07:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6B50606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=NfCGkZ/x;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ovw4dRCx;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=NfCGkZ/x;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ovw4dRCx
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6EE60225DB;
	Fri, 20 Nov 2026 13:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795180043; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w2gYpdKwXWil9aD9NeOOchzZTzt6b+o0HGb2JlcVPVM=;
	b=NfCGkZ/xd+22J7Bq4dvbNs0RDpEjA69jFLPH6cL50sHdqUNN22M8aD0O5PL/yY35gJMMbb
	xQFlMQyFEnp/m8danx8dvGN522+a+yUNWPNiPHjQsZlYhKfjuUSaOxXgGgJ3lXDl4oEIzV
	E4m/mjQBQNNtpA4eywEK+aIvdGWf/1Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795180043;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w2gYpdKwXWil9aD9NeOOchzZTzt6b+o0HGb2JlcVPVM=;
	b=ovw4dRCxoVEpLJ9tbb1eR/Da8/6oAUMT2DYDDmuBpk6uZVBl8YolC5xB8NmSSjbV74322y
	d1PahcFB0ZuX0NDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="NfCGkZ/x";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ovw4dRCx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795180043; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w2gYpdKwXWil9aD9NeOOchzZTzt6b+o0HGb2JlcVPVM=;
	b=NfCGkZ/xd+22J7Bq4dvbNs0RDpEjA69jFLPH6cL50sHdqUNN22M8aD0O5PL/yY35gJMMbb
	xQFlMQyFEnp/m8danx8dvGN522+a+yUNWPNiPHjQsZlYhKfjuUSaOxXgGgJ3lXDl4oEIzV
	E4m/mjQBQNNtpA4eywEK+aIvdGWf/1Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795180043;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w2gYpdKwXWil9aD9NeOOchzZTzt6b+o0HGb2JlcVPVM=;
	b=ovw4dRCxoVEpLJ9tbb1eR/Da8/6oAUMT2DYDDmuBpk6uZVBl8YolC5xB8NmSSjbV74322y
	d1PahcFB0ZuX0NDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 44CEF1342D;
	Fri, 20 Nov 2026 13:07:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id y1QaCAtGAGt1WAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Nov 2026 13:07:23 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id C3D7525F65; Fri, 20 Nov 2026 14:07:18 +0100 (CET)
Date: Fri, 20 Nov 2026 14:07:18 +0100
From: Jan Kara <jack@suse.cz>
To: syzbot <syzbot+1d23ad199a3bfd6f9149@syzkaller.appspotmail.com>
Cc: jack@suse.cz, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	sandeen@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [ext4?] BUG: unable to handle kernel NULL pointer
 dereference in strrchr
Message-ID: <zl5zw6dozpvswogdaj6vmlc5qnk4hn6ekz3gysijmidihdw66s@sfsqyiwf7hv2>
References: <6b0041e7.9fc8cf76.202198.0005.GAE@google.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rizs2fl6skraupwk"
Content-Disposition: inline
In-Reply-To: <6b0041e7.9fc8cf76.202198.0005.GAE@google.com>
X-Rspamd-Queue-Id: 6EE60225DB
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-10.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=3299dd89908ef903];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain,text/x-patch];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+,2:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[appspotmail.com:email,googlesource.com:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,syzkaller.appspot.com:url,suse.com:email];
	HAS_ATTACHMENT(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[1d23ad199a3bfd6f9149];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Spam-Score: -10.51


--rizs2fl6skraupwk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 20-11-26 04:49:43, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    65e4fd942f72 Merge tag 'selinux-pr-20261119' of git://git...
> git tree:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
> console output: https://syzkaller.appspot.com/x/log.txt?x=1102b185580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3299dd89908ef903
> dashboard link: https://syzkaller.appspot.com/bug?extid=1d23ad199a3bfd6f9149
> compiler:       arm-linux-gnueabi-gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> userspace arch: arm
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=165e3abd580000
> 
> The issue was bisected by AI to:
> 
> commit 98f18c76c2c3089183c35d2c33e468ad6c03d86b
> Author: Eric Sandeen <sandeen@redhat.com>
> Date:   Sun Feb 23 19:57:41 2025 +0000
> 
>     ext2: create ext2_msg_fc for use during parsing
> 
> AI reasoning:   https://syzkaller.appspot.com/ai_job?id=f0a661eb-7c3b-44be-becd-54ce0bd776b2
> 
> AI-generated root cause summary:
> In fs/ext2/super.c, ext2_msg_fc() formats log messages for filesystem context
> operations. When fc->purpose != FS_CONTEXT_FOR_RECONFIGURE, it unconditionally
> executes strrchr(fc->source, '/') without verifying that fc->source is non-NULL.
> During filesystem configuration via the new mount API (e.g., fsopen() followed
> by fsconfig()), fc->source starts as NULL and options can be parsed in any
> order. Specifying an option that triggers ext2_msg_fc() (such as "dax", "nobh",
> or "reservation") prior to supplying the "source" parameter passes a NULL
> pointer to strrchr(), causing a kernel NULL pointer dereference.

Yeah, correct. I'm putting attached patch to my tree.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--rizs2fl6skraupwk
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-ext2-Fix-NULL-ptr-dereference-in-ext2_msg_fc.patch"

From bd31e164b532d064560868011167baa218fcb2f3 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 20 Nov 2026 14:03:58 +0100
Subject: [PATCH] ext2: Fix NULL ptr dereference in ext2_msg_fc()

When mount parameters emitting messages are configured before
fc->source, we crash in ext2_msg_fc() when trying to create a fs
identifier for the filesystem from fc->source. Just use unknown in that
case.

Fixes: 98f18c76c2c3 ("ext2: create ext2_msg_fc for use during parsing")
Reported-by: syzbot+1d23ad199a3bfd6f9149@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 54a6c26d0388..63a3a212a0ec 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -89,13 +89,15 @@ static void ext2_msg_fc(struct fs_context *fc, const char *prefix,
 
 	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
 		s_id = fc->root->d_sb->s_id;
-	} else {
+	} else if (fc->source) {
 		/* get last path component of source */
 		s_id = strrchr(fc->source, '/');
 		if (s_id)
 			s_id++;
 		else
 			s_id = fc->source;
+	} else {
+		s_id = "unknown";
 	}
 	va_start(args, fmt);
 
-- 
2.53.0


--rizs2fl6skraupwk--
