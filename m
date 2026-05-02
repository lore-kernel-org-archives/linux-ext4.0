Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F672690F9;
	Sat,  2 May 2026 16:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777741116; cv=none; b=U0/HfeJ2ZmgSGskahBsz7spDz7ZlwT1YoJ1FBeVQEykgFoC5xCSw7cleYnVBishYMw6kXFAFi+++F0Y8jMm6qIUIZknGamEwP7LYpAqYR3LkeMpzS9RYtnBAmq5se1gkP5NHvTX7PgOzRSV2EmJX1YvULleOVV7PLgNFKNQ5KE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777741116; c=relaxed/simple;
	bh=NlJotEAPvdeiXGVbGrZy9HqjXoR1yUb+HtqUZ9GpHn4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jDvzqhdj44p3SrX9rAqylQcNDON6src7yy0KhnyexXBg2dbqnJ58ke8jx9tk8MMRKJWswzaLTaHFMOkE8TsWSnYGLrxf0fGDJtzILLEwfslfnhSCYLwUKkJ8w2TNzQ5OuKcAlQ+8JeWAhrv9YAnbq9cnuwB50jd79hKWzQb+zlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=PCPIQYrS; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=QKDoxfm4; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="PCPIQYrS";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="QKDoxfm4"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 3F0C4EC009D;
	Sat,  2 May 2026 12:58:33 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Sat, 02 May 2026 12:58:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1777741113;
	 x=1777827513; bh=yoijN2NrJuHc4VN/n85wB/Sw/w5f9YmHkW06gFdCPgw=; b=
	PCPIQYrS7vrnOY2J1nw8h4swcTIBWWzUzdwts81IsX0cSkOkftqsQq95Vx7BwBdC
	QlbGgGRlySwB0k+eF/7ch1mH2IF/xDZ1Rlf2hwPcKBLPZMIKz3/tT/AssdT11hA6
	G6TNVEVsVxCQjtutsaK/4uIF30eAuTuMHjbsSCPhuNRCJ1wGmRxAop6fHMYQteOO
	QZFKm89/C75bnq49rkDFYzGaw5piU4LNya+2iQSv71Vn/HwY7cAWlYFOgmey/JaG
	HIP7+kY8zl6spJox7Vz0zYKwReo0w8g4TQJWG6CcGHfJUGU3djI6XwxoU5N6zkvm
	E+n/TVA9I3cmWaeydlNOtQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1777741113; x=
	1777827513; bh=yoijN2NrJuHc4VN/n85wB/Sw/w5f9YmHkW06gFdCPgw=; b=Q
	KDoxfm4UCdsdh5HDhbWLDIiKWA/fIktAU47GIxLQA6HRjOTtdn+Ka1tMbWr3vjw9
	2KUQ6A39MnaUZJ38+PcEd+EcZSEdmmk6y9qQFeXLCzFFDiZoPB0v+SC0qklsdDej
	hQM0BXz/3PJeFfMDC5XkGLFur11RPvTOL7iaAtR/EkHXsM3zXicIQWHkfvyJjhUS
	IJQiKbqqXxKAP2MoQVfs/44bJ5GzcgqbnPtriznp1YePnGBfpZOUKNOXBNNdTmDW
	BUSitFTF8Du4HwJYVoHi/yRusF1H+vPtX2dSqiDz4BtodR6N8sxUZzYtch5ZHS4i
	/R0HhuXdszf91+IXlBxFA==
X-ME-Sender: <xms:OC32aQ403ACl1Oiv6jFXpNtbhuYm1UxHVx5iiZ_MhiqRwKyKzfwhtg>
    <xme:OC32ab8dvKci-e74QDC87xRc3xkmPWkHna5RfJEV3hXFVxnTfmG6IvZJNcKl2ZLBo
    qwHPvU_3JZiTFm0nKEYlpW8tpjx3HsT_CSaW-2ae68tJVEZ9GJTrA>
