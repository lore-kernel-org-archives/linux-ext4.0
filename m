Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5F539C01E
	for <linux-ext4@vger.kernel.org>; Tue,  7 Apr 2026 10:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775557774; cv=none; b=YIbJmsJMywr8P2mu7wST2KJM2GfSbUppMjWCvG3tNH1VIT0Mqh/FpRoAyzTRONfvdcuqK8ZD30Ca03YDMsd9ClxLqwKWLxIVgZH7gEgnL3u13GqpVm6RdnSxQsh0rZzngEh556+2CP4lIbx7SLbcchoW1PMJO4oRXPYtQ+yhi04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775557774; c=relaxed/simple;
	bh=7D9hKiql2l9Xe7SCXvJve+5YiX8ZVh86qv8U6I9Rack=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RnysdO6uSrthM5PahHzl4OA9luCJI1ZJT9oxVABZBG2vkV3YLKrfo8AaKBWFMOiIw9///Jb26pGbCP5W0SWUHPdmnJoxAREekMPPWuBAmJicyveCLA+x/xE9bQuPc5+Yo3IdsldyUbyMfIQQqX/MMUeTT/2GhT65ex6w3sVuyOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AkkBmK9N; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RFuJl61n; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AkkBmK9N; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RFuJl61n; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AkkBmK9N";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RFuJl61n";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AkkBmK9N";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RFuJl61n"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ACC935BD3D;
	Tue,  7 Apr 2026 10:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775557771; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g1+Ci/akFMdO0jko6/Y2u7OnVMbV6gzyEmJjEE1R3HI=;
	b=AkkBmK9NqQjLzi63Z2mnAn3JGiqmFA/So2LUvszGIIwCCjVObil0nyNq6V+N6YK0H5ZjE5
	GHXhC8f0Uew7Sru98+0tOMBkMQfjo/8+tVdmrxw5LReLK/EoK0tNA53cdtdZ9sqbKERJ0k
	O7suWjGBlYsbWPh3TYdd+stzp02xjrw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775557771;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g1+Ci/akFMdO0jko6/Y2u7OnVMbV6gzyEmJjEE1R3HI=;
	b=RFuJl61nGltbpAVDqNXLOXXHeS5l0zcCGMyczsZV+jUiKnlHMAgviy9Z3RajqIp9iXXKIN
	E7D7kmChM/sZe4Bw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775557771; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g1+Ci/akFMdO0jko6/Y2u7OnVMbV6gzyEmJjEE1R3HI=;
	b=AkkBmK9NqQjLzi63Z2mnAn3JGiqmFA/So2LUvszGIIwCCjVObil0nyNq6V+N6YK0H5ZjE5
	GHXhC8f0Uew7Sru98+0tOMBkMQfjo/8+tVdmrxw5LReLK/EoK0tNA53cdtdZ9sqbKERJ0k
	O7suWjGBlYsbWPh3TYdd+stzp02xjrw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775557771;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g1+Ci/akFMdO0jko6/Y2u7OnVMbV6gzyEmJjEE1R3HI=;
	b=RFuJl61nGltbpAVDqNXLOXXHeS5l0zcCGMyczsZV+jUiKnlHMAgviy9Z3RajqIp9iXXKIN
	E7D7kmChM/sZe4Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A308F4A0B1;
	Tue,  7 Apr 2026 10:29:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kIXFJ4vc1GlMGgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 07 Apr 2026 10:29:31 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 55898A0A81; Tue,  7 Apr 2026 12:29:23 +0200 (CEST)
Date: Tue, 7 Apr 2026 12:29:23 +0200
From: Jan Kara <jack@suse.cz>
To: Ye Bin <yebin@huaweicloud.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	jack@suse.cz, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/3] show orphan file inode detail info
Message-ID: <n4sccudy5avcgnkdhc27rzofzoprxqtwhfrlmsh3yyrj6vbc6d@mmu73gmtawkq>
References: <20260403082507.1882703-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403082507.1882703-1-yebin@huaweicloud.com>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

Hi!

On Fri 03-04-26 16:25:04, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> In actual production environments, the issue of inconsistency between
> df and du is frequently encountered. In many cases, the cause of the
> problem can be identified through the use of lsof. However, when
> overlayfs is combined with project quota configuration, the issue becomes
> more complex and troublesome to diagnose. First, to determine the project
> ID, one needs to obtain orphaned nodes using `fsck.ext4 -fn /dev/xx`, and
> then retrieve file information through `debugfs`. However, the file names
> cannot always be obtained, and it is often unclear which files they are.
> To identify which files these are, one would need to use crash for online
> debugging or use kprobe to gather information incrementally. However, some
> customers in production environments do not agree to upload any tools, and
> online debugging might impact the business. There are also scenarios where
> files are opened in kernel mode, which do not generate file descriptors(fds),
> making it impossible to identify which files were deleted but still have
> references through lsof. This patchset adds a procfs interface to query
> information about orphaned nodes, which can assist in the analysis and
> localization of such issues.

I agree listing orphan inodes for a superblock is useful and the usefulness
could actually go beyond ext4. I imagine the very same problem is there for
XFS or btrfs so perhaps we could think for a while whether we can provide
an interface that wouldn't be ext4 specific? Perhaps an ioctl
(GET_ORPHAN_FILES) that would return an fd and reading from that fd would
return entries for orphan inodes?

Also regarding information reported about orphan inodes - won't it be better
interface to just return a list of file handles? Userspace can then do
whatever it needs with them - open, statx, calling ioctl, etc - so we
thwart feature creep with people asking us to add more information to the
interface. This also offloads a lot of security questions about the
interface to appropriate syscalls. So overall it looks like a win to me.

								Honza

> 
> Ye Bin (3):
>   ext4: register 'orphan_list' procfs
>   ext4: show inode orphan list detail information
>   ext4: show orphan file inode detail info
> 
>  fs/ext4/ext4.h   |   1 +
>  fs/ext4/orphan.c | 227 +++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/sysfs.c  |   2 +
>  3 files changed, 230 insertions(+)
> 
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
