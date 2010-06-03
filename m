From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH] ext4: Always journal quota file modifications
Date: Thu, 3 Jun 2010 18:47:49 +0200
Message-ID: <201006031847.49273.bernd.schubert@fastmail.fm>
References: <1275488593-7237-1-git-send-email-jack@suse.cz> <20100603125312.GH24062@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:50037 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958Ab0FCQzT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jun 2010 12:55:19 -0400
Received: from compute1.internal (compute1.internal [10.202.2.41])
	by gateway1.messagingengine.com (Postfix) with ESMTP id 6F42DF88D6
	for <linux-ext4@vger.kernel.org>; Thu,  3 Jun 2010 12:47:51 -0400 (EDT)
Received: from bathl.localnet (stgt-4d0391f0.pool.mediaWays.net [77.3.145.240])
	by mail.messagingengine.com (Postfix) with ESMTPSA id 1D2774D9477
	for <linux-ext4@vger.kernel.org>; Thu,  3 Jun 2010 12:47:51 -0400 (EDT)
In-Reply-To: <20100603125312.GH24062@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 
> OTOH, I think we have similar races with journaled quotas, and no one
> has complained (although the vast majority of the quota documentation
> on various HOWTO pages still don't talk about journaled quotas, so I
> don't know how many people are using journaled quotas.  :-/ )

Lustre uses journal quotas since 1.6.5, which was released in 2008. While 
there had been a number of quotas issues, I'm only aware of one issue related 
to journaled quotas and that was also Lustre specific. Maybe Andreas knows 
more.


Cheers,
Bernd
