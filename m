From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/11] quota: Improve locking
Date: Fri, 23 Jan 2009 23:49:12 -0800
Message-ID: <20090123234912.f78d75a0.akpm@linux-foundation.org>
References: <yes>
	<1232129299-22018-1-git-send-email-jack@suse.cz>
	<1232129299-22018-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbZAXHte (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Jan 2009 02:49:34 -0500
In-Reply-To: <1232129299-22018-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 16 Jan 2009 19:08:09 +0100 Jan Kara <jack@suse.cz> wrote:

>  static DEFINE_SPINLOCK(dq_list_lock);
> +static DEFINE_SPINLOCK(dq_state_lock);
>  DEFINE_SPINLOCK(dq_data_lock);

The chances are very good that two or even three of these locks will
all get placed into the same cacheline in main memory.  The effects
will be quite bad if different CPUs (or, worse, different nodes) are
taking these locks.

For single, kernel-wide locks like these I think we should almost
always pad out to a cacheline.

With __cacheline_aligned_in_smp, rather than __cacheline_aligned. 
Because spinlocks do take space even in uniprocessor builds.

There are probably lots of existing locks which should be converted.
