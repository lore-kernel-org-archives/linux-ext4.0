From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: replace __FUNCTION__ occurrences in ext4
Date: Sat, 12 Jul 2008 23:25:21 -0700
Message-ID: <20080712232521.154f853a.akpm@linux-foundation.org>
References: <6d291e080807062136q4ece9368y6c747b90bd0de8e6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, adilger@sun.com, linux-ext4@vger.kernel.org
To: "Stoyan Gaydarov" <stoyboyker@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752105AbYGMGZm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Jul 2008 02:25:42 -0400
In-Reply-To: <6d291e080807062136q4ece9368y6c747b90bd0de8e6@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 6 Jul 2008 23:36:56 -0500 "Stoyan Gaydarov" <stoyboyker@gmail.com> wrote:

> __FUNCTION__ is gcc-specific, use __func__ instead
> 
> Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
> 
> diff -uprN linux-2.6.26-rc9/fs/ext4/ext4.h devel/fs/ext4/ext4.h
> --- linux-2.6.26-rc9/fs/ext4/ext4.h     2008-07-05 17:53:22.000000000 -0500
> +++ devel/fs/ext4/ext4.h        2008-07-06 23:35:08.000000000 -0500
> @@ -45,7 +45,7 @@
>  #define ext4_debug(f, a...)                                            \
>         do {                                                            \
>                 printk (KERN_DEBUG "EXT4-fs DEBUG (%s, %d): %s:",       \
> -                       __FILE__, __LINE__, __FUNCTION__);              \
> +                       __FILE__, __LINE__, __func__);          \

Your email client replaces tabs with spaces.
