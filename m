Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13E53E3D8C
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2026 17:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776275965; cv=none; b=UDEbmW5QiIuzkIzKFe6xm18fXSsMLRKStYpd4OdJNu7QuXyDcifOhMFT9jkJXh1nFcSzm/DPFFcCWiC2F2rGge/TYAWUccU5MNv4cIZVcjwhvAHQmrR/w3dZtQMQpKOjnHJ6TSuOsAHrQwND1/6/Mbsyv3Bl+SKbU+7D8ZjgPuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776275965; c=relaxed/simple;
	bh=nPhPTTWiwlwWX8Ov2dqUK0WbDtDa02Mv3zaNymxItzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a9wGxDn+7ARV6rP3iYMHWJTYsp7U+vXiS/SKMlD1230+e81vAeJiEzEulRntn6LZvvIKjGcW2VN3D5Vm9YGzO+BPAA7ma/GOafGjxH3Ir8N4XVaX+k/21+ZkUvx8QCrXR28LgbmnxCbR0HxU6gpLny/aAoiUUnEhCWa5e40ebEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Hh6b6LAQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Lf3VqkTG; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ijVV3bdH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8ROWJqxS; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Hh6b6LAQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Lf3VqkTG";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ijVV3bdH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8ROWJqxS"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EAD405BD45;
	Wed, 15 Apr 2026 17:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776275962; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GRgWkXxWbhqTeZSQjO2XR41qFMF5O21UcprOlIQi2vI=;
	b=Hh6b6LAQAJmODJayP2iDs9KGKaw3NwLk+Mck9J9gZa+PJvYsaoycsDDaTzTL1MP92sHp+C
	1JrrvXS1g0HUdaiApb2ObwW4vdxl+9dDM52h2fmNr3ao9Xp3ji97K9xfGBNezV/oIGp8j+
	u9DUOA4ceFcPmGFn5gGdI1zlXLlpZjw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776275962;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GRgWkXxWbhqTeZSQjO2XR41qFMF5O21UcprOlIQi2vI=;
	b=Lf3VqkTG5XJJvDKREbuCYCP4McNDHrNLmyEJ8db+thkVO10eHdTnmYk+m75BJi7trHaxxD
	8XZ765BWB3Kr14Aw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776275961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GRgWkXxWbhqTeZSQjO2XR41qFMF5O21UcprOlIQi2vI=;
	b=ijVV3bdHQOIP1RUxi/wayEm95hy7JAVbW3/Shyt78N1r9KlvTpz4AWjlM8tBk2GF4WIUVv
	555bmKQN7xEYqoYWegpYnDFbzhnka6LGPaQNXc+Xj2yfEEi5NTHmGz5kWB9xKJiXw4hlKO
	QxS5/Om0Rg3m3KH9VM5cvpf7DT19Nzc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776275961;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GRgWkXxWbhqTeZSQjO2XR41qFMF5O21UcprOlIQi2vI=;
	b=8ROWJqxS7HN7Fju1EL1fwvFm8Oy6AuhMzM/C2mZhjXbuHh1HPKc+BRek/Kre4VhqaNTNAP
	hCogJWI3pn6sbABA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DD0904BB30;
	Wed, 15 Apr 2026 17:59:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Vw+TNPnR32nhbQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 15 Apr 2026 17:59:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 990C9A0B59; Wed, 15 Apr 2026 19:59:17 +0200 (CEST)
Date: Wed, 15 Apr 2026 19:59:17 +0200
From: Jan Kara <jack@suse.cz>
To: Ye Bin <yebin@huaweicloud.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	jack@suse.cz
Subject: Re: [PATCH v2 0/4] show orphan file inode detail info
Message-ID: <lweohtnu6fdvhi2fnbo7obo7vtvehsr4m6u4zwgeqx2abhgx3w@dv5e6zapdwlq>
References: <20260415105505.342358-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415105505.342358-1-yebin@huaweicloud.com>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,huawei.com:email]
X-Spam-Flag: NO

Hello!

On Wed 15-04-26 18:55:01, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> Diffs v2 vs v1:
> (1) Fix sashiko review issues:
> https://sashiko.dev/#/patchset/20260403082507.1882703-1-yebin%40huaweicloud.com
> (2) Change "orphan_list" file mode from 0444 to 0400;
> (3) The display format of the "orphan_list" file is modified according
>     to Andreas' suggestions.
> Fault injection tests have been conducted to address the issues raised
> in the sashik review. There is no UAF issue in the ext4_seq_orphan_release()
> function. The reason for this has already been explained in the code comments.
> In addition to the fault injection tests, we also performed a stress test by
> observing the /proc/fs/ext4/XX/orphan_list and the concurrent processes of
> adding and removing orphan nodes, and no issues were found so far.
> 
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

Ye, did you read my comments to the v1 of the patchset [1]? I didn't see
any reply from you. I don't think this is a good way how to expose orphan
information for a filesystem for reasons I've outlined in that email.

								Honza

[1] https://lore.kernel.org/all/n4sccudy5avcgnkdhc27rzofzoprxqtwhfrlmsh3yyrj6vbc6d@mmu73gmtawkq/

> 
> Ye Bin (4):
>   ext4: register 'orphan_list' procfs
>   ext4: skip cursor node in ext4_orphan_del()
>   ext4: show inode orphan list detail information
>   ext4: show orphan file inode detail info
> 
>  fs/ext4/ext4.h   |   1 +
>  fs/ext4/orphan.c | 326 ++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/ext4/sysfs.c  |   2 +
>  3 files changed, 328 insertions(+), 1 deletion(-)
> 
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
