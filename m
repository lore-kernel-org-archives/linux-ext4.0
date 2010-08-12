From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Problem with 15TB logical volume
Date: Thu, 12 Aug 2010 11:14:07 -0400
Message-ID: <4C640FBF.3060103@redhat.com>
References: <20100812091635.GC2699@asrockhome.verdurin.salon> <4C63FA81.8060306@redhat.com> <20100812145130.GD2699@asrockhome.verdurin.salon>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Adam Huffman <bloch@verdurin.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab0HLPOO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Aug 2010 11:14:14 -0400
In-Reply-To: <20100812145130.GD2699@asrockhome.verdurin.salon>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adam Huffman wrote:

> Looking at
> https://bugs.launchpad.net/ubuntu/+source/e2fsprogs/+bug/521648,
> specifically Ted's comment, is it correct that 64-bit blocks support is
> still at the early development stage?
> 
> Adam


the code is in a branch in ted's e2fsprogs git tree but not yet in a release.

-Eric
