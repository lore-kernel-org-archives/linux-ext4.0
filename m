From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 15/27] fs: retrofit old error reporting API onto new
 infrastructure
Date: Mon, 15 May 2017 12:42:46 +0200
Message-ID: <20170515104246.GC16182@quack2.suse.cz>
References: <20170509154930.29524-1-jlayton@redhat.com>
 <20170509154930.29524-16-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
        ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org,
        jack-IBi9RG/b67k@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org,
        neilb-l3A5Bk7waGM@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org,
        josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, hubcap-gqc3UtWaqJ5Wk0Htik3J/w@public.gmane.org, rpeterso-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        bo.li.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170509154930.29524-16-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue 09-05-17 11:49:18, Jeff Layton wrote:
> Now that we have a better way to store and report errors that occur
> during writeback, we need to convert the existing codebase to use it. We
> could just adapt all of the filesystem code and related infrastructure
> to the new API, but that's a lot of churn.
> 
> When it comes to setting errors in the mapping, filemap_set_wb_error is
> a drop-in replacement for mapping_set_error. Turn that function into a
> simple wrapper around the new one.
> 
> Because we want to ensure that writeback errors are always reported at
> fsync time, inject filemap_report_wb_error calls much closer to the
> syscall boundary, in call_fsync.
> 
> For fsync calls (and things like the nfsd equivalent), we either return
> the error that the fsync operation returns, or the one returned by
> filemap_report_wb_error. In both cases, we advance the file->f_wb_err to
> the latest value. This allows us to provide new fsync semantics that
> will return errors that may have occurred previously and been viewed
> via other file descriptors.
> 
> The final piece of the puzzle is what to do about filemap_check_errors
> calls that are being called directly or via filemap_* functions. Here,
> we must take a little "creative license".
> 
> Since we now handle advancing the file->f_wb_err value at the generic
> filesystem layer, we no longer need those callers to clear errors out
> of the mapping or advance an errseq_t.
> 
> A lot of the existing codebase relies on being getting an error back
> from those functions when there is a writeback problem, so we do still
> want to have them report writeback errors somehow.
> 
> When reporting writeback errors, we will always report errors that have
> occurred since a particular point in time. With the old writeback error
> reporting, the time we used was "since it was last tested/cleared" which
> is entirely arbitrary and potentially racy. Now, we can at least report
> the latest error that has occurred since an arbitrary point in time
> (represented as a sampled errseq_t value).
> 
> In the case where we don't have a struct file to work with, this patch
> just has the wrappers sample the current mapping->wb_err value, and use
> that as an arbitrary point from which to check for errors.

I think this is really dangerous and we shouldn't do this. You are quite
likely to lose IO errors in such calls because you will ignore all errors
that happened during previous background writeback or even for IO that
managed to complete before we called filemap_fdatawait(). Maybe we need to
keep the original set-clear-bit IO error reporting for these cases, until
we can convert them to fdatawait_range_since()?

> That's probably not "correct" in all cases, particularly in the case of
> something like filemap_fdatawait, but I'm not sure it's any worse than
> what we already have, and this gives us a basis from which to work.
> 
> A lot of those callers will likely want to change to a model where they
> sample the errseq_t much earlier (perhaps when starting a transaction),
> store it in an appropriate place and then use that value later when
> checking to see if an error occurred.
> 
> That will almost certainly take some involvement from other subsystem
> maintainers. I'm quite open to adding new API functions to help enable
> this if that would be helpful, but I don't really want to do that until
> I better understand what's needed.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

...

> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 5f7317875a67..7ce13281925f 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -187,6 +187,7 @@ static int f2fs_do_sync_file(struct file *file, loff_t start, loff_t end,
>  		.nr_to_write = LONG_MAX,
>  		.for_reclaim = 0,
>  	};
> +	errseq_t since = READ_ONCE(file->f_wb_err);
>  
>  	if (unlikely(f2fs_readonly(inode->i_sb)))
>  		return 0;
> @@ -265,6 +266,8 @@ static int f2fs_do_sync_file(struct file *file, loff_t start, loff_t end,
>  	}
>  
>  	ret = wait_on_node_pages_writeback(sbi, ino);
> +	if (ret == 0)
> +		ret = filemap_check_wb_error(NODE_MAPPING(sbi), since);
>  	if (ret)
>  		goto out;

So this conversion looks wrong and actually points to a larger issue with
the scheme. The problem is there are two mappings that come into play here
- file_inode(file)->i_mapping which is the data mapping and
NODE_MAPPING(sbi) which is the metadata mapping (and this is not a problem
specific to f2fs. For example ext2 also uses this scheme where block
devices' mapping is the metadata mapping). And we need to merge error
information from these two mappings so for the stamping scheme to work,
we'd need two stamps stored in struct file. One for data mapping and one
for metadata mapping. Or maybe there's some more clever scheme but for now
I don't see one...

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
