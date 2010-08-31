From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC PATCH] ext4: fix 50% disk write performance regression
Date: Mon, 30 Aug 2010 22:29:27 -0500
Message-ID: <4C7C7717.1020704@redhat.com>
References: <20100829231126.8d8b2086.billfink@mindspring.com>	<20100830174000.GA6647@thunk.org>	<20100830164958.edb64c63.bill@wizard.sci.gsfc.nasa.gov>	<4C7C1D04.1080205@redhat.com>	<20100830194533.6d09c38b.bill@wizard.sci.gsfc.nasa.gov>	<4C7C446D.6070602@redhat.com>	<20100830210541.8b248a14.billfink@mindspring.com>	<4C7C62E9.4090707@redhat.com> <20100830232704.39d2e9f4.billfink@mindspring.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, bill.fink@nasa.gov, linux-ext4@vger.kernel.org
To: Bill Fink <billfink@mindspring.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082Ab0HaD3f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Aug 2010 23:29:35 -0400
In-Reply-To: <20100830232704.39d2e9f4.billfink@mindspring.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bill Fink wrote:

> The .0 and .1 files were 0 bytes.  There was also a 56 byte .3 file
> in each case.  Did you also want to see those?

nah it's ok I filled it in.

I think I see at least 1 thing wrong in the writeback path, I may have
a patch for you yet tonight.

-Eric
 


