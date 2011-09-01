From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: Tree for Aug 30 (jbd2 + bug.h)
Date: Thu, 1 Sep 2011 13:43:21 +0200
Message-ID: <201109011343.22014.arnd@arndb.de>
References: <20110830171605.168f29decb0558fa31e59210@canb.auug.org.au> <20110831131429.0513af51.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-ext4@vger.kernel.org, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:60066 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab1IALna (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Sep 2011 07:43:30 -0400
In-Reply-To: <20110831131429.0513af51.rdunlap@xenotime.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wednesday 31 August 2011, Randy Dunlap wrote:
> On Tue, 30 Aug 2011 17:16:05 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> 
> [Sorry about the delay.  My build machine is being slow.
> If this is alread fixed, sorry about the noise.]
> 
> 
> When CONFIG_BUG is not enabled (I see this on x86_64):
> 
> fs/jbd2/transaction.c: In function 'jbd2_journal_dirty_metadata':
> fs/jbd2/transaction.c:1176: error: implicit declaration of function '__WARN'
> 
> 
> asm-generic/bug.h does not provide a version of __WARN() when
> CONFIG_BUG is not enabled...
> 

Hmm, my feeling is that we shouldn't do that either, and that jbd2 should
be changed. If we want a function that does what __WARN() does today, we
should probably make a conscious decision about what we want it to be called
and not have it start with "__".

	Arnd
