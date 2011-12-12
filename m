From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 2/2] ext4: ext4_discard_partial_page_buffers_no_lock()
 wrong parameters
Date: Mon, 12 Dec 2011 17:55:17 +0100
Message-ID: <20111212165517.GE16411@redhat.com>
References: <1323656828-24465-1-git-send-email-aarcange@redhat.com>
 <1323656828-24465-3-git-send-email-aarcange@redhat.com>
 <CAGBYx2YTiHq4mkY5uh3ZawOAz1hbdzfgV2faBDEYZz-k9bySAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab1LLQzr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Dec 2011 11:55:47 -0500
Content-Disposition: inline
In-Reply-To: <CAGBYx2YTiHq4mkY5uh3ZawOAz1hbdzfgV2faBDEYZz-k9bySAA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 12, 2011 at 11:17:54AM +0800, Yongqiang Yang wrote:
> Hi Andrea,
> 
> The code you are testing are removed in recent patches,  the patches
> have not been merged.

I checked out the git ext4 tree and the two patches applies clean to
it. So I'm unsure why you say it was removed. origin/dev origin/master
are equal too.

> 
> Please try following patches:
> [PATCH 1/2] ext4: let mpage_submit_io works well when blocksize < pagesize
> [PATCH 2/2] ext4: let ext4_discard_partial_buffers handle pages
> without buffers correctly
> 
> and
> 
> [PATCH 1/2] ext4: remove a wrong BUG_ON in ext4_ext_convert_to_initialized
> [PATCH 2/2] ext4: let ext4_bio_write_page handle EOF correctly

Is there a git tree with these patches? I'm not subscribed to the list.

Thanks,
Andrea
