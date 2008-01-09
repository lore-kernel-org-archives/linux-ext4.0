From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Fix up uuidd man page
Date: Wed, 09 Jan 2008 10:45:01 -0600
Message-ID: <4784FA0D.7010600@redhat.com>
References: <4784F0F0.9090303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbYAIQp3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Jan 2008 11:45:29 -0500
In-Reply-To: <4784F0F0.9090303@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> uuidd(8) man page had a typo, and a couple of stale defaults
> documented.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> ---
> 
> Index: e2fsprogs-1.40.4/misc/uuidd.8.in
> ===================================================================
> --- e2fsprogs-1.40.4.orig/misc/uuidd.8.in
> +++ e2fsprogs-1.40.4/misc/uuidd.8.in
> @@ -64,11 +64,11 @@ UUID's.
>  .TP
>  .BI \-p  " pidfile"
>  Specify the pathname where the pid file should be written.  By default,
> -the pid file is written to /var/run/uuidd.pid.
> +the pid file is written to /var/lib/libuuid/uuidd.pid.

Actually, hang on.  Why is this in /var/lib, not /var/run?

I can see keeping state files in /var/lib so they're persistent across
boots, but the pidfile?

-Eric
