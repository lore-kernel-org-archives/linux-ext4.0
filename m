From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Performance of ext4
Date: Thu, 12 Jun 2008 09:02:35 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0806120855370.27806@diagnostix.dwd.de>
References: <Pine.LNX.4.64.0806110801370.19793@diagnostix.dwd.de>
 <20080611105945.GB9008@skywalker>  <Pine.LNX.4.64.0806111937460.3720@diagnostix.dwd.de>
  <18563.1213215457@alphaville.zko.hp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dwdmx4.dwd.de ([141.38.3.230]:35652 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbYFLJCj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jun 2008 05:02:39 -0400
Received: from localhost (localhost [127.0.0.1])
	by node7.dwd.de (Postfix) with ESMTP id 940697903A3
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 09:02:38 +0000 (UTC)
Received: from localhost ([127.0.0.1])
	by localhost (node7.csg-cluster.lan [127.0.0.1]) (amavisd-new, port 2525)
	with SMTP id 24072-91 for <linux-ext4@vger.kernel.org>;
	Thu, 12 Jun 2008 09:02:38 +0000 (UTC)
In-Reply-To: <18563.1213215457@alphaville.zko.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 11 Jun 2008, Nick Dokos wrote:

> Holger Kiehl <Holger.Kiehl@dwd.de> wrote:
>
>> Against a clean 2.6.26-rc5 the patchqueue does not apply. Lots of rejects.
>> The patchqueue also contains changes for defrag that are not in 2.6.26-rc5.
>> Or did you mean to apply those against the mm tree?
>>
>
> Just an FYI and a data point: I was able to apply the patch queue
> against 2.6.26-rc5 (after I set up quilt correctly) without any
> problems.
>
I have never used quilt, so how do I set it up correctly? I am using
Fedora 9 and have copied all patches from ext4-patch-queue into
2.6.26-rc5/patches. Then I always issue the following command in
2.6.26-rc5 directory:

      quilt push

That works until it comes to patch patches/ext4_ialloc-flexbg.patch when
it gets lots of rejects. So how do I set this up correctly?

Thanks,
Holger

