Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793796243;
	b=dBGUb6NK7Jzg4SXV4IYmKd3uJu0QG3z4ay15XX5ulyPblddUZfbQ1NR7Zkq+yUOgb3O5
	 FmhHbYDTz/KByOBJj0yXM9/Pdq9DEyqrDmuso2ScZwVPUmF1YIoVk6IfIauuCFsaipGTb
	 kqArzI3a/fik/+y+Y+QhNpjrnWTsrrEwDSBEFxItJO1WXDWx0grbNyIXQglhmyj6Y33E6
	 qjPkWMu4cKumfsds+xAwM2KszrmxJOQSrcom3QoEmHDiGSY3mzVS3/YRzgrX+gZlVHie7
	 cr7gGANuNNVkxbWS4XPGy6KanX4TXRpqLGZGGBl367Hqwaxx14BaedoNvj7hWFukd8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793796243;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=WwaC4b0cLVSF727gUMsJoTLQTIaBl/Xdkq7vP7dh0BA=;
	b=AUO6fQLUmm/Q2f/qfk3oBVgHzntVpG6jiImWZVtKitA2IewJtAVUyJUE/Nl7w39SOPzA
	 cVo6qulyM54ADVx6IwBu6++14LKuzHiCNurPpTXdkdxuTtY3egAX1m4UFU/+cTBexADIP
	 RnEDGWE/mpPvXbmxN9yVtOZAgbmG+2oRjlfjBqMoVbOCIMGxxuSc3ry1RB7DMgCoZXu5k
	 vJGKX26jtorVV1iFcQhLxHLzT0pt0mrYnNvBIPrnBS2Ym4U54vmH0IWbwzNVX1QtvSw5p
	 a66jG1EezgYVU/f8qvTGq1YH9D9y/j3yHdFRo1qa11uhfubxtHNwQry9jgR85L2uQZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Mhyf3BE6;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IRmQPJhP;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="bpOP/wvs";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Qsc0Kgxm;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FB6606A32C;
	Wed,  4 Nov 2026 12:44:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77FB6606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Mhyf3BE6;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IRmQPJhP;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=bpOP/wvs;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Qsc0Kgxm
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6E9BC21FA1;
	Wed,  4 Nov 2026 12:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793796240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WwaC4b0cLVSF727gUMsJoTLQTIaBl/Xdkq7vP7dh0BA=;
	b=Mhyf3BE6NJeb/qk+/NhyS/IRZbTImpwO0Dthehtdt+sqCCqe/AZXy942JUPapgyQLxAgBt
	wZruvANz5WKkby3Cuxa4nys9QAxt09gRWFpJ3XVWjFcEmbfbF+zpTkS85As7Jg0mZTvZtS
	MMpbWdAq2AKfBEzazeNLQwSqCsYhFnI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793796240;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WwaC4b0cLVSF727gUMsJoTLQTIaBl/Xdkq7vP7dh0BA=;
	b=IRmQPJhP/RnsnYsQyZrOKUJQM9c3jFVhocXzoUHrSelbWp/hb4B1S9cmI5X8TTXNRBZwaS
	KlIqoatvOIt0XJBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793796239; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WwaC4b0cLVSF727gUMsJoTLQTIaBl/Xdkq7vP7dh0BA=;
	b=bpOP/wvsBq+FbQBilNbHf5zRLhlDuFkRo45IeelOELKNg5xneBtXczvRaI+mLQGxcnb0c4
	MaLVm2Flc1ArH+0hBPyZjpk5/svInAoCk8lIK+hOYRCNwOjyJrq7SnKddkl7/LhWLRF427
	ppRGOP6hJqOdv9eTLhWBNEubQQdw0jE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793796239;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WwaC4b0cLVSF727gUMsJoTLQTIaBl/Xdkq7vP7dh0BA=;
	b=Qsc0Kgxm/wArigy8p0g/R2sQdvI7aJvHA6am9jUhI3UhIPfMgjEMAl8b2SeuzkesXphFWE
	yl7+LOFUNCsZlzAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4535E134F0;
	Wed,  4 Nov 2026 12:43:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 67JlCI8o62oafwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 04 Nov 2026 12:43:59 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id CA1C4B3B7; Wed, 04 Nov 2026 13:43:54 +0100 (CET)
