Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AB12D0617;
	Thu, 30 Apr 2026 21:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777584852; cv=none; b=Zha0PIcvRKHOb/LUKSYSt5HmrqDFxJlU3D677UB04XHLGpJx1Dnk1ajEqlB5ICgx7+o6W00qD1h6mUVZZwnoDNG781jJ0oZF/ZWFsipaWyMCchk55Een9AJdSFHCx0cYQC/3BWIMXkyYb0pCFa9xbrRRSUIY3qed+MMnHjAGexw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777584852; c=relaxed/simple;
	bh=1YNIl7WpHSPFiOaH3ewl0blRSkIt9nnFe7esKq+WYaI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RnWSEBTih5RewG0R4eagJWA6G4rm3jHzC23FThI4M9L7sMbARSfwrVrTrUi8QXjjn8XtAmT/w0NzvES4MqnsZZfHJZmUs10uamaOoLS1X7R1L5ZqWXnk6eWXqYVNe5zd4g0ZQAejemz9nWPcjkqPUVmurApAmSFnbplXbLOCl9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=BLMGq8R1; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=koXWvG+I; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="BLMGq8R1";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="koXWvG+I"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id A7494EC0166;
	Thu, 30 Apr 2026 17:34:09 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 30 Apr 2026 17:34:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1777584849;
	 x=1777671249; bh=mbufzZ7doPbWjQ2uTA/b9Zpwi5k8zjyCRmxP5d68Zfg=; b=
	BLMGq8R1I5vJ8Vm9q3fcVdQ8LN8H47pd4WoV6azNiWymV39rtpJq4TbXvcVIvf7J
	UmGysD7yVo6/EDm/7sjtWt0INhlEbO+bFdYJdtoT8b0cHU0KINHy783pKvLHw5v7
	JvVS+yNJ4aSsLiRIRlcWpm2ac/ZlasAAgvPWXO9hwirne8h1PNORzBBRT1qeNobK
	mRORfeg6yumsKeK3ecnXKXz08UnqKa1URl0mweMEe628+1h9TQqBFBnrxAB0inhO
	YKAkjg6/3UBQgMSka5iMs6zTF7ETGcEYLtYeJErERNQhknvqIIDCA5bPAh4aBsuK
	5J6F69jdG1e/RWAxxzFy8w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1777584849; x=
	1777671249; bh=mbufzZ7doPbWjQ2uTA/b9Zpwi5k8zjyCRmxP5d68Zfg=; b=k
	oXWvG+I/RNXBihidXwjeBnp3yp7nFxnAFtR/iXn+zTb6P6vHKf/ivaut6kfUuWtt
	5m37KMMKOFqo2Micd4YPVKxpdjTmp6Rg1GycdQNmOY+S/nRvZw/kL0DJjWS4X4Ac
	LyJ0felJKmxR5O7DSS3RsRhJAp8E80ZlLSEA3vgS16TL9V2MGMG7C6z/vqUPhM+c
	xq01kTnR9wYKZinu3C576tYiR0u2u+4RtC9LXEJiZTNnd7spgIXg06qioGqkKkga
	hL3fFRhOxRPlRn4h7RhZFYqzXEe95L8N3ljeu7wYUVistmvWpGOlyJaswtvojoGY
	RcYuHvug3WGIebzyYOKag==
X-ME-Sender: <xms:0crzaUdjtJCUUNpZ6nzXqfM7w8-Me08UKl0bBgdIYnASeJnNcx6prA>
    <xme:0crzaQRvwReNq7FPFPuhxZxUT4BioB-R9tLkykCyBawe6ILQNHgZOa8miEzbjxpyQ
    SzINKBPiUTUKOko5Gr3jbwLHIM1qbmQmC-Xh5z9paQVvs4kyZcM>
X-ME-Received: <xmr:0crzaVY4pCpFwgAqELh7q9qgQzq2Xibr4os-IbQKdyewFBzOkKFzbE9rJex8u_9IIzkhnORWW1j-NzlXY66NkmVChYw5tQDx6ECait3Ra-5gCsp1iA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekkeegudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepuegvrhhnugcu
    ufgthhhusggvrhhtuceosggvrhhnugessghssggvrhhnugdrtghomheqnecuggftrfgrth
    htvghrnhephefhjeeujeelhedtheetfedvgfdtleffuedujefhheegudefvdfhheeuvedu
    ueegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsg
    gvrhhnugessghssggvrhhnugdrtghomhdpnhgspghrtghpthhtohepjedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtohepughjfihonhhgsehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehfuhhsvgdquggvvhgvlheslhhishhtshdrlhhinhhugidruggvvhdprhgtphht
    thhopehjohgrnhhnvghlkhhoohhnghesghhmrghilhdrtghomhdprhgtphhtthhopehlih
    hnuhigqdgvgihtgeesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhn
    uhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepmh
    hikhhlohhssehsiigvrhgvughirdhhuhdprhgtphhtthhopehnvggrlhesghhomhhprgdr
    uggvvh
