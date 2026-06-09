Received: from smtp153-165.sina.com.cn (smtp153-165.sina.com.cn [61.135.153.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE1D28980F
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 01:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.135.153.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968325; cv=none; b=bL2yzzaLWjN/l+ZYkthAIeaG4ICcuW6Q/9wJ1mSR+IfEmi8t+3vsF1KA2OagA6bldtvKtreAzBljU3jFd5FMZ2kZwUHr5MdBJcL8IjKhXk/srdv88Z0fYhQRmM2I55H7NxWxgcyr0vTpVHck2fJhv+bNkWNv0wD4TcpsESmfE0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968325; c=relaxed/simple;
	bh=wZYs57/4Gwd1AtNmrbA4OTlKLJtgshAoYIJktLqURKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+BJe/Rhyk0yPpA52SQL66mFwMeL2Ge5d13Lx2/2ceTFouON6B5D3yiEs0IJNHNqf29+PLMKA7/XWXk1pUk6gC6ewPBQHgDtJP2z5KWHFqtvEFrkTy0ThLNDBRE9pqwymkqWTv/cudWfJEznz1ibVDOhrTaOqg9jppBU+8kVBMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=zRJDmhXv; arc=none smtp.client-ip=61.135.153.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="zRJDmhXv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1780968319;
	bh=ukkFDX0syLajMKrCkjr+nKhiOSxKdxUsCHEYd0H9dl8=;
	h=From:Subject:Date:Message-ID;
	b=zRJDmhXv5b23uBLpzIYcWHpI2KnNaHE0x4G4bw0tWAiueOJg6kFC1wkSBhU2YGeFg
	 QmcFDUdOA+uV+PKn6bI1611QJ4L6LClXp2TBOifjTezrVti3MuhNbw+9GHrB/ymwQh
	 sBT5QPXRveVJFapuzEQBxX+3WdmzM0CCE1xEuqbs=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.144])
	by sina.com (10.54.253.32) with ESMTP
	id 6A27693300007951; Tue, 9 Jun 2026 09:15:34 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 7876384456651
X-SMAIL-UIID: 25C3511104FF4E1CB922C55EF6C675A8-20260609-091534-1
From: Hillf Danton <hdanton@sina.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: tytso@mit.edu,
	jack@suse.cz,
	Yun Zhou <yun.zhou@windriver.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: validate donor file superblock early in EXT4_IOC_MOVE_EXT
Date: Tue,  9 Jun 2026 09:15:21 +0800
Message-ID: <20260609011522.1708-1-hdanton@sina.com>
In-Reply-To: <5D214F11-047A-4414-B9BC-8ED669817145@dilger.ca>
References: 
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 8 Jun 2026 12:20:07 -0600 Andreas Dilger wrote:
> On Jun 8, 2026, at 09:25, Yun Zhou <yun.zhou@windriver.com> wrote:
> > 
> > Reject the EXT4_IOC_MOVE_EXT ioctl early if the donor file does not
> > belong to the same superblock as the original file.  Currently, this
> > validation is performed inside ext4_move_extents() by
> > mext_check_validity(), but only after lock_two_nondirectories() has
> > already acquired the inode locks.  When the donor fd refers to a file
> > on a different filesystem (e.g., overlayfs), this late validation
> > creates a circular lock dependency:
> > 
> >  CPU0 (overlayfs write)            CPU1 (ext4 ioctl)
> >  ----                              ----
> >  inode_lock(ovl_inode)
> >                                    mnt_want_write_file(filp)
> >                                      sb_start_write(ext4_sb)   [sb_writers]
> >    backing_file_write_iter()
> >      vfs_iter_write(real_file)
> >        file_start_write(real_file)
> >          sb_start_write(ext4_sb)   [blocked by freeze]
> >                                    lock_two_nondirectories()
> >                                      inode_lock(ovl_inode)     [blocked]
>
Why does it exist if the locking order on CPU0 is incorrect?