Date: Wed, 4 Nov 2026 13:43:54 +0100
From: Jan Kara <jack@suse.cz>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: jack@suse.com, ritesh.list@gmail.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext2: preserve IOMAP_F_DIRTY for extending direct writes
Message-ID: <jnqgrofg5eh4rvmpqr3wrhyimlux2cwtguj2o5d3tjzdaqq6nc@xsxxjpzmpomu>
References: <20261029013616.97194-1-dennylin0707@gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="hhurp2xrs3achqmx"
Content-Disposition: inline
In-Reply-To: <20261029013616.97194-1-dennylin0707@gmail.com>
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain,text/x-patch];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+,2:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,gmail.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,msgid.link:url,imap1.dmz-prg2.suse.org:helo,suse.cz:email];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	HAS_ATTACHMENT(0.00)[]
X-Spam-Score: -12.80
X-Spam-Level: 
X-Spam-Flag: NO


--hhurp2xrs3achqmx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 29-10-26 01:36:16, Hungyu Lin wrote:
> ext2_iomap_begin() sets IOMAP_F_DIRTY for writes that may extend i_size,
> but clears the flag after ext2_get_blocks(). When the write uses an
> existing mapped block, iomap can then use FUA and skip
> generic_write_sync(), even though ext2_dio_write_end_io() updates the
> inode size. An O_DSYNC write can therefore return without persisting
> the new size.
> 
> For example, on a FUA-capable device, a 512-byte O_DIRECT|O_DSYNC write
> at offset 512 into a fsynced one-byte file returns successfully and
> extends the in-memory size to 1024, while an immediate read of the
> on-disk inode still shows size 1. An explicit fsync persists the new
> size.
> 
> Initialize iomap->flags before setting IOMAP_F_DIRTY so that the flag
> survives and the required metadata synchronization takes place.
> 
> Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Thanks for the fix. I've just move the setting of the IOMAP_F_DIRTY bit
instead of moving the initialization. Functionally this is equivalent and
the iomap modification is better localized that way (the resulting patch is
attached).

								Honza

> ---
>  fs/ext2/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 12ac4cfe1500..ba23cadb157b 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -805,6 +805,7 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  	    (first_block << blkbits) < i_size_read(inode))
>  		create = 0;
>  
> +	iomap->flags = 0;
>  	/*
>  	 * Writes that span EOF might trigger an IO size update on completion,
>  	 * so consider them to be dirty for the purposes of O_DSYNC even if
> @@ -818,7 +819,6 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  	if (ret < 0)
>  		return ret;
>  
> -	iomap->flags = 0;
>  	iomap->offset = (u64)first_block << blkbits;
>  	iomap->bdev = inode->i_sb->s_bdev;
>  
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--hhurp2xrs3achqmx
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-ext2-preserve-IOMAP_F_DIRTY-for-extending-direct-wri.patch"

From 6fda7e6fba044590ce5d7bae6eebd437df1f5b92 Mon Sep 17 00:00:00 2001
From: Hungyu Lin <dennylin0707@gmail.com>
Date: Thu, 29 Oct 2026 01:36:16 +0000
Subject: [PATCH] ext2: preserve IOMAP_F_DIRTY for extending direct writes

ext2_iomap_begin() sets IOMAP_F_DIRTY for writes that may extend i_size,
but clears the flag after ext2_get_blocks(). When the write uses an
existing mapped block, iomap can then use FUA and skip
generic_write_sync(), even though ext2_dio_write_end_io() updates the
inode size. An O_DSYNC write can therefore return without persisting
the new size.

For example, on a FUA-capable device, a 512-byte O_DIRECT|O_DSYNC write
at offset 512 into a fsynced one-byte file returns successfully and
extends the in-memory size to 1024, while an immediate read of the
on-disk inode still shows size 1. An explicit fsync persists the new
size.

Move setting of IOMAP_F_DIRTY after the initialization.

Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Link: https://patch.msgid.link/20261029013616.97194-1-dennylin0707@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 12ac4cfe1500..51250717c70b 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -805,6 +805,12 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	    (first_block << blkbits) < i_size_read(inode))
 		create = 0;
 
+	ret = ext2_get_blocks(inode, first_block, max_blocks,
+			&bno, &new, &boundary, create);
+	if (ret < 0)
+		return ret;
+
+	iomap->flags = 0;
 	/*
 	 * Writes that span EOF might trigger an IO size update on completion,
 	 * so consider them to be dirty for the purposes of O_DSYNC even if
@@ -812,13 +818,6 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	 */
 	if ((flags & IOMAP_WRITE) && offset + length > i_size_read(inode))
 		iomap->flags |= IOMAP_F_DIRTY;
-
-	ret = ext2_get_blocks(inode, first_block, max_blocks,
-			&bno, &new, &boundary, create);
-	if (ret < 0)
-		return ret;
-
-	iomap->flags = 0;
 	iomap->offset = (u64)first_block << blkbits;
 	iomap->bdev = inode->i_sb->s_bdev;
 
-- 
2.53.0


--hhurp2xrs3achqmx--
