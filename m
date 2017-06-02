From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v5 00/17] fs: introduce new writeback error reporting
 and convert ext2 and ext4 to use it
Date: Fri, 02 Jun 2017 06:07:30 -0400
Message-ID: <1496398050.13822.2.camel@redhat.com>
References: <20170531124540.8782-1-jlayton@redhat.com>
         <20170602052545.GB5909@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        corbet@lwn.net, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:35107 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbdFBKHj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Jun 2017 06:07:39 -0400
Received: by mail-qt0-f170.google.com with SMTP id w1so28454923qtg.2
        for <linux-ext4@vger.kernel.org>; Fri, 02 Jun 2017 03:07:39 -0700 (PDT)
In-Reply-To: <20170602052545.GB5909@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2017-06-01 at 23:25 -0600, Ross Zwisler wrote:
> On Wed, May 31, 2017 at 08:45:23AM -0400, Jeff Layton wrote:
> > v5: don't retrofit old API over the new infrastructure
> >     add fstype flag to indicate how wb errors are tracked within that fs
> >     add more function variants that take a errseq_t "since" value
> >     add second errseq_t to struct file to track metadata wb errors
> >     convert ext4 and ext2 to use the new APIs
> > 
> > v4: several more cleanup patches
> >     documentation and kerneldoc comment updates
> >     fix bugs in gfs2 patches
> >     make sync_file_range use same error reporting semantics
> >     bugfixes in buffer.c
> >     convert nfs to new scheme (maybe bogus, can be dropped)
> > 
> > v3: wb_err_t -> errseq_t conversion
> >     clean up places that re-set errors after calling filemap_* functions
> > 
> > v2: introduce wb_err_t, use atomics
> > 
> > This is v5 of the patchset to improve how we're tracking and reporting
> > errors that occur during pagecache writeback. The main difference in
> > this set from the last one is that I've stopped trying to retrofit the
> > old error tracking API on top of the new one. This is more work since
> > we'll have to touch each fs individually, but should be safer as the
> > "since" values used for checking errors will be more deliberate.
> > 
> > There are several situations where the kernel can "lose" errors that
> > occur during writeback, such that fsync will return success even
> > though it failed to write back some data previously. The basic idea
> > here is to have the kernel be more deliberate about the point from
> > which errors are checked to ensure that that doesn't happen.
> > 
> > An additional aim of this set is to change the behavior of fsync in
> > Linux to report writeback errors on all fds instead of just the first
> > one. This allows writers to reliably tell whether their data made it to
> > the backing device without having to coordinate fsync calls with other
> > writers.
> > 
> > To do this, we add a new typedef: errseq_t. This is a 32-bit value
> > that can store an error code, and a sequence number so we can tell
> > whether it has changed since we last sampled it. This allows us to
> > record errors in the address_space and then report those errors only
> > once per file description.
> > 
> > This set just alters block device files, ext4 and the legacy ext2
> > driver. If this general approach seems acceptable, then I'll start
> > converting other filesystems in follow-on patchsets. I'd also like
> > to get this into linux-next as soon as possible to ensure that we're
> > banging out any bugs that might be lurking here.
> > 
> > I also have a couple of xfstests for this as well that I'll re-post
> > soon.
> 
> Can you tell me a baseline that this applies cleanly to, or give me a link to
> a tree with these patches already applied?  I've tried applying it to v4.11,
> linux/master and mmots/master, and so far nothing has worked.

It's basically on top of v4.12-rc3, but it may not apply cleanly
without the pile of individual patches that I sent recently.

It may be best to just pull down the "wberr" branch from my tree here:

    git://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git

I was originally sending the prep patches as part of this series, but
maintainers weren't picking them up, so I moved to sending them
individually and then sending this pile as its own set.

Many thanks for giving this a look and testing it!
-- 
Jeff Layton <jlayton@redhat.com>
