From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC] [PATCH] Fix race when checking i_size on direct i/o read
Date: Fri, 17 Jan 2014 11:20:49 +0100
Message-ID: <CAJfpegtffQj1Rk0UM6nd0yBpbnS8kXjN-1j04gt1hnZefLZJ9w@mail.gmail.com>
References: <1387273422.2729.13.camel@menhir>
	<20131217111626.GA7544@gmail.com>
	<1387282664.2729.42.camel@menhir>
	<20131217164159.GA7331@gmail.com>
	<1387456073.2763.20.camel@menhir>
	<20131219224400.GC31386@dastard>
	<1387531724.2739.13.camel@menhir>
	<20131223030006.GD3220@dastard>
	<1389712933.2790.31.camel@menhir>
	<20140114191901.GC27863@quack.suse.cz>
	<20140115071933.GA3449@gmail.com>
	<1389886553.2779.32.camel@menhir>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, Jan Kara <jack@suse.cz>,
	Dave Chinner <david@fromorbit.com>,
	Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, Chris Mason <clm@fb.com>,
	Josef Bacik <jbacik@fb.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1389886553.2779.32.camel@menhir>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 16, 2014 at 4:35 PM, Steven Whitehouse <swhiteho@redhat.com> wrote:
>
> Following on from the "Re: [PATCH v3] vfs: fix a bug when we do some dio
> reads with append dio writes" thread on linux-fsdevel, this patch is my
> current version of the fix proposed as option (b) in that thread.
>
> Removing the i_size test from the direct i/o read path at VFS level
> means that filesystems now have to deal with requests which are beyond
> i_size themselves. These I've divided into three sets:
>
>  a) Those with "no op" ->direct_IO (9p, cifs, ceph)
> These are obviously not going to be an issue
>
>  b) Those with "home brew" ->direct_IO (nfs, fuse)
> I've been told that NFS should not have any problem with the larger
> i_size, however I've added an extra test to FUSE to duplicate the
> original behaviour just to be on the safe side. Someone who knows fuse
> better maybe able to confirm whether this is actually required or not.
>
>  c) Those using __blockdev_direct_IO()
> These call through to ->get_block() which should deal with the EOF
> condition correctly. I've verified that with GFS2 and I believe that
> Zheng has verified it for ext4. I've also run the test on XFS and it
> passes both before and after this change.
>
> The part of the patch in filemap.c looks a lot larger than it really is
> - there are only two lines of real change. The rest is just indentation
> of the contained code.
>
> There remains a test of i_size though, which was added for btrfs. It
> doesn't cause the other filesystems a problem as the test is performed
> after ->direct_IO has been called. It is possible that there is a race
> that does matter to btrfs, however this patch doesn't change that, so
> its still an overall improvement.
>
> So please have a look at this and let me know what you think. I guess
> that when time comes to submit it, it should probably be via the vfs
> tree.
>
> Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
> Reported-by: Zheng Liu <gnehzuil.liu@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <jbacik@fb.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 7e70506..89fdfd1 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -2710,6 +2710,9 @@ fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
>         inode = file->f_mapping->host;
>         i_size = i_size_read(inode);
>
> +       if ((rw == READ) && (offset > i_size))
> +               return 0;
> +

Hmm, OK.   It's not strictly needed, but a valid optimization.  So ACK.

Thanks,
Miklos
