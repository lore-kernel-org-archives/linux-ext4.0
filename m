From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH 0/1] iomap: Direct I/O for inline data
Date: Wed, 27 Jun 2018 13:14:24 +0200
Message-ID: <CAHc6FU7gJUcaKRr6He8Te0wcMYMQjriwbz58pC-ie1m-WJOw0g@mail.gmail.com>
References: <20180627003906.15571-1-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: cluster-devel <cluster-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20180627003906.15571-1-agruenba@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On 27 June 2018 at 02:39, Andreas Gruenbacher <agruenba@redhat.com> wrote:
> Here's a patch that implements direct I/O for inline data.  Direct I/O
> to inline data is a bit weird because it's not direct in the usual
> sense, but since Christoph's been asking for it ...
>
> The usual alignment restrictions to the logical block size of the
> underlying block device still apply.  I don't see a reason for changing
> that; the resulting behavior would only become very weird for no
> benefit.
>
> I've tested this against a hacked-up version of gfs2.  However, the
> "real" gfs2 will keep falling back to buffered I/O for writes to inline
> data: gfs2 takes a shared lock during direct I/O, and writing to the
> inode under that shared lock is not allowed.  Ext4 may become the first
> actual user of this part of the patch.

One further issue is the alignment check in iomap_dio_actor:

>        if ((pos | length | align) & ((1 << blkbits) - 1))
>                return -EINVAL;

For inline data, iomap->length is set to the file size. iomap_apply
truncates the requested length down to that, so iomap_dio_actor sees
the truncated length instead of the requested length and fails with
-EINVAL. This causes tests like the following to fail (also see
xfstest generic/120):

  xfs_io -fd -c 'truncate 300' -c 'pread -v 0 4096' /mnt/test/foo

A possible fix is to change the alignment check in iomap_dio_actor as follows:

-       if ((pos | length | align) & ((1 << blkbits) - 1))
+       if ((pos | align) & ((1 << blkbits) - 1))
+               return -EINVAL;
+       if (length & ((1 << blkbits) - 1) &&
+           pos + length != iomap->offset + iomap->length)
                return -EINVAL;

Moving the alignment check from iomap_dio_actor to iomap_dio_rw isn't
that easy because iomap->bdev isn't known there.

Any thoughts?

Thanks,
Andreas
