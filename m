From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: freeze_bdev hangs
Date: Fri, 05 Oct 2012 12:33:26 -0500
Message-ID: <506F19E6.8030005@redhat.com>
References: <CAD6i1f+fzh-z+Xr6V2gHBzq4kmJzPcfre91g=q6fJ7P_5nY0Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Prashant Shah <pshah.mumbai@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab2JERd2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2012 13:33:28 -0400
In-Reply-To: <CAD6i1f+fzh-z+Xr6V2gHBzq4kmJzPcfre91g=q6fJ7P_5nY0Zw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/5/12 6:58 AM, Prashant Shah wrote:
> Hi,
> 
> I am writing a filter driver for ext3 in which it replaces the block
> device request queue 'make_request_fn' with the driver custom
> function. Calling freeze_bdev() or freeze_super() before replacing the
> 'make_request_fn' hangs the kernel. What am I doing wrong ? Will this
> method work ?

I haven't looked at your custom code, but freeze has changed a bit lately,
and "hangs" is a very vague description

For starters I'd try a sysrq-w when the system "hangs" and see where things
are at, that would offer you some clues.

-Eric
