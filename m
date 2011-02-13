From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [GIT PULL] ext4.git#for_linus
Date: Sun, 13 Feb 2011 08:57:10 -0500
Message-ID: <274C1C63-6C0B-4EA8-97FC-5E382436FD03@mit.edu>
References: <AANLkTinfTjPKc=MU6-qKmCYZDtCNjV9O_1v=gf7X2qaF@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: sedat.dilek@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:47531 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754375Ab1BMN5P convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Feb 2011 08:57:15 -0500
In-Reply-To: <AANLkTinfTjPKc=MU6-qKmCYZDtCNjV9O_1v=gf7X2qaF@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Feb 13, 2011, at 2:35 AM, Sedat Dilek wrote:

> Hi,
> 
> I pulled 24hrs ago ext4.git#for_linus into my local linux-next tree.
> What happened to Dan's patch?
> 
> Dan Carpenter (1):
>      ext4: off by one check in ext4_groupinfo_create_slab()
> 
> This patch was in the first pull-request [1],  but did not find its
> way to Linus-tree.
> Intention or forgotten?

Linus complained about another patch, so while I was fixing up that patch, I combined Dan Carpenter's patch (which was a fix to Eric Sandeen's static slab name patch) into the base patch which it was fixing up.

-- Ted

