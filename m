Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568AC2727FD;
	Wed, 29 Apr 2026 14:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474702; cv=none; b=eyJWGKiijZ0wNLftDvjFFJ8LDfC8RK1XVCLRK4lw8qwH0SfPe1F4CND+Oz3rAKO3WvNccisvGH8tiasz+b+baPn9J88omaXE5rFYY+PD0xxpxUV4pUWiEXLaxxjKobY/FHxvo0gUFflsakKST/xY6llq9WXE9bUpXEsoxajdtGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474702; c=relaxed/simple;
	bh=91UOHMu33y6Ej+8eMUeRnjwWNoeYFdTIxZBoKWV/eJY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fT7p7LgYpRRwGfZzReLreifHODhVoaDLE/2mM/yt1hHtfee/bIlQPlmxD5Y3khpCZjf3C8J6Imp7LhXdOQXAQAdORNO8Ir/PU/MFU1PgFWLdNM031+oM+/YSDXyVb6NucMRS1+7o0M+Dpbk9kATX6IltF0HI/jgWMK/caqb0TJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qXcvmI6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qXcvmI6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330F7C19425;
	Wed, 29 Apr 2026 14:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474702;
	bh=91UOHMu33y6Ej+8eMUeRnjwWNoeYFdTIxZBoKWV/eJY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qXcvmI6uszprsLCyB63heD1R+NQcOdCJpSS6NupAkIRla8MKdCd+cE2HXgyfJcB2g
	 xhfmi8hJ5oh53U5lhupLqjEcJlrdqLxC7CvWRdNjXGjYbfvmV+6MnQY+kTuqJphtXR
	 CV3t7E52PbG8QNbItm8Phu0ThjJbMsqGDbBlbT4EZ+VxIAbo9XhSKgHDzXgIAe5QBN
	 TxIzengsJ89OUxjMapQoGVlsPAoHz8qfK2d/b7oX9zVBv4zBWkWkdDecpaA9Fjrck9
	 u5QHC9F9JjvsEnAd6h1xY0Ae3pQqCbo4G8wdRHCUxY2m8LGzE4s41ldd/F6xPH7NDK
	 YQamFn8rgmMHQ==
Date: Wed, 29 Apr 2026 07:58:21 -0700
Subject: [PATCH 3/3] fuse4fs: ask for loop devices when opening via
 fuservicemount
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215080.4109882.14715706821119071686.stgit@frogsfrogsfrogs>
In-Reply-To: <177747215017.4109882.630706253054166885.stgit@frogsfrogsfrogs>
References: <177747215017.4109882.630706253054166885.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When requesting a file, ask the fuservicemount program to transform an
open regular file into a loop device for us, so that we can use iomap
even when the filesystem is actually an image file.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index e4338722e88e73..7c861fc28e9fa4 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -1491,13 +1491,18 @@ static int fuse4fs_service_get_config(struct fuse4fs *ff)
 {
 	double deadline = init_deadline(FUSE4FS_OPEN_TIMEOUT);
 	const int open_flags = O_EXCL | (ff->directio ? O_DIRECT : 0);
+	unsigned int request_flags = 0;
 	int open_mode = O_RDWR;
 	int fd;
 	int ret;
 
+	if (fuse4fs_can_iomap(ff))
+		request_flags |= FUSE_SERVICE_REQUEST_FILE_TRYLOOP;
+
 	do {
 		ret = fuse_service_request_file(ff->service, ff->device,
-						open_mode | open_flags, 0, 0);
+						open_mode | open_flags, 0,
+						request_flags);
 		if (ret)
 			return ret;
 

