Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6782D42A86
	for <linux-ext4@vger.kernel.org>; Thu, 28 Mar 2024 17:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711646987; cv=none; b=cj3YWrwz8v6Cp97hCp8wPKTbRyr7MdlJA3sfG6wAmBcq7AYWFtW8rn0xqgIvdAPB+S+bcn3z7PuYQe2IrmaoobcjRltasAbXFPPBeo4pVtY7A7HQRqMQz7hbSrxxXnuIGBsBaAlJpphv6EoN7YHps4GsnH1Hdjhb3ufuAAXFMkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711646987; c=relaxed/simple;
	bh=bJeyLyTUanKc6gmWlaDBgJMEoRLjWZQ10a7FSTj9o3E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AMJXo1V+ubHAzxFFzWoUE6XvBX/acqGGdMc0q+MKqtXkYAsEZC8yL0EFswSkGMnNjWLxiwZf+IXCK+oblW6jmxnxbLXEp5WAxB7ldOqIHRiMhdEAlPstGR69AzEJl4HfU/AbC8AHrbFzsxvUi3XQK6oyG7RSoEcp3Wsvu6EWLaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T0x3smgN; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T0x3smgN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711646983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fCEM6vBjsKoj5ztRKEN5xpFexqa95kalZoYFnFSgWO4=;
	b=T0x3smgNMwDwwDNmPhqlDSd2coKgbf7rsZf+EWIIKqmQdEjFWMrENBt0dQ0WjfC1fLYNb+
	ADvGHoH6K9VrLBD5IgeK5bGJfcFkzHARomXnS068RhLZeJs9BtP51wDb/rSrrG+YD/2DF4
	0zeACNLBeG+yCBkuOFBtdiRvQyzGU4c=
From: "Luis Henriques (SUSE)" <luis.henriques@linux.dev>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>
Subject: [PATCH e2fsprogs 0/4] quota-related e2fsck fixes and tests
Date: Thu, 28 Mar 2024 17:29:36 +0000
Message-ID: <20240328172940.1609-1-luis.henriques@linux.dev>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi!

I'm sending two fixes to e2fsck that are related with quota handling.  The
fixes are the first two patches, the other two are test cases for these
fixes.

The first patch is actually re-send, which Andreas Dilger had already kindly
reviewed and suggested to add a test for it.  One (important!) thing I
forgot to mention and to include in that initial email was that there _is_
already a test case for it: it's in the fstests suite, ext4/014.  That's how
I found the issue initially.  Thus, my test case for e2fsck is nothing but a
filesystem generated with a simplified version of that test.

As for the second issue, it was also found by an fstest, ext4/019, and the
test I'm sending is also based on it.

Cheers,
-- 
Luis

Luis Henriques (SUSE) (4):
  e2fsck: update quota accounting after directory optimization
  e2fsck: update quota when deallocating a bad inode
  tests: new test to check quota after directory optimization
  tests: new test to check quota after a bad inode deallocation

 e2fsck/pass2.c                          |  33 +++++++++++++------
 e2fsck/rehash.c                         |  27 ++++++++++++----
 tests/f_quota_deallocate_inode/expect.1 |  18 +++++++++++
 tests/f_quota_deallocate_inode/expect.2 |   7 +++++
 tests/f_quota_deallocate_inode/image.gz | Bin 0 -> 11594 bytes
 tests/f_quota_deallocate_inode/name     |   1 +
 tests/f_quota_shrinkdir/expect.1        |  40 ++++++++++++++++++++++++
 tests/f_quota_shrinkdir/expect.2        |   7 +++++
 tests/f_quota_shrinkdir/image.gz        | Bin 0 -> 11453 bytes
 tests/f_quota_shrinkdir/name            |   1 +
 10 files changed, 118 insertions(+), 16 deletions(-)
 create mode 100644 tests/f_quota_deallocate_inode/expect.1
 create mode 100644 tests/f_quota_deallocate_inode/expect.2
 create mode 100644 tests/f_quota_deallocate_inode/image.gz
 create mode 100644 tests/f_quota_deallocate_inode/name
 create mode 100644 tests/f_quota_shrinkdir/expect.1
 create mode 100644 tests/f_quota_shrinkdir/expect.2
 create mode 100644 tests/f_quota_shrinkdir/image.gz
 create mode 100644 tests/f_quota_shrinkdir/name

