Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B68D244694;
	Thu, 30 Apr 2026 22:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777589352; cv=none; b=KA0wk2pR51ukaa8TL68jLr3YXuyaY7GToRL0Nf3o7ffjM5rIp9/lRdayZlnYLuyBxKiXKoxv9084MtWDQNrbMjdXk6VPzLXfmDCwq4v5zNlKg6jfpt9yB3WSoHlEyTEKgQZznvrVI9AUX8ocer++UhYfHLW3j2b6UIsFIneueNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777589352; c=relaxed/simple;
	bh=gCatdnP88Ve9njnjtfj6SDwlQPjNZnCbiusngZUoy2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XquQn84vNcbmPpjDXzso+ndqG5fxoBJZD2OIL0E1l1j6xsm4S6e1PQsRUzdmiOjqvG2yppGcOimFg/XF1/VaArKbk+3JtAiZPEFYpcgC7tW2BbCEENy8VfK8odMjnrw15p31B4h19dzpwAUyAUmpxDk5616lkJ6CPQfT/3oIwqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oxmV7ICp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oxmV7ICp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91B5C2BCB3;
	Thu, 30 Apr 2026 22:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777589351;
	bh=gCatdnP88Ve9njnjtfj6SDwlQPjNZnCbiusngZUoy2U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oxmV7ICpUrX2wL8OE9fAJ7eNsE0gQiMChVo85DbHyU1ifMBJdW8C9xSfROqOW3FIJ
	 XEedjDaCg4nAlk4aUwQLDXAslJ5m3YqSZ0NAhROBdsL27aPPVKSH5Z16VOPWVsiQ9c
	 wioU33X1lk9PoKkqU5MhEtjoXK4L+AZJv6NVZN2h4xJ/Xtvjllbr9r/kMHrsNJJ2xS
	 w56FTF2nMUGdC4+aleX0Iw0WD6JvUQRcJ1/QTNVwuxR35lg6/uL4u4Sh9QqYx+wFpn
	 1s9Gdcu9Tm9F5TW5P8f1wG7F17U++CKLAJcBBItewezUgabBn7xP4muTLc0AFhEaWY
	 IzuukwxqwZYcw==
Date: Thu, 30 Apr 2026 15:49:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bernd Schubert <bernd@bsbernd.com>
Cc: fuse-devel@lists.linux.dev, joannelkoong@gmail.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	miklos@szeredi.hu, neal@gompa.dev
Subject: Re: [GIT PULL v5.1] libfuse: run fuse servers as a contained service
Message-ID: <20260430224911.GN7765@frogsfrogsfrogs>
References: <177758364789.1315233.15610945404741826500.stg-ugh@frogsfrogsfrogs>
 <9c920b17-81a8-4c1e-921e-4c08cc290cb5@bsbernd.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c920b17-81a8-4c1e-921e-4c08cc290cb5@bsbernd.com>

On Thu, Apr 30, 2026 at 11:34:06PM +0200, Bernd Schubert wrote:
> Hi Darrick,
> 
> On 4/30/26 23:18, Darrick J. Wong wrote:
> > Hi Bernd,
> > 
> > Please pull this branch with changes for libfuse.
> > 
> > As usual, I did a test-merge with the main upstream branch as of a few
> > minutes ago, and didn't see any conflicts.  Please let me know if you
> > encounter any problems.
> 
> pushed to my github branch. BSD build fails with
> 
> 2026-04-30T21:25:16.3874802Z FAILED: [code=1] lib/libfuse3.so.3.19.0 
> 2026-04-30T21:25:16.3906762Z cc  -o lib/libfuse3.so.3.19.0 lib/libfuse3.so.3.19.0.p/fuse.c.o lib/libfuse3.so.3.19.0.p/fuse_loop.c.o lib/libfuse3.so.3.19.0.p/fuse_loop_mt.c.o lib/libfuse3.so.3.19.0.p/fuse_lowlevel.c.o lib/libfuse3.so.3.19.0.p/fuse_opt.c.o lib/libfuse3.so.3.19.0.p/fuse_signals.c.o lib/libfuse3.so.3.19.0.p/buffer.c.o lib/libfuse3.so.3.19.0.p/cuse_lowlevel.c.o lib/libfuse3.so.3.19.0.p/helper.c.o lib/libfuse3.so.3.19.0.p/modules_subdir.c.o lib/libfuse3.so.3.19.0.p/mount_util.c.o lib/libfuse3.so.3.19.0.p/fuse_log.c.o lib/libfuse3.so.3.19.0.p/compat.c.o lib/libfuse3.so.3.19.0.p/util.c.o lib/libfuse3.so.3.19.0.p/mount_bsd.c.o lib/libfuse3.so.3.19.0.p/fuse_service_stub.c.o lib/libfuse3.so.3.19.0.p/modules_iconv.c.o -Wl,--as-needed -Wl,--no-undefined -shared -fPIC -Wl,-soname,libfuse3.so.4 -Wl,--version-script,/home/runner/work/libfuse/libfuse/lib/fuse_versionscript -pthread -Wl,--start-group -ldl -lrt -Wl,--end-group
> 2026-04-30T21:25:16.3939590Z ld: error: version script assignment of 'FUSE_3.19' to symbol 'fuse_service_can_allow_other' failed: symbol not defined

