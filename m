From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: Performance of ext4
Date: Wed, 11 Jun 2008 16:17:37 -0400
Message-ID: <18563.1213215457@alphaville.zko.hp.com>
References: <Pine.LNX.4.64.0806110801370.19793@diagnostix.dwd.de> <20080611105945.GB9008@skywalker>  <Pine.LNX.4.64.0806111937460.3720@diagnostix.dwd.de>
Reply-To: nicholas.dokos@hp.com
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:1342 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbYFKURj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jun 2008 16:17:39 -0400
In-Reply-To: Message from Holger Kiehl <Holger.Kiehl@dwd.de>
   of "Wed, 11 Jun 2008 19:58:53 -0000." <Pine.LNX.4.64.0806111937460.3720@diagnostix.dwd.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Holger Kiehl <Holger.Kiehl@dwd.de> wrote:

> Against a clean 2.6.26-rc5 the patchqueue does not apply. Lots of rejects.
> The patchqueue also contains changes for defrag that are not in 2.6.26-rc5.
> Or did you mean to apply those against the mm tree?
> 

Just an FYI and a data point: I was able to apply the patch queue
against 2.6.26-rc5 (after I set up quilt correctly) without any
problems.

Regards,
Nick
