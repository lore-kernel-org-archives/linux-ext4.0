From: Simon Kirby <sim@netnation.com>
Subject: Re: status of the ext3/jbd error handling enhancement patches
Date: Mon, 20 Oct 2008 10:17:12 -0700
Message-ID: <20081020171712.GA22653@hostway.ca>
References: <48FC081D.60306@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from newpeace.netnation.com ([204.174.223.7]:43536 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756835AbYJTRRT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Oct 2008 13:17:19 -0400
Content-Disposition: inline
In-Reply-To: <48FC081D.60306@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 20, 2008 at 01:25:01PM +0900, Hidehiro Kawai wrote:

> Hi Andrew,
> 
> Thank you for pushing my ext3/jbd to Linus.  But some of patches
> in -mm (following three patches) haven't been sent to Linus.
> 
>   #jbd-fix-error-handling-for-checkpoint-io.patch: double-check this
>   jbd-fix-error-handling-for-checkpoint-io.patch
>   ext3-add-checks-for-errors-from-jbd.patch
>   jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers.patch
> 
> They improve filesystem corruption problem and it is needed by
> mission critical systems.

Hi Hidehiro,

It seems you have been looking the code behind the problems I reported
(see linux-ext4 post "EXT3 way too happy with write errors", October
14th).

Are you aware of any patches that look at failed writes outside of JBD
also not noticing write errors?  It seems that not all write errors are
causing EXT3 to take the action of aborting the journal, which seems to
be a very bad idea (an example in my previous posting, testing with fault
injection).

Anyway, I would be very happy to test out any patches in this area, and
if none exist, I will try to track down why it is ignoring some of these
errors.

Thanks,

Simon-
