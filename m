From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: return correct wbc.nr_to_write in ext4_da_writepages
Date: Thu, 17 Dec 2009 09:40:25 -0600
Message-ID: <4B2A50E9.4010806@redhat.com>
References: <1261063063.4882.38.camel@castor>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965211AbZLQPkf@vger.kernel.org>
In-Reply-To: <1261063063.4882.38.camel@castor>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Richard Kennedy wrote:
> ext4: always re-base nr_to_write in ext4_da_writepages
> 
> When ext4_da_writepages increases the nr_to_write in writeback_control
> then it must always re-base the return value.
> 
> Without this change, when wb_writeback calculates how many pages were
> actually written it can get a negative value and loop more times than
> necessary. In tests I have seen nearly all the dirty pages pushed out to
> writeback due to this issue.
> 
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> 
> ----
> 
> patch against 2.6.32
> tested on x86_64
> 
> wb_writeback calculates (MAX_WRITE_PAGES - nr_to_write) & cannot know
> that the value got changed.
> 
> I'm not sure what the test I removed was for.
> Perhaps 
> 	if (nr_to_writebump)
> 		wbc->nr_to_write -= nr_to_writebump;
> was intended?

Ted's commit 55138e0b added it (just part of the commit):

@@ -2914,7 +2994,8 @@ retry:
 out_writepages:
        if (!no_nrwrite_index_update)
                wbc->no_nrwrite_index_update = 0;
-       wbc->nr_to_write -= nr_to_writebump;
+       if (wbc->nr_to_write > nr_to_writebump)
+               wbc->nr_to_write -= nr_to_writebump;
        wbc->range_start = range_start;
        trace_ext4_da_writepages_result(inode, wbc, ret, pages_written);
        return ret;

so it looks like the intent there was to stop ->nr_to_write from
going negative ...


> regards
> Richard
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 2c8caa5..52a573c 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2999,8 +2999,7 @@ retry:
>  out_writepages:
>  	if (!no_nrwrite_index_update)
>  		wbc->no_nrwrite_index_update = 0;
> -	if (wbc->nr_to_write > nr_to_writebump)
> -		wbc->nr_to_write -= nr_to_writebump;
> +	wbc->nr_to_write -= nr_to_writebump;
>  	wbc->range_start = range_start;
>  	trace_ext4_da_writepages_result(inode, wbc, ret, pages_written);
>  	return ret;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
