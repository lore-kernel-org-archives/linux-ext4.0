Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F171D3A5448
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 11:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781003647; cv=none; b=u5aRWUvTJE1uninFvh8t26A+xlDQgv7uTwcRadDtiowpbgFqpVy9moGrFCrYVvpzVsZWq1rP12oGDVxY7Yr5dc9Qy63825DLkAll/EW9mQx/v4J5798WPiMr8peBHEWXqxvAVkzgDo+5jGa0borRKOnYbEWKxTa6FYCdwRtF0HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781003647; c=relaxed/simple;
	bh=hF82TRdJfstJ3AjMlCi56sI9lkq3vXZJsDH9SBVWKqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AD+N6HeuGt+bcuSOwUZLjM08Eeakp/DqsNHmR3Qox3ZT/eBeiu0AGbFRDrPAoUUXOpF08/KOGhkgNLbAK5V1ZBLvMpQe+WOF6YgtP7qaEZM3FeVTirP5xog/mk+rK6GjMLxUOVgqkfuSpmRcUxMtGbxZv5rBldkDKhyhKdOe0po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Kp+vWpqD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4Zn95tX2; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Kp+vWpqD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4Zn95tX2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Kp+vWpqD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4Zn95tX2";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Kp+vWpqD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4Zn95tX2"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1F01E759A1;
	Tue,  9 Jun 2026 11:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781003644; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=njZaSloqxYyqDvRf8CsXF7WQ7VCaRcrQgQMXk2GhK+s=;
	b=Kp+vWpqDssn+A33T4xqw6hB/pvg4LknFwLmjD6eywQCBJrJHL9S+H4x+8/O1qH+Kc2sZF2
	0RBkMBuTDIdBZgX2KIRlgpwg5Q1+khRs+aPxHpgP5FztSV5l7nCbBKPbZq7OLdm/Ec7c+n
	+cXl1711NFNDZO7NlOC4rhw2eJYA5Pk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781003644;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=njZaSloqxYyqDvRf8CsXF7WQ7VCaRcrQgQMXk2GhK+s=;
	b=4Zn95tX28cmU9VgXZ+Tkt17M0ezbfsLti4kkUEe6zJ9btn0n2YQgMScDhOltc5hyQq0pmr
	ntenxIoi6J9di+Cw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781003644; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=njZaSloqxYyqDvRf8CsXF7WQ7VCaRcrQgQMXk2GhK+s=;
	b=Kp+vWpqDssn+A33T4xqw6hB/pvg4LknFwLmjD6eywQCBJrJHL9S+H4x+8/O1qH+Kc2sZF2
	0RBkMBuTDIdBZgX2KIRlgpwg5Q1+khRs+aPxHpgP5FztSV5l7nCbBKPbZq7OLdm/Ec7c+n
	+cXl1711NFNDZO7NlOC4rhw2eJYA5Pk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781003644;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=njZaSloqxYyqDvRf8CsXF7WQ7VCaRcrQgQMXk2GhK+s=;
	b=4Zn95tX28cmU9VgXZ+Tkt17M0ezbfsLti4kkUEe6zJ9btn0n2YQgMScDhOltc5hyQq0pmr
	ntenxIoi6J9di+Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 16A87779A7;
	Tue,  9 Jun 2026 11:14:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id P0GABXz1J2roDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 09 Jun 2026 11:14:04 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A1DDCA0A90; Tue, 09 Jun 2026 13:13:59 +0200 (CEST)
Date: Tue, 9 Jun 2026 13:13:59 +0200
From: Jan Kara <jack@suse.cz>
To: yebin <yebin@huaweicloud.com>
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, adilger.kernel@dilger.ca, 
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2 0/4] show orphan file inode detail info
Message-ID: <a5v57ie6feotxznmhrf3i22gzplw2ucotlnw3y7hmjhkalbb26@bx2lzoil75ks>
References: <20260415105505.342358-1-yebin@huaweicloud.com>
 <lweohtnu6fdvhi2fnbo7obo7vtvehsr4m6u4zwgeqx2abhgx3w@dv5e6zapdwlq>
 <6A26AB14.8050508@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6A26AB14.8050508@huaweicloud.com>
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,sashiko.dev:url,huawei.com:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,sashiko.dev:url,suse.com:email,huawei.com:email]
X-Spam-Level: 

