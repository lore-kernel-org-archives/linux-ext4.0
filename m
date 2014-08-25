From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH v5 2/10] xfs: Add support FALLOC_FL_INSERT_RANGE for
	fallocate
Date: Mon, 25 Aug 2014 15:52:26 +0900
Message-ID: <001901cfc031$2140a950$63c1fbf0$@samsung.com>
References: <004301cfb2c6$6ef2d330$4cd87990$@samsung.com>
	<20140822120659.GF3152@laptop.bfoster>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: 'Theodore Ts'o' <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	=?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>,
	'linux-ext4' <linux-ext4@vger.kernel.org>
To: 'Brian Foster' <bfoster@redhat.com>
Return-path: <xfs-bounces@oss.sgi.com>
In-reply-to: <20140822120659.GF3152@laptop.bfoster>
Content-language: ko
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

> Hi Namjae,
Hi Brian.

Thanks for your mail :)
> 
> Sorry for finding things so late, but it looks like this suffers from
> the same couple bugs we've recently discovered with the collapse range
> patches. See the following for a couple fixes that have been proposed
> recently:
> 
> http://oss.sgi.com/archives/xfs/2014-08/msg00292.html
> 
> This one helps prevent scenarios where we try to cancel a transaction
> that is dirty. This leads to a shutdown on XFS. The idea is basically to
> avoid logging until we actually make a change, so errors hit early in
> the function (before we change anything) won't lead to an abort in the
> error path. It looks like the bmap split and shift functions in this
> patch could use the very same attention.
Okay, I will add this commit to insert range patch.

> 
> http://oss.sgi.com/archives/xfs/2014-08/index.html
> 
> This one deals with a problem with the high level shift algorithm. The
> problem with the algorithm here is that 'current_ext' can change
> unexpectedly once we release the ilock due to writeback on parts of the
> file before the range being collapsed/inserted. E.g., it is not a stable
> index once ilock is dropped. The temporary solution is to flush the
> entire file, since we have the iolock during the entire operation and
> nothing else can dirty the file. The better fix is to track via an
> offset across iterations of the shift, rather than the extent count
> (iirc, xfs_bunmapi() and other bmap functions provide examples of this
> kind of algorithm).
Okay, I will check your points.

> 
> Brian
> 
> P.S., It's probably a good idea to remove my r-b tag on the next post as
> well to avoid confusion and remind me that I need to take another look
> at this. ;) Thanks again.
Okay, I will remove it.

Thanks Brian!
> 

> > --
> > 1.7.11-rc0
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
