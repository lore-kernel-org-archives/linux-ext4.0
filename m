Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4422D9484;
	Sat,  2 May 2026 19:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777751488; cv=none; b=fZBJfVFRXT05vlArfLx0u8QK6tIcVnzoRHVG+7HtRbWWqoFExfFTEKaNIUBQcD0ngEiBsAuvFuANmMeVaQpWMnMmG/YSoor6NgQhAaqRo2RSYa9F7nNzbPfcJeQztC/JcuyCPMuE9oW/rxOHZszVzdyZJQFBoucS7Njs5eR9X4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777751488; c=relaxed/simple;
	bh=LEmp+OQGng+7UURa422OD+Fi2EmDgB26gU2m4UCycmQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RKHdhpBhlb8YdUZDJo9iuUub7qXArJUosYQLuVUWbJthvntDEFygZB0Y1LyKeXLz0KJABysxn2ESoA5mVtxbSLA8GFR0XHkyppr5uCgmDeTe0+BIrQFVy1Jo8Fk9FqziaZcZeexH13juMvtIflbTFy0kn7anSmSsYIVY8nMmiLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=l7+8wX+e; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=JPLp1F18; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="l7+8wX+e";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JPLp1F18"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id 0D794EC003B;
	Sat,  2 May 2026 15:51:25 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Sat, 02 May 2026 15:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1777751485;
	 x=1777837885; bh=ZWLLXe8K0Npq10FIHOukoiavr79sYdTxacck2K7s4dg=; b=
	l7+8wX+eRGIAs+cVdbE3C50K8NT9A2nQ/AkApk92DjeKx8ZfC9u+/p6NhFO2kPlI
	EZwpQ4yNsgLh7ZL+46bLc8y41ciuNdXGDmqExO5hV8izLY94dly0nvymja3rkF55
	ZIj8wJ81MQbT+w+38wQWkPnAhv//31RJWrf9uESuHgq+4v7tMr+3WRi28mxXisEP
	YYpQezja0WYksLf6BRat5oGDgzPJ0hM/c7Pqbo4vNPr0Ot90cXf/7VAjHgyERlim
	lt3TYIvVJqOZutOnjvawD6fjE0wP8/zQvvvtnZaeQGSdcyrEElg2aEv5x2nS7id/
	fMJqT/ON6/yqBsVAXKV6yQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1777751485; x=
	1777837885; bh=ZWLLXe8K0Npq10FIHOukoiavr79sYdTxacck2K7s4dg=; b=J
	PLp1F18JsuLoxexEb8UvOvFWjKoF85bPKuehX4eUQh2KJFWW6fTOJjxnuo1jx8OR
	ZbDgqWomv+vvNGB9d9t9LyKFRi50rgKrCNUXVllyzvnJHAvizE8LZvcvv2RbhnOe
	clVd3rFm+yb2gG6xvTDt9mtJLyVc1bfyHELTQBKG8pVpOLa/3rZgub4FYJ31mcMS
	SjHkh0qplLQDbl0xQfukBj6EJlGx+pyBt09fcxmDNQGpo0KPNNqLKFyIHO7tPmKE
	oN0cMyLoBdODDwGuWnOoqoBvvPU9N7zPibBh71w9fQbfmcfVhUUnNDc63AlXonWJ
	J2vKwELQ9wqIcRB+SVAGA==
X-ME-Sender: <xms:vFX2afUturABXEwDqDG6me-HgSs1so6cjIjKU4tF-CsmZh4XPOquTw>
    <xme:vFX2aRoPuaq_TzHPHZhoEkXMG5skjWA7EKuze-hfnqhaIqMx6Be71RUsV5LaqIYqI
    cy7GuDXjL6m5D7BY30NRlH1g1ra7EzuYZlvYLbYbnYpAVLTnA>
X-ME-Received: <xmr:vFX2abQlL-AokDsKY7KYKW-ZQ5_ntOfoz0NXFuIy61N65BbLd4_68R2KYujDCEJ3z4AlhxKcQ_hfBrue6RAvEonk-_dsdm21mrHYXX3LrIjXrX51JA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdelfeeljecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepuegvrhhnugcu
    ufgthhhusggvrhhtuceosggvrhhnugessghssggvrhhnugdrtghomheqnecuggftrfgrth
    htvghrnhepgfffgfelkeevffdtjefhtdeuffdtgfejtdefkeekgfejfeejhfefveevveef
    gfejnecuffhomhgrihhnpehfuhhsvggpshgvrhhvihgtvggpshhtuhgsrdgtfienucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgusegs
    shgsvghrnhgurdgtohhmpdhnsggprhgtphhtthhopeejpdhmohguvgepshhmthhpohhuth
    dprhgtphhtthhopegujhifohhngheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfhhu
    shgvqdguvghvvghlsehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtohepjhhorg
    hnnhgvlhhkohhonhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtoheplhhinhhugidqvgig
    thegsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqfhhsug
    gvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehmihhklhhoshes
    shiivghrvgguihdrhhhupdhrtghpthhtohepnhgvrghlsehgohhmphgrrdguvghv