X-ME-Received: <xmr:OC32afWfwO8wy_yd5y-tudVf0J0vVGPQQTcgS0tg5SEZDIsTPghdNUw0d3ja35x-w18VZQ39lBrY1OtSw3HtiShij7b8XrqksGRDDLFYC44UYDSmhA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdelfeeivdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepuegvrhhnugcu
    ufgthhhusggvrhhtuceosggvrhhnugessghssggvrhhnugdrtghomheqnecuggftrfgrth
    htvghrnhepkeelkefhkeejveetieefuddtkeetffduledufedtveffvdejhfevteejudff
    leetnecuffhomhgrihhnpehfuhhsvggpshgvrhhvihgtvggpshhtuhgsrdgtfidpghhith
    hhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepsggvrhhnugessghssggvrhhnugdrtghomhdpnhgspghrtghpthhtohepjedpmh
    houggvpehsmhhtphhouhhtpdhrtghpthhtohepughjfihonhhgsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehfuhhsvgdquggvvhgvlheslhhishhtshdrlhhinhhugidruggvvh
    dprhgtphhtthhopehjohgrnhhnvghlkhhoohhnghesghhmrghilhdrtghomhdprhgtphht
    thhopehlihhnuhigqdgvgihtgeesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghp
    thhtohepmhhikhhlohhssehsiigvrhgvughirdhhuhdprhgtphhtthhopehnvggrlhesgh
    homhhprgdruggvvh
X-ME-Proxy: <xmx:OC32aWo0_57KvoavZFqXj48C3_pw_EGabY0Je_0lYcJED2Fu0OOG_Q>
    <xmx:OC32aRlLBc0gzuLfyHTEUOoY0OksisvI92PE_M6tYCHU1jf_seO9og>
    <xmx:OC32aW2NrmpgCxZcRRp0YU2my3rDlWkAGv4oqzS4C-8nk1CpdmG47A>
    <xmx:OC32aeSzHE62YkDkhzyyXwrljCFjcSV0M_CXLHVi7SeigOoQZxaOww>
    <xmx:OS32aeC5s6sgONGDZK1f7WIbMjB35CYPGsFWXsDUxiFozSeXinTvSusN>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 2 May 2026 12:58:31 -0400 (EDT)
Message-ID: <c88d39e4-0a67-4de6-9d7d-353f8c950c81@bsbernd.com>
Date: Sat, 2 May 2026 18:58:30 +0200
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL v5.1] libfuse: run fuse servers as a contained service
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fuse-devel@lists.linux.dev, joannelkoong@gmail.com,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 miklos@szeredi.hu, neal@gompa.dev
References: <177758364789.1315233.15610945404741826500.stg-ugh@frogsfrogsfrogs>
 <9c920b17-81a8-4c1e-921e-4c08cc290cb5@bsbernd.com>
 <20260430224911.GN7765@frogsfrogsfrogs>
 <2f2ba053-53a7-43e5-969a-32d185e9c7b7@bsbernd.com>
 <20260502163027.GO7765@frogsfrogsfrogs>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: fr
