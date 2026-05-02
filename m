Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394C138228E;
	Sat,  2 May 2026 16:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777739428; cv=none; b=OwKkS3WXtvKJaBO8ldHEdKvcC/VLaA6XCys6SVE7vl22KgpYky4zcXNQk575t2Cv3WNj23+uoqKqiskrMGA3CKvipZq8IwIYSehxjPipHTk8e6c5mcYNrtV1QQQfIwPaYT7aCJKFOK/Al8cEcN11xFfEF+PD66eZnYoPs4+4jLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777739428; c=relaxed/simple;
	bh=OaUAH+zG4CFxGz1JMMyi9y3sY5jTRcCTP9nXmckMiZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rflo3ihGTGufYYSuB4pLAshKyM6AmVgL3sQZ6rvWu9iCEhEFXqzJ24yf93NR6vwwzry1UNiByPajErhloZRm3L0pemDneXconETC7U6fBR39WHJTvKec8bJ1vP15wsXqv4qGI++OyciEn92Ct8UDqGnzrl4LaXcMBCqkYMw+RTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b6VxtDDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b6VxtDDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20B5C2BCC4;
	Sat,  2 May 2026 16:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777739427;
	bh=OaUAH+zG4CFxGz1JMMyi9y3sY5jTRcCTP9nXmckMiZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b6VxtDDkCpT4/4vb4OgFpTSe7ttX9/kRMfyvdxgsRlLpfHGwYKfiIgX5w4R3enbJY
	 uBDCDzJtLZV0V5uSiWbWrX5kn7Ybxx/YFoov9UFKW9pe4zQMIFJuzwilg5/VIpfwcG
	 6+GnpTPKVWs+t9kFLRr5uRe1mJ8yZO/2poZDByvSI3gug9RFNws8nhmqfkf5AG9pfx
	 +o+R2QZP3hcj4NaKw0J/RsdmSeRiZSXO8I9F/zdFcHnQqj4pl/8FGHcZw4v/cGegBe
	 U8pYreOU63vdi8q5f/owO3Qz/gyqE1+Xz4HBwwi29diMK5N2OOZMzAKFsPznQ/XYhI
	 CXUqJds1wLLww==
Date: Sat, 2 May 2026 09:30:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bernd Schubert <bernd@bsbernd.com>
Cc: fuse-devel@lists.linux.dev, joannelkoong@gmail.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	miklos@szeredi.hu, neal@gompa.dev
Subject: Re: [GIT PULL v5.1] libfuse: run fuse servers as a contained service
Message-ID: <20260502163027.GO7765@frogsfrogsfrogs>
References: <177758364789.1315233.15610945404741826500.stg-ugh@frogsfrogsfrogs>
 <9c920b17-81a8-4c1e-921e-4c08cc290cb5@bsbernd.com>
 <20260430224911.GN7765@frogsfrogsfrogs>
 <2f2ba053-53a7-43e5-969a-32d185e9c7b7@bsbernd.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f2ba053-53a7-43e5-969a-32d185e9c7b7@bsbernd.com>

