From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 25/27] Documentation: flesh out the section in
 vfs.txt on storing and reporting writeback errors
Date: Tue, 09 May 2017 12:24:17 -0400
Message-ID: <1494347057.2659.10.camel@redhat.com>
References: <20170509154930.29524-1-jlayton@redhat.com>
         <20170509154930.29524-26-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
        ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org,
        jack-IBi9RG/b67k@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org,
        neilb-l3A5Bk7waGM@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org,
        josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, hubcap-gqc3UtWaqJ5Wk0Htik3J/w@public.gmane.org, rpeterso-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        bo.li.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170509154930.29524-26-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2017-05-09 at 11:49 -0400, Jeff Layton wrote:
> I waxed a little loquacious here, but I figured that more detail was
> better, and writeback error handling is so hard to get right.
> 
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/filesystems/vfs.txt | 54 ++++++++++++++++++++++++++++++++-------
>  1 file changed, 45 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
> index f201a77873f7..382190a872e5 100644
> --- a/Documentation/filesystems/vfs.txt
> +++ b/Documentation/filesystems/vfs.txt
> @@ -576,12 +576,46 @@ should clear PG_Dirty and set PG_Writeback.  It can be actually
>  written at any point after PG_Dirty is clear.  Once it is known to be
>  safe, PG_Writeback is cleared.
>  
> -If there is an error during writeback, then the address_space should be
> -marked with an error (typically using mapping_set_error), in order to
> -ensure that the error can later be reported to the application when an
> -fsync is issued.
> -
> -Writeback makes use of a writeback_control structure...
> +Writeback makes use of a writeback_control structure to direct the
> +operations.  This gives the the writepage and writepages operations some
> +information about the nature of and reason for the writeback request,
> +and the constraints under which it is being done.  It is also used to
> +return information back to the caller about the result of a writepage or
> +writepages request.
> +
> +Handling errors during writeback
> +--------------------------------
> +Most applications that utilize the pagecache will periodically call
> +fsync to ensure that data written has made it to the backing store.
> +When there is an error during writeback, that error should be reported
> +when fsync is called.  After an error has been reported to fsync,
> +subsequent fsync calls on the same file descriptor should return 0,
> +unless further writeback errors have occurred since the previous fsync.
> +
> +Ideally, the kernel would report it only on file descriptions on which
> +writes were done that subsequently failed to be written back.  The
> +generic pagecache infrastructure does not track the file descriptions
> +that have dirtied each individual page however, so determining which
> +file descriptors should get back an error is not possible.
> +
> +Instead, the generic writeback error tracking infrastructure in the
> +kernel settles for reporting errors to fsync on all file descriptions
> +that were open at the time that the error occurred.  In a situation with
> +multiple writers, all of them will get back an error on a subsequent fsync,
> +even if all of the writes done through that particular file descriptor
> +succeeded (or even if there were no writes on that file descriptor at all).
> +

(cc'ing Michael Kerrisk)

Once this is closer to merge, I think we'll also want to update the
fsync(2) manpage with something similar to the 3 paragraphs above, and
also with an explanation of the behavior that applications can expect
from earlier kernels.

> +Filesystems that wish to use this infrastructure should call
> +mapping_set_error to record the error in the address_space when it
> +occurs.  The generic vfs code will then handle reporting the error when
> +fsync is called, even if the fsync file operation returned 0.
> +
> +Filesystems are free to track errors internally if they choose (i.e. if
> +they do keep track of how the pages were dirtied), but they should aim
> +to provide the same (or better) error reporting semantics for when there
> +are multiple writers.  Those filesystems should avoid calling
> +mapping_set_error in order to ensure that errors stored in the mapping
> +aren't improperly reported by the generic filesystem code.
>  
>  struct address_space_operations
>  -------------------------------
> @@ -810,7 +844,8 @@ struct address_space_operations {
>  The File Object
>  ===============
>  
> -A file object represents a file opened by a process.
> +A file object represents a file opened by a process. This is also known
> +as an "open file description" in POSIX parlance.
>  
>  
>  struct file_operations
> @@ -893,9 +928,10 @@ otherwise noted.
>  
>    release: called when the last reference to an open file is closed
>  
> -  fsync: called by the fsync(2) system call. Errors that were previously
> +  fsync: called by the fsync(2) system call.  Errors that were previously
>  	 recorded using mapping_set_error will automatically be returned to
> -	 the application and the file's error sequence advanced.
> +	 the application and the struct file's error sequence advanced.
> +	 See the section above on handling writeback errors.
>  
>    fasync: called by the fcntl(2) system call when asynchronous
>  	(non-blocking) mode is enabled for a file


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
