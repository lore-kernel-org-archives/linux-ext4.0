Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4618834107D;
	Fri,  3 Jul 2026 10:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783073355; cv=none; b=InAdH339aCsmSfcqeogSdY6+Z2pvLPsBCip7ieuYQWvYjCY9j7eGXbCdRL9SJqnKWqnegrEYZSZTR2FRbaKonYRqpGSun3RkH2zMY9HQxD+Pz86hDN4qUkvKg22E23HCxbykN3TowCXErz5sjbhzdKTQVGYVXzFXO9zYI+/kS3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783073355; c=relaxed/simple;
	bh=fqHGFkQ/uMNgUnBpeH+E4QtycunIZVDXtaaz/Bp+0yU=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=FCGYwyEzJwrCezRqaJSlSxZxsVzvjIndHDBXnOd4I7lE7vhOvfbi2K9pSNRWt3Pc6eJLZr5KqC74ORycZXd4mvz/VthwPNmYVtl7Vq+k/vRzfuNHaaWKD3TB99Vudnv3FA3mvZUWvovzuzmsaxZfch+8L28nZ44W5wKeIS7q+ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mcLraPN1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mcLraPN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640CE1F000E9;
	Fri,  3 Jul 2026 10:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783073354;
	bh=DV57qCjUZpfPbDnSrLBCDL2EOZGWZj+b5zIBbWejluA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=mcLraPN10yP6HXPN9P1vmGwujxjj9uXH198p/MIIsjMeisZvsoem1Ww3Jk4F3ouKw
	 Nb2ync7hOsSKSv/EYHgShRPkN9cv53OlHn5uZFEtFs9FTLHpCLrk5pgmmcZdZZjzUU
	 EfaKvwC5Uvpea9ylBiS63tSgimkZL419/vsF3eiYYErKvqb8dot9inHX6RpBva/nZB
	 +udg3luhbG3dpQGHyglnC/eLSWmhn2UUqYvB0gOVqz+/d8QEOtu+V9CWaj81VlR9j+
	 rd58Vfz7BkF49NgMF3vllzHdB4lqZfMcP++gky/TZOeU04Mp4S9LVxl/c81H2sc36m
	 jm/pEXOsBMFgw==
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 0/19] fs: Fix missed inode write during fsync
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
 aivazian.tigran@gmail.com, Ted Tso <tytso@mit.edu>, 
 linux-ext4@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
In-Reply-To: <20260702175436.12226-1-jack@suse.cz>
References: <20260702175436.12226-1-jack@suse.cz>
Date: Fri, 03 Jul 2026 12:09:09 +0200
Message-Id: <20260703-fahrbahn-tierwelt-anrechnen-e055769a5edb@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2284; i=brauner@kernel.org;
 h=from:subject:message-id; bh=fqHGFkQ/uMNgUnBpeH+E4QtycunIZVDXtaaz/Bp+0yU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS5d3mc3rzUrNhr/2f3ZWFLzzLe+P/h9BPOCzHTLW7c7
 JVlTzbW6ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIcTjDfwcnMUmd9Vucv23Z
 +Dkp5ueLyfdWOdTHLtt/JvtdpX5fsDjD//SknSfU1mwTVs0XqOnZPGnv0euqP9+E578X2nRN++J
 EbhYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

> Hello,
> 
> here is v3 of the patch series which fixes the possibly missing inode write
> during fsync(2) for filesystems using generic metadata bh tracking. This is
> a heavily reworked version since v2 mostly based on problems Sashiko found
> which prompted me to redesign the whole approach.
> 
> The series now strives to make sure sync_inode_metadata() ->
> writeback_single_inode() will end up to properly persisting not only the inode
> but also all metadata associated with the inode. This is beneficial for several
> reasons:
> 
> 1) This removes the need for separate mmb_fsync() implementations. Filesystems
> can just use simple_fsync().
> 
> 2) This makes sure all metadata is written for IS_SYNC / IS_DIRSYNC inodes.
> Currently most filesystems just write inode itself.
> 
> 3) This fixes races when multiple fsyncs race for a while where mmb_sync()
> could return before all buffers were really persisted (now I_SYNC state flag
> properly serializes everything).
> 
> To be able to achieve this we add new .sync_inode_metadata superblock operation
> which gets called from __writeback_single_inode() and new I_METADATA_WRITEBACK
> state flag (putting everything into .write_inode is possible but it looked too
> ugly so I've decided for the new operation).
> 
> This scheme with I_METADATA_WRITEBACK state flag also fixes the problem that
> when WB_SYNC_NONE writeback happened between write(2) and fsync(2), fsync(2)
> would fail to properly persist the inode. Note that this problem isn't specific
> to filesystems using the generic metadata bh tracking. This patch set doesn't
> fix such filesystems as it is already big enough but the universality of this
> problem among simple filesystems is another reason why I've chosen the new
> superblock operation instead of trying to somehow hack up metadata bh tracking
> infrastructure.
> 
> Patches passed some basic testing with fstests, more tests are still running
> but I guess the patch set is good enough for people to have a look.
> 
> Changes since v2:
> * redesigned the patch set to use new superblock operation

I think this is a clear win and a lot easier to follow than what we have before.
So I'm all for this.

-- 
Christian Brauner <brauner@kernel.org>
