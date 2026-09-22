Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8D45372CF
	for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 11:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790075081; cv=none; b=BEk/CTpVZmfWkg5TyF5WBm9TM2IhZwkRLjHSTYtZ/um4+w8zQBhg7Do7Ffm7RW5FwkUu5Kxdyz9SPH0eF+i2inPfAyICkT+I9C8uLvLm1F8FFNLgu+Z8b9+rmK5CwMMoDKn1bexSB7tHBClVnYp+3A6uqfjLUb2jyczPFqN6Aho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790075081; c=relaxed/simple;
	bh=XrntUMqtv+5STCu6GVPtxPr3qDmlNLiO+TSz4JGusxo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qIXoYkW+PvLa7WQeSB1HZtWsBiLxlWYosyNSDvBZaz2lU1kPGezNmIjFS5HP9sADCN/CwdqrFtg3CJE7jK6LQPh0AM4UXFw/e4CLfL7TXl4unZWZUJ8o/NMbtKkcRxd0C9+Er2/IBh1QxoPevzRjYRH/7nZwOBAbbUo+IdGqudY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HXjcsEWb; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HXjcsEWb"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d91ede8035so48312705ad.3
        for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 04:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790075079; x=1790679879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=quCMQpSP3GkxFpVvlOBPI6bWTobHNZTw/8lDPTf3Jzg=;
        b=HXjcsEWbCrjpLjXOIDs5yzgG2RcxxrJNPRBKe0zS0Bzr4Ai9lTJPoQ4ISY6pKswD2F
         bC3UKmM5cOChNK1zyU8ZNVPE1p3sfHB695g76ONGeOPBY84fleSRcdv3n3QCbYISG4ZD
         jtBDMPCnFGCtToH79DjvmIS1Gr4cxUlecwvZoH8ozrtF48MaM9Lj6X1b4CtHmTyx9FSW
         uxYdMMz14h7FuQamKSYvnlbqsJsDWjs7Txr0oa8cL5bA1cr3rQSHXibiO8/YztHswzo1
         nUdVbB9qocJyU9YX/ku65az6M5Nd3jQsEfIGoFxUAGukL9BECF3a1a64E/NZKOBZkNPC
         oS/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790075079; x=1790679879;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=quCMQpSP3GkxFpVvlOBPI6bWTobHNZTw/8lDPTf3Jzg=;
        b=2FON8kWqoBqsV+sXXkhhwuoNNQLrRAST1/EexPTjfPW/gkZzEwA4lKiAmKYfP16FAg
         DsMMbhbCHtUR/99saP0ADQsDzpBkL0H2csHlzte2YriDjzVH2+r4drB8dPLENRZGje4l
         3cFQ/X2VLo9JYA02BGeyPAZfASjntO8intnsGGjR1h+tFA0p0vlUUW4dBiqa/1OqXeQ4
         LzlYIvASFO4UgtqiwrPsXFdtny6soUI8AFoAxR9QUzsewEbFqvTFqvlS4cPEK+j0RqhQ
         p/yE6UCAdQTvg3gJs4ize8MD1NvsJkrTyI5kP9dXNglcv1/OyB2D2Kz/5vNTVVzvg/6e
         BNng==
X-Gm-Message-State: AFuF++mz+HTRw7OxjBQ6My7nSZu6wxPLuT7y21fT8SS1HJzyhiVBnbrE
	4M7zQRZhJLzBpje1/ZAncj8BEVusRhMvXbFl33+s8A+vUuYdm1RstVLSAEa0g+Fz
