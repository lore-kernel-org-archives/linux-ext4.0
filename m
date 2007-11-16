From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext3,4:fdatasync should skip metadata writeout
Date: Thu, 15 Nov 2007 19:53:21 -0800
Message-ID: <20071115195321.2b802bc0.akpm@linux-foundation.org>
References: <6.0.0.20.2.20071116114652.03b9e4e8@172.19.0.2>
	<20071115185919.7df4cda9.akpm@linux-foundation.org>
	<473D12DC.8090907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: wcheng@redhat.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <473D12DC.8090907@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 15 Nov 2007 22:47:40 -0500 Wendy Cheng <wcheng@redhat.com> wrote:

> Andrew Morton wrote:
> 
> >On Fri, 16 Nov 2007 11:47:27 +0900 Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:
> >
> >  
> >
> >>Currently fdatasync is identical to fsync in ext3,4.
> >>I think fdatasync should skip journal flush in data=ordered and data=writeback mode
> >>because this syscall is not required to synchronize the metadata.
> >>    
> >>
> >
> >I suppose so.  Although one wonders what earthly point there is in syncing
> >a file's data if we haven't yet written out the metadata which is required
> >for locating that data.
> >
> >IOW, fdatasync() is only useful if the application knows that it is overwriting
> >already-instantiated blocks.
> >
> >In which case it might as well have used fsync().  For ext2-style filesystems,
> >anyway.
> >
> >hm.  It needs some thought.
> >
> >  
> >
> 
> There are non-trivial amount of performance critical programs, 
> particularly in financial application segment ported from legacy UNIX 
> platforms, know the difference between fsync() and fdatasync(). Those 
> can certainly take advantages of this separation. Don't underestimate 
> the talents of these application programmers.
> 

If they're that good, they'll be using sync_file_range() ;)
