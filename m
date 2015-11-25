From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix race aio-dio vs freeze_fs
Date: Wed, 25 Nov 2015 10:19:16 +0100
Message-ID: <20151125091916.GL25232@quack.suse.cz>
References: <1448294568-20892-1-git-send-email-dmonakhov@openvz.org>
	<20151124132421.GG25232@quack.suse.cz>
	<CAF5pi0HpbN=kKQQUA5V1QaBzZMGQDcwuDs4bvuRYifnOHiJ8Bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, xfs@oss.sgi.com, Dmitriy Monakhov <dmonakhov@openvz.org>,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhovopenvz@gmail.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <CAF5pi0HpbN=kKQQUA5V1QaBzZMGQDcwuDs4bvuRYifnOHiJ8Bw@mail.gmail.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Tue 24-11-15 20:55:40, Dmitry Monakhov wrote:
> On Nov 24, 2015 16:25, "Jan Kara" <jack@suse.cz> wrote:
> > On Mon 23-11-15 20:02:48, Dmitry Monakhov wrote:
> > > After freeze_fs was revoked (from Jan Kara) pages's write-back
> completion
> > > is deffered before unwritten conversion, so explicit
> flush_unwritten_io()
> > > was removed here: c724585b62411
> > > But we still may face deferred conversion for aio-dio case
> > > # Trivial testcase
> > > for ((i=0;i<60;i++));do fsfreeze -f /mnt ;sleep 1;fsfreeze -u /mnt;done
> &
> > > fio --bs=4k --ioengine=libaio --iodepth=128 --size=1g --direct=1 \
> > >     --runtime=60 --filename=/mnt/file --name=rand-write --rw=randwrite
> > > NOTE: Sane testcase should be integrated to xfstests, but it requires
> > > changes in common/* code, so let's use this this test at the moment.
> > >
> > > In order to fix this race we have to guard journal transaction with
> explicit
> > > sb_{start,end}_intwrite()  as we do with ext4_evict_inode here:8e8ad8a5
> >
> > Well, this problem seems to suggest that we have the freeze protection for
> > AIO writes wrong. We should call file_end_write() from aio_complete() and
> > not from aio_run_iocb()...
> Yep. It was my first attempt to fix that issue, but  unfortunately this
> trick will break lockdep. Caller will do file_start_write and exit to
> userspace. Lockdep treats such behaviour as bug (return to userspace with a
> lock held)
> 
> There are two way to fix that
> 1) add specific 'long' lock primitive to lockdep

The way we tell lockdep about transfer of context is that we just lie to
lockdep and tell it that the lock got unlocked at appropriate place and
then tell it we locked it again at another place. It is somewhat ugly but
not that hard to do... Generally lockdep is a tool that should help but by
no means it should be a reason for poor locking decisions just because
lockdep cannot handle them.

								Honza
--
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