X-Gm-Gg: AYBFou1OdsAwNWo8jfcPAuJudcbDVb+MegEj/HiUmESv3NE666Ga8fdvCgNexf5TYif
	8cwgdhbYYeMlefBnzQ8U44Q/7Box4FNtidHIDvn+c3HIz4Bron7Kd18Ezbry802EkhYV9KsLI9p
	Zd5oYd2Tg/eyOUJ8F+0fH+dNIs2E6XMq+9XA4mEbDWUcz1WZBDvGNcGGJ8M14dimw/c8WUBnQO7
	WB9j2GH7Nl0hpMIzMWxIKdL2jKnRBuRr6WHUrFbnPrpdpQZW7Y7DvD5NkF5eODxcCegbGTb3n2k
	KfRNR8a3igAUTd+toc1HTO0gz5DIF+PLg57Zh3hqtLv/z42+vcU6zVNwZ4fk1GoRVXIRkShlQL9
	ulw/BDu9C2YtUpR2/SqOgvljcRSnSGx9TTon4mr33pz1p8d2GFLl88ID4AFYjDH2hh7C5NCWRbZ
	hJgahTml8dOrzFCZZRffMX+zj87beYbnzyZ7eIruEM33fbMBFHjC8KHqraB/RbXjKXGu8dVZYU3
	HalpGMT8O7DKfvLHLuZdbIETRRKkB9npt7lKEDnyORWA5OHZuH+/a9ePy/SfcYWD28U2Bxvpjwz
	/njn8JScIQc/oxibhPNFdGD3eBJsv54blGDhMdP0p8HkoaQICCtT0TtIFNGdilM=
X-Received: by 2002:a17:903:90d:b0:2dd:ad74:ac81 with SMTP id d9443c01a7336-2df60b2eb7cmr8919905ad.28.1790075079100;
        Tue, 22 Sep 2026 04:04:39 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df5d019a83sm7999465ad.26.2026.09.22.04.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 04:04:38 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: [PATCH e2fsprogs 0/2] e2fsck: fix a self-deadlock that hangs fsck on corrupt images
Date: Tue, 22 Sep 2026 19:04:33 +0800
Message-ID: <20260922110435.1528332-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

e2fsck can hang forever on a corrupt image.  The hang is a self-deadlock
in libext2fs: flush_cached_blocks() releases CACHE_MTX around the
write_error callback, re-acquires it, and then jumps to a label above
the loop whose first statement acquires it again.  The mutex is not
recursive, so the first flush that reports a write error through a
registered handler blocks the thread that already holds the lock.

Patch 1 removes the redundant acquisition.  Patch 2 adds a regression
test.

This matters beyond the fuzzer that found it: the deadlocked process
sits at 0% CPU and does not respond to SIGTERM, so an init script
waiting on fsck waits forever, and read-only checking (-fn) is enough
to reach it.

Patch 2 departs from the usual f_* shape twice, both times because the
bug is a hang rather than a wrong answer: the e2fsck run is wrapped in
timeout(1), or a failure would stop the suite indefinitely rather than
fail, and the transcript is not compared, because it is a thousand
lines of repeated write errors that say nothing about this bug.  Happy
to drop the test or shape it differently if you would rather not have
either of those in the f_* tests.

Matthias Goergens (2):
  libext2fs: fix self-deadlock in flush_cached_blocks() write-error
    retry
  tests: add f_cache_mtx_deadlock for the flush_cached_blocks() retry
    lock

 lib/ext2fs/unix_io.c                |   2 +-
 tests/f_cache_mtx_deadlock/expect   |   2 ++
 tests/f_cache_mtx_deadlock/image.gz | Bin 0 -> 695 bytes
 tests/f_cache_mtx_deadlock/name     |   1 +
 tests/f_cache_mtx_deadlock/script   |  44 ++++++++++++++++++++++++++++
 5 files changed, 48 insertions(+), 1 deletion(-)
 create mode 100644 tests/f_cache_mtx_deadlock/expect
 create mode 100644 tests/f_cache_mtx_deadlock/image.gz
 create mode 100644 tests/f_cache_mtx_deadlock/name
 create mode 100644 tests/f_cache_mtx_deadlock/script


base-commit: 8fd79523d051d5ea881237f27eb1c664486e0078
-- 
2.55.0

