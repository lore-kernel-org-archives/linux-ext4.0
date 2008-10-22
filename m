From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: status of the ext3/jbd error handling enhancement patches
Date: Wed, 22 Oct 2008 13:54:26 +0900
Message-ID: <48FEB202.2090704@hitachi.com>
References: <48FC081D.60306@hitachi.com> <20081020171712.GA22653@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Simon Kirby <sim@netnation.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail4.hitachi.co.jp ([133.145.228.5]:57187 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbYJVEyn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Oct 2008 00:54:43 -0400
Received: from mlsv1.hitachi.co.jp (unknown [133.144.234.166])
	by mail4.hitachi.co.jp (Postfix) with ESMTP id 4A2DE33CC4
	for <linux-ext4@vger.kernel.org>; Wed, 22 Oct 2008 13:54:42 +0900 (JST)
In-Reply-To: <20081020171712.GA22653@hostway.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Simon,

Simon Kirby wrote:

> Hi Hidehiro,
> 
> It seems you have been looking the code behind the problems I reported
> (see linux-ext4 post "EXT3 way too happy with write errors", October
> 14th).
> 
> Are you aware of any patches that look at failed writes outside of JBD
> also not noticing write errors?  It seems that not all write errors are
> causing EXT3 to take the action of aborting the journal, which seems to
> be a very bad idea (an example in my previous posting, testing with fault
> injection).

Which kernel did you use for testing?  If you use the latest -mm kernel
(2.6.27-rc5-mm1) with a patch at http://userweb.kernel.org/~akpm/mmotm/
broken-out/jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers.patch,
most of this kind of problems may be solved.  But some additional works are
still needed; nobody checks I/O error on updating a journal super block.
 
> Anyway, I would be very happy to test out any patches in this area, and
> if none exist, I will try to track down why it is ignoring some of these
> errors.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

