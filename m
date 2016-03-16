From: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Subject: RE: ext4 out of order when use cfq scheduler
Date: Wed, 16 Mar 2016 00:41:14 +0000
Message-ID: <7c853c5a66424ff58aa7acaba97ced2d@SGPMBX1004.APAC.bosch.com>
References: <c73ca48af09742318189c61d167c4459@SGPMBX1004.APAC.bosch.com>
 <20160106100621.GA24046@quack.suse.cz>
 <3ab48fa47e434455b101251730e69bd2@SGPMBX1004.APAC.bosch.com>
 <20160107102420.GB8380@quack.suse.cz>
 <f0c925079bb4450380c019a7455a2537@SGPMBX1004.APAC.bosch.com>
 <20160107114736.GC8380@quack.suse.cz> <20160313042723.GC29218@thunk.org>
 <20160314073928.GD5213@quack.suse.cz> <20160314143635.GM29218@thunk.org>
 <20160315104634.GG17942@quack.suse.cz> <20160315144633.GA12352@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Li, Michael" <huayil@qti.qualcomm.com>
To: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:14277 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbcCPAlT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Mar 2016 20:41:19 -0400
In-Reply-To: <20160315144633.GA12352@quack.suse.cz>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 
> OK, I have something - Huang, can you check whether the attached patches also
> fix your data exposure issues please? The first patch is the original fix, patch two
> is a cleanup, patches 3 and 4 implement the speedup suggested by Ted. Patches
> are only lightly tested so far.  I'll run more comprehensive tests later and in
> particular I want to check whether the additional complexity actually brings us
> some advantage at least for workloads which redirty pages in addition to writing
> some new ones using delayed allocation.
> 
> 								Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR


Sure, I will try to merge the patches and do the test on my kernel.

Huang weller
