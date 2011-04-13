From: Mark Lord <kernel@teksavvy.com>
Subject: Re: CONFIG_EXT4_USE_FOR_EXT23:  rootfs shows as ext2 instead of ext4
Date: Wed, 13 Apr 2011 10:05:26 -0400
Message-ID: <4DA5ADA6.5060301@teksavvy.com>
References: <4DA48AF4.5080803@teksavvy.com> <20110413004938.GE3682@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:53219 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752024Ab1DMOF3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Apr 2011 10:05:29 -0400
In-Reply-To: <20110413004938.GE3682@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11-04-12 08:49 PM, Ted Ts'o wrote:
>
> It's a cosemtic bug, I agree

Great.  Got a patch to fix it for me to try?

Since it currently misidentifies the filesystem type,
some of the disk management tools I have get confused.
I don't like taking any chances with user data like that.

Thanks.

