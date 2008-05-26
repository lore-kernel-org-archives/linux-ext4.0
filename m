From: Solofo.Ramangalahy@bull.net
Subject: Re: Soft lockups in mballoc code
Date: Mon, 26 May 2008 22:39:54 +0200
Message-ID: <18491.8218.574435.741417@frecb006361.adech.frec.bull.fr>
References: <25037.1210612895@alphaville.zko.hp.com>
	<1210785517.3657.42.camel@localhost.localdomain>
	<27364.1210787137@alphaville.zko.hp.com>
	<18481.37660.871969.813688@frecb006361.adech.frec.bull.fr>
	<18490.27904.103939.811128@frecb006361.adech.frec.bull.fr>
	<18517.1211812057@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: nicholas.dokos@hp.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39716 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbYEZUj3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 May 2008 16:39:29 -0400
In-Reply-To: <18517.1211812057@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nick Dokos writes:
 > No, I am not seeing them any more

Good!

 > So it seems to be entirely caused by my bad choice of a config file.

I don't see anything wrong with what you did.

 > As a matter of good practice, is defconfig+ext4dev the best way of
 > producing a kernel for ext4 testing purposes?

No, I don't think so. I have used it because this is reasonably fast
to compile.

I don't think there is a best single .config for testing ext4 (but
let's see what other think).

Using .config from distributions is fine since it is the way some
users get ext4 (that's why I tested Fedora 9 too).
Using other ways is also fine since it increases testing coverage.

 > Are there any settings
 > that should be added/delete/modified from the default?

Yes, for example, defconfig lacks options from the "Kernel Hacking"
section for testability which are mentionned e.g. in
Documentation/SubmitChecklist.

-- 
solofo