X-ME-Proxy: <xmx:0crzabc7OsRu1G0_2H2XL-cwg5G2rN58UXu4l4sC9bkDHLiKx-c-tw>
    <xmx:0crzaeKUsjAGZ-twz5G0rGA2rIhAOLxnxIYxG30R6Dc5QmFRfpdaeA>
    <xmx:0crzaQKODd-3-piOR9sUeZH7f7IXo47UU3Uqyii1JIgztu17sPbSrQ>
    <xmx:0crzaVXRcfTwB8v2H_9A-zEvdSjayLz9Xc-8tZhfHWP1LRxdS-5zNQ>
    <xmx:0crzaZUQ0k_fGDu-4sTSMWu_-DrpJ-5cueI78kI6MbIKIvDhW5DCIAzY>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Apr 2026 17:34:08 -0400 (EDT)
Message-ID: <9c920b17-81a8-4c1e-921e-4c08cc290cb5@bsbernd.com>
Date: Thu, 30 Apr 2026 23:34:06 +0200
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
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: fr
In-Reply-To: <177758364789.1315233.15610945404741826500.stg-ugh@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Darrick,

On 4/30/26 23:18, Darrick J. Wong wrote:
> Hi Bernd,
> 
> Please pull this branch with changes for libfuse.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.

pushed to my github branch. BSD build fails with

2026-04-30T21:25:16.3874802Z FAILED: [code=1] lib/libfuse3.so.3.19.0 
2026-04-30T21:25:16.3906762Z cc  -o lib/libfuse3.so.3.19.0 lib/libfuse3.so.3.19.0.p/fuse.c.o lib/libfuse3.so.3.19.0.p/fuse_loop.c.o lib/libfuse3.so.3.19.0.p/fuse_loop_mt.c.o lib/libfuse3.so.3.19.0.p/fuse_lowlevel.c.o lib/libfuse3.so.3.19.0.p/fuse_opt.c.o lib/libfuse3.so.3.19.0.p/fuse_signals.c.o lib/libfuse3.so.3.19.0.p/buffer.c.o lib/libfuse3.so.3.19.0.p/cuse_lowlevel.c.o lib/libfuse3.so.3.19.0.p/helper.c.o lib/libfuse3.so.3.19.0.p/modules_subdir.c.o lib/libfuse3.so.3.19.0.p/mount_util.c.o lib/libfuse3.so.3.19.0.p/fuse_log.c.o lib/libfuse3.so.3.19.0.p/compat.c.o lib/libfuse3.so.3.19.0.p/util.c.o lib/libfuse3.so.3.19.0.p/mount_bsd.c.o lib/libfuse3.so.3.19.0.p/fuse_service_stub.c.o lib/libfuse3.so.3.19.0.p/modules_iconv.c.o -Wl,--as-needed -Wl,--no-undefined -shared -fPIC -Wl,-soname,libfuse3.so.4 -Wl,--version-script,/home/runner/work/libfuse/libfuse/lib/fuse_versionscript -pthread -Wl,--start-group -ldl -lrt -Wl,--end-group
2026-04-30T21:25:16.3939590Z ld: error: version script assignment of 'FUSE_3.19' to symbol 'fuse_service_can_allow_other' failed: symbol not defined
2026-04-30T21:25:16.3951874Z cc: error: linker command failed with exit code 1 (use -v to see invocation)
2026-04-30T21:25:16.4291582Z [44/82] cc -Itest/test_teardown_watchdog.p -Itest -I../test -Iinclude -I../include -Ilib -I../lib -I. -I.. -fdiagnostics-color=always -


checkpatch, CodeChecker-cppcheck, CodeChecker-gcc also all fail. This CodeQL
report is funny

> int mount_service_main(int argc, char *argv[])
> Warning
> Poorly documented large function
> Poorly documented function: fewer than 2% comments for a function of 113 lines.
> CodeQL



I think I'm going to merge my sync fuse init series tomorrow. Are you ok if 
skip posting another version of the series? Or do you prefer to review the
recent changes and last piece I'm going to do tomorrow?

Basically my goal is to rebase your series against it immediately and to
merge your series during the next few days.


Cheers,
Bernd
