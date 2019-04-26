Return-Path: <SRS0=whOe=S4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38DA8C43219
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Apr 2019 16:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F378208CA
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Apr 2019 16:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfDZQ2Z (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:28:25 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:55953 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726349AbfDZQ2Y (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Apr 2019 12:28:24 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x3QGSBUI000810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Apr 2019 12:28:12 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E5705420003; Fri, 26 Apr 2019 12:28:10 -0400 (EDT)
Date:   Fri, 26 Apr 2019 12:28:10 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     kernel test robot <rong.a.chen@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
        lkp@01.org
Subject: Re: [ext4] 345c0dbf3a: xfstests.ext4.303.fail
Message-ID: <20190426162810.GA9835@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        kernel test robot <rong.a.chen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
        lkp@01.org
References: <20190426094708.GA20480@shao2-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426094708.GA20480@shao2-debian>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Apr 26, 2019 at 05:47:09PM +0800, kernel test robot wrote:
> FYI, we noticed the following commit (built with gcc-7):
> 
> commit: 345c0dbf3a30872d9b204db96b5857cd00808cae ("ext4: protect journal inode's blocks using block_validity")
> https://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git dev
> 
> in testcase: xfstests
> with following parameters:
> 
> 	disk: 4HDD
> 	fs: ext4
> 	test: ext4-run

Hi, I'm not able to reproduce this.

TESTRUNID: tytso-20190426093752
KERNEL:    kernel 5.1.0-rc3-xfstests-00007-g345c0dbf3a30 #921 SMP Fri Apr 26 09:36:55 EDT 2019 x86_64
CMDLINE:   -c 4k -g auto
CPUS:      2
MEM:       7680

ext4/4k: 462 tests, 43 skipped, 4271 seconds
Totals: 419 tests, 43 skipped, 0 failures, 0 errors, 4249s

Ran: ext4/001 ext4/002 ext4/003 ext4/004 ext4/005 ext4/020 ext4/021 ext4/022 ext4/023 ext4/024 ext4/025 ext4/026 ext4/027 ext4/028 ext4/029 ext4/030 ext4/031 ext4/032 ext4/033 ext4/034 ext4/271 ext4/301 ext4/302 ext4/303 ext4/305 ext4/306 ext4/307 ext4/308 generic/001 generic/002 generic/003 ....

Given some of the failures, especially this one:

> ext4/307	- output mismatch (see /lkp/benchmarks/xfstests/results//ext4/307.out.bad)
>     --- tests/ext4/307.out	2019-04-25 09:04:55.000000000 +0800
>     +++ /lkp/benchmarks/xfstests/results//ext4/307.out.bad	2019-04-26 13:15:02.522490198 +0800
>     @@ -1,6 +1,7 @@
>      QA output created by 307
>      
>      Run fsstress
>     +./tests/ext4/307: line 34: gawk: command not found
>      Allocate donor file
>      Perform compacting
>      Check data
>     ...
>     (Run 'diff -u /lkp/benchmarks/xfstests/tests/ext4/307.out /lkp/benchmarks/xfstests/results//ext4/307.out.bad'  to see the entire diff)

I'm very much wondering whether your VM has gotten corrupted or hasn't
been correctly set up?

					- Ted
