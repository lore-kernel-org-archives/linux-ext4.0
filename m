From: Ron Yorston <rmy@tigress.co.uk>
Subject: Re: Feature request: e2fsck -z
Date: Wed, 10 Aug 2011 08:54:53 +0100
Message-ID: <201108100754.p7A7ss3n016775@tiffany.internal.tigress.co.uk>
References: <4E4173D4.9010104@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, hpa@zytor.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.tigress.co.uk ([195.172.168.163]:33919 "EHLO
	intgat.tigress.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1HJIQQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Aug 2011 04:16:16 -0400
In-Reply-To: <4E4173D4.9010104@zytor.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"H. Peter Anvin" wrote:

>It would be a very nice thing to have a flag to e2fsck, presumably -z,
>to zero out any unused data blocks, inodes and so on.  The goal is to
>minimize the amount of space required after compressing a virtual disk
>image or similar, and to make sure any non-data isn't lying around.

I wrote a separate utility, zerofree[1], that zeroes out free blocks.

Ron
--
[1] http://intgat.tigress.co.uk/rmy/uml/
