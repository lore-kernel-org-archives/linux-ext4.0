From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] ext4: Add fdatasync scalability optimization
Date: Tue, 14 Oct 2014 04:35:47 -0700
Message-ID: <20141014113547.GB3926@infradead.org>
References: <1413281035-6483-1-git-send-email-dmonakhov@openvz.org>
 <1413281035-6483-5-git-send-email-dmonakhov@openvz.org>
 <20141014105729.GA19981@infradead.org>
 <87oateq4e5.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87oateq4e5.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 14, 2014 at 03:25:54PM +0400, Dmitry Monakhov wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> 
> > Much of the bookkeeping here seems generic and should be in common
> > code and not inside a filesystem.
> Yes. But this means that I need to store flush_id inside generic inode
> which likely will be accepted negatively because VFS people do not like
> inode bloating. But if you are OK then I'll prepare the patch.

With my "VFS person critical of struct inode size increases" hat on
I'm still critical of any struct inode increase, so if you can find
an option that say just takes the address of the counter variable
I'd prefer that.  But even if we have to increase the inode this might
be one of the cases where it's fine as cache flushing is something
at least all on disk filesystems need to do.