On Mon 08-06-26 19:44:20, yebin wrote:
> On 2026/4/16 1:59, Jan Kara wrote:
> > On Wed 15-04-26 18:55:01, Ye Bin wrote:
> > > From: Ye Bin <yebin10@huawei.com>
> > > 
> > > Diffs v2 vs v1:
> > > (1) Fix sashiko review issues:
> > > https://sashiko.dev/#/patchset/20260403082507.1882703-1-yebin%40huaweicloud.com
> > > (2) Change "orphan_list" file mode from 0444 to 0400;
> > > (3) The display format of the "orphan_list" file is modified according
> > >      to Andreas' suggestions.
> > > Fault injection tests have been conducted to address the issues raised
> > > in the sashik review. There is no UAF issue in the ext4_seq_orphan_release()
> > > function. The reason for this has already been explained in the code comments.
> > > In addition to the fault injection tests, we also performed a stress test by
> > > observing the /proc/fs/ext4/XX/orphan_list and the concurrent processes of
> > > adding and removing orphan nodes, and no issues were found so far.
> > > 
> > > 
> > > In actual production environments, the issue of inconsistency between
> > > df and du is frequently encountered. In many cases, the cause of the
> > > problem can be identified through the use of lsof. However, when
> > > overlayfs is combined with project quota configuration, the issue becomes
> > > more complex and troublesome to diagnose. First, to determine the project
> > > ID, one needs to obtain orphaned nodes using `fsck.ext4 -fn /dev/xx`, and
> > > then retrieve file information through `debugfs`. However, the file names
> > > cannot always be obtained, and it is often unclear which files they are.
> > > To identify which files these are, one would need to use crash for online
> > > debugging or use kprobe to gather information incrementally. However, some
> > > customers in production environments do not agree to upload any tools, and
> > > online debugging might impact the business. There are also scenarios where
> > > files are opened in kernel mode, which do not generate file descriptors(fds),
> > > making it impossible to identify which files were deleted but still have
> > > references through lsof. This patchset adds a procfs interface to query
> > > information about orphaned nodes, which can assist in the analysis and
> > > localization of such issues.
> > 
> > Ye, did you read my comments to the v1 of the patchset [1]? I didn't see
> > any reply from you. I don't think this is a good way how to expose orphan
> > information for a filesystem for reasons I've outlined in that email.
> > 
> 
> Hi Jan
> 
> I thought about how to prevent resource exhaustion caused by making too many
> FDs in a single application. My idea is that IOCTL should only obtain one FD
> at a time, and the next time it should start obtaining orphan nodes from the
> inode after the previous one. Each time an fd is obtained, the previous fd
> should be closed. I expect that after traversing all the fds from the beginning,
> they will all be closed and there will be no need for user space to close them
> manually. I wonder if this approach is feasible? Or do you have any good
> suggestions?

Hum, I think you've misunderstood my suggestion in [1]. What I suggested
is:

1) Provide ioctl GET_ORPHAN_FILES that will return one "virtual" fd that
tracks state of iteration over orphan entries of a superblock

2) Reading from this fd will be returning file *handles* (as struct
file_handle) describing the orphan inodes. There are no kernel resources
struct file_handle occupies in the kernel. It is essentially just a
filesystem agnostic container for inode number and inode generation number.
Userspace can then use open_by_handle() syscall to convert struct
file_handle into normal file descriptor but that is upto userspace and what
it wants orphan information for.

Is the design clearer now?

								Honza

[1] https://lore.kernel.org/all/n4sccudy5avcgnkdhc27rzofzoprxqtwhfrlmsh3yyrj6vbc6d@mmu73gmtawkq/
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
