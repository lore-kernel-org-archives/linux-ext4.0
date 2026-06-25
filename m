Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A03A315793
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416113; cv=none; b=Qbo+8AMzMD5R/YOVPQsRuT3viBlKvvIHJmEBSZM2PTRPUlojzb5AUhgZIQ6jFz/SEWauGSwh7XbRNhFL6HehmnqvyCy7Mnv6PndLgjrz0KdJW3BWRh43lpW2Hzk8f8R5rYP4wWcMGfWaEoLgVB1nCr3P1/sPRaSHHBABy1rnOlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416113; c=relaxed/simple;
	bh=Xoq4a1WV30tzAIc3wtqPdKH4JNoKiOYZ8bvT/lD8bc0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RIX0e1bK6ZRX0jppJAZXJzAqOykrPWBAMT2mji2plSB0CXws/ZeickGAGdWerZwLdh4PCSwZVGLT5MdvZv1NHGm9ThSDfHtCP/wg567m95VponF/mXXLdyJbKlWHmEd08m0qH6hbbT62aZpGY4CthWcUzXjN0FnBmfR53kUA/P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kynsNVxT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kynsNVxT"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EE38D1F000E9;
	Thu, 25 Jun 2026 19:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416112;
	bh=A5vgUJ+nW32bYuFu29nLL70SXr+SD3v/iBKG0RTIUyA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=kynsNVxTL5SeRr16ZThwb1+lZep61uTQ4TY1zq8pdE7MA0r6ni/eiucvVkVKeBxw7
	 hIZql9FSF1wV+FuvQEZA90beOdZskAeFy1SffRDiS0vjSWAl5wIxrIZUGm6MYHuW8a
	 7ZKpOwYU2xWcp/7IrJPz+SphRcc8NjVIn0cwW+7i+iqXqDoFIe84q++YD/ZdYKhL5j
	 HSBbODq1lRgOMRdItJitdryqVAyhcogYQjRfd/iskUK2e/GUInpEW+Y0Y04k1Orr9U
	 Obr3G40xjxHGrVloTSOime1H9IuQC+20K9zwWjBUirWp7SfCc9+4d6mmsSMz6PuIba
	 oZCxOQ7fcXsMg==
Date: Thu, 25 Jun 2026 12:35:11 -0700
Subject: [PATCHSET 1/4] libext2fs: fix some missed fsync calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <178241606573.1810243.8333361812351601871.stgit@frogsfrogsfrogs>
In-Reply-To: <20260625193302.GC6054@frogsfrogsfrogs>
References: <20260625193302.GC6054@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Fix a few places (like device closing) where we really ought to tell the
block device to flush whatever's dirty to disk, even if we've failed to
flush all our cached buffers out to disk.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

e2fsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/e2fsprogs.git/log/?h=libext2fs-flushing-fixes
---
Commits in this patchset:
 * libext2fs: always fsync the device when flushing the cache
 * libext2fs: always fsync the device when closing the unix IO manager
 * libext2fs: only fsync the unix fd if we wrote to the device
---
 lib/ext2fs/unix_io.c |   83 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 69 insertions(+), 14 deletions(-)

