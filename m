From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Block size limited to Linux page size?
Date: Tue, 03 Jun 2008 12:10:18 -0500
Message-ID: <48457AFA.6000700@redhat.com>
References: <46221.143.166.255.40.1212512440.squirrel@tomslinux.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Thomas King <kingttx@tomslinux.homelinux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831AbYFCRKb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jun 2008 13:10:31 -0400
In-Reply-To: <46221.143.166.255.40.1212512440.squirrel@tomslinux.homelinux.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thomas King wrote:
> To fill in one piece of information, I'm reading the maximum block size can be
> limited by the Linux page size, 4K on x86. Is this true in ext4?
> 
> I know this is a basic question, so thanks for humoring me.
> Tom King

Generally, yes.

There are patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/christoph/largeblocksize/4/patches/

but I'm not sure what the current state of all that is, honestly...

Before it's discussed as a limitation though it'd be interesting to see
some recent benchmarks on how much it might actually matter.

>From some reports:
http://kerneltrap.org/Linux/Large_Blocksize_Performance

it may indeed help.

-Eric
