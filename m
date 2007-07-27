From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Fri, 27 Jul 2007 16:38:44 +0400
Message-ID: <46A9E754.5070904@clusterfs.com>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org> <46A878FC.5040600@clusterfs.com> <46A88DFD.7030609@garzik.org> <46A8A294.2070106@clusterfs.com> <20070727050714.GS12413810@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Garzik <jeff@garzik.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070727050714.GS12413810@sgi.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

David Chinner wrote:
> Firstly, XFS attaches a different I/O completion to delalloc writes
> to allow us to update the file size when the write is beyond the
> current on disk EOF. This code cannot do that as all it does is
> allocation and present "normal looking" buffers to the generic code
> path.

how do you implement fsync(2) ? you'd have to wait such IO to complete,
then update the inode and write it through the log?

> Also, looking at the way mpage_da_map_blocks() is done - if we have
> an 128MB delalloc extent - ext4 will allocate that will allocate it
> in one go, right? What happens if we then crash after only writing a
> few megabytes of that extent? stale data exposure? XFS can allocate
> multiple gigabytes in a single get_blocks call so even if ext4 can't
> do this, it's a problem for XFS.....

I just realized that you're talking about data=ordered mode in ext4,
where care is taken to prevent on-disk references to no-yet-written
blocks. The solution is to wait such IO to complete before metadata
commit. And the key thing here is to allocate and attach to inode
blocks we're writing immediately. IOW, there is no unwritten blocks
attached to inode (except fallocate(2) case), but there may be blocks
preallocated for this inode in-core. same gigabytes, but different
way ;)

I have no single objection to custom IO completion callback per
mpage_writepages().


thanks, Alex