Aha, that function got left out of the stub. :(

Annoyingly, on Linux the build succeeds despite the missing symbol
when I tweak meson so that it doesn't build the service stuff.  I would
have thought that --no-undefined would have done that, but alas.

Sorry about that too.  The following patch fixes it.

diff --git i/lib/fuse_service_stub.c w/lib/fuse_service_stub.c
index d34df3891a6e31..231b98423df628 100644
--- i/lib/fuse_service_stub.c
+++ w/lib/fuse_service_stub.c
@@ -49,12 +49,17 @@ int fuse_service_send_goodbye(struct fuse_service *sf, int error)
 int fuse_service_accept(struct fuse_service **sfp)
 {
 	*sfp = NULL;
 	return 0;
 }
 
+bool fuse_service_can_allow_other(struct fuse_service *sf)
+{
+	return false;
+}
+
 int fuse_service_append_args(struct fuse_service *sf,
 			     struct fuse_args *existing_args)
 {
 	return -EOPNOTSUPP;
 }
 

> 2026-04-30T21:25:16.3951874Z cc: error: linker command failed with exit code 1 (use -v to see invocation)
> 2026-04-30T21:25:16.4291582Z [44/82] cc -Itest/test_teardown_watchdog.p -Itest -I../test -Iinclude -I../include -Ilib -I../lib -I. -I.. -fdiagnostics-color=always -
> 
> 
> checkpatch, CodeChecker-cppcheck, CodeChecker-gcc also all fail. This CodeQL

Not sure why checkpatch fails, this is what I got (Debian 13):

$ git diff origin/master.. | ./checkpatch.pl --max-line-length=100 --no-tree --ignore MAINTAINERS,SPDX_LICENSE_TAG,COMMIT_MESSAGE,FILE_PATH_CHANGES,EMAIL_SUBJECT,AVOID_EXTERNS,GIT_COMMIT_ID,ENOSYS_SYSCALL,ENOSYS,FROM_SIGN_OFF_MISMATCH,QUOTED_COMMIT_ID,,PREFER_ATTRIBUTE_ALWAYS_UNUSED,PREFER_DEFINED_ATTRIBUTE_MACRO,STRCPY,STRNCPY -
No typos will be found - file '/storage/home/djwong/cdev/work/libfuse/spelling.txt': No such file or directory
No structs that should be const will be found - file '/storage/home/djwong/cdev/work/libfuse/const_structs.checkpatch': No such file or directory
total: 0 errors, 0 warnings, 3908 lines checked

Your patch has no obvious style problems and is ready for submission.

NOTE: Ignored message types: AVOID_EXTERNS COMMIT_MESSAGE EMAIL_SUBJECT ENOSYS ENOSYS_SYSCALL FILE_PATH_CHANGES FROM_SIGN_OFF_MISMATCH GIT_COMMIT_ID MAINTAINERS PREFER_ATTRIBUTE_ALWAYS_UNUSED PREFER_DEFINED_ATTRIBUTE_MACRO QUOTED_COMMIT_ID SPDX_LICENSE_TAG STRCPY STRNCPY

cppcheck had a few things to say, but none of it was about the changed
lines.

> report is funny
> 
> > int mount_service_main(int argc, char *argv[])
> > Warning
> > Poorly documented large function
> > Poorly documented function: fewer than 2% comments for a function of 113 lines.
> > CodeQL

Hrmm.  I guess I'll have to figure out how to get those things running.
That said, the stuff in mount_service.c is internal to libfuse (i.e.
it's not public library API) so I didn't comment them as intensely.
Would you like more?

> I think I'm going to merge my sync fuse init series tomorrow.

Yay!

> Are you ok if skip posting another version of the series?

               ^ is there an "I" here?  e.g. "...if I skip posting..."?

/My/ normal practice (from xfs) was to repost the series as it was
merged, followed by an announcement.  That way the mailing list is a
complete record of what was merged.  However, very very few people
actually do that, even in the kernel.

I'm ok with you not posting another version of the series.

> Or do you prefer to review the recent changes and last piece I'm going
> to do tomorrow?

Nah, just merge it.  I'll look over the changes once it's in the branch
and if there's anything weird, you or I or anyone else can send patches.
As long as you're not planning to tag it as a release, nothing's set in
stone.

> Basically my goal is to rebase your series against it immediately and
> to merge your series during the next few days.

<nod> Let me know what you want changed, I'll be around since I am not
travelling anywhere for a couple of weeks. :)

I can reflow changes into the patchset, or if you'd prefer, I can add
them as new patches that would go on the end of the series.

--D
