Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B701C3BE179
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 08:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791536358; cv=none; b=dWzphqUu0bT5R4UDcXhqIi+NieQewhRC0VXJuSSA9geZjDS1IRhi0tySjzHNLQf8gz5uPtzxcDaFJrkbOkfSgoo6mn7HBV60dwYCqCONKJ3LtXswDxknkmdEPOCZVjKopcRD9SmE80lbmvx5h8E7ABw7IUJ7LH0NXuDgrNn7oqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791536358; c=relaxed/simple;
	bh=lilY2NdmQTc83pB/pB8SusrV8tz0hLRc5Y6xtrwfMrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X0NW+uoltrWYVM7b6n+sGri4HBaJmkD4297t0tXqwst5zDn4lDoCUVt4AZt2JzH7+6HzFnpCeJvdPI0DVI6QMC9six3DhmlGy7xmqhBBqQCRQS/jS3znJIytMWxaxHX2+uJHYgbKcqj29UscRDpqHSNug1Zdzcw/XGIRC5Oa0LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=JFj+cFZh; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="JFj+cFZh"
Received: from trampoline.thunk.org (pool-173-48-119-87.bstnma.fios.verizon.net [173.48.119.87])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6998uVdl014138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 9 Oct 2026 04:56:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1791536195; bh=TpKOvn5/5VXw5a8z7rh02lioc8t5md6jsdqLhZeypgI=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=JFj+cFZhNvXTyNCSQHm4EDUl5/+rfgxZndYLiI0UrxGoVw8NFeHsfZUxTTzfMSlTn
	 Yewf/Vl8uIFHVlXl4YjzzRkhMZNv0ZoYCB1lcUyU0dUqdzug1+Na/Da8TQUVdSbJ34
	 NTrCwItdkxdv1B7pTd7t3xF18u3PvJukQntHW2EEIfrHVokzeof+K0pYQPa7ayzEPU
	 uYTgyGzvwG1oA/uqj/S2iPS6aK+SVTu8KB4d+9OjBAuQwaHqS//cIQZaGSboSdHNrf
	 hlfqyPXChSkaxqjdqq9IIGGKktBSu6zcbpNX5YK5cxmEkBs8mnnaZdgH3CrJA3hu/p
	 ljWbSOOTzrLgg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 545402E013B; Fri, 09 Oct 2026 04:56:31 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        guzebing <guzebing1612@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, yi.zhang@huawei.com, bretznic@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] ext4: reject delalloc to nodelalloc before applying remount options
Date: Fri,  9 Oct 2026 04:56:19 -0400
Message-ID: <179153611738.860602.11716864305544067473.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260814034855.1573759-1-guzebing1612@gmail.com>
References: <20260814034855.1573759-1-guzebing1612@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Fri, 14 Aug 2026 11:48:55 +0800, guzebing wrote:
> Commit 97f5ec3b166d ("ext4: prevent delalloc to nodelalloc on
> remount") rejects switching a mounted filesystem from delalloc to
> nodelalloc.  However, it performs the check after ext4_apply_options()
> has already cleared EXT4_MOUNT_DELALLOC in the live superblock.  The
> failure path eventually restores the bit, but leaves a window where
> other CPUs can observe nodelalloc.
> 
> [...]

Applied, thanks!

[1/1] ext4: reject delalloc to nodelalloc before applying remount options
      commit: 26a3ff309c91986dbedb05d0e0f0050ea0aa629c

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
