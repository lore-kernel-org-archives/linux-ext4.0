From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH] e4defrag: fix ppc build
Date: Mon, 24 Aug 2009 09:40:51 -0400
Message-ID: <87f94c370908240640n75bef581k5abe45d4f18c2f68@mail.gmail.com>
References: <4A9220A6.7020000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:12603 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbZHXNkv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Aug 2009 09:40:51 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1302837qwh.37
        for <linux-ext4@vger.kernel.org>; Mon, 24 Aug 2009 06:40:52 -0700 (PDT)
In-Reply-To: <4A9220A6.7020000@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 24, 2009 at 1:09 AM, Eric Sandeen<sandeen@redhat.com> wrote:
> From: Kyle McMartin <kyle@mcmartin.ca>
>
> ppc glibc seems to be missing sync_file_range, so we fell back
> to the local define, and there ppc differs as well, so the
> build was failing.
>
> Thanks to Kyle for the patch w/ the tidy solution.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> diff --git a/misc/e4defrag.c b/misc/e4defrag.c

Eric,

Which git repository holds e4defrag.c?  I assume it is public.

Greg