On Sat, May 02, 2026 at 05:59:06PM +0200, Bernd Schubert wrote:
> 
> 
> On 5/1/26 00:49, Darrick J. Wong wrote:
> > On Thu, Apr 30, 2026 at 11:34:06PM +0200, Bernd Schubert wrote:
> >> Hi Darrick,
> >>
> >> On 4/30/26 23:18, Darrick J. Wong wrote:
> >>> Hi Bernd,
> >>>
> >>> Please pull this branch with changes for libfuse.
> >>>
> >>> As usual, I did a test-merge with the main upstream branch as of a few
> >>> minutes ago, and didn't see any conflicts.  Please let me know if you
> >>> encounter any problems.
> >>
> >> pushed to my github branch. BSD build fails with
> >>
> >> 2026-04-30T21:25:16.3874802Z FAILED: [code=1] lib/libfuse3.so.3.19.0 
> >> 2026-04-30T21:25:16.3906762Z cc  -o lib/libfuse3.so.3.19.0 lib/libfuse3.so.3.19.0.p/fuse.c.o lib/libfuse3.so.3.19.0.p/fuse_loop.c.o lib/libfuse3.so.3.19.0.p/fuse_loop_mt.c.o lib/libfuse3.so.3.19.0.p/fuse_lowlevel.c.o lib/libfuse3.so.3.19.0.p/fuse_opt.c.o lib/libfuse3.so.3.19.0.p/fuse_signals.c.o lib/libfuse3.so.3.19.0.p/buffer.c.o lib/libfuse3.so.3.19.0.p/cuse_lowlevel.c.o lib/libfuse3.so.3.19.0.p/helper.c.o lib/libfuse3.so.3.19.0.p/modules_subdir.c.o lib/libfuse3.so.3.19.0.p/mount_util.c.o lib/libfuse3.so.3.19.0.p/fuse_log.c.o lib/libfuse3.so.3.19.0.p/compat.c.o lib/libfuse3.so.3.19.0.p/util.c.o lib/libfuse3.so.3.19.0.p/mount_bsd.c.o lib/libfuse3.so.3.19.0.p/fuse_service_stub.c.o lib/libfuse3.so.3.19.0.p/modules_iconv.c.o -Wl,--as-needed -Wl,--no-undefined -shared -fPIC -Wl,-soname,libfuse3.so.4 -Wl,--version-script,/home/runner/work/libfuse/libfuse/lib/fuse_versionscript -pthread -Wl,--start-group -ldl -lrt -Wl,--end-group
> >> 2026-04-30T21:25:16.3939590Z ld: error: version script assignment of 'FUSE_3.19' to symbol 'fuse_service_can_allow_other' failed: symbol not defined
> > 
> > Aha, that function got left out of the stub. :(
> > 
> > Annoyingly, on Linux the build succeeds despite the missing symbol
> > when I tweak meson so that it doesn't build the service stuff.  I would
> > have thought that --no-undefined would have done that, but alas.
> > 
> > Sorry about that too.  The following patch fixes it.
> > 
> > diff --git i/lib/fuse_service_stub.c w/lib/fuse_service_stub.c
> > index d34df3891a6e31..231b98423df628 100644
> > --- i/lib/fuse_service_stub.c
> > +++ w/lib/fuse_service_stub.c
> > @@ -49,12 +49,17 @@ int fuse_service_send_goodbye(struct fuse_service *sf, int error)
> >  int fuse_service_accept(struct fuse_service **sfp)
> >  {
> >  	*sfp = NULL;
> >  	return 0;
> >  }
> >  
> > +bool fuse_service_can_allow_other(struct fuse_service *sf)
> > +{
> > +	return false;
> > +}
> > +
> >  int fuse_service_append_args(struct fuse_service *sf,
> >  			     struct fuse_args *existing_args)
> >  {
> >  	return -EOPNOTSUPP;
> >  }
> >  
> > 
> >> 2026-04-30T21:25:16.3951874Z cc: error: linker command failed with exit code 1 (use -v to see invocation)
> >> 2026-04-30T21:25:16.4291582Z [44/82] cc -Itest/test_teardown_watchdog.p -Itest -I../test -Iinclude -I../include -Ilib -I../lib -I. -I.. -fdiagnostics-color=always -
> >>
> >>
> >> checkpatch, CodeChecker-cppcheck, CodeChecker-gcc also all fail. This CodeQL
> > 
> > Not sure why checkpatch fails, this is what I got (Debian 13):
> > 
> > $ git diff origin/master.. | ./checkpatch.pl --max-line-length=100 --no-tree --ignore MAINTAINERS,SPDX_LICENSE_TAG,COMMIT_MESSAGE,FILE_PATH_CHANGES,EMAIL_SUBJECT,AVOID_EXTERNS,GIT_COMMIT_ID,ENOSYS_SYSCALL,ENOSYS,FROM_SIGN_OFF_MISMATCH,QUOTED_COMMIT_ID,,PREFER_ATTRIBUTE_ALWAYS_UNUSED,PREFER_DEFINED_ATTRIBUTE_MACRO,STRCPY,STRNCPY -
> > No typos will be found - file '/storage/home/djwong/cdev/work/libfuse/spelling.txt': No such file or directory
> > No structs that should be const will be found - file '/storage/home/djwong/cdev/work/libfuse/const_structs.checkpatch': No such file or directory
> > total: 0 errors, 0 warnings, 3908 lines checked
> > 
> > Your patch has no obvious style problems and is ready for submission.
> > 
> > NOTE: Ignored message types: AVOID_EXTERNS COMMIT_MESSAGE EMAIL_SUBJECT ENOSYS ENOSYS_SYSCALL FILE_PATH_CHANGES FROM_SIGN_OFF_MISMATCH GIT_COMMIT_ID MAINTAINERS PREFER_ATTRIBUTE_ALWAYS_UNUSED PREFER_DEFINED_ATTRIBUTE_MACRO QUOTED_COMMIT_ID SPDX_LICENSE_TAG STRCPY STRNCPY
> > 
> > cppcheck had a few things to say, but none of it was about the changed
> > lines.
> > 
> >> report is funny
> >>
> >>> int mount_service_main(int argc, char *argv[])
> >>> Warning
> >>> Poorly documented large function
> >>> Poorly documented function: fewer than 2% comments for a function of 113 lines.
> >>> CodeQL
> > 
> > Hrmm.  I guess I'll have to figure out how to get those things running.
> > That said, the stuff in mount_service.c is internal to libfuse (i.e.
> > it's not public library API) so I didn't comment them as intensely.
> > Would you like more?
> > 
> >> I think I'm going to merge my sync fuse init series tomorrow.
> > 
> > Yay!
> > 
> >> Are you ok if skip posting another version of the series?
> > 
> >                ^ is there an "I" here?  e.g. "...if I skip posting..."?
> > 
> > /My/ normal practice (from xfs) was to repost the series as it was
> > merged, followed by an announcement.  That way the mailing list is a
> > complete record of what was merged.  However, very very few people
> > actually do that, even in the kernel.
> > 
> > I'm ok with you not posting another version of the series.
> > 
> >> Or do you prefer to review the recent changes and last piece I'm going
> >> to do tomorrow?
> > 
> > Nah, just merge it.  I'll look over the changes once it's in the branch
> > and if there's anything weird, you or I or anyone else can send patches.
> > As long as you're not planning to tag it as a release, nothing's set in
> > stone.
> > 
> >> Basically my goal is to rebase your series against it immediately and
> >> to merge your series during the next few days.
> > 
> > <nod> Let me know what you want changed, I'll be around since I am not
> > travelling anywhere for a couple of weeks. :)
> > 
> > I can reflow changes into the patchset, or if you'd prefer, I can add
> > them as new patches that would go on the end of the series.
> > 
> 
> Hi Darrick,
> 
> eventually merged my patches and made a quick rebase and conflict 
> resolving with your branch. Github still reports plenty of issues ;)
> 
> Could you fix all of the checkpatch isssues? This one shows plenty
> "util: hoist the fuse.conf parsing and setuid mode enforcement code"
> 
> bschubert2@imesrv6 libfuse.git>stg series
> + mount_service-add-systemd
> + mount_service-create-high
> + mount_service-use-the-new
> + mount_service-update-mtab
> > util-hoist-the-fuse.conf
> - util-fix-checkpatch-complaints
> - mount_service-enable
> - mount.fuse3-integrate-systemd
> - mount_service-allow
> - example-service_ll-create-a
> - example-service-create-a
> - nullfs-support-fuse-systemd
> - meson-show-feature-summary
> bschubert2@imesrv6 libfuse.git>.github/workflows/run-checkpatch.sh 
> No typos will be found - file '/home/bschubert2/src/libfuse/libfuse.git/spelling.txt': No such file or directory
> No structs that should be const will be found - file '/home/bschubert2/src/libfuse/libfuse.git/const_structs.checkpatch': No such file or directory
> ERROR:GLOBAL_INITIALISERS: do not initialise globals to 0
> #61: FILE: util/fuser_conf.c:33:
> +int user_allow_other = 0;
> 
> WARNING:LINE_SPACING: Missing a blank line after declarations
> #74: FILE: util/fuser_conf.c:46:
> +	char *dest = buf;
> +	while (1) {

Oh!  The checkpatch fixes are all in the next commit
"util-fix-checkpatch-complaints".  I kept the checkpatch fixes as a
separate commit so that the hoist change can be inspected more easily.

(XFS practice is to have separate patches for moving the code and
cleaning it up)

> ...
> 
> I don't have a strong opinion about these two above - feel 
> free to disable them. However, in order to merge it, it would
> be good to run without any checkpatch report.
> And everything that cppcheck and gcc-checker reports, definitely 
> need to be fixed.

Hrm, should I try to fix the things that cppcheck complains about in
HEAD?  There's an awful lot of them...

(oh, I see you pushed to master, I'll go rebase now)

--D

Checking build-aarch64/meson-private/sanitycheckc.c ...
Checking build-aarch64/meson-private/sanitycheckc.c: FUSE_USE_VERSION=319...
1/75 files checked 0% done
Checking build-aarch64/fuse_config.h ...
Checking build-aarch64/fuse_config.h: FUSE_USE_VERSION=319...
2/75 files checked 0% done
Checking build-aarch64/libfuse_config.h ...
Checking build-aarch64/libfuse_config.h: FUSE_USE_VERSION=319...
3/75 files checked 0% done
Checking example/cuse.c ...
Checking example/cuse.c: FUSE_USE_VERSION=319...
example/cuse.c:75:18: portability: 'new_buf' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
  memset(new_buf + cusexmp_size, 0, new_size - cusexmp_size);
                 ^
example/cuse.c:113:34: portability: 'cusexmp_buf' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
 fuse_reply_buf(req, cusexmp_buf + off, size);
                                 ^
example/cuse.c:126:21: portability: 'cusexmp_buf' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
 memcpy(cusexmp_buf + off, buf, size);
                    ^
example/cuse.c:145:9: portability: 'in_buf' is of type 'const void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
 in_buf += sizeof(*arg);
        ^
example/cuse.c:150:8: portability: 'addr' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
  addr + offsetof(struct fioc_rw_arg, prev_size);
       ^
example/cuse.c:154:8: portability: 'addr' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
  addr + offsetof(struct fioc_rw_arg, new_size);
       ^
example/cuse.c:191:33: portability: 'cusexmp_buf' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
  iov[2].iov_base = cusexmp_buf + off;
                                ^
example/cuse.c:200:22: portability: 'cusexmp_buf' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
  memcpy(cusexmp_buf + arg->offset, in_buf, in_bufsz);
                     ^
Checking example/cuse.c: FUSE_USE_VERSION=319;FUSE_H_;FUSE_LOWLEVEL_H_...
Checking example/cuse.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking example/cuse.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
4/75 files checked 0% done
Checking example/cuse_client.c ...
Checking example/cuse_client.c: FUSE_USE_VERSION=319...
5/75 files checked 1% done
Checking example/hello.c ...
Checking example/hello.c: FUSE_USE_VERSION=319...
Checking example/hello.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking example/hello.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking example/hello.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
6/75 files checked 1% done
Checking example/hello_ll_uds.c ...
Checking example/hello_ll_uds.c: FUSE_USE_VERSION=319...
example/hello_ll_uds.c:212:3: error: Resource leak: sfd [resourceLeak]
  return -1;
  ^
example/hello_ll_uds.c:216:3: error: Resource leak: sfd [resourceLeak]
  return -1;
  ^
example/hello_ll_uds.c:223:3: error: Resource leak: sfd [resourceLeak]
  return -1;
  ^
example/hello_ll_uds.c:227:2: error: Resource leak: sfd [resourceLeak]
 return cfd;
 ^
Checking example/hello_ll_uds.c: FUSE_USE_VERSION=319;FUSE_H_;FUSE_LOWLEVEL_H_...
Checking example/hello_ll_uds.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking example/hello_ll_uds.c: FUSE_USE_VERSION=319;__KERNEL__...
Checking example/hello_ll_uds.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
7/75 files checked 2% done
Checking example/invalidate_path.c ...
Checking example/invalidate_path.c: FUSE_USE_VERSION=319...
example/invalidate_path.c:169:8: portability: Non reentrant function 'localtime' called. For threadsafe applications it is recommended to use the reentrant replacement function 'localtime_r'. [localtimeCalled]
 now = localtime(&t);
       ^
example/invalidate_path.c:166:13: style: Variable 'now' can be declared as pointer to const [constVariablePointer]
 struct tm *now;
            ^
Checking example/invalidate_path.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking example/invalidate_path.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking example/invalidate_path.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
8/75 files checked 3% done
Checking example/ioctl.c ...
Checking example/ioctl.c: FUSE_USE_VERSION=319...
example/ioctl.c:60:18: portability: 'new_buf' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
  memset(new_buf + fioc_size, 0, new_size - fioc_size);
                 ^
example/ioctl.c:126:23: portability: 'fioc_buf' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
 memcpy(buf, fioc_buf + offset, size);
                      ^
example/ioctl.c:147:18: portability: 'fioc_buf' is of type 'void *'. When using void pointers in calculations, the behaviour is undefined. [arithOperationsOnVoidPointer]
 memcpy(fioc_buf + offset, buf, size);
                 ^
Checking example/ioctl.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking example/ioctl.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking example/ioctl.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
9/75 files checked 3% done
Checking example/ioctl.h ...
Checking example/ioctl.h: FUSE_USE_VERSION=319...
10/75 files checked 3% done
Checking example/ioctl_client.c ...
Checking example/ioctl_client.c: FUSE_USE_VERSION=319...
11/75 files checked 4% done
Checking example/notify_inval_entry.c ...
Checking example/notify_inval_entry.c: FUSE_USE_VERSION=319...
example/notify_inval_entry.c:264:11: portability: Non reentrant function 'localtime' called. For threadsafe applications it is recommended to use the reentrant replacement function 'localtime_r'. [localtimeCalled]
    now = localtime(&t);
          ^
example/notify_inval_entry.c:141:34: style: Operator '|' with one operand equal to zero is redundant. [badBitmaskCheck]
        stbuf->st_mode = S_IFREG | 0000;
                                 ^
example/notify_inval_entry.c:274:11: style: The scope of the variable 'old_name' can be reduced. [variableScope]
    char *old_name;
          ^
example/notify_inval_entry.c:260:16: style: Variable 'now' can be declared as pointer to const [constVariablePointer]
    struct tm *now;
               ^
Checking example/notify_inval_entry.c: FUSE_USE_VERSION=319;FUSE_H_;FUSE_LOWLEVEL_H_...
Checking example/notify_inval_entry.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking example/notify_inval_entry.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
12/75 files checked 5% done
Checking example/notify_inval_inode.c ...
Checking example/notify_inval_inode.c: FUSE_USE_VERSION=319...
example/notify_inval_inode.c:274:11: portability: Non reentrant function 'localtime' called. For threadsafe applications it is recommended to use the reentrant replacement function 'localtime_r'. [localtimeCalled]
    now = localtime(&t);
          ^
example/notify_inval_inode.c:271:16: style: Variable 'now' can be declared as pointer to const [constVariablePointer]
    struct tm *now;
               ^
Checking example/notify_inval_inode.c: FUSE_USE_VERSION=319;FUSE_H_;FUSE_LOWLEVEL_H_...
Checking example/notify_inval_inode.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking example/notify_inval_inode.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
13/75 files checked 6% done
Checking example/notify_store_retrieve.c ...
Checking example/notify_store_retrieve.c: FUSE_USE_VERSION=319...
example/notify_store_retrieve.c:329:11: portability: Non reentrant function 'localtime' called. For threadsafe applications it is recommended to use the reentrant replacement function 'localtime_r'. [localtimeCalled]
    now = localtime(&t);
          ^
example/notify_store_retrieve.c:326:16: style: Variable 'now' can be declared as pointer to const [constVariablePointer]
    struct tm *now;
               ^
example/notify_store_retrieve.c:297:20: error: Uninitialized variable: buf [uninitvar]
    assert(strncmp(buf, expected, ret) == 0);
                   ^
Checking example/notify_store_retrieve.c: FUSE_USE_VERSION=319;FUSE_H_;FUSE_LOWLEVEL_H_...
Checking example/notify_store_retrieve.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking example/notify_store_retrieve.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
14/75 files checked 7% done
Checking example/passthrough.c ...
Checking example/passthrough.c: FUSE_USE_VERSION=319...
example/passthrough.c:134:15: portability: Non reentrant function 'readdir' called. For threadsafe applications it is recommended to use the reentrant replacement function 'readdir_r'. [readdirCalled]
 while ((de = readdir(dp)) != NULL) {
              ^
example/passthrough_helpers.h:119:2: error: Returning/dereferencing 'res' after it is deallocated / released [deallocret]
 return res;
 ^
example/passthrough_helpers.h:82:10: note: Returning/dereferencing 'res' after it is deallocated / released
   res = close(res);
         ^
example/passthrough_helpers.h:119:2: note: Returning/dereferencing 'res' after it is deallocated / released
 return res;
 ^
Checking example/passthrough.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking example/passthrough.c: FUSE_USE_VERSION=319;HAVE_COPY_FILE_RANGE...
Checking example/passthrough.c: FUSE_USE_VERSION=319;HAVE_FSPACECTL...
Checking example/passthrough.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking example/passthrough.c: FUSE_USE_VERSION=319;HAVE_SETXATTR...
Checking example/passthrough.c: FUSE_USE_VERSION=319;HAVE_STATX...
Checking example/passthrough.c: FUSE_USE_VERSION=319;HAVE_UTIMENSAT...
Checking example/passthrough.c: FUSE_USE_VERSION=319;__FreeBSD__...
Checking example/passthrough.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
Checking example/passthrough.c: FUSE_USE_VERSION=319;linux...
15/75 files checked 8% done
Checking example/passthrough_fh.c ...
Checking example/passthrough_fh.c: FUSE_USE_VERSION=319...
example/passthrough_fh.c:175:15: portability: Non reentrant function 'readdir' called. For threadsafe applications it is recommended to use the reentrant replacement function 'readdir_r'. [readdirCalled]
   d->entry = readdir(d->dp);
              ^
example/passthrough_fh.c:143:2: error: Resource leak: d.dp [resourceLeak]
 return 0;
 ^
example/passthrough_fh.c:128:6: style: The scope of the variable 'res' can be reduced. [variableScope]
 int res;
     ^
example/passthrough_fh.c:146:64: style: Parameter 'fi' can be declared as pointer to const [constParameterPointer]
static inline struct xmp_dirp *get_dirp(struct fuse_file_info *fi)
                                                               ^
Checking example/passthrough_fh.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking example/passthrough_fh.c: FUSE_USE_VERSION=319;HAVE_COPY_FILE_RANGE...
Checking example/passthrough_fh.c: FUSE_USE_VERSION=319;HAVE_FDATASYNC...
Checking example/passthrough_fh.c: FUSE_USE_VERSION=319;HAVE_FSPACECTL...
Checking example/passthrough_fh.c: FUSE_USE_VERSION=319;HAVE_FSTATAT...
Checking example/passthrough_fh.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking example/passthrough_fh.c: FUSE_USE_VERSION=319;HAVE_LIBULOCKMGR...
Checking example/passthrough_fh.c: FUSE_USE_VERSION=319;HAVE_SETXATTR...
Checking example/passthrough_fh.c: FUSE_USE_VERSION=319;HAVE_STATX...
Checking example/passthrough_fh.c: FUSE_USE_VERSION=319;HAVE_UTIMENSAT...
Checking example/passthrough_fh.c: FUSE_USE_VERSION=319;__FreeBSD__...
Checking example/passthrough_fh.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
16/75 files checked 10% done
Checking example/passthrough_helpers.h ...
Checking example/passthrough_helpers.h: FUSE_USE_VERSION=319...
Checking example/passthrough_helpers.h: FUSE_USE_VERSION=319;HAVE_FALLOCATE...
Checking example/passthrough_helpers.h: FUSE_USE_VERSION=319;HAVE_FSPACECTL...
Checking example/passthrough_helpers.h: FUSE_USE_VERSION=319;HAVE_POSIX_FALLOCATE...
Checking example/passthrough_helpers.h: FUSE_USE_VERSION=319;__FreeBSD__...
17/75 files checked 10% done
Checking example/passthrough_ll.c ...
Checking example/passthrough_ll.c: FUSE_USE_VERSION=319...
example/passthrough_ll.c:705:15: portability: Non reentrant function 'readdir' called. For threadsafe applications it is recommended to use the reentrant replacement function 'readdir_r'. [readdirCalled]
   d->entry = readdir(d->dp);
              ^
example/passthrough_ll.c:656:2: error: Resource leak: d.dp [resourceLeak]
 return;
 ^
example/passthrough_ll.c:167:18: style: Variable 'lo' can be declared as pointer to const [constVariablePointer]
 struct lo_data *lo = (struct lo_data *)userdata;
                 ^
example/passthrough_ll.c:204:18: style: Variable 'lo' can be declared as pointer to const [constVariablePointer]
 struct lo_data *lo = lo_data(req);
                 ^
example/passthrough_ll.c:221:19: style: Variable 'inode' can be declared as pointer to const [constVariablePointer]
 struct lo_inode *inode = lo_inode(req, ino);
                  ^
example/passthrough_ll.c:291:66: style: Parameter 'st' can be declared as pointer to const [constParameterPointer]
static struct lo_inode *lo_find(struct lo_data *lo, struct stat *st)
                                                                 ^
example/passthrough_ll.c:425:19: style: Variable 'dir' can be declared as pointer to const [constVariablePointer]
 struct lo_inode *dir = lo_inode(req, parent);
                  ^
example/passthrough_ll.c:631:18: style: Variable 'lo' can be declared as pointer to const [constVariablePointer]
 struct lo_data *lo = lo_data(req);
                 ^
example/passthrough_ll.c:793:18: style: Variable 'lo' can be declared as pointer to const [constVariablePointer]
 struct lo_data *lo = lo_data(req);
                 ^
example/passthrough_ll.c:828:18: style: Variable 'lo' can be declared as pointer to const [constVariablePointer]
 struct lo_data *lo = lo_data(req);
                 ^
example/passthrough_ll.c:876:18: style: Variable 'lo' can be declared as pointer to const [constVariablePointer]
 struct lo_data *lo = lo_data(req);
                 ^
example/passthrough_ll.c:1029:19: style: Variable 'inode' can be declared as pointer to const [constVariablePointer]
 struct lo_inode *inode = lo_inode(req, ino);
                  ^
example/passthrough_ll.c:1079:19: style: Variable 'inode' can be declared as pointer to const [constVariablePointer]
 struct lo_inode *inode = lo_inode(req, ino);
                  ^
example/passthrough_ll.c:1129:19: style: Variable 'inode' can be declared as pointer to const [constVariablePointer]
 struct lo_inode *inode = lo_inode(req, ino);
                  ^
example/passthrough_ll.c:1154:19: style: Variable 'inode' can be declared as pointer to const [constVariablePointer]
 struct lo_inode *inode = lo_inode(req, ino);
                  ^
example/passthrough_ll.c:382:9: style: Variable 'newfd' is assigned a value that is never used. [unreadVariable]
  newfd = -1;
        ^
Checking example/passthrough_ll.c: FUSE_USE_VERSION=319;FUSE_H_;FUSE_LOWLEVEL_H_...
Checking example/passthrough_ll.c: FUSE_USE_VERSION=319;HAVE_COPY_FILE_RANGE...
Checking example/passthrough_ll.c: FUSE_USE_VERSION=319;HAVE_FSPACECTL...
Checking example/passthrough_ll.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
example/passthrough_ll.c:1220:18: style: Variable 'lo' can be declared as pointer to const [constVariablePointer]
 struct lo_data *lo = lo_data(req);
                 ^
Checking example/passthrough_ll.c: FUSE_USE_VERSION=319;HAVE_STATX...
Checking example/passthrough_ll.c: FUSE_USE_VERSION=319;__FreeBSD__...
Checking example/passthrough_ll.c: FUSE_USE_VERSION=319;__GNUC__...
Checking example/passthrough_ll.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
18/75 files checked 14% done
Checking example/poll.c ...
Checking example/poll.c: FUSE_USE_VERSION=319...
Checking example/poll.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking example/poll.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking example/poll.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
19/75 files checked 14% done
Checking example/poll_client.c ...
Checking example/poll_client.c: FUSE_USE_VERSION=319...
example/poll_client.c:43:8: style: Variable 'name' can be declared as const array [constVariable]
  char name[] = { hex_map[i], '\0' };
       ^
20/75 files checked 14% done
Checking example/ioctl_ll.c ...
Checking example/ioctl_ll.c: FUSE_USE_VERSION=319...
Checking example/ioctl_ll.c: FUSE_USE_VERSION=319;FUSE_H_;FUSE_LOWLEVEL_H_...
Checking example/ioctl_ll.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking example/ioctl_ll.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
21/75 files checked 16% done
Checking example/ioctl_ll_client.c ...
Checking example/ioctl_ll_client.c: FUSE_USE_VERSION=319...
22/75 files checked 16% done
Checking example/notify_prune.c ...
Checking example/notify_prune.c: FUSE_USE_VERSION=319...
example/notify_prune.c:108:8: portability: Non reentrant function 'localtime' called. For threadsafe applications it is recommended to use the reentrant replacement function 'localtime_r'. [localtimeCalled]
 now = localtime(&t);
       ^
example/notify_prune.c:105:13: style: Variable 'now' can be declared as pointer to const [constVariablePointer]
 struct tm *now;
            ^
Checking example/notify_prune.c: FUSE_USE_VERSION=319;FUSE_H_;FUSE_LOWLEVEL_H_...
Checking example/notify_prune.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking example/notify_prune.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
23/75 files checked 17% done
Checking example/hello_ll.c ...
Checking example/hello_ll.c: FUSE_USE_VERSION=319...
Checking example/hello_ll.c: FUSE_USE_VERSION=319;FUSE_H_;FUSE_LOWLEVEL_H_...
Checking example/hello_ll.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking example/hello_ll.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
24/75 files checked 18% done
Checking example/null.c ...
Checking example/null.c: FUSE_USE_VERSION=319...
Checking example/null.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking example/null.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking example/null.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
25/75 files checked 18% done
Checking example/printcap.c ...
Checking example/printcap.c: FUSE_USE_VERSION=319...
example/printcap.c:88:2: warning: %d in format string (no. 1) requires 'int' but the argument type is 'unsigned int'. [invalidPrintfArgType_sint]
 printf("Protocol version: %d.%d\n", conn->proto_major,
 ^
example/printcap.c:88:2: warning: %d in format string (no. 2) requires 'int' but the argument type is 'unsigned int'. [invalidPrintfArgType_sint]
 printf("Protocol version: %d.%d\n", conn->proto_major,
 ^
example/printcap.c:108:3: error: Memory leak: mountpoint [memleak]
  return 1;
  ^
example/printcap.c:106:13: warning: If memory allocation fails, then there is a possible null pointer dereference: mountpoint [nullPointerOutOfMemory]
 if(mkdtemp(mountpoint) == NULL) {
            ^
example/printcap.c:105:21: note: Assuming allocation function fails
 mountpoint = strdup("/tmp/fuse_printcap_XXXXXX");
                    ^
example/printcap.c:105:21: note: Assignment 'mountpoint=strdup("/tmp/fuse_printcap_XXXXXX")', assigned value is 0
 mountpoint = strdup("/tmp/fuse_printcap_XXXXXX");
                    ^
example/printcap.c:106:13: note: Null pointer dereference
 if(mkdtemp(mountpoint) == NULL) {
            ^
example/printcap.c:74:55: style: Parameter 'conn' can be declared as pointer to const [constParameterPointer]
static void print_capabilities(struct fuse_conn_info *conn)
                                                      ^
Checking example/printcap.c: FUSE_USE_VERSION=319;FUSE_H_;FUSE_LOWLEVEL_H_...
Checking example/printcap.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking example/printcap.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
26/75 files checked 18% done
Checking include/cuse_lowlevel.h ...
Checking include/cuse_lowlevel.h: FUSE_USE_VERSION=319...
Checking include/cuse_lowlevel.h: FUSE_USE_VERSION=319;FUSE_H_;FUSE_LOWLEVEL_H_...
Checking include/cuse_lowlevel.h: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking include/cuse_lowlevel.h: FUSE_USE_VERSION=319;__STDC_VERSION__...
27/75 files checked 19% done
Checking include/fuse_log.h ...
Checking include/fuse_log.h: FUSE_USE_VERSION=319...
28/75 files checked 19% done
Checking include/fuse_mount_compat.h ...
Checking include/fuse_mount_compat.h: FUSE_USE_VERSION=319...
29/75 files checked 19% done
Checking include/fuse_opt.h ...
Checking include/fuse_opt.h: FUSE_USE_VERSION=319...
30/75 files checked 20% done
Checking include/fuse.h ...
Checking include/fuse.h: FUSE_USE_VERSION=319...
Checking include/fuse.h: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking include/fuse.h: FUSE_USE_VERSION=319;FUSE_USE_VERSION=30...
Checking include/fuse.h: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking include/fuse.h: FUSE_USE_VERSION=319;LIBFUSE_BUILT_WITH_VERSIONED_SYMBOLS...
Checking include/fuse.h: FUSE_USE_VERSION=319;__STDC_VERSION__...
31/75 files checked 25% done
Checking include/fuse_common.h ...
Checking include/fuse_common.h: FUSE_USE_VERSION=319;FUSE_H_;FUSE_LOWLEVEL_H_...
32/75 files checked 29% done
Checking include/fuse_kernel.h ...
Checking include/fuse_kernel.h: FUSE_USE_VERSION=319...
Checking include/fuse_kernel.h: FUSE_USE_VERSION=319;__KERNEL__...
33/75 files checked 32% done
Checking include/fuse_lowlevel.h ...
Checking include/fuse_lowlevel.h: FUSE_USE_VERSION=319...
Checking include/fuse_lowlevel.h: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking include/fuse_lowlevel.h: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking include/fuse_lowlevel.h: FUSE_USE_VERSION=319;LIBFUSE_BUILT_WITH_VERSIONED_SYMBOLS...
Checking include/fuse_lowlevel.h: FUSE_USE_VERSION=319;__STDC_VERSION__...
34/75 files checked 41% done
Checking lib/modules/iconv.c ...
Checking lib/modules/iconv.c: FUSE_USE_VERSION=319...
lib/modules/iconv.c:673:3: warning: If memory allocation fails, then there is a possible null pointer dereference: charmap [nullPointerOutOfMemory]
  charmap);
  ^
lib/modules/iconv.c:664:18: note: Assuming allocation function fails
 charmap = strdup(nl_langinfo(CODESET));
                 ^
lib/modules/iconv.c:664:18: note: Assignment 'charmap=strdup(nl_langinfo(CODESET))', assigned value is 0
 charmap = strdup(nl_langinfo(CODESET));
                 ^
lib/modules/iconv.c:673:3: note: Null pointer dereference
  charmap);
  ^
Checking lib/modules/iconv.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking lib/modules/iconv.c: FUSE_USE_VERSION=319;FUSE_USE_VERSION=30...
Checking lib/modules/iconv.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking lib/modules/iconv.c: FUSE_USE_VERSION=319;HAVE_STATX...
Checking lib/modules/iconv.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
35/75 files checked 42% done
Checking lib/modules/subdir.c ...
Checking lib/modules/subdir.c: FUSE_USE_VERSION=319...
lib/modules/subdir.c:104:46: style: Parameter 'd' can be declared as pointer to const [constParameterPointer]
static void transform_symlink(struct subdir *d, const char *path,
                                             ^
Checking lib/modules/subdir.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking lib/modules/subdir.c: FUSE_USE_VERSION=319;FUSE_USE_VERSION=30...
Checking lib/modules/subdir.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking lib/modules/subdir.c: FUSE_USE_VERSION=319;HAVE_STATX...
Checking lib/modules/subdir.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
36/75 files checked 44% done
Checking lib/buffer.c ...
Checking lib/buffer.c: FUSE_USE_VERSION=319...
Checking lib/buffer.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_;FUSE_USE_VERSION...
Checking lib/buffer.c: FUSE_USE_VERSION=319;FUSE_USE_VERSION=30...
Checking lib/buffer.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H;FUSE_USE_VERSION...
Checking lib/buffer.c: FUSE_USE_VERSION=319;HAVE_SPLICE;FUSE_USE_VERSION...
Checking lib/buffer.c: FUSE_USE_VERSION=319;__STDC_VERSION__;FUSE_USE_VERSION...
37/75 files checked 45% done
Checking lib/compat.c ...
Checking lib/compat.c: FUSE_USE_VERSION=319...
Checking lib/compat.c: FUSE_USE_VERSION=319;LIBFUSE_BUILT_WITH_VERSIONED_SYMBOLS...
Checking lib/compat.c: FUSE_USE_VERSION=319;LIBFUSE_BUILT_WITH_VERSIONED_SYMBOLS;fuse_parse_cmdline...
38/75 files checked 45% done
Checking lib/cuse_lowlevel.c ...
Checking lib/cuse_lowlevel.c: FUSE_USE_VERSION=319...
Checking lib/cuse_lowlevel.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking lib/cuse_lowlevel.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking lib/cuse_lowlevel.c: FUSE_USE_VERSION=319;__KERNEL__...
Checking lib/cuse_lowlevel.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
39/75 files checked 46% done
Checking lib/fuse_log.c ...
Checking lib/fuse_log.c: FUSE_USE_VERSION=319...
40/75 files checked 46% done
Checking lib/fuse_loop.c ...
Checking lib/fuse_loop.c: FUSE_USE_VERSION=319...
Checking lib/fuse_loop.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_;FUSE_USE_VERSION...
Checking lib/fuse_loop.c: FUSE_USE_VERSION=319;FUSE_USE_VERSION=30...
Checking lib/fuse_loop.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H;FUSE_USE_VERSION...
Checking lib/fuse_loop.c: FUSE_USE_VERSION=319;__KERNEL__;FUSE_USE_VERSION...
Checking lib/fuse_loop.c: FUSE_USE_VERSION=319;__STDC_VERSION__;FUSE_USE_VERSION...
41/75 files checked 46% done
Checking lib/fuse_loop_mt.c ...
Checking lib/fuse_loop_mt.c: FUSE_USE_VERSION=319...
Checking lib/fuse_loop_mt.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_;FUSE_USE_VERSION...
Checking lib/fuse_loop_mt.c: FUSE_USE_VERSION=319;FUSE_USE_VERSION=30...
Checking lib/fuse_loop_mt.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H;FUSE_USE_VERSION...
Checking lib/fuse_loop_mt.c: FUSE_USE_VERSION=319;HAVE_STRUCT_STAT_ST_ATIMESPEC...
Checking lib/fuse_loop_mt.c: FUSE_USE_VERSION=319;HAVE_SYMVER_ATTRIBUTE...
Checking lib/fuse_loop_mt.c: FUSE_USE_VERSION=319;__KERNEL__;FUSE_USE_VERSION...
Checking lib/fuse_loop_mt.c: FUSE_USE_VERSION=319;__STDC_VERSION__;FUSE_USE_VERSION...
42/75 files checked 47% done
Checking lib/fuse_misc.h ...
Checking lib/fuse_misc.h: FUSE_USE_VERSION=319...
Checking lib/fuse_misc.h: FUSE_USE_VERSION=319;HAVE_STRUCT_STAT_ST_ATIM...
Checking lib/fuse_misc.h: FUSE_USE_VERSION=319;HAVE_STRUCT_STAT_ST_ATIMESPEC...
Checking lib/fuse_misc.h: FUSE_USE_VERSION=319;HAVE_SYMVER_ATTRIBUTE;LIBFUSE_BUILT_WITH_VERSIONED_SYMBOLS...
Checking lib/fuse_misc.h: FUSE_USE_VERSION=319;LIBFUSE_BUILT_WITH_VERSIONED_SYMBOLS...
43/75 files checked 48% done
Checking lib/fuse_opt.c ...
Checking lib/fuse_opt.c: FUSE_USE_VERSION=319...
Checking lib/fuse_opt.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_;FUSE_USE_VERSION...
Checking lib/fuse_opt.c: FUSE_USE_VERSION=319;FUSE_USE_VERSION=30...
Checking lib/fuse_opt.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H;FUSE_USE_VERSION...
Checking lib/fuse_opt.c: FUSE_USE_VERSION=319;HAVE_STRUCT_STAT_ST_ATIMESPEC...
Checking lib/fuse_opt.c: FUSE_USE_VERSION=319;HAVE_SYMVER_ATTRIBUTE...
Checking lib/fuse_opt.c: FUSE_USE_VERSION=319;__STDC_VERSION__;FUSE_USE_VERSION...
44/75 files checked 48% done
Checking lib/fuse_signals.c ...
Checking lib/fuse_signals.c: FUSE_USE_VERSION=319...
Checking lib/fuse_signals.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_;FUSE_USE_VERSION...
Checking lib/fuse_signals.c: FUSE_USE_VERSION=319;FUSE_USE_VERSION=30...
Checking lib/fuse_signals.c: FUSE_USE_VERSION=319;HAVE_BACKTRACE;FUSE_USE_VERSION...
Checking lib/fuse_signals.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H;FUSE_USE_VERSION...
Checking lib/fuse_signals.c: FUSE_USE_VERSION=319;__STDC_VERSION__;FUSE_USE_VERSION...
45/75 files checked 49% done
Checking lib/fuse_uring_i.h ...
Checking lib/fuse_uring_i.h: FUSE_USE_VERSION=319...
Checking lib/fuse_uring_i.h: FUSE_USE_VERSION=319;FUSE_H_;FUSE_LOWLEVEL_H_;FUSE_USE_VERSION...
Checking lib/fuse_uring_i.h: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H;FUSE_USE_VERSION...
Checking lib/fuse_uring_i.h: FUSE_USE_VERSION=319;HAVE_URING;FUSE_USE_VERSION...
Checking lib/fuse_uring_i.h: FUSE_USE_VERSION=319;__KERNEL__;FUSE_USE_VERSION...
Checking lib/fuse_uring_i.h: FUSE_USE_VERSION=319;__STDC_VERSION__;FUSE_USE_VERSION...
46/75 files checked 49% done
Checking lib/mount_bsd.c ...
Checking lib/mount_bsd.c: FUSE_USE_VERSION=319...
lib/mount_bsd.c:190:8: style: The scope of the variable 'ret' can be reduced. [variableScope]
   int ret = -1;
       ^
lib/mount_bsd.c:138:16: style: Variable 'dev' can be declared as pointer to const [constVariablePointer]
 char *fdnam, *dev;
               ^
lib/mount_bsd.c:261:64: style: Parameter 'mo' can be declared as pointer to const [constParameterPointer]
int fuse_kern_mount(const char *mountpoint, struct mount_opts *mo)
                                                               ^
lib/mount_bsd.c:190:12: style: Variable 'ret' is assigned a value that is never used. [unreadVariable]
   int ret = -1;
           ^
Checking lib/mount_bsd.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_;FUSE_USE_VERSION...
Checking lib/mount_bsd.c: FUSE_USE_VERSION=319;FUSE_USE_VERSION=30...
Checking lib/mount_bsd.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H;FUSE_USE_VERSION...
Checking lib/mount_bsd.c: FUSE_USE_VERSION=319;HAVE_STRUCT_STAT_ST_ATIMESPEC...
Checking lib/mount_bsd.c: FUSE_USE_VERSION=319;HAVE_SYMVER_ATTRIBUTE...
Checking lib/mount_bsd.c: FUSE_USE_VERSION=319;__STDC_VERSION__;FUSE_USE_VERSION...
47/75 files checked 50% done
Checking lib/usdt.h ...
Checking lib/usdt.h: FUSE_USE_VERSION=319...
Checking lib/usdt.h: FUSE_USE_VERSION=319;__LP64__...
Checking lib/usdt.h: FUSE_USE_VERSION=319;__STDC_VERSION__...
Checking lib/usdt.h: FUSE_USE_VERSION=319;__arm__...
Checking lib/usdt.h: FUSE_USE_VERSION=319;__i386__...
Checking lib/usdt.h: FUSE_USE_VERSION=319;__ia64__;__s390__;__s390x__...
Checking lib/usdt.h: FUSE_USE_VERSION=319;__loongarch__...
Checking lib/usdt.h: FUSE_USE_VERSION=319;__powerpc64__;__powerpc__...
Checking lib/usdt.h: FUSE_USE_VERSION=319;__powerpc__...
48/75 files checked 52% done
Checking lib/util.c ...
Checking lib/util.c: FUSE_USE_VERSION=319...
Checking lib/util.c: FUSE_USE_VERSION=319;FUSE_H_;FUSE_LOWLEVEL_H_...
Checking lib/util.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking lib/util.c: FUSE_USE_VERSION=319;HAVE_PTHREAD_SETNAME_NP...
Checking lib/util.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
49/75 files checked 52% done
Checking lib/fuse.c ...
Checking lib/fuse.c: FUSE_USE_VERSION=319...
lib/fuse.c:5025:30: style: Parameter 'version' can be declared as pointer to const [constParameterPointer]
     struct libfuse_version *version, void *user_data)
                             ^
Checking lib/fuse.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_;FUSE_USE_VERSION...
lib/fuse.c:2971:19: warning: Uninitialized variable: &e [uninitvar]
 reply_entry(req, &e, err);
                  ^
lib/fuse.c:2945:6: note: Assuming condition is false
 if (!err) {
     ^
lib/fuse.c:2971:19: note: Uninitialized variable: &e
 reply_entry(req, &e, err);
                  ^
lib/fuse.c:2993:19: warning: Uninitialized variable: &e [uninitvar]
 reply_entry(req, &e, err);
                  ^
lib/fuse.c:2983:6: note: Assuming condition is false
 if (!err) {
     ^
lib/fuse.c:2993:19: note: Uninitialized variable: &e
 reply_entry(req, &e, err);
                  ^
lib/fuse.c:3076:19: warning: Uninitialized variable: &e [uninitvar]
 reply_entry(req, &e, err);
                  ^
lib/fuse.c:3066:6: note: Assuming condition is false
 if (!err) {
     ^
lib/fuse.c:3076:19: note: Uninitialized variable: &e
 reply_entry(req, &e, err);
                  ^
lib/fuse.c:3139:19: warning: Uninitialized variable: &e [uninitvar]
 reply_entry(req, &e, err);
                  ^
lib/fuse.c:3128:6: note: Assuming condition is false
 if (!err) {
     ^
lib/fuse.c:3139:19: note: Uninitialized variable: &e
 reply_entry(req, &e, err);
                  ^
Checking lib/fuse.c: FUSE_USE_VERSION=319;FUSE_USE_VERSION=30...
Checking lib/fuse.c: FUSE_USE_VERSION=319;HAVE_ICONV;FUSE_USE_VERSION...
Checking lib/fuse.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H;FUSE_USE_VERSION...
Checking lib/fuse.c: FUSE_USE_VERSION=319;HAVE_STATX;FUSE_USE_VERSION...
Checking lib/fuse.c: FUSE_USE_VERSION=319;HAVE_STRUCT_STAT_ST_ATIMESPEC...
Checking lib/fuse.c: FUSE_USE_VERSION=319;HAVE_SYMVER_ATTRIBUTE...
Checking lib/fuse.c: FUSE_USE_VERSION=319;HAVE_UTIMENSAT;FUSE_USE_VERSION...
Checking lib/fuse.c: FUSE_USE_VERSION=319;__FreeBSD__;FUSE_USE_VERSION...
Checking lib/fuse.c: FUSE_USE_VERSION=319;__FreeBSD__;__NetBSD__;FUSE_USE_VERSION...
Checking lib/fuse.c: FUSE_USE_VERSION=319;__KERNEL__;FUSE_USE_VERSION...
Checking lib/fuse.c: FUSE_USE_VERSION=319;__STDC_VERSION__;FUSE_USE_VERSION...
50/75 files checked 65% done
Checking lib/fuse_i.h ...
Checking lib/fuse_i.h: FUSE_USE_VERSION=319...
Checking lib/fuse_i.h: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_;FUSE_USE_VERSION...
Checking lib/fuse_i.h: FUSE_USE_VERSION=319;FUSE_USE_VERSION=30...
Checking lib/fuse_i.h: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H;FUSE_USE_VERSION...
Checking lib/fuse_i.h: FUSE_USE_VERSION=319;__STDC_VERSION__;FUSE_USE_VERSION...
51/75 files checked 66% done
Checking lib/fuse_lowlevel.c ...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319...
lib/fuse_lowlevel.c:1336:15: style: The scope of the variable 'i' can be reduced. [variableScope]
 unsigned int i;
              ^
lib/fuse_lowlevel.c:1445:31: style: The scope of the variable 'arg' can be reduced. [variableScope]
 const struct fuse_access_in *arg = op_in;
                              ^
lib/fuse_lowlevel.c:1481:14: style: The scope of the variable 'name' can be reduced. [variableScope]
 const char *name = in_payload;
             ^
lib/fuse_lowlevel.c:1506:14: style: The scope of the variable 'name' can be reduced. [variableScope]
 const char *name = in_payload;
             ^
lib/fuse_lowlevel.c:1530:14: style: The scope of the variable 'name' can be reduced. [variableScope]
 const char *name = in_payload;
             ^
lib/fuse_lowlevel.c:1548:14: style: The scope of the variable 'name' can be reduced. [variableScope]
 const char *name = in_payload;
             ^
lib/fuse_lowlevel.c:1606:32: style: The scope of the variable 'arg' can be reduced. [variableScope]
 const struct fuse_rename2_in *arg = op_in;
                               ^
lib/fuse_lowlevel.c:1676:14: style: The scope of the variable 'name' can be reduced. [variableScope]
 const char *name = in_payload;
             ^
lib/fuse_lowlevel.c:1761:14: style: The scope of the variable 'buf' can be reduced. [variableScope]
 const char *buf = in_payload;
             ^
lib/fuse_lowlevel.c:2094:33: style: The scope of the variable 'arg' can be reduced. [variableScope]
 const struct fuse_getxattr_in *arg = op_in;
                                ^
lib/fuse_lowlevel.c:2115:33: style: The scope of the variable 'arg' can be reduced. [variableScope]
 const struct fuse_getxattr_in *arg = inarg;
                                ^
lib/fuse_lowlevel.c:2132:14: style: The scope of the variable 'name' can be reduced. [variableScope]
 const char *name = in_payload;
             ^
lib/fuse_lowlevel.c:2342:29: style: The scope of the variable 'arg' can be reduced. [variableScope]
 const struct fuse_bmap_in *arg = op_in;
                            ^
lib/fuse_lowlevel.c:2359:14: style: The scope of the variable 'in_buf' can be reduced. [variableScope]
 const void *in_buf = in_payload;
             ^
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_;FUSE_USE_VERSION...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;FUSE_USE_VERSION=30...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H;FUSE_USE_VERSION...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;HAVE_PIPE2;O_CLOEXEC;HAVE_SPLICE;FUSE_USE_VERSION...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;HAVE_SPLICE;FUSE_USE_VERSION...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;HAVE_SPLICE;HAVE_VMSPLICE;FUSE_USE_VERSION...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;HAVE_STATX;FUSE_USE_VERSION...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;HAVE_STRUCT_STAT_ST_ATIMESPEC...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;HAVE_SYMVER_ATTRIBUTE...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;USDT_ENABLED;FUSE_USE_VERSION...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;__KERNEL__;FUSE_USE_VERSION...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;__LP64__...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;__STDC_VERSION__;FUSE_USE_VERSION...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;__arm__...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;__i386__...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;__ia64__;__s390__;__s390x__...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;__loongarch__...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;__powerpc64__;__powerpc__...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;__powerpc__...
Checking lib/fuse_lowlevel.c: FUSE_USE_VERSION=319;linux;FUSE_USE_VERSION...
52/75 files checked 78% done
Checking lib/helper.c ...
Checking lib/helper.c: FUSE_USE_VERSION=319...
Checking lib/helper.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_;FUSE_USE_VERSION...
Checking lib/helper.c: FUSE_USE_VERSION=319;FUSE_USE_VERSION=30...
Checking lib/helper.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H;FUSE_USE_VERSION...
Checking lib/helper.c: FUSE_USE_VERSION=319;HAVE_STRUCT_STAT_ST_ATIMESPEC...
Checking lib/helper.c: FUSE_USE_VERSION=319;HAVE_SYMVER_ATTRIBUTE...
Checking lib/helper.c: FUSE_USE_VERSION=319;__FreeBSD__;FUSE_USE_VERSION...
Checking lib/helper.c: FUSE_USE_VERSION=319;__STDC_VERSION__;FUSE_USE_VERSION...
53/75 files checked 80% done
Checking lib/fuse_uring.c ...
Checking lib/fuse_uring.c: FUSE_USE_VERSION=319...
Checking lib/fuse_uring.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_;FUSE_USE_VERSION...
Checking lib/fuse_uring.c: FUSE_USE_VERSION=319;FUSE_USE_VERSION=30...
Checking lib/fuse_uring.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H;FUSE_USE_VERSION...
Checking lib/fuse_uring.c: FUSE_USE_VERSION=319;__KERNEL__;FUSE_USE_VERSION...
Checking lib/fuse_uring.c: FUSE_USE_VERSION=319;__STDC_VERSION__;FUSE_USE_VERSION...
54/75 files checked 82% done
Checking lib/mount.c ...
Checking lib/mount.c: FUSE_USE_VERSION=319...
lib/mount.c:130:63: style: Parameter 'action' can be declared as pointer to const [constParameterPointer]
static int fusermount_posix_spawn(posix_spawn_file_actions_t *action,
                                                              ^
Checking lib/mount.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_;FUSE_USE_VERSION...
Checking lib/mount.c: FUSE_USE_VERSION=319;FUSE_USE_VERSION=30...
Checking lib/mount.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H;FUSE_USE_VERSION...
Checking lib/mount.c: FUSE_USE_VERSION=319;HAVE_STRUCT_STAT_ST_ATIMESPEC...
Checking lib/mount.c: FUSE_USE_VERSION=319;HAVE_SYMVER_ATTRIBUTE...
Checking lib/mount.c: FUSE_USE_VERSION=319;__NetBSD__;FUSE_USE_VERSION...
Checking lib/mount.c: FUSE_USE_VERSION=319;__STDC_VERSION__;FUSE_USE_VERSION...
55/75 files checked 84% done
Checking lib/mount_util.c ...
Checking lib/mount_util.c: FUSE_USE_VERSION=319...
Checking lib/mount_util.c: FUSE_USE_VERSION=319;__ANDROID__;__DragonFly__;__FreeBSD__;__NetBSD__...
Checking lib/mount_util.c: FUSE_USE_VERSION=319;__DragonFly__;__FreeBSD__;__FreeBSD_kernel__;__NetBSD__...
56/75 files checked 85% done
Checking lib/mount_util.h ...
Checking lib/mount_util.h: FUSE_USE_VERSION=319...
57/75 files checked 85% done
Checking lib/util.h ...
Checking lib/util.h: FUSE_USE_VERSION=319...
58/75 files checked 85% done
Checking test/hello.c ...
Checking test/hello.c: FUSE_USE_VERSION=319...
Checking test/hello.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking test/hello.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking test/hello.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
59/75 files checked 86% done
Checking test/readdir_inode.c ...
Checking test/readdir_inode.c: FUSE_USE_VERSION=319...
test/readdir_inode.c:31:12: portability: Non reentrant function 'readdir' called. For threadsafe applications it is recommended to use the reentrant replacement function 'readdir_r'. [readdirCalled]
    dent = readdir(dirp);
           ^
test/readdir_inode.c:47:16: portability: Non reentrant function 'readdir' called. For threadsafe applications it is recommended to use the reentrant replacement function 'readdir_r'. [readdirCalled]
        dent = readdir(dirp);
               ^
test/readdir_inode.c:17:20: style: Variable 'dent' can be declared as pointer to const [constVariablePointer]
    struct dirent* dent;
                   ^
60/75 files checked 86% done
Checking test/release_unlink_race.c ...
Checking test/release_unlink_race.c: FUSE_USE_VERSION=319...
test/release_unlink_race.c:66:56: style: Obsolescent function 'usleep' called. It is recommended to use 'nanosleep' or 'setitimer' instead. [usleepCalled]
        if(!getenv("RELEASEUNLINKRACE_DELAY_DISABLE")) usleep(100000);
                                                       ^
test/release_unlink_race.c:91:56: style: Obsolescent function 'usleep' called. It is recommended to use 'nanosleep' or 'setitimer' instead. [usleepCalled]
        if(!getenv("RELEASEUNLINKRACE_DELAY_DISABLE")) usleep(100000);
                                                       ^
Checking test/release_unlink_race.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking test/release_unlink_race.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking test/release_unlink_race.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
61/75 files checked 86% done
Checking test/stracedecode.c ...
Checking test/stracedecode.c: FUSE_USE_VERSION=319...
test/stracedecode.c:68:3: warning: %i in format string (no. 3) requires 'int' but the argument type is 'unsigned int'. [invalidPrintfArgType_sint]
  printf("unique: %llu, opcode: %s (%i), nodeid: %lu, len: %i, insize: %i\n",
  ^
test/stracedecode.c:68:3: warning: %i in format string (no. 5) requires 'int' but the argument type is 'unsigned int'. [invalidPrintfArgType_sint]
  printf("unique: %llu, opcode: %s (%i), nodeid: %lu, len: %i, insize: %i\n",
  ^
test/stracedecode.c:76:4: warning: %llu in format string (no. 1) requires 'unsigned long long' but the argument type is 'unsigned long'. [invalidPrintfArgType_uint]
   printf("-READ fh:%llu off:%llu siz:%u rfl:%u own:%llu fl:%u\n",
   ^
test/stracedecode.c:76:4: warning: %llu in format string (no. 2) requires 'unsigned long long' but the argument type is 'unsigned long'. [invalidPrintfArgType_uint]
   printf("-READ fh:%llu off:%llu siz:%u rfl:%u own:%llu fl:%u\n",
   ^
test/stracedecode.c:76:4: warning: %llu in format string (no. 5) requires 'unsigned long long' but the argument type is 'unsigned long'. [invalidPrintfArgType_uint]
   printf("-READ fh:%llu off:%llu siz:%u rfl:%u own:%llu fl:%u\n",
   ^
test/stracedecode.c:83:4: warning: %llu in format string (no. 1) requires 'unsigned long long' but the argument type is 'unsigned long'. [invalidPrintfArgType_uint]
   printf("-WRITE fh:%llu off:%llu siz:%u wfl:%u own:%llu fl:%u\n",
   ^
test/stracedecode.c:83:4: warning: %llu in format string (no. 2) requires 'unsigned long long' but the argument type is 'unsigned long'. [invalidPrintfArgType_uint]
   printf("-WRITE fh:%llu off:%llu siz:%u wfl:%u own:%llu fl:%u\n",
   ^
test/stracedecode.c:83:4: warning: %llu in format string (no. 5) requires 'unsigned long long' but the argument type is 'unsigned long'. [invalidPrintfArgType_uint]
   printf("-WRITE fh:%llu off:%llu siz:%u wfl:%u own:%llu fl:%u\n",
   ^
test/stracedecode.c:95:3: warning: %i in format string (no. 4) requires 'int' but the argument type is 'unsigned int'. [invalidPrintfArgType_sint]
  printf("   unique: %llu, error: %i (%s), len: %i, outsize: %i\n",
  ^
test/stracedecode.c:103:5: warning: %llu in format string (no. 1) requires 'unsigned long long' but the argument type is 'unsigned long'. [invalidPrintfArgType_uint]
    printf("+ATTR v:%llu.%09u i:%llu s:%llu b:%llu\n",
    ^
test/stracedecode.c:103:5: warning: %llu in format string (no. 3) requires 'unsigned long long' but the argument type is 'unsigned long'. [invalidPrintfArgType_uint]
    printf("+ATTR v:%llu.%09u i:%llu s:%llu b:%llu\n",
    ^
test/stracedecode.c:103:5: warning: %llu in format string (no. 4) requires 'unsigned long long' but the argument type is 'unsigned long'. [invalidPrintfArgType_uint]
    printf("+ATTR v:%llu.%09u i:%llu s:%llu b:%llu\n",
    ^
test/stracedecode.c:103:5: warning: %llu in format string (no. 5) requires 'unsigned long long' but the argument type is 'unsigned long'. [invalidPrintfArgType_uint]
    printf("+ATTR v:%llu.%09u i:%llu s:%llu b:%llu\n",
    ^
test/stracedecode.c:110:5: warning: %llu in format string (no. 1) requires 'unsigned long long' but the argument type is 'unsigned long'. [invalidPrintfArgType_uint]
    printf("+ENTRY nodeid:%llu v:%llu.%09u i:%llu s:%llu b:%llu\n",
    ^
test/stracedecode.c:110:5: warning: %llu in format string (no. 2) requires 'unsigned long long' but the argument type is 'unsigned long'. [invalidPrintfArgType_uint]
    printf("+ENTRY nodeid:%llu v:%llu.%09u i:%llu s:%llu b:%llu\n",
    ^
test/stracedecode.c:110:5: warning: %llu in format string (no. 4) requires 'unsigned long long' but the argument type is 'unsigned long'. [invalidPrintfArgType_uint]
    printf("+ENTRY nodeid:%llu v:%llu.%09u i:%llu s:%llu b:%llu\n",
    ^
test/stracedecode.c:110:5: warning: %llu in format string (no. 5) requires 'unsigned long long' but the argument type is 'unsigned long'. [invalidPrintfArgType_uint]
    printf("+ENTRY nodeid:%llu v:%llu.%09u i:%llu s:%llu b:%llu\n",
    ^
test/stracedecode.c:110:5: warning: %llu in format string (no. 6) requires 'unsigned long long' but the argument type is 'unsigned long'. [invalidPrintfArgType_uint]
    printf("+ENTRY nodeid:%llu v:%llu.%09u i:%llu s:%llu b:%llu\n",
    ^
test/stracedecode.c:178:14: warning: %x in format string (no. 1) requires 'unsigned int *' but the argument type is 'signed int *'. [invalidScanfArgType_int]
       res = scanf("%x", &val);
             ^
test/stracedecode.c:65:26: style: Variable 'in' can be declared as pointer to const [constVariablePointer]
  struct fuse_in_header *in = (struct fuse_in_header *) buf;
                         ^
test/stracedecode.c:75:25: style: Variable 'arg' can be declared as pointer to const [constVariablePointer]
   struct fuse_read_in *arg = (struct fuse_read_in *) buf;
                        ^
test/stracedecode.c:82:26: style: Variable 'arg' can be declared as pointer to const [constVariablePointer]
   struct fuse_write_in *arg = (struct fuse_write_in *) buf;
                         ^
test/stracedecode.c:92:27: style: Variable 'out' can be declared as pointer to const [constVariablePointer]
  struct fuse_out_header *out = (struct fuse_out_header *) buf;
                          ^
test/stracedecode.c:102:27: style: Variable 'arg' can be declared as pointer to const [constVariablePointer]
    struct fuse_attr_out *arg = (struct fuse_attr_out *) buf;
                          ^
test/stracedecode.c:109:28: style: Variable 'arg' can be declared as pointer to const [constVariablePointer]
    struct fuse_entry_out *arg = (struct fuse_entry_out *) buf;
                           ^
Checking test/stracedecode.c: FUSE_USE_VERSION=319;__KERNEL__...
62/75 files checked 86% done
Checking test/test_abi.c ...
Checking test/test_abi.c: FUSE_USE_VERSION=319...
Checking test/test_abi.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking test/test_abi.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking test/test_abi.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
63/75 files checked 86% done
Checking test/test_setattr.c ...
Checking test/test_setattr.c: FUSE_USE_VERSION=319...
test/test_setattr.c:142:12: warning: Assert statement calls a function which may have desired side effects: 'snprintf'. [assertWithSideEffect]
    assert(snprintf(fname, PATH_MAX, "%s/" FILE_NAME,
           ^
test/test_setattr.c:150:12: warning: Assert statement calls a function which may have desired side effects: 'fchmod'. [assertWithSideEffect]
    assert(fchmod(fd, 0600) == 0);
           ^
test/test_setattr.c:171:12: warning: Assert statement calls a function which may have desired side effects: 'pthread_create'. [assertWithSideEffect]
    assert(pthread_create(&fs_thread, NULL, run_fs, (void *)se) == 0);
           ^
test/test_setattr.c:150:19: warning: Either the condition 'fd==-1' is redundant or fchmod() argument nr 1 can have invalid value. The value is -1 but the valid values are '0:'. [invalidFunctionArg]
    assert(fchmod(fd, 0600) == 0);
                  ^
test/test_setattr.c:145:12: note: Assuming that condition 'fd==-1' is not redundant
    if (fd == -1) {
           ^
test/test_setattr.c:150:19: note: Invalid argument
    assert(fchmod(fd, 0600) == 0);
                  ^
test/test_setattr.c:151:11: warning: Either the condition 'fd==-1' is redundant or close() argument nr 1 can have invalid value. The value is -1 but the valid values are '0:'. [invalidFunctionArg]
    close(fd);
          ^
test/test_setattr.c:145:12: note: Assuming that condition 'fd==-1' is not redundant
    if (fd == -1) {
           ^
test/test_setattr.c:151:11: note: Invalid argument
    close(fd);
          ^
Checking test/test_setattr.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking test/test_setattr.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking test/test_setattr.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
Checking test/test_setattr.c: FUSE_USE_VERSION=319;__linux__...
64/75 files checked 87% done
Checking test/test_signals.c ...
Checking test/test_signals.c: FUSE_USE_VERSION=319...
test/test_signals.c:56:2: style: Obsolescent function 'usleep' called. It is recommended to use 'nanosleep' or 'setitimer' instead. [usleepCalled]
 usleep(2 * 1000 * 1000);
 ^
test/test_signals.c:56:18: error: Invalid usleep() argument nr 1. The value is 2000000 but the valid values are '0:999999'. [invalidFunctionArg]
 usleep(2 * 1000 * 1000);
                 ^
Checking test/test_signals.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking test/test_signals.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking test/test_signals.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
65/75 files checked 87% done
Checking test/test_syscalls.c ...
Checking test/test_syscalls.c: FUSE_USE_VERSION=319...
test/test_syscalls.c:420:8: portability: Non reentrant function 'readdir' called. For threadsafe applications it is recommended to use the reentrant replacement function 'readdir_r'. [readdirCalled]
  de = readdir(dp);
       ^
test/test_syscalls.c:794:8: portability: Non reentrant function 'readdir' called. For threadsafe applications it is recommended to use the reentrant replacement function 'readdir_r'. [readdirCalled]
  de = readdir(dp);
       ^
test/test_syscalls.c:806:8: portability: Non reentrant function 'readdir' called. For threadsafe applications it is recommended to use the reentrant replacement function 'readdir_r'. [readdirCalled]
  de = readdir(dp);
       ^
test/test_syscalls.c:811:8: portability: Non reentrant function 'readdir' called. For threadsafe applications it is recommended to use the reentrant replacement function 'readdir_r'. [readdirCalled]
  de = readdir(dp);
       ^
test/test_syscalls.c:984:8: style: Obsolescent function 'utime' called. It is recommended to use 'utimensat' instead. [utimeCalled]
 res = utime(testfile, &utm);
       ^
test/test_syscalls.c:1934:3: error: Resource leak: fd [resourceLeak]
  return -1;
  ^
test/test_syscalls.c:2038:3: error: Resource leak: fd [resourceLeak]
  return -1;
  ^
test/test_syscalls.c:2072:3: error: Resource leak: fd [resourceLeak]
  return -1;
  ^
test/test_syscalls.c:2083:3: error: Resource leak: fd [resourceLeak]
  return -1;
  ^
test/test_syscalls.c:2088:3: error: Resource leak: fd [resourceLeak]
  return -1;
  ^
test/test_syscalls.c:275:56: style: Parameter 'st' can be declared as pointer to const [constParameterPointer]
static int fcheck_stat(int fd, int flags, struct stat *st)
                                                       ^
Checking test/test_syscalls.c: FUSE_USE_VERSION=319;HAVE_COPY_FILE_RANGE...
Checking test/test_syscalls.c: FUSE_USE_VERSION=319;HAVE_STATX...
66/75 files checked 92% done
Checking test/test_want_conversion.c ...
Checking test/test_want_conversion.c: FUSE_USE_VERSION=319...
Checking test/test_want_conversion.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking test/test_want_conversion.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking test/test_want_conversion.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
67/75 files checked 93% done
Checking test/test_write_cache.c ...
Checking test/test_write_cache.c: FUSE_USE_VERSION=319...
test/test_write_cache.c:232:9: warning: Assert statement calls a function which may have desired side effects: 'read'. [assertWithSideEffect]
 assert(read(fd, buf, dsize) == dsize);
        ^
test/test_write_cache.c:235:9: warning: Assert statement calls a function which may have desired side effects: 'snprintf'. [assertWithSideEffect]
 assert(snprintf(fname, PATH_MAX, "%s/" FILE_NAME, mountpoint) > 0);
        ^
test/test_write_cache.c:245:10: warning: Assert statement calls a function which may have desired side effects: 'pthread_create'. [assertWithSideEffect]
  assert(pthread_create(&rofd_thread, NULL, close_rofd,
         ^
test/test_write_cache.c:252:10: warning: Assert statement calls a function which may have desired side effects: 'pwrite'. [assertWithSideEffect]
  assert(pwrite(fd, buf + off, iosize, off) == iosize);
         ^
test/test_write_cache.c:262:10: warning: Assert statement calls a function which may have desired side effects: 'pthread_join'. [assertWithSideEffect]
  assert(pthread_join(rofd_thread, NULL) == 0);
         ^
test/test_write_cache.c:285:9: warning: Assert statement calls a function which may have desired side effects: 'pthread_create'. [assertWithSideEffect]
 assert(pthread_create(&fs_thread, NULL, run_fs, (void *)se) == 0);
        ^
test/test_write_cache.c:294:9: warning: Assert statement calls a function which may have desired side effects: 'pthread_join'. [assertWithSideEffect]
 assert(pthread_join(fs_thread, NULL) == 0);
        ^
test/test_write_cache.c:170:3: style: Obsolescent function 'usleep' called. It is recommended to use 'nanosleep' or 'setitimer' instead. [usleepCalled]
  usleep(options.delay_ms * 1000);
  ^
test/test_write_cache.c:248:3: style: Obsolescent function 'usleep' called. It is recommended to use 'nanosleep' or 'setitimer' instead. [usleepCalled]
  usleep(options.delay_ms * 1000);
  ^
test/test_write_cache.c:249:2: error: Resource leak: rofd [resourceLeak]
 }
 ^
Checking test/test_write_cache.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking test/test_write_cache.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking test/test_write_cache.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
Checking test/test_write_cache.c: FUSE_USE_VERSION=319;__linux__...
68/75 files checked 93% done
Checking test/wrong_command.c ...
Checking test/wrong_command.c: FUSE_USE_VERSION=319...
Checking test/wrong_command.c: FUSE_USE_VERSION=319;MESON_IS_SUBPROJECT...
69/75 files checked 93% done
Checking test/test_teardown_watchdog.c ...
Checking test/test_teardown_watchdog.c: FUSE_USE_VERSION=319...
test/test_teardown_watchdog.c:71:2: style: Obsolescent function 'usleep' called. It is recommended to use 'nanosleep' or 'setitimer' instead. [usleepCalled]
 usleep(uta->delay_ms * 1000);
 ^
test/test_teardown_watchdog.c:165:2: style: Obsolescent function 'usleep' called. It is recommended to use 'nanosleep' or 'setitimer' instead. [usleepCalled]
 usleep(500 * 1000);
 ^
test/test_teardown_watchdog.c:180:3: style: Obsolescent function 'usleep' called. It is recommended to use 'nanosleep' or 'setitimer' instead. [usleepCalled]
  usleep(100 * 1000);
  ^
Checking test/test_teardown_watchdog.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking test/test_teardown_watchdog.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking test/test_teardown_watchdog.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
70/75 files checked 94% done
Checking util/fusermount.c ...
Checking util/fusermount.c: FUSE_USE_VERSION=319...
util/fusermount.c:185:22: portability: Non reentrant function 'getpwuid' called. For threadsafe applications it is recommended to use the reentrant replacement function 'getpwuid_r'. [getpwuidCalled]
 struct passwd *pw = getpwuid(getuid());
                     ^
util/fusermount.c:1328:12: warning: If memory allocation fails, then there is a possible null pointer dereference: x_mnt_opts [nullPointerOutOfMemory]
   strncat(x_mnt_opts, x_opts,
           ^
util/fusermount.c:1321:29: note: Assuming allocation function fails
   char *x_mnt_opts = calloc(1, x_mnt_opts_len);
                            ^
util/fusermount.c:1321:29: note: Assignment 'x_mnt_opts=calloc(1,x_mnt_opts_len)', assigned value is 0
   char *x_mnt_opts = calloc(1, x_mnt_opts_len);
                            ^
util/fusermount.c:1328:12: note: Null pointer dereference
   strncat(x_mnt_opts, x_opts,
           ^
util/fusermount.c:357:14: style: The scope of the variable 'mnt' can be reduced. [variableScope]
 const char *mnt = a[1];
             ^
util/fusermount.c:602:6: style: The scope of the variable 'n_mounts' can be reduced. [variableScope]
 int n_mounts = 0;
     ^
util/fusermount.c:609:20: style: Variable 'sm' can be declared as pointer to const [constVariablePointer]
 struct statmount *sm;
                   ^
util/fusermount.c:602:15: style: Variable 'n_mounts' is assigned a value that is never used. [unreadVariable]
 int n_mounts = 0;
              ^
util/fusermount.c:603:10: style: Variable 'ret' is assigned a value that is never used. [unreadVariable]
 int ret = 0;
         ^
Checking util/fusermount.c: FUSE_USE_VERSION=319;GETMNTENT_NEEDS_UNESCAPING...
Checking util/fusermount.c: FUSE_USE_VERSION=319;HAVE_CLOSE_RANGE...
Checking util/fusermount.c: FUSE_USE_VERSION=319;HAVE_CLOSE_RANGE;linux...
Checking util/fusermount.c: FUSE_USE_VERSION=319;HAVE_LISTMOUNT...
Checking util/fusermount.c: FUSE_USE_VERSION=319;IGNORE_MTAB...
Checking util/fusermount.c: FUSE_USE_VERSION=319;__ia64__...
71/75 files checked 98% done
Checking util/mount.fuse.c ...
Checking util/mount.fuse.c: FUSE_USE_VERSION=319...
util/mount.fuse.c:314:10: portability: Non reentrant function 'strtok' called. For threadsafe applications it is recommended to use the reentrant replacement function 'strtok_r'. [strtokCalled]
   opt = strtok(opts, ",");
         ^
util/mount.fuse.c:348:11: portability: Non reentrant function 'strtok' called. For threadsafe applications it is recommended to use the reentrant replacement function 'strtok_r'. [strtokCalled]
    opt = strtok(NULL, ",");
          ^
util/mount.fuse.c:409:24: portability: Non reentrant function 'getpwnam' called. For threadsafe applications it is recommended to use the reentrant replacement function 'getpwnam_r'. [getpwnamCalled]
  struct passwd *pwd = getpwnam(setuid_name);
                       ^
util/mount.fuse.c:409:18: style: Variable 'pwd' can be declared as pointer to const [constVariablePointer]
  struct passwd *pwd = getpwnam(setuid_name);
                 ^
Checking util/mount.fuse.c: FUSE_USE_VERSION=319;FUSE_LOWLEVEL_H_...
Checking util/mount.fuse.c: FUSE_USE_VERSION=319;FUSE_USE_VERSION=30...
Checking util/mount.fuse.c: FUSE_USE_VERSION=319;HAVE_LIBFUSE_PRIVATE_CONFIG_H...
Checking util/mount.fuse.c: FUSE_USE_VERSION=319;SECBIT_KEEP_CAPS;SECURE_KEEP_CAPS;linux...
util/mount.fuse.c:212:4: warning: %u in format string (no. 2) requires 'unsigned int' but the argument type is 'signed int'. [invalidPrintfArgType_uint]
   fprintf(stderr,
   ^
util/mount.fuse.c:218:4: warning: %u in format string (no. 2) requires 'unsigned int' but the argument type is 'signed int'. [invalidPrintfArgType_uint]
   fprintf(stderr,
   ^
Checking util/mount.fuse.c: FUSE_USE_VERSION=319;SECBIT_KEEP_CAPS_LOCKED;SECURE_KEEP_CAPS_LOCKED;linux...
Checking util/mount.fuse.c: FUSE_USE_VERSION=319;SECBIT_NOROOT;SECURE_NOROOT;linux...
Checking util/mount.fuse.c: FUSE_USE_VERSION=319;SECBIT_NOROOT_LOCKED;SECURE_NOROOT_LOCKED;linux...
Checking util/mount.fuse.c: FUSE_USE_VERSION=319;SECBIT_NO_SETUID_FIXUP;SECURE_NO_SETUID_FIXUP;linux...
Checking util/mount.fuse.c: FUSE_USE_VERSION=319;SECBIT_NO_SETUID_FIXUP_LOCKED;SECURE_NO_SETUID_FIXUP_LOCKED;linux...
Checking util/mount.fuse.c: FUSE_USE_VERSION=319;__STDC_VERSION__...
Checking util/mount.fuse.c: FUSE_USE_VERSION=319;linux...
72/75 files checked 99% done
Checking build-x86_64/meson-private/sanitycheckc.c ...
Checking build-x86_64/meson-private/sanitycheckc.c: FUSE_USE_VERSION=319...
73/75 files checked 99% done
Checking build-x86_64/fuse_config.h ...
Checking build-x86_64/fuse_config.h: FUSE_USE_VERSION=319...
74/75 files checked 99% done
Checking build-x86_64/libfuse_config.h ...
Checking build-x86_64/libfuse_config.h: FUSE_USE_VERSION=319...
75/75 files checked 100% done
include/fuse.h:923:0: style: The function 'fuse_main_real' is never used. [unusedFunction]
static inline int fuse_main_real(int argc, char *argv[],
^
lib/fuse.c:370:0: style: The function 'list_add_head' is never used. [unusedFunction]
static inline void list_add_head(struct list_head *new, struct list_head *head)
^
lib/fuse.c:1819:0: style: The function 'fuse_fs_read' is never used. [unusedFunction]
int fuse_fs_read(struct fuse_fs *fs, const char *path, char *mem, size_t size,
^
lib/fuse.c:1924:0: style: The function 'fuse_fs_write' is never used. [unusedFunction]
int fuse_fs_write(struct fuse_fs *fs, const char *path, const char *mem,
^
lib/fuse.c:4718:0: style: The function 'fuse_loop_mt_31' is never used. [unusedFunction]
int fuse_loop_mt_31(struct fuse *f, int clone_fd)
^
lib/fuse.c:4735:0: style: The function 'fuse_exit' is never used. [unusedFunction]
void fuse_exit(struct fuse *f)
^
lib/fuse.c:4750:0: style: The function 'fuse_getgroups' is never used. [unusedFunction]
int fuse_getgroups(int size, gid_t list[])
^
lib/fuse.c:4759:0: style: The function 'fuse_interrupted' is never used. [unusedFunction]
int fuse_interrupted(void)
^
lib/fuse.c:5213:0: style: The function 'fuse_new_30' is never used. [unusedFunction]
struct fuse *fuse_new_30(struct fuse_args *args,
^
lib/fuse.c:5299:0: style: The function 'fuse_version' is never used. [unusedFunction]
int fuse_version(void)
^
lib/fuse_log.c:32:0: style: The function 'fuse_set_log_func' is never used. [unusedFunction]
void fuse_set_log_func(fuse_log_func_t func)
^
lib/fuse_log.c:49:0: style: The function 'fuse_log_enable_syslog' is never used. [unusedFunction]
void fuse_log_enable_syslog(const char *ident, int option, int facility)
^
lib/fuse_log.c:56:0: style: The function 'fuse_log_close_syslog' is never used. [unusedFunction]
void fuse_log_close_syslog(void)
^
lib/fuse_loop_mt.c:439:0: style: The function 'fuse_session_loop_mt_32' is never used. [unusedFunction]
int fuse_session_loop_mt_32(struct fuse_session *se, const struct fuse_loop_config_v1 *config_v1)
^
lib/fuse_loop_mt.c:463:0: style: The function 'fuse_session_loop_mt_31' is never used. [unusedFunction]
int fuse_session_loop_mt_31(struct fuse_session *se, int clone_fd)
^
lib/fuse_lowlevel.c:365:0: style: The function 'fuse_reply_iov' is never used. [unusedFunction]
int fuse_reply_iov(fuse_req_t req, const struct iovec *iov, int count)
^
lib/fuse_lowlevel.c:580:0: style: The function 'fuse_passthrough_open' is never used. [unusedFunction]
int fuse_passthrough_open(fuse_req_t req, int fd)
^
lib/fuse_lowlevel.c:594:0: style: The function 'fuse_passthrough_close' is never used. [unusedFunction]
int fuse_passthrough_close(fuse_req_t req, int backing_id)
^
lib/fuse_lowlevel.c:3240:0: style: The function 'fuse_lowlevel_notify_delete' is never used. [unusedFunction]
int fuse_lowlevel_notify_delete(struct fuse_session *se,
^
lib/fuse_lowlevel.c:3450:0: style: The function 'fuse_req_is_uring' is never used. [unusedFunction]
bool fuse_req_is_uring(fuse_req_t req)
^
lib/fuse_lowlevel.c:4177:0: style: The function 'fuse_session_receive_buf' is never used. [unusedFunction]
int fuse_session_receive_buf(struct fuse_session *se, struct fuse_buf *buf)
^
lib/fuse_lowlevel.c:4397:0: style: The function 'fuse_session_custom_io_30' is never used. [unusedFunction]
int fuse_session_custom_io_30(struct fuse_session *se,
^
lib/fuse_lowlevel.c:4464:0: style: The function 'fuse_session_fd' is never used. [unusedFunction]
int fuse_session_fd(const struct fuse_session *se)
^
lib/fuse_lowlevel.c:4561:0: style: The function 'fuse_session_reset' is never used. [unusedFunction]
void fuse_session_reset(struct fuse_session *se)
^
lib/fuse_opt.c:201:0: style: The function 'fuse_opt_match' is never used. [unusedFunction]
int fuse_opt_match(const struct fuse_opt *opts, const char *opt)
^
lib/fuse_signals.c:175:0: style: The function 'fuse_set_fail_signal_handlers' is never used. [unusedFunction]
int fuse_set_fail_signal_handlers(struct fuse_session *se)
^
lib/fuse_uring.c:209:0: style: The function 'fuse_req_get_payload' is never used. [unusedFunction]
int fuse_req_get_payload(fuse_req_t req, char **payload, size_t *payload_sz,
^
lib/helper.c:237:0: style: The function 'fuse_parse_cmdline_30' is never used. [unusedFunction]
int fuse_parse_cmdline_30(struct fuse_args *args,
^
lib/helper.c:422:0: style: The function 'fuse_apply_conn_info_opts' is never used. [unusedFunction]
void fuse_apply_conn_info_opts(const struct fuse_conn_info_opts *opts,
^
lib/helper.c:476:0: style: The function 'fuse_parse_conn_info_opts' is never used. [unusedFunction]
struct fuse_conn_info_opts* fuse_parse_conn_info_opts(struct fuse_args *args)
^
lib/cuse_lowlevel.c:147:0: style: The function 'cuse_lowlevel_new' should have static linkage since it is not used outside of its translation unit. [staticFunction]
struct fuse_session *cuse_lowlevel_new(struct fuse_args *args,
^
lib/cuse_lowlevel.c:273:0: style: The function 'cuse_lowlevel_setup' should have static linkage since it is not used outside of its translation unit. [staticFunction]
struct fuse_session *cuse_lowlevel_setup(int argc, char *argv[],
^
lib/cuse_lowlevel.c:344:0: style: The function 'cuse_lowlevel_teardown' should have static linkage since it is not used outside of its translation unit. [staticFunction]
void cuse_lowlevel_teardown(struct fuse_session *se)
^
lib/fuse.c:2253:0: style: The function 'fuse_fs_ioctl' should have static linkage since it is not used outside of its translation unit. [staticFunction]
int fuse_fs_ioctl(struct fuse_fs *fs, const char *path, unsigned int cmd,
^
lib/fuse.c:2267:0: style: The function 'fuse_fs_poll' should have static linkage since it is not used outside of its translation unit. [staticFunction]
int fuse_fs_poll(struct fuse_fs *fs, const char *path,
^
lib/fuse.c:2290:0: style: The function 'fuse_fs_fallocate' should have static linkage since it is not used outside of its translation unit. [staticFunction]
int fuse_fs_fallocate(struct fuse_fs *fs, const char *path, int mode,
^
lib/fuse.c:2306:0: style: The function 'fuse_fs_copy_file_range' should have static linkage since it is not used outside of its translation unit. [staticFunction]
ssize_t fuse_fs_copy_file_range(struct fuse_fs *fs, const char *path_in,
^
lib/fuse.c:2377:0: style: The function 'fuse_fs_syncfs' should have static linkage since it is not used outside of its translation unit. [staticFunction]
int fuse_fs_syncfs(struct fuse_fs *fs, const char *path)
^
lib/fuse.c:4526:0: style: The function 'fuse_clean_cache' should have static linkage since it is not used outside of its translation unit. [staticFunction]
int fuse_clean_cache(struct fuse *f)
^
lib/fuse.c:4685:0: style: The function 'fuse_loop_mt_312' should have static linkage since it is not used outside of its translation unit. [staticFunction]
int fuse_loop_mt_312(struct fuse *f, struct fuse_loop_config *config)
^
lib/fuse.c:5001:0: style: The function 'fuse_start_cleanup_thread' should have static linkage since it is not used outside of its translation unit. [staticFunction]
int fuse_start_cleanup_thread(struct fuse *f)
^
lib/fuse.c:5009:0: style: The function 'fuse_stop_cleanup_thread' should have static linkage since it is not used outside of its translation unit. [staticFunction]
void fuse_stop_cleanup_thread(struct fuse *f)
^
lib/fuse.c:5196:0: style: The function 'fuse_new_31' should have static linkage since it is not used outside of its translation unit. [staticFunction]
struct fuse *fuse_new_31(struct fuse_args *args,
^
lib/fuse_loop_mt.c:497:0: style: The function 'fuse_loop_cfg_verify' should have static linkage since it is not used outside of its translation unit. [staticFunction]
int fuse_loop_cfg_verify(const struct fuse_loop_config *config)
^
lib/fuse_opt.c:95:0: style: The function 'fuse_opt_insert_arg' should have static linkage since it is not used outside of its translation unit. [staticFunction]
int fuse_opt_insert_arg(struct fuse_args *args, int pos, const char *arg)
^
lib/helper.c:208:0: style: The function 'fuse_parse_cmdline_312' should have static linkage since it is not used outside of its translation unit. [staticFunction]
int fuse_parse_cmdline_312(struct fuse_args *args,
^
nofile:0:0: information: Active checkers: 109/856 (use --checkers-report=<filename> to see details) [checkersReport]

