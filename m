Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794347811;
	b=IABEHpw8o+WZzbwgkUe8yVxs6IU1xLRM+WysxeIGxrHlctJb22fjdUQB1o3FS1ZbZgWB
	 fJFZ8hv0LBL64UHpVRnY7/eyh0C17NxDPE83vTd14vOvyRh63YQsE6hYsTb8GjixAt/EH
	 /JmNWMl9iKgot+HsXOjcKOqGkSex8vLHsrXyBgt7vLeR0D2pjaCz5Xc49t83fz5cqcJNM
	 zTM4p3ijNJagi7uyA23zEm1/g/irCMbQ+mbPcmeTGpodBzd45m0+wNEL6ns5y6SkVrWW+
	 h1pgQCFuhB/MCcmHk3j7pSx1P2j4Qvcyq6aRUzmndB1ZiDfEJPRty9HXiI4TfBxLvgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794347811;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=2ZDErYEQzOGJUjtDBXVtItn62hZcw22wk/hmpMTwW8s=;
	b=oEcKGSC4qwIe66vFkMiP6BAY1V46Q7jhY12cFye0q8UXQhnTUKMM8pSAG7p3zS54eeyA
	 DTelOa9CC1bi3zq1ik6GeXK2LJ9TKQFzb+4FD4D7EG7KJvxnC+tF8vGkuevx5Govb16tL
	 BGvF5P4+VBXlvY5qtZF2I5IDZtzdoJH8Fw1ZnPMQrnscMHUKT2KF/JA1QxgvUfu+DeddF
	 5ZcoHZCuV1xaCy88AqrGHOoWYnKmW9L1/RX0Ho81B8ENOKAyGrrWKnjZWORGlkFIX5ASG
	 SO3rcBlSQKJqj0zaCS2SmODe/4MCLlXIXg9AuMT4CWqLCTabz8y+3C5Ksj6waDRD4cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="OT1LM/Xd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AC9606D4EC;
	Tue, 10 Nov 2026 21:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OT1LM/Xd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C96A1F008A2;
	Tue, 10 Nov 2026 21:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794347810;
	bh=2ZDErYEQzOGJUjtDBXVtItn62hZcw22wk/hmpMTwW8s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OT1LM/XddW8RQD5eAmU8fBGOFbAM8/CnJEQs3885Wa0JF4KqnzpeNdym5//nw/qmO
	 iSIXz2DK4b5upf83EDFMcSmu0R158tcCDKFJPJc+nb5CZdciue++Ti2l4+7JB3cJcZ
	 ofKUHpSYZzgbI/fZlqfADzqczaOi6d9z3Y/zO6lUhjFut4nTY/Mo51uO4It6fBxl4w
	 kteuhsecwTnXgVw0wlXvii87uhXMhUgsuU0E2MSi8RSzt1K2+xoj6E83ckzwcRg4rF
	 Ht/S7BOo0R3XlqC9Z0pGpdIAMmq9jRNZQqamTSsu2Lll7rHCO7Qg9kxjiih6PwTNRR
	 88zmVF8rr0Lbw==
Date: Tue, 10 Nov 2026 22:56:45 +0100
From: Christian Brauner <brauner@kernel.org>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, Karl Mehltretter <kmehltretter@gmail.com>, dsterba@suse.cz, 
	tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 06/34] nilfs2: don't set SB_RDONLY after filesystem
 errors
Message-ID: <20261110-deformation-knabe-geltung-3bb7600eaead@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-6-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191225@kernel.org>
 <CAKFNMombDWkJ=m+CjMy7qnd_yy-vZ9c-EE7R95HKKkcy-M0+SQ@mail.gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKFNMombDWkJ=m+CjMy7qnd_yy-vZ9c-EE7R95HKKkcy-M0+SQ@mail.gmail.com>

On Wed, Nov 04, 2026 at 02:32:10AM +0900, Ryusuke Konishi wrote:
> Sashiko's point here has a valid aspect.
>
> This inconsistency can be resolved by inserting the following handling
> logic if sb_emergency_ro(s) is true:
>
>        } else if (!ctx->cno) {
>                 if (nilfs_tree_is_busy(s->s_root)) {
>                         if (sb_emergency_ro(s)) {
>                                 if (!(fc->sb_flags & SB_RDONLY)) {
>                                         err = -EROFS;
>                                         goto failed_super;
>                                 } else {
>                                         s->s_flags |= SB_RDONLY;
>                                 }

Meh, I'd not set SB_RDONLY there. Because it changes the read-only state
outside of reconfigure_super() which is precisely what this series gets
rid of.

The superblock can be frozen at that point, e.g., when the error hit
while it was frozen, and then thaw_super() leaves s_writers locked again:

  mount /dev/sda /mnt
  fsfreeze -f /mnt
  <error>                       -> sb_set_emergency_ro()
  mount -o ro /dev/sda /mnt2    -> SB_RDONLY on the frozen superblock
  fsfreeze -u /mnt              -> s_writers stay locked

It also turns the superblock read-only underneath the existing
read-write mount without sb_prepare_remount_readonly().

The busy-tree branch does what get_tree_bdev() does for every other
block device filesystem. A second read-only mount fails with EBUSY and a
second read-write mount gets the superblock and every write fails with
EROFS. That's what ext4 does since commit d3476f3dad4a ("ext4: don't set
SB_RDONLY after filesystem errors").

If we want the second read-only mount to work I think we should do it
for get_tree_bdev() and nilfs2 alike and treat the emergency state as
read-only in the comparison without touching s_flags:

	if ((bool)(fc->sb_flags & SB_RDONLY) !=
	    (sb_rdonly(s) || sb_emergency_ro(s))) {

But I'd do that on top.
