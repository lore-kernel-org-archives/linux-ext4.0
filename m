From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [RFC PATCH 1/1] Allow ext4 to run without a journal, take 2.
Date: Mon, 01 Dec 2008 09:33:38 -0800
Message-ID: <1228152818.16846.2.camel@bobble.smo.corp.google.com>
References: <1225397281.19114.13.camel@bobble.smo.corp.google.com>
	 <1226431111.4444.41.camel@bobble.smo.corp.google.com>
	 <492E52FA.7070705@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Michael Rubin <mrubin@google.com>
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:58831 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbYLARdp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2008 12:33:45 -0500
In-Reply-To: <492E52FA.7070705@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-11-27 at 15:57 +0800, Peng Tao wrote:
> Hi, Frank
> 
> I somehow managed to apply your patch against v2.6.28-rc3 kernel. With
> some small modifications, it worked just as supposed.
> 
> now, I have tested the modified patch in three ways, so far so good:
> 1. mount an ext2 fs image as ext4 and muck about with it. Then mount it
> as ext2
> 2. unmark an ext4 image's has_journal flag and mount it as ext4, and
> compile a kernel and delete all files on it.
> 3. mount a normal ext4 image, and compile a kernel and delete all files
> on it.

I have a new version of the patch that has several problems corrected
and one or two bugs fixed.  One of us ran into a memory leak on
Wednesday (after I had already left for the long weekend), though, so
I'll resubmit the patch after we get that fixed.  (The memory leak is
only when using ext4 without a journal, with a journal it works fine.
Looks like the no-journal case is missing a code path with a free
somewhere but I haven't had a chance to look at it yet.)
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

