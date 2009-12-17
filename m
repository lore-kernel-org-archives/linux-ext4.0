From: Richard Kennedy <richard@rsk.demon.co.uk>
Subject: Re: [PATCH] ext4: return correct wbc.nr_to_write in
 ext4_da_writepages
Date: Thu, 17 Dec 2009 15:58:26 +0000
Message-ID: <1261065506.4882.47.camel@castor>
References: <1261063063.4882.38.camel@castor>  <4B2A50E9.4010806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:35040 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752192AbZLQP62 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Dec 2009 10:58:28 -0500
In-Reply-To: <4B2A50E9.4010806@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2009-12-17 at 09:40 -0600, Eric Sandeen wrote:
> Richard Kennedy wrote:
> > ext4: always re-base nr_to_write in ext4_da_writepages
> > 
> > When ext4_da_writepages increases the nr_to_write in writeback_control
> > then it must always re-base the return value.
> > 
> > Without this change, when wb_writeback calculates how many pages were
> > actually written it can get a negative value and loop more times than
> > necessary. In tests I have seen nearly all the dirty pages pushed out to
> > writeback due to this issue.
> > 
> > Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> > 
> > ----
> > 
> > patch against 2.6.32
> > tested on x86_64
> > 
> > wb_writeback calculates (MAX_WRITE_PAGES - nr_to_write) & cannot know
> > that the value got changed.
> > 
> > I'm not sure what the test I removed was for.
> > Perhaps 
> > 	if (nr_to_writebump)
> > 		wbc->nr_to_write -= nr_to_writebump;
> > was intended?
> 
> Ted's commit 55138e0b added it (just part of the commit):
> 
> @@ -2914,7 +2994,8 @@ retry:
>  out_writepages:
>         if (!no_nrwrite_index_update)
>                 wbc->no_nrwrite_index_update = 0;
> -       wbc->nr_to_write -= nr_to_writebump;
> +       if (wbc->nr_to_write > nr_to_writebump)
> +               wbc->nr_to_write -= nr_to_writebump;
>         wbc->range_start = range_start;
>         trace_ext4_da_writepages_result(inode, wbc, ret, pages_written);
>         return ret;
> 
> so it looks like the intent there was to stop ->nr_to_write from
> going negative ...
> 
> 
wb_writeback is OK with negative, it just needs to know how many pages
were written. Then it can decide if it's done the work it was asked to
do. balance_dirty_pages uses this throttle a device by asking for
writeback on a small number of pages. 
regards
Richard 



