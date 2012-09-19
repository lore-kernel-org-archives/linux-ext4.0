From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/4] ioengine: File based ioengines
Date: Wed, 19 Sep 2012 21:40:30 +0200
Message-ID: <505A1FAE.10704@kernel.dk>
References: <1348082576-10528-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, fio@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58212 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab2ISTkf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Sep 2012 15:40:35 -0400
In-Reply-To: <1348082576-10528-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-09-19 21:22, Dmitry Monakhov wrote:
> Fio is very cool tool for generating various io patterns.
> And I use it as a base io-loader for xfsstress framework
> 
> I've prepared two file-based ioengines which allow to generate
> interesting io patterns. 'falloc' is more generic and may be useful
> for many cases, other 'e4defrag' is more specific but still
> usfull. It would be nice to have this engines in-tree if possible.
> 
> TOC:
>  # fixes for external engines
>  export file_lookup_open
>  ioengine: allow several external ioengines
>  # file based ioengines
>  ioengine: Add fallocate ioengine
>  ioengine: Add e4defrag ioengine

This looks nifty, especially the fallocate engine. I've added the
patchset, thanks a lot.

Care to send a bit more careful documentation on both of them? The
commit message for fallocate is good, something like that in the HOWTO
would be useful. Bonus points for updating the man page, too! And
e4defrag seems largely undocumented. Some comments in the sample files
(which are great to have, btw) would be nice too.

Will also want wiring up on options.c, the ioengine part, now that they
are in tree.

-- 
Jens Axboe

