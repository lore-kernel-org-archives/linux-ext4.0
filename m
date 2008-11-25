From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] imporve jbd2 fsync batching
Date: Tue, 25 Nov 2008 05:23:35 -0500
Message-ID: <20081125102335.GB9882@mit.edu>
References: <20081104161024.GC28058@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:39661 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752252AbYKYKXi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2008 05:23:38 -0500
Content-Disposition: inline
In-Reply-To: <20081104161024.GC28058@unused.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 04, 2008 at 11:10:25AM -0500, Josef Bacik wrote:
> +	commit_time = ktime_to_ns(ktime_sub(ktime_get(), start_time));
> +
> +	/*
> +	 * weight the commit time higher than the average time so we don't
> +	 * react too strongly to vast changes in the commit time
> +	 */
> +	if (likely(journal->j_average_commit_time))
> +		journal->j_average_commit_time = (commit_time*3 +
> +				journal->j_average_commit_time) / 4;

Stupid question... if the goal is to not have the average commit time
not react too strongly to sudden and vast changes to the commit time,
would it be better to do this instead:

> +		journal->j_average_commit_time = (commit_time +
> +				journal->j_average_commit_time*3) / 4;


						    - Ted
