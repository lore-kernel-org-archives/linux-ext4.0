From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Performance of ext4
Date: Thu, 12 Jun 2008 12:00:54 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0806121154090.27806@diagnostix.dwd.de>
References: <Pine.LNX.4.64.0806110801370.19793@diagnostix.dwd.de>
 <20080611105945.GB9008@skywalker> <Pine.LNX.4.64.0806111937460.3720@diagnostix.dwd.de>
 <18563.1213215457@alphaville.zko.hp.com> <Pine.LNX.4.64.0806120855370.27806@diagnostix.dwd.de>
 <18513.345.553912.449710@frecb006361.adech.frec.bull.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Nick Dokos <nicholas.dokos@hp.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Solofo.Ramangalahy@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dwdmx4.dwd.de ([141.38.3.230]:56744 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbYFLMBC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jun 2008 08:01:02 -0400
Received: from localhost (localhost [127.0.0.1])
	by node6.dwd.de (Postfix) with ESMTP id D7C72C583DC
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 12:01:00 +0000 (UTC)
Received: from localhost ([127.0.0.1])
	by localhost (node6.csg-cluster.lan [127.0.0.1]) (amavisd-new, port 2525)
	with SMTP id 15302-71 for <linux-ext4@vger.kernel.org>;
	Thu, 12 Jun 2008 12:01:00 +0000 (UTC)
In-Reply-To: <18513.345.553912.449710@frecb006361.adech.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Solofo

On Thu, 12 Jun 2008, Solofo.Ramangalahy@bull.net wrote:

> Hi Holger,
>
> Holger Kiehl writes:
> > That works until it comes to patch patches/ext4_ialloc-flexbg.patch when
> > it gets lots of rejects. So how do I set this up correctly?
>
> I think your quilt is set up correctly.
>
> The rejects probably come from the patch queue being based on a
> different version than 2.6.26-rc5.
>
> Which patchset did you use?
>
> What I do when wanting a patch queue for a specific kernel is to
> search for commit message indicating the rebase for this version.
>
> There is a "Rebase to linux-2.6.26-rc5" on
> http://repo.or.cz/w/ext4-patch-queue.git
> So the corresponding snapshot
> http://repo.or.cz/w/ext4-patch-queue.git?a=snapshot;h=ed6aaac3b0cc0ba47dbb2af0884306584271e5a2;sf=tgz
> patches 2.6.26-rc5 smoothly.
> (the last patchset also applies, with offset and fuzz, though)
>
Yes, that is the one I took. Just to make sure, I downloaded it again (and
the linux-2.6.26-rc5 tree) and now it works. When I compare the two patchsets
the one I pulled this morning had patches from 7 June and this one has more
and they are from 11th June.

Thanks a lot for your help, at last I now have all the patches and can go
on with testing.

Thanks,
Holger

