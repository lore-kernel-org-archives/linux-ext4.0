From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] xfs: Add support IOC_MOV_DATA ioctl
Date: Mon, 14 Jul 2014 17:25:39 -0400
Message-ID: <20140714212539.GH8935@thunk.org>
References: <003f01cf9aa4$1e9e5240$5bdaf6c0$@samsung.com>
	<20140708121500.GA518@infradead.org>
	<001801cf9b3f$ad786ff0$08694fd0$@samsung.com>
	<87ha2jsy6p.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Namjae Jeon <namjae.jeon@samsung.com>, 'Brian Foster' <bfoster@redhat.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	'Christoph Hellwig' <hch@infradead.org>,
	'Ashish Sangwan' <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org,
	'Luk?? Czerner' <lczerner@redhat.com>,
	'linux-ext4' <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <87ha2jsy6p.fsf@openvz.org>
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

On Mon, Jul 14, 2014 at 08:27:26PM +0400, Dmitry Monakhov wrote:
> Actually they are differ. EXT4_IOC_MOVE_EXT copy data inside kernel,
> but XFS_IOC_SWAPEXT live this job to userpsace see:
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsprogs.git;a=blob;f=fsr/xfs_fsr.c packfile
> And I'll vote to make EXT4_IOC_MOVE_EXT deprecated, and implement EXT4_IOC_SWAPEXT
> as XFS does that.
> Ted, Lukas what do you think about that?

The reason why EXT4_IOC_MOVE_EXT moves the data via the cache is to
avoid being subject to races if the file happens to mmap'ed and being
actively modified at the time of the defrag operation.  

I'm not sure how XFS handles that case, but if it's not somehow
locking the file against mmap's before it starts the userspace copy,
it would seem to me to be fairly dangerous in terms of prevent
potential data loss in this scenario.  Unless they are doing some
especially clever?

Regards,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
