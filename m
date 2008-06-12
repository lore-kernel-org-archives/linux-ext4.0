From: Solofo.Ramangalahy@bull.net
Subject: Re: Performance of ext4
Date: Thu, 12 Jun 2008 12:58:33 +0200
Message-ID: <18513.345.553912.449710@frecb006361.adech.frec.bull.fr>
References: <Pine.LNX.4.64.0806110801370.19793@diagnostix.dwd.de>
	<20080611105945.GB9008@skywalker>
	<Pine.LNX.4.64.0806111937460.3720@diagnostix.dwd.de>
	<18563.1213215457@alphaville.zko.hp.com>
	<Pine.LNX.4.64.0806120855370.27806@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Nick Dokos <nicholas.dokos@hp.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47712 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759612AbYFLK6H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 06:58:07 -0400
In-Reply-To: <Pine.LNX.4.64.0806120855370.27806@diagnostix.dwd.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Holger,

Holger Kiehl writes:
 > That works until it comes to patch patches/ext4_ialloc-flexbg.patch when
 > it gets lots of rejects. So how do I set this up correctly?

I think your quilt is set up correctly.

The rejects probably come from the patch queue being based on a
different version than 2.6.26-rc5.

Which patchset did you use?

What I do when wanting a patch queue for a specific kernel is to
search for commit message indicating the rebase for this version.

There is a "Rebase to linux-2.6.26-rc5" on
http://repo.or.cz/w/ext4-patch-queue.git
So the corresponding snapshot
http://repo.or.cz/w/ext4-patch-queue.git?a=snapshot;h=ed6aaac3b0cc0ba47dbb2af0884306584271e5a2;sf=tgz
patches 2.6.26-rc5 smoothly.
(the last patchset also applies, with offset and fuzz, though)

-- 
solofo
