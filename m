Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1DF15746F
	for <linux-ext4@vger.kernel.org>; Sun,  6 Sep 2026 00:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788653475; cv=none; b=qQaJG1AfF6xOlmg5lcoA+BRSoFDCy/fhf8Nh1Hto6KA3hP7NiAmVPg41ktzK2PTHq0QRTydaAwjWl3dbAPGXH7V0Lal2PFNvO6J7l/nNpXLGNXjr4jdUzaTvlr8q+RWzbtW7uoWQzYmWVSsFOS6ca3p2NgzHBNMW03NFWZ/I3gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788653475; c=relaxed/simple;
	bh=CoyuDNLwmpFMKF1+Wt8gxo9l5cm9ULe/tNqHGW28qzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u1aHfGKyhl9Dc4MIrREvrDJgtM4gLChPgm0N1IbnrE5QQs6JklRR90VT291SBKnRfmlps86oM/4osedAM8KjTNEdA0sKf5+KKgd2WHOtBPa0dKHk6HZygbYDvn41fP7lJVpZG4qUdG3RvsKS3OqYsByMksNxxnVIdRvW6zKqXgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=ZiJbAV1K; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="ZiJbAV1K"
Received: from macsyma.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6860AxeJ026422
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 5 Sep 2026 20:11:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1788653461; bh=vz5suWPEf5q350+o0Dp97BPwHaSsfhjD7DXfpMO7GSw=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=ZiJbAV1K4jJFKVm2mrehh6doYRLcLvgNIGQqxenZv81U0zV995HDME4iwaupgFVVe
	 oq5k/Zeva+VXMaJKOpAQsbEjyDrnDkbnDHcwxdTCQwfjainNoYBzfyqzlYQg5sYHK8
	 PBsOUaN7DwBKYGGd5pMyxgSuUDjQMikrP8FXOX3wMDNWe8HBiRfEzWPDnnaqE2FvuN
	 BDkOSVdGIeWD+NArjYV81fg3YK1IxhXtFB+91ZMcYCCuf+IaYzSIQqi9+3r+FmgjMw
	 sH5MsSJrzuxCFhvRp21onjbjGVL4DDVf4QwGGNRhHKgDqw2rS2m6Op+xjP3JPc0Aec
	 lTLsdb9oyY7Zg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 1AB031380346; Sat,  5 Sep 2026 20:09:59 -0400 (EDT)
Date: Sat, 5 Sep 2026 20:09:59 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Levi Shafter <levi.shafter@elder-tomes.com>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [BUG] e2fsck: ignores SOURCE_DATE_EPOCH / E2FSPROGS_FAKE_TIME
 for s_lastcheck
Message-ID: <apyvC8WI70m2D7he@mit.edu>
References: <4c130a23-7283-45a9-852a-b24ed78eb0d1@elder-tomes.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c130a23-7283-45a9-852a-b24ed78eb0d1@elder-tomes.com>

On Mon, Aug 10, 2026 at 11:56:11AM -0500, Levi Shafter wrote:
> Sponsor: 21SoftWare LLC
> 
> Version: e2fsprogs 1.47.1 (also 1.47.0)
> 
> Summary
> 
> mke2fs and the ext2fs library honor SOURCE_DATE_EPOCH (and
> E2FSPROGS_FAKE_TIME) for filesystem timestamps, but e2fsck does not. A
> check pass therefore writes the current wall-clock time into the
> superblock's last-check time (s_lastcheck) and last-write time
> (s_wtime), so running e2fsck as part of a reproducible image build
> produces a different filesystem on every run.

Thanks for the report.  This patch should address your concerns.

       	       		     	   	  - Ted

commit fa70a99daf14a98b2b67d85010942de4f6a937b6
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Sep 5 17:50:32 2026 -0400

    e2fsck: support SOURCE_DATE_EPOCH and E2FSPROGS_FAKE_TIME env variables
    
    Some projects use SOURCE_DATE_EPOCH the environment variable per the
    recommendations in [1] to create reproducible artifacts.  If those
    projects use e2fsck to check a generated file system before running
    tune2fs or resize2fs, the current time will get used in some
    superblock fields, thus making it no longer be reproducible.
    
    [1] https://reproducible-builds.org/specs/source-date-epoch
    
    Setting the E2FSCK_TIME environment variable will address this issue,
    but it's confusing that e2fsck requires that both environment
    variables needs to be set.
    
    Fix this by teaching e2fsck to support SOURCE_DATE_EPOCH and
    E2FSPROGS_FAKE_TIME environment variables to work alongside
    E2FSCK_TIME, and setting any one of these three environment variables
    should be sufficient to address all changes made by e2fsck.
    
    Reported-by: Levi Shafter <levi.shafter@elder-tomes.com>
    Link: https://lore.kernel.org/r/4c130a23-7283-45a9-852a-b24ed78eb0d1@elder-tomes.com
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/e2fsck/e2fsck.c b/e2fsck/e2fsck.c
index 1e295e3ef..18dd2569e 100644
--- a/e2fsck/e2fsck.c
+++ b/e2fsck/e2fsck.c
@@ -36,6 +36,10 @@ errcode_t e2fsck_allocate_context(e2fsck_t *ret)
 	context->htree_slack_percentage = 255;
 
 	time_env = getenv("E2FSCK_TIME");
+	if (!time_env)
+		time_env = getenv("SOURCE_DATE_EPOCH");
+	if (!time_env)
+		time_env = getenv("E2FSPROGS_FAKE_TIME");
 	if (time_env)
 		context->now = (time_t) strtoull(time_env, NULL, 0);
 	else {
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 7768f0ed7..4de7bf78d 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1211,6 +1211,7 @@ static errcode_t try_open_fs(e2fsck_t ctx, int flags, io_manager io_ptr,
 
 	if (retval == 0) {
 		(*ret_fs)->priv_data = ctx;
+		(*ret_fs)->now = ctx->now;
 		e2fsck_set_bitmap_type(*ret_fs, EXT2FS_BMAP64_RBTREE,
 				       "default", NULL);
 	}
