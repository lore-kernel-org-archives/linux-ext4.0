From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: return correct wbc.nr_to_write in
 ext4_da_writepages
Date: Thu, 17 Dec 2009 23:02:32 +0530
Message-ID: <20091217173232.GA2950@skywalker.linux.vnet.ibm.com>
References: <1261063063.4882.38.camel@castor>
 <4B2A50E9.4010806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Richard Kennedy <richard@rsk.demon.co.uk>, tytso@mit.edu,
	adilger@sun.com, linux-ext4@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:33421 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765046AbZLQRci (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Dec 2009 12:32:38 -0500
Content-Disposition: inline
In-Reply-To: <4B2A50E9.4010806@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 17, 2009 at 09:40:25AM -0600, Eric Sandeen wrote:
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

I guess writeback code can handle nr_to_write going negative. If we are
not updating wbc->nr_to_write then i guess writeback code will get a 
wrong value for number of pages written and can end up doing wrong things
We had it that way as a part of 22208dedbd7626e5fc4339c417f8d24cc21f79d7
and i guess we didn't had any problems with that

So for the patch

Acked-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

-aneesh
