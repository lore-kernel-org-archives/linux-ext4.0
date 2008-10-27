From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 patch-queue patching issues
Date: Sun, 26 Oct 2008 20:41:40 -0500
Message-ID: <49051C54.2060905@redhat.com>
References: <3.0.6.32.20081024165139.024a3ee0@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45216 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbYJ0Blo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 26 Oct 2008 21:41:44 -0400
In-Reply-To: <3.0.6.32.20081024165139.024a3ee0@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Gary Hawco wrote:
> What specific kernel are the latest ext4 queue patches for?  I can't get
> any patches (from 16 Oct 2008 @0151hrs to today's latest -- 24Oct 2008 @
> 2151hrs) to work against any 2.6.27.XX source. The most recent patch I have
> been successful with was 15 Oct @ 1302hrs against 2.6.27 kernel.
> 
> The notation from 16 Oct. 2008 @0151 says "Rebase to 2.6.26-git5" which
> seems to be a typo. 
> 
> Looking at the snapshots from another portion of the ext4 tree:
> http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=summary
> 
> with the newest being from 16 Oct 2008 @ 2311hrs. it says they are based
> against 2.6.27-git7, which again, is which kernel?  

# BASE 2.6.27-git7

http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.27-git7.bz2

I had to chase this down Friday as well :)

-Eric
