Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA693AFB01;
	Tue, 12 May 2026 14:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.171.160.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778595483; cv=none; b=fSpdEDHe3CY4tPM1rcjXK+5edDccAPcRF0txvLcvlfbYsMduO6mlsPydd+M2CReOgHFGbW1qrSxROYbE29B2T4ZlzPSWC05z7u8kfQrySDP4VLmxOxFvGPmHawVahIvEIvlaWuL3x68e0qGIPIEGTlinVsOIlzDoLcl7P+IDD74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778595483; c=relaxed/simple;
	bh=kejAEHqBenFMFafirQkFb6mAhDaYtvEE+s4akeTQlFY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bKIGSmZ0Mimgw7Q2kJUG6W81MFo33WaYSfcgUj+8nEN2GAu7mne/IG/N/nqFupevyBuJ6HWf2xpQ1Xip3ElE1Weevc6BeEMK1KM8027mtJAMfRVCzUgOXKXmJwHrUWvSuVLd1OBFeu6DBeGe9gziHq1/V5OUTygJvOG/1Uyy52A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp; spf=pass smtp.mailfrom=parknet.co.jp; dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b=WkwcHurj; dkim=permerror (0-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b=6BRhwhT6; arc=none smtp.client-ip=210.171.160.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b="WkwcHurj";
	dkim=permerror (0-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b="6BRhwhT6"
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
	by mail.parknet.co.jp (Postfix) with ESMTPSA id D4B4626F765F;
	Tue, 12 May 2026 23:17:55 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114; t=1778595476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3DdxPBC2n7SyGRDmV6K4MMBEWAyKXcmTOyDMBrRpKxc=;
	b=WkwcHurjdF4riviUQdpY/ew20ceVo7OlSd368rh033LBoouGp6CrFQVI2HJJe1GqOwZh3e
	wUIOBqa40ucfbN2tEvYHEsySkgADpa4SjRM/Hx81B/gynMjjFGjiC5L6WoNMN1av+VC+C+
	ZnDCFmx8r6CbTyATFVCJi/bwEbRac0J5JvesdDdfAkyXKK+oiD3NPLG0y3O1uGwPFhWt2D
	+ZjK3KX1rIZyV9LMgt0qLw/QZ0rUs06TBsU3TP4Ogi6gmbECQWn7XDs9EmF/cKMRaVSto5
	7jfUrRHcaJRYw079F5cP1g3b/3iEAAx5iwgdglPXsl44X56BXzMASdYNncc/IA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114-ed25519; t=1778595476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3DdxPBC2n7SyGRDmV6K4MMBEWAyKXcmTOyDMBrRpKxc=;
	b=6BRhwhT65gAe8gYFHoGvQIFdVX5SmojDR+uTuXCEJKHDI6f7qe/AmmyOXAr00Zadi/dmw6
	UT20mRHYCmLXu0Ag==
Received: from devron.myhome.or.jp (devron.myhome.or.jp [192.168.0.3])
	by ibmpc.myhome.or.jp (Postfix) with ESMTPS id 61373E002BE;
	Tue, 12 May 2026 23:17:55 +0900 (JST)
Received: by devron.myhome.or.jp (Postfix, from userid 1000)
	id 5497D22000B9; Tue, 12 May 2026 23:17:55 +0900 (JST)
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org,  Christian Brauner <brauner@kernel.org>,
  aivazian.tigran@gmail.com,  Ted Tso <tytso@mit.edu>,
  linux-ext4@vger.kernel.org
Subject: Re: [PATCH 6/9] fat: Fix possibly missing inode write on fsync(2)
In-Reply-To: <jb536ihpuajtk4dcpxquos5fmmllfs7uiq3ryvnsfl4tesiidj@jwhnlrdiaih3>
References: <20260511115725.28441-1-jack@suse.cz>
	<20260511121356.241821-15-jack@suse.cz>
	<87pl32yq2a.fsf@mail.parknet.co.jp>
	<rnl552jwa6x72ibx3sg2oeitn6sh6jp5tnfu7evycol2fopw7v@ahwlfjnuoiwy>
	<87v7ctddui.fsf@mail.parknet.co.jp>
	<jb536ihpuajtk4dcpxquos5fmmllfs7uiq3ryvnsfl4tesiidj@jwhnlrdiaih3>
Date: Tue, 12 May 2026 23:17:55 +0900
Message-ID: <877bp8yang.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jan Kara <jack@suse.cz> writes:

>> I didn't check the case of rename completely, just recalled it when I
>> saw this code, need confirm/check.  But at least, the case of remove
>> will leave it even after the block is reused.
>
> Right. fat_detach() should set i_metadata_bhs.inode_blk to INVALID_BLK,
> thanks for catching that. I was thinking whether we should set
> i_metadata_bhs.inode_blk in fat_attach() instead of during inode dirtying.
> It would be somewhat more obviously correct but it could lead to
> unnecessary flushing in case the directory block gets dirtied by some other
> entry in it while the inode we are fsyncing got never dirtied. IMHO that's
> a sensible tradeoff so I'd do that but what is your opinion?

IMO, the marker should be cleared like b_assoc_buffers or I_DIRTY_*
flags after each sync. Otherwise, because the block is shared with other
inodes, it would sync/wait the unrelated dirty easily.

[And more serious implementation, looks like it should be cleared at
similar points or such with b_assoc_buffers is cleared to minimize
unrelated sync/wait.]
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
