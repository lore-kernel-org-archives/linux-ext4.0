Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74291484237;
	Thu,  8 Oct 2026 10:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791454099; cv=none; b=JQf9Zs3Hh0u9X4vtYGftEFmGl+/po5xruTwrQy+LIKO9bDPbKEpfFTWAjAkxLkYJY1iyzRRYUKc8uzkloSKZ0m/L71PexR5eo5+8wTcpdhAiV+dKqSshZKMibQ/ly2c9LlhaGJ0yIqm783Rwb95VXX2TzOkSkUsmFHsaU0TG0jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791454099; c=relaxed/simple;
	bh=eZUGXwsI3NzWhnlMgjYNBD5eqnT1TVLMkQpJnpiKROQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eceYe2e/BukpHb8gU0qAiERbC5cktsjBi/AvnzetjxzcvLmV99YPRRDDLsBTz7eU6JgoKh1PgdpzXIadfocnYUwfMAGdsjwU+q5oCpOeaD4XfrSsV8nPVi9ylZToJ+ugWnvBLclswAqkSv9YcG+7EnQUIrKvLHkQhKBSXmQExIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ryRT5VaO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ORWGV06X; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ryRT5VaO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ORWGV06X"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2F55E1F79D;
	Thu,  8 Oct 2026 10:08:16 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791454096; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HrWvcaddFOnuytcC3zGMkWmIvXz+drcjFZscktNZXf0=;
	b=ryRT5VaOQEAPQ53QKSRQkkJbv/JNdjltnCh8Yp28kF38cDs1nizGUJlgDXplIlXt+2XmG4
	3avuDOe/RIerJZYfV8fhb4HCLe71DmdjSliQXstx97X3RUTJgav9jI6eFV0hk6M4MLxlKF
	rP8tIiNNCCga8wEBIxLHP2rwzacTxgI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791454096;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HrWvcaddFOnuytcC3zGMkWmIvXz+drcjFZscktNZXf0=;
	b=ORWGV06XNyJzjvQOCopeaY3mdHmZ6Y0JNLNVdvnM8+U9CMGx7sYJ3AuT8pR4/80qH+mvul
	ZMjcgEPxOJ1/9BCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D74541339F;
	Thu,  8 Oct 2026 10:08:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id j4bjK49rx2oWKwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 08 Oct 2026 10:08:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 64122A13FC; Thu, 08 Oct 2026 12:08:00 +0200 (CEST)
Date: Thu, 8 Oct 2026 12:08:00 +0200
From: Jan Kara <jack@suse.cz>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: Karl Mehltretter <kmehltretter@gmail.com>, linux-ext4@vger.kernel.org, 
	Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>
Subject: Re: [PATCH] ext4: return an error when a journal block is not mapped
Message-ID: <xmgbasz4ie6aiuz37ubci7qwp55j4zefghhrv5yfzx3cnzsyie@f4tqtbyovfae>
References: <20261004180629.27213-1-kmehltretter@gmail.com>
 <23514bc7-e2b1-4796-a107-a5674dede5b0@web.de>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <23514bc7-e2b1-4796-a107-a5674dede5b0@web.de>
X-Spamd-Result: default: False [0.00 / 50.00];
	TAGGED_RCPT(0.00)[]
X-Spam-Score: 0.00
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason

On Thu 08-10-26 10:32:06, Markus Elfring wrote:
> …
> > +++ b/fs/ext4/super.c
> > @@ -5967,7 +5967,7 @@ static int ext4_journal_bmap(journal_t *journal, sector_t *block)
> >  			 "journal bmap failed: block %llu ret %d\n",
> >  			 *block, ret);
> >  		jbd2_journal_abort(journal, ret ? ret : -EFSCORRUPTED);
> > -		return ret;
> > +		return ret ? ret : -EFSCORRUPTED;
> >  	}
> >  	*block = map.m_pblk;
> >  	return 0;
> 
> Would you expect that an optimiser will avoid a duplicate expression here?
> How do you think about to adjust this implementation detail another bit?

I don't think we care about a duplicate expression in this path but yes,
perhaps doing:
	if (!ret)
		ret = -EFSCORRUPTED;
before calling jbd2_journal_abort() would be a tad bit cleaner.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