X-ME-Proxy: <xmx:vFX2ab3ASziCattTnrjVv57JHFxF0nckmPMc1NdRsn3SnR6hHIFyBw>
    <xmx:vFX2aXCcMy_L_TwcsdzOSLoJ4Lw4Siz-TD9Q4cKjldY5DF-ndKKVeg>
    <xmx:vFX2aXhZr0MVwZlFwfzAfaSG3eToyD6yQskcewuLQpsWXMqoApHqHQ>
    <xmx:vFX2aZN26Q65n6WVqwqYZy59f9QzPdKwlqE4VIPkLEwx_-a7v5HUTA>
    <xmx:vVX2acszdjiWxw7p96COvm607iey6EKEenvNm__ZpbrdWETjpB-YAg-x>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 2 May 2026 15:51:23 -0400 (EDT)
Message-ID: <757367d0-3a8b-4de8-aa86-f74f316b3445@bsbernd.com>
Date: Sat, 2 May 2026 21:51:21 +0200
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
 <1d2c00d0-255f-44cd-9757-d7418373cdcd@bsbernd.com>
 <20260502190543.GG3778109@frogsfrogsfrogs>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: fr
In-Reply-To: <20260502190543.GG3778109@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/2/26 21:05, Darrick J. Wong wrote:
> On Sat, May 02, 2026 at 06:26:16PM +0200, Bernd Schubert wrote:
>>
>>
>> On 5/2/26 17:59, Bernd Schubert wrote:
>>>
>>>
>>> On 5/1/26 00:49, Darrick J. Wong wrote:
>>>> On Thu, Apr 30, 2026 at 11:34:06PM +0200, Bernd Schubert wrote:
>>>>> Hi Darrick,
>>>>>
>>>>> On 4/30/26 23:18, Darrick J. Wong wrote:
>>>>>> Hi Bernd,
>>>>>>
>>>>>> Please pull this branch with changes for libfuse.
>>>>>>
>>>>>> As usual, I did a test-merge with the main upstream branch as of a few
>>>>>> minutes ago, and didn't see any conflicts.  Please let me know if you
>>>>>> encounter any problems.
>>>>>
>>>>> pushed to my github branch. BSD build fails with
>>>>>
>>>>> 2026-04-30T21:25:16.3874802Z FAILED: [code=1] lib/libfuse3.so.3.19.0 
>>>>> 2026-04-30T21:25:16.3906762Z cc  -o lib/libfuse3.so.3.19.0 lib/libfuse3.so.3.19.0.p/fuse.c.o lib/libfuse3.so.3.19.0.p/fuse_loop.c.o lib/libfuse3.so.3.19.0.p/fuse_loop_mt.c.o lib/libfuse3.so.3.19.0.p/fuse_lowlevel.c.o lib/libfuse3.so.3.19.0.p/fuse_opt.c.o lib/libfuse3.so.3.19.0.p/fuse_signals.c.o lib/libfuse3.so.3.19.0.p/buffer.c.o lib/libfuse3.so.3.19.0.p/cuse_lowlevel.c.o lib/libfuse3.so.3.19.0.p/helper.c.o lib/libfuse3.so.3.19.0.p/modules_subdir.c.o lib/libfuse3.so.3.19.0.p/mount_util.c.o lib/libfuse3.so.3.19.0.p/fuse_log.c.o lib/libfuse3.so.3.19.0.p/compat.c.o lib/libfuse3.so.3.19.0.p/util.c.o lib/libfuse3.so.3.19.0.p/mount_bsd.c.o lib/libfuse3.so.3.19.0.p/fuse_service_stub.c.o lib/libfuse3.so.3.19.0.p/modules_iconv.c.o -Wl,--as-needed -Wl,--no-undefined -shared -fPIC -Wl,-soname,libfuse3.so.4 -Wl,--version-script,/home/runner/work/libfuse/libfuse/lib/fuse_versionscript -pthread -Wl,--start-group -ldl -lrt -Wl,--end-group
>>>>> 2026-04-30T21:25:16.3939590Z ld: error: version script assignment of 'FUSE_3.19' to symbol 'fuse_service_can_allow_other' failed: symbol not defined
>>>>
>>>> Aha, that function got left out of the stub. :(
>>>>
>>>> Annoyingly, on Linux the build succeeds despite the missing symbol
>>>> when I tweak meson so that it doesn't build the service stuff.  I would
>>>> have thought that --no-undefined would have done that, but alas.
>>>>
>>>> Sorry about that too.  The following patch fixes it.
>>>>
>>>> diff --git i/lib/fuse_service_stub.c w/lib/fuse_service_stub.c
>>>> index d34df3891a6e31..231b98423df628 100644
>>>> --- i/lib/fuse_service_stub.c
>>>> +++ w/lib/fuse_service_stub.c
>>>> @@ -49,12 +49,17 @@ int fuse_service_send_goodbye(struct fuse_service *sf, int error)
>>>>  int fuse_service_accept(struct fuse_service **sfp)
>>>>  {
>>>>  	*sfp = NULL;
>>>>  	return 0;
>>>>  }
>>>>  
>>>> +bool fuse_service_can_allow_other(struct fuse_service *sf)
>>>> +{
>>>> +	return false;
>>>> +}
>>>> +
>>>>  int fuse_service_append_args(struct fuse_service *sf,
>>>>  			     struct fuse_args *existing_args)
>>>>  {
>>>>  	return -EOPNOTSUPP;
>>>>  }
>>>>  
>>>>
>>>>> 2026-04-30T21:25:16.3951874Z cc: error: linker command failed with exit code 1 (use -v to see invocation)
>>>>> 2026-04-30T21:25:16.4291582Z [44/82] cc -Itest/test_teardown_watchdog.p -Itest -I../test -Iinclude -I../include -Ilib -I../lib -I. -I.. -fdiagnostics-color=always -
>>>>>
>>>>>
>>>>> checkpatch, CodeChecker-cppcheck, CodeChecker-gcc also all fail. This CodeQL
>>>>
>>>> Not sure why checkpatch fails, this is what I got (Debian 13):
>>>>
>>>> $ git diff origin/master.. | ./checkpatch.pl --max-line-length=100 --no-tree --ignore MAINTAINERS,SPDX_LICENSE_TAG,COMMIT_MESSAGE,FILE_PATH_CHANGES,EMAIL_SUBJECT,AVOID_EXTERNS,GIT_COMMIT_ID,ENOSYS_SYSCALL,ENOSYS,FROM_SIGN_OFF_MISMATCH,QUOTED_COMMIT_ID,,PREFER_ATTRIBUTE_ALWAYS_UNUSED,PREFER_DEFINED_ATTRIBUTE_MACRO,STRCPY,STRNCPY -
>>>> No typos will be found - file '/storage/home/djwong/cdev/work/libfuse/spelling.txt': No such file or directory
>>>> No structs that should be const will be found - file '/storage/home/djwong/cdev/work/libfuse/const_structs.checkpatch': No such file or directory
>>>> total: 0 errors, 0 warnings, 3908 lines checked
>>>>
>>>> Your patch has no obvious style problems and is ready for submission.
>>>>
>>>> NOTE: Ignored message types: AVOID_EXTERNS COMMIT_MESSAGE EMAIL_SUBJECT ENOSYS ENOSYS_SYSCALL FILE_PATH_CHANGES FROM_SIGN_OFF_MISMATCH GIT_COMMIT_ID MAINTAINERS PREFER_ATTRIBUTE_ALWAYS_UNUSED PREFER_DEFINED_ATTRIBUTE_MACRO QUOTED_COMMIT_ID SPDX_LICENSE_TAG STRCPY STRNCPY
>>>>
>>>> cppcheck had a few things to say, but none of it was about the changed
>>>> lines.
>>>>
>>>>> report is funny
>>>>>
>>>>>> int mount_service_main(int argc, char *argv[])
>>>>>> Warning
>>>>>> Poorly documented large function
>>>>>> Poorly documented function: fewer than 2% comments for a function of 113 lines.
>>>>>> CodeQL
>>>>
>>>> Hrmm.  I guess I'll have to figure out how to get those things running.
>>>> That said, the stuff in mount_service.c is internal to libfuse (i.e.
>>>> it's not public library API) so I didn't comment them as intensely.
>>>> Would you like more?
>>>>
>>>>> I think I'm going to merge my sync fuse init series tomorrow.
>>>>
>>>> Yay!
>>>>
>>>>> Are you ok if skip posting another version of the series?
>>>>
>>>>                ^ is there an "I" here?  e.g. "...if I skip posting..."?
>>>>
>>>> /My/ normal practice (from xfs) was to repost the series as it was
>>>> merged, followed by an announcement.  That way the mailing list is a
>>>> complete record of what was merged.  However, very very few people
>>>> actually do that, even in the kernel.
>>>>
>>>> I'm ok with you not posting another version of the series.
>>>>
>>>>> Or do you prefer to review the recent changes and last piece I'm going
>>>>> to do tomorrow?
>>>>
>>>> Nah, just merge it.  I'll look over the changes once it's in the branch
>>>> and if there's anything weird, you or I or anyone else can send patches.
>>>> As long as you're not planning to tag it as a release, nothing's set in
>>>> stone.
>>>>
>>>>> Basically my goal is to rebase your series against it immediately and
>>>>> to merge your series during the next few days.
>>>>
>>>> <nod> Let me know what you want changed, I'll be around since I am not
>>>> travelling anywhere for a couple of weeks. :)
>>>>
>>>> I can reflow changes into the patchset, or if you'd prefer, I can add
>>>> them as new patches that would go on the end of the series.
>>>>
>>>
>>> Hi Darrick,
>>>
>>> eventually merged my patches and made a quick rebase and conflict 
>>> resolving with your branch. Github still reports plenty of issues ;)
>>>
>>> Could you fix all of the checkpatch isssues? This one shows plenty
>>> "util: hoist the fuse.conf parsing and setuid mode enforcement code"
>>>
>>> bschubert2@imesrv6 libfuse.git>stg series
>>> + mount_service-add-systemd
>>> + mount_service-create-high
>>> + mount_service-use-the-new
>>> + mount_service-update-mtab
>>>> util-hoist-the-fuse.conf
>>> - util-fix-checkpatch-complaints
>>> - mount_service-enable
>>> - mount.fuse3-integrate-systemd
>>> - mount_service-allow
>>> - example-service_ll-create-a
>>> - example-service-create-a
>>> - nullfs-support-fuse-systemd
>>> - meson-show-feature-summary
>>> bschubert2@imesrv6 libfuse.git>.github/workflows/run-checkpatch.sh 
>>> No typos will be found - file '/home/bschubert2/src/libfuse/libfuse.git/spelling.txt': No such file or directory
>>> No structs that should be const will be found - file '/home/bschubert2/src/libfuse/libfuse.git/const_structs.checkpatch': No such file or directory
>>> ERROR:GLOBAL_INITIALISERS: do not initialise globals to 0
>>> #61: FILE: util/fuser_conf.c:33:
>>> +int user_allow_other = 0;
>>>
>>> WARNING:LINE_SPACING: Missing a blank line after declarations
>>> #74: FILE: util/fuser_conf.c:46:
>>> +	char *dest = buf;
>>> +	while (1) {
>>>
>>> ...
>>>
>>> I don't have a strong opinion about these two above - feel 
>>> free to disable them. However, in order to merge it, it would
>>> be good to run without any checkpatch report.
>>> And everything that cppcheck and gcc-checker reports, definitely 
>>> need to be fixed.
>>
>> Basically
>>
>> cd <$FUSEDIR>
>> BUILDDIR="build-without-examples"
>> mkdir -p ${BUILDDIR}
>> meson setup ${BUILDDIR} -Dexamples=false 
>> ninja -C ${BUILDDIR}
>> ./.github/workflows/codechecker.sh --gcc --codechecker --build-dir ${BUILDDIR}
>>
>> gcc reports are starting here
>>
>> bschubert2@imesrv6 libfuse.git>stg series
>> + mount_service-add-systemd
>> + mount_service-create-high
>> + mount_service-use-the-new
>> + mount_service-update-mtab
>> + util-hoist-the-fuse.conf
>> + util-fix-checkpatch-complaints
>> + mount_service-enable
>>> mount.fuse3-integrate-systemd
>>
>>
>> bschubert2@imesrv6 libfuse.git>git show |head -n5
>> commit f908bb1504eca167e156671dde957c2e7192b7d2
>> Author: Darrick J. Wong <djwong@kernel.org>
>> Date:   Wed Mar 4 13:48:55 2026 -0800
>>
>>     mount.fuse3: integrate systemd service startup
>>
>>
>> ---==== Severity Statistics ====----
>> ----------------------------
>> Severity | Number of reports
>> ----------------------------
>> MEDIUM   |                 1
>> ----------------------------
>> ----=================----
>>
>> ----==== Checker Statistics ====----
>> -----------------------------------------------------
>> Checker name           | Severity | Number of reports
>> -----------------------------------------------------
>> gcc-deref-before-check | MEDIUM   |                 1
> 
> Oh, that's concerning.  Could you figure out exactly what it's
> complaining about and send that to me, please?

I'm afraid I don't manage anymore today. Still a couple of
other things to do (like changing laptop keyboard and packing
a few things, preparing bread for the oven).

It is really easy to run this yourself

cd <$FUSEDIR>
BUILDDIR="build-without-examples"
mkdir -p ${BUILDDIR}
meson setup ${BUILDDIR} -Dexamples=false 
ninja -C ${BUILDDIR}
./.github/workflows/codechecker.sh --gcc --codechecker --build-dir ${BUILDDIR}

There is --gcc and --cppcheck




