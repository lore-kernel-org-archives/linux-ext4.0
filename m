From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/2] ext4: fix delalloc retry loop logic v2
Date: Fri, 05 Feb 2010 00:50:15 +0300
Message-ID: <87636cwu08.fsf@openvz.org>
References: <87zl3qrwnx.fsf@openvz.org> <87sk9irve0.fsf@openvz.org>
	<87y6j9qlwq.fsf@linux.vnet.ibm.com> <20100204194559.GL25885@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64150 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757770Ab0BDVuW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Feb 2010 16:50:22 -0500
Received: by bwz19 with SMTP id 19so876677bwz.28
        for <linux-ext4@vger.kernel.org>; Thu, 04 Feb 2010 13:50:20 -0800 (PST)
In-Reply-To: <20100204194559.GL25885@thunk.org> (tytso@mit.edu's message of
	"Thu, 4 Feb 2010 14:45:59 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu writes:

> Dmitry, what version were you testing when you ran into the problem
> that you reported?  Annesh's patch hit mainline just before 2.6.33-rc6.
I've hit the bug on Jan's quota tree (33-rc5 before Annesh's patch)
Yesterday i have no inet connection to check mainstream tree.
Obviously i've expected what quota-tree should contain working quota code. 
My patch is almost equals to Annesh's. So current mainstream is OK.
Sorry for false warning.
BTW. I want to deploy automated testing suite in order to test some devel
trees on daily basis in order to avoid obvious regressions (f.e. when i
broke ext3+quota). Do you know a good one?
Currently i'm looking in to autotest.kernel.org

