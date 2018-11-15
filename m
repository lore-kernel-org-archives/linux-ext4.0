Return-Path: <SRS0=JALT=N2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35446 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbeKPFaF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 16 Nov 2018 00:30:05 -0500
Date: Thu, 15 Nov 2018 14:20:58 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] e2scrub: fix systemd escaping again
Message-ID: <20181115192058.GE20617@thunk.org>
References: <20181105175946.GA4124@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181105175946.GA4124@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 05, 2018 at 09:59:46AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Apparently newer versions of systemd than the one on this author's
> laptop <cough> now complain about lack of (path) escaping in unit
> instance variable contents:
> 
>  # e2scrub_all
>  Scrubbing /home...
>  Invalid unit name "e2scrub@/home" was escaped as "e2scrub@-home"
>  (maybe you should use systemd-escape?)
>  Starting Online ext4 Metadata Check for /home...
> 
> So change the escape_path_for_systemd function to escape paths
> unconditionally to make the warning go away.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
