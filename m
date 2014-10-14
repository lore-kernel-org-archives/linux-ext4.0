From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] add aio/dio regression test race between write and fcntl
 V2
Date: Tue, 14 Oct 2014 16:11:51 +1100
Message-ID: <20141014051151.GK5267@dastard>
References: <1412866642-25191-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:56696 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746AbaJNFL5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Oct 2014 01:11:57 -0400
Content-Disposition: inline
In-Reply-To: <1412866642-25191-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 09, 2014 at 06:57:22PM +0400, Dmitry Monakhov wrote:
> Original report: https://lkml.org/lkml/2014/10/8/545
> perform AIO-DIO and fcntl(F_SETFL) concurently
> Unaligned AIO likely result in synchronization which makes racewindow wider.
> 
> changes from v1->v2
>  - Properly reuse aio context

Couple of things below....

> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  src/aio-dio-regress/aio-dio-fcntl-race.c |  148 ++++++++++++++++++++++++++++++
>  tests/generic/326                        |   51 ++++++++++
>  tests/generic/326.out                    |    2 +
>  tests/generic/group                      |    1 +
>  4 files changed, 202 insertions(+), 0 deletions(-)
>  create mode 100644 src/aio-dio-regress/aio-dio-fcntl-race.c
>  create mode 100755 tests/generic/326
>  create mode 100644 tests/generic/326.out
> 
> diff --git a/src/aio-dio-regress/aio-dio-fcntl-race.c b/src/aio-dio-regress/aio-dio-fcntl-race.c
> new file mode 100644
> index 0000000..835dbdf
> --- /dev/null
> +++ b/src/aio-dio-regress/aio-dio-fcntl-race.c
> @@ -0,0 +1,148 @@
> +/*
> + * Perform aio writes to file and toggle O_DIRECT flag concurrently
> + * this may trigger race between file->f_flags read and modification
> + * unuligned aio allow to makes race window wider.
> + * Regression test for https://lkml.org/lkml/2014/10/8/545
> + *
> + * Copyright (C) 2010 Red Hat, Inc. All Rights reserved.

YOu must have copied the code from somewhere. Can you add a note to
say where it came from in the patch description? And if you added
any significant modifications, you should add your own copyright to
it as well...

> diff --git a/tests/generic/326 b/tests/generic/326
> new file mode 100755
> index 0000000..8975a91
> --- /dev/null
> +++ b/tests/generic/326
> @@ -0,0 +1,51 @@
> +#! /bin/bash
> +# FS QA Test No. 326

Can you rename this to the first unused generic test?

> +# Run aio-dio-fcntl-race - test aio write race with O_DIRECT toggle
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2009 Dmitry Monakhov.  All Rights Reserved.

2009 doesn't seem right for a test that was just written...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
