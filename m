Return-Path: <SRS0=kccS=UI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F68DC28EBD
	for <linux-ext4@archiver.kernel.org>; Sun,  9 Jun 2019 12:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78A442080C
	for <linux-ext4@archiver.kernel.org>; Sun,  9 Jun 2019 12:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560084751;
	bh=Jp7kr5DJqAmzvLis1iU/kH5HcxTG0RVYIAF+Rpsd6qw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:List-ID:From;
	b=1oV9YJKTwOOqkwqjjr6hFifT6qWtY4Pnz9RxAvnvZxkrnSk5ZhIkfeFOb81WJAt3j
	 UFnoDmeEwxdE5418kJFx6MPpBzYdnsnwb1f5qnnQ+xugWgKmACjbUVBnIn+qaIUX1C
	 bjJr9QT6Gg9v6yvZ9DZ5v9b2hVeofejn/mgabESU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbfFIMw1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 9 Jun 2019 08:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728319AbfFIMw1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 9 Jun 2019 08:52:27 -0400
Received: from vulcan (047-135-017-034.res.spectrum.com [47.135.17.34])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0543520644;
        Sun,  9 Jun 2019 12:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560084746;
        bh=Jp7kr5DJqAmzvLis1iU/kH5HcxTG0RVYIAF+Rpsd6qw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Fb0/d1TPF/IYByoPE3/h+/h5Nml1u3pYuNxucYdi3Pa7jHKQWf5ff6iC0gdj4ClyR
         1+mbW/akKAyRuHM4gDoX0wazMyWkrtb2zYBHWqsFXVnAUf4YOmYBHdBPzbKX96kB2U
         oP2KgGTk8o+FmZtKSAhFyGm8i96fdLia2YEod7hM=
Message-ID: <dbc19013b6f2a654541980edd1a00b72331645f9.camel@kernel.org>
Subject: Re: [PATCH RFC 01/10] fs/locks: Add trace_leases_conflict
From:   Jeff Layton <jlayton@kernel.org>
To:     ira.weiny@intel.com, Dan Williams <dan.j.williams@intel.com>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        Dave Chinner <david@fromorbit.com>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org,
        linux-mm@kvack.org
Date:   Sun, 09 Jun 2019 08:52:20 -0400
In-Reply-To: <20190606014544.8339-2-ira.weiny@intel.com>
References: <20190606014544.8339-1-ira.weiny@intel.com>
         <20190606014544.8339-2-ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, 2019-06-05 at 18:45 -0700, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  fs/locks.c                      | 20 ++++++++++++++-----
>  include/trace/events/filelock.h | 35 +++++++++++++++++++++++++++++++++
>  2 files changed, 50 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index ec1e4a5df629..0cc2b9f30e22 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -1534,11 +1534,21 @@ static void time_out_leases(struct inode *inode, struct list_head *dispose)
>  
>  static bool leases_conflict(struct file_lock *lease, struct file_lock *breaker)
>  {
> -	if ((breaker->fl_flags & FL_LAYOUT) != (lease->fl_flags & FL_LAYOUT))
> -		return false;
> -	if ((breaker->fl_flags & FL_DELEG) && (lease->fl_flags & FL_LEASE))
> -		return false;
> -	return locks_conflict(breaker, lease);
> +	bool rc;
> +
> +	if ((breaker->fl_flags & FL_LAYOUT) != (lease->fl_flags & FL_LAYOUT)) {
> +		rc = false;
> +		goto trace;
> +	}
> +	if ((breaker->fl_flags & FL_DELEG) && (lease->fl_flags & FL_LEASE)) {
> +		rc = false;
> +		goto trace;
> +	}
> +
> +	rc = locks_conflict(breaker, lease);
> +trace:
> +	trace_leases_conflict(rc, lease, breaker);
> +	return rc;
>  }
>  
>  static bool
> diff --git a/include/trace/events/filelock.h b/include/trace/events/filelock.h
> index fad7befa612d..4b735923f2ff 100644
> --- a/include/trace/events/filelock.h
> +++ b/include/trace/events/filelock.h
> @@ -203,6 +203,41 @@ TRACE_EVENT(generic_add_lease,
>  		show_fl_type(__entry->fl_type))
>  );
>  
> +TRACE_EVENT(leases_conflict,
> +	TP_PROTO(bool conflict, struct file_lock *lease, struct file_lock *breaker),
> +
> +	TP_ARGS(conflict, lease, breaker),
> +
> +	TP_STRUCT__entry(
> +		__field(void *, lease)
> +		__field(void *, breaker)
> +		__field(unsigned int, l_fl_flags)
> +		__field(unsigned int, b_fl_flags)
> +		__field(unsigned char, l_fl_type)
> +		__field(unsigned char, b_fl_type)
> +		__field(bool, conflict)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->lease = lease;
> +		__entry->l_fl_flags = lease->fl_flags;
> +		__entry->l_fl_type = lease->fl_type;
> +		__entry->breaker = breaker;
> +		__entry->b_fl_flags = breaker->fl_flags;
> +		__entry->b_fl_type = breaker->fl_type;
> +		__entry->conflict = conflict;
> +	),
> +
> +	TP_printk("conflict %d: lease=0x%p fl_flags=%s fl_type=%s; breaker=0x%p fl_flags=%s fl_type=%s",
> +		__entry->conflict,
> +		__entry->lease,
> +		show_fl_flags(__entry->l_fl_flags),
> +		show_fl_type(__entry->l_fl_type),
> +		__entry->breaker,
> +		show_fl_flags(__entry->b_fl_flags),
> +		show_fl_type(__entry->b_fl_type))
> +);
> +
>  #endif /* _TRACE_FILELOCK_H */
>  
>  /* This part must be outside protection */

This looks useful. I'll plan to merge this one for v5.3 unless there
are objections.

Reviewed-by: Jeff Layton <jlayton@kernel.org>