In-Reply-To: <20260502163027.GO7765@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/2/26 18:30, Darrick J. Wong wrote:
> On Sat, May 02, 2026 at 05:59:06PM +0200, Bernd Schubert wrote:
>>
>>
>> On 5/1/26 00:49, Darrick J. Wong wrote:
>>> On Thu, Apr 30, 2026 at 11:34:06PM +0200, Bernd Schubert wrote:
>>>> Hi Darrick,
>>>>
>>>> On 4/30/26 23:18, Darrick J. Wong wrote:
>>>>> Hi Bernd,
>>>>>
>>>>> Please pull this branch with changes for libfuse.
>>>>>
>>>>> As usual, I did a test-merge with the main upstream branch as of a few
>>>>> minutes ago, and didn't see any conflicts.  Please let me know if you
>>>>> encounter any problems.
>>>>
>>>> pushed to my github branch. BSD build fails with
>>>>
>>>> 2026-04-30T21:25:16.3874802Z FAILED: [code=1] lib/libfuse3.so.3.19.0 
>>>> 2026-04-30T21:25:16.3906762Z cc  -o lib/libfuse3.so.3.19.0 lib/libfuse3.so.3.19.0.p/fuse.c.o lib/libfuse3.so.3.19.0.p/fuse_loop.c.o lib/libfuse3.so.3.19.0.p/fuse_loop_mt.c.o lib/libfuse3.so.3.19.0.p/fuse_lowlevel.c.o lib/libfuse3.so.3.19.0.p/fuse_opt.c.o lib/libfuse3.so.3.19.0.p/fuse_signals.c.o lib/libfuse3.so.3.19.0.p/buffer.c.o lib/libfuse3.so.3.19.0.p/cuse_lowlevel.c.o lib/libfuse3.so.3.19.0.p/helper.c.o lib/libfuse3.so.3.19.0.p/modules_subdir.c.o lib/libfuse3.so.3.19.0.p/mount_util.c.o lib/libfuse3.so.3.19.0.p/fuse_log.c.o lib/libfuse3.so.3.19.0.p/compat.c.o lib/libfuse3.so.3.19.0.p/util.c.o lib/libfuse3.so.3.19.0.p/mount_bsd.c.o lib/libfuse3.so.3.19.0.p/fuse_service_stub.c.o lib/libfuse3.so.3.19.0.p/modules_iconv.c.o -Wl,--as-needed -Wl,--no-undefined -shared -fPIC -Wl,-soname,libfuse3.so.4 -Wl,--version-script,/home/runner/work/libfuse/libfuse/lib/fuse_versionscript -pthread -Wl,--start-group -ldl -lrt -Wl,--end-group
>>>> 2026-04-30T21:25:16.3939590Z ld: error: version script assignment of 'FUSE_3.19' to symbol 'fuse_service_can_allow_other' failed: symbol not defined
>>>
>>> Aha, that function got left out of the stub. :(
>>>
>>> Annoyingly, on Linux the build succeeds despite the missing symbol
>>> when I tweak meson so that it doesn't build the service stuff.  I would
>>> have thought that --no-undefined would have done that, but alas.
>>>
>>> Sorry about that too.  The following patch fixes it.
>>>
>>> diff --git i/lib/fuse_service_stub.c w/lib/fuse_service_stub.c
>>> index d34df3891a6e31..231b98423df628 100644
>>> --- i/lib/fuse_service_stub.c
>>> +++ w/lib/fuse_service_stub.c
>>> @@ -49,12 +49,17 @@ int fuse_service_send_goodbye(struct fuse_service *sf, int error)
>>>  int fuse_service_accept(struct fuse_service **sfp)
>>>  {
>>>  	*sfp = NULL;
>>>  	return 0;
>>>  }
>>>  
>>> +bool fuse_service_can_allow_other(struct fuse_service *sf)
>>> +{
>>> +	return false;
>>> +}
>>> +
>>>  int fuse_service_append_args(struct fuse_service *sf,
>>>  			     struct fuse_args *existing_args)
>>>  {
>>>  	return -EOPNOTSUPP;
>>>  }
>>>  
>>>
>>>> 2026-04-30T21:25:16.3951874Z cc: error: linker command failed with exit code 1 (use -v to see invocation)
>>>> 2026-04-30T21:25:16.4291582Z [44/82] cc -Itest/test_teardown_watchdog.p -Itest -I../test -Iinclude -I../include -Ilib -I../lib -I. -I.. -fdiagnostics-color=always -
>>>>
>>>>
>>>> checkpatch, CodeChecker-cppcheck, CodeChecker-gcc also all fail. This CodeQL
>>>
>>> Not sure why checkpatch fails, this is what I got (Debian 13):
>>>
>>> $ git diff origin/master.. | ./checkpatch.pl --max-line-length=100 --no-tree --ignore MAINTAINERS,SPDX_LICENSE_TAG,COMMIT_MESSAGE,FILE_PATH_CHANGES,EMAIL_SUBJECT,AVOID_EXTERNS,GIT_COMMIT_ID,ENOSYS_SYSCALL,ENOSYS,FROM_SIGN_OFF_MISMATCH,QUOTED_COMMIT_ID,,PREFER_ATTRIBUTE_ALWAYS_UNUSED,PREFER_DEFINED_ATTRIBUTE_MACRO,STRCPY,STRNCPY -
>>> No typos will be found - file '/storage/home/djwong/cdev/work/libfuse/spelling.txt': No such file or directory
>>> No structs that should be const will be found - file '/storage/home/djwong/cdev/work/libfuse/const_structs.checkpatch': No such file or directory
>>> total: 0 errors, 0 warnings, 3908 lines checked
>>>
>>> Your patch has no obvious style problems and is ready for submission.
>>>
>>> NOTE: Ignored message types: AVOID_EXTERNS COMMIT_MESSAGE EMAIL_SUBJECT ENOSYS ENOSYS_SYSCALL FILE_PATH_CHANGES FROM_SIGN_OFF_MISMATCH GIT_COMMIT_ID MAINTAINERS PREFER_ATTRIBUTE_ALWAYS_UNUSED PREFER_DEFINED_ATTRIBUTE_MACRO QUOTED_COMMIT_ID SPDX_LICENSE_TAG STRCPY STRNCPY
>>>
>>> cppcheck had a few things to say, but none of it was about the changed
>>> lines.
>>>
>>>> report is funny
>>>>
>>>>> int mount_service_main(int argc, char *argv[])
>>>>> Warning
>>>>> Poorly documented large function
>>>>> Poorly documented function: fewer than 2% comments for a function of 113 lines.
>>>>> CodeQL
>>>
>>> Hrmm.  I guess I'll have to figure out how to get those things running.
>>> That said, the stuff in mount_service.c is internal to libfuse (i.e.
>>> it's not public library API) so I didn't comment them as intensely.
>>> Would you like more?
>>>
>>>> I think I'm going to merge my sync fuse init series tomorrow.
>>>
>>> Yay!
>>>
>>>> Are you ok if skip posting another version of the series?
>>>
>>>                ^ is there an "I" here?  e.g. "...if I skip posting..."?
>>>
>>> /My/ normal practice (from xfs) was to repost the series as it was
>>> merged, followed by an announcement.  That way the mailing list is a
>>> complete record of what was merged.  However, very very few people
>>> actually do that, even in the kernel.
>>>
>>> I'm ok with you not posting another version of the series.
>>>
>>>> Or do you prefer to review the recent changes and last piece I'm going
>>>> to do tomorrow?
>>>
>>> Nah, just merge it.  I'll look over the changes once it's in the branch
>>> and if there's anything weird, you or I or anyone else can send patches.
>>> As long as you're not planning to tag it as a release, nothing's set in
>>> stone.
>>>
>>>> Basically my goal is to rebase your series against it immediately and
>>>> to merge your series during the next few days.
>>>
>>> <nod> Let me know what you want changed, I'll be around since I am not
>>> travelling anywhere for a couple of weeks. :)
>>>
>>> I can reflow changes into the patchset, or if you'd prefer, I can add
>>> them as new patches that would go on the end of the series.
>>>
>>
>> Hi Darrick,
>>
>> eventually merged my patches and made a quick rebase and conflict 
>> resolving with your branch. Github still reports plenty of issues ;)
>>
>> Could you fix all of the checkpatch isssues? This one shows plenty
>> "util: hoist the fuse.conf parsing and setuid mode enforcement code"
>>
>> bschubert2@imesrv6 libfuse.git>stg series
>> + mount_service-add-systemd
>> + mount_service-create-high
>> + mount_service-use-the-new
>> + mount_service-update-mtab
>>> util-hoist-the-fuse.conf
>> - util-fix-checkpatch-complaints
>> - mount_service-enable
>> - mount.fuse3-integrate-systemd
>> - mount_service-allow
>> - example-service_ll-create-a
>> - example-service-create-a
>> - nullfs-support-fuse-systemd
>> - meson-show-feature-summary
>> bschubert2@imesrv6 libfuse.git>.github/workflows/run-checkpatch.sh 
>> No typos will be found - file '/home/bschubert2/src/libfuse/libfuse.git/spelling.txt': No such file or directory
>> No structs that should be const will be found - file '/home/bschubert2/src/libfuse/libfuse.git/const_structs.checkpatch': No such file or directory
>> ERROR:GLOBAL_INITIALISERS: do not initialise globals to 0
>> #61: FILE: util/fuser_conf.c:33:
>> +int user_allow_other = 0;
>>
>> WARNING:LINE_SPACING: Missing a blank line after declarations
>> #74: FILE: util/fuser_conf.c:46:
>> +	char *dest = buf;
>> +	while (1) {
> 
> Oh!  The checkpatch fixes are all in the next commit
> "util-fix-checkpatch-complaints".  I kept the checkpatch fixes as a
> separate commit so that the hoist change can be inspected more easily.

That is not going to work, the script it set up to check every commit in
the PR branch.

> 
> (XFS practice is to have separate patches for moving the code and
> cleaning it up)
> 
>> ...
>>
>> I don't have a strong opinion about these two above - feel 
>> free to disable them. However, in order to merge it, it would
>> be good to run without any checkpatch report.
>> And everything that cppcheck and gcc-checker reports, definitely 
>> need to be fixed.
> 
> Hrm, should I try to fix the things that cppcheck complains about in
> HEAD?  There's an awful lot of them...
> 
> (oh, I see you pushed to master, I'll go rebase now)

I had already rebased:

https://github.com/bsbernd/libfuse/tree/fuse-service-container




