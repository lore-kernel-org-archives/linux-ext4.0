From: Nikolay Borisov <nborisov@suse.com>
Subject: Re: [RFC PATCH 1/4] fs: new infrastructure for writeback error
 handling and reporting
Date: Mon, 3 Apr 2017 10:12:48 +0300
Message-ID: <3b4d45be-ef00-04a5-5858-126c5aeaa76f@suse.com>
References: <20170331192603.16442-1-jlayton@redhat.com>
 <20170331192603.16442-2-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz,
        willy@infradead.org, neilb@suse.com
To: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170331192603.16442-2-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On 31.03.2017 22:26, Jeff Layton wrote:
> Most filesystems currently use mapping_set_error and
> filemap_check_errors for setting and reporting/clearing writeback errors
> at the mapping level. filemap_check_errors is indirectly called from
> most of the filemap_fdatawait_* functions and from
> filemap_write_and_wait*. These functions are called from all sorts of
> contexts to wait on writeback to finish -- e.g. mostly in fsync, but
> also in truncate calls, getattr, etc.
> 
> It's those non-fsync callers that are problematic. We should be
> reporting writeback errors during fsync, but many places in the code
> clear out errors before they can be properly reported, or report errors
> at nonsensical times. If I get -EIO on a stat() call, how do I know that
> was because writeback failed?
> 
> This patch adds a small bit of new infrastructure for setting and
> reporting errors during pagecache writeback. While the above was my
> original impetus for adding this, I think it's also the case that
> current fsync semantics are just problematic for userland. Most
> applications that call fsync do so to ensure that the data they wrote
> has hit the backing store.
> 
> In the case where there are multiple writers to the file at the same
> time, this is really hard to determine. The first one to call fsync will
> see any stored error, and the rest get back 0. The processes with open
> fd may not be associated with one another in any way. They could even be
> in different containers, so ensuring coordination between all fsync
> callers is not really an option.
> 
> One way to remedy this would be to track what file descriptor was used
> to dirty the file, but that's rather cumbersome and would likely be
> slow. However, there is a simpler way to improve the semantics here
> without incurring too much overhead.
> 
> This set adds a wb_error field and a sequence counter to the
> address_space, and a corresponding sequence counter in the struct file.
> When errors are reported during writeback, we set the error field in the
> mapping and increment the sequence counter.
> 
> When fsync or flush is called, we check the sequence in the file vs. the
> one in the mapping. If the file's counter is behind the one in the
> mapping, then we update the sequence counter in the file to the value of
> the one in the mapping and report the error. If the file is "caught up"
> then we just report 0.
> 
> This changes the semantics of fsync such that applications can now use
> it to determine whether there were any writeback errors since fsync(fd)
> was last called (or since the file was opened in the case of fsync
> having never been called).
> 
> Note that those writeback errors may have occurred when writing data
> that was dirtied via an entirely different fd, but that's the case now
> with the current mapping_set_error/filemap_check_error infrastructure.
> This will at least prevent you from getting a false report of success.
> 
> The basic idea here is for filesystems to use filemap_set_wb_error to
> set the error in the mapping when there are writeback errors, and then
> have the fsync and flush operations call filemap_report_wb_error just
> before returning to ensure that those errors get reported properly.
> 
> Eventually, it may make sense to move the reporting into the generic
> vfs_fsync_range helper, but doing it this way for now makes it simpler
> to convert filesystems to the new API individually.

There is already a mapping_set_error API which sets flags in
mapping->flags (AS_EIO/AS_ENOSPC). Aren't you essentially duplicating
some of the semantics of that API ?
