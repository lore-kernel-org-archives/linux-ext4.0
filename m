From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH 1/1] iomap: Direct I/O for inline data
Date: Sun, 1 Jul 2018 23:44:50 +0200
Message-ID: <CAHc6FU5sG4369QmOo8bN2ycQ+UurnzR3H06CuSspT07boUub4w@mail.gmail.com>
References: <20180627003906.15571-1-agruenba@redhat.com>
	<20180627003906.15571-2-agruenba@redhat.com>
	<20180629085614.GB16042@lst.de>
	<CAHc6FU66vvPsDU2sq9O-_fRcU8CH_b6UsnQCYaSSbh-vVVWj=g@mail.gmail.com>
	<20180701062901.GA27398@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: cluster-devel <cluster-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20180701062901.GA27398@lst.de>
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

On 1 July 2018 at 08:29, Christoph Hellwig <hch@lst.de> wrote:
> On Fri, Jun 29, 2018 at 04:40:40PM +0200, Andreas Gruenbacher wrote:
>> On 29 June 2018 at 10:56, Christoph Hellwig <hch@lst.de> wrote:
>> > This looks generally fine.  But I think it might be worth refactoring
>> > iomap_dio_actor a bit first, e.g. something like this new patch
>> > before yours, which would also nicely solve your alignmnet concern
>> > (entirely untested for now):
>>
>> This looks correct. I've rebased my patches on top of it and I ran the
>> xfstest auto group on gfs2 and xfs on top.
>
> As I've just been rebasing the iomap work I've done the work already,
> does the version below work for you?

Yes, it does.

> ---
> From 5e8a0f157629bb8850b8d8fe049bb896730f0da7 Mon Sep 17 00:00:00 2001
> From: Andreas Gruenbacher <agruenba@redhat.com>
> Date: Sun, 1 Jul 2018 08:26:22 +0200
> Subject: iomap: support direct I/O to inline data
>
> Add support for reading from and writing to inline data to iomap_dio_rw.
> This saves filesystems from having to implement fallback code for this
> case.
>
> The inline data is actually cached in the inode, so the I/O is only
> direct in the sense that it doesn't go through the page cache.
>
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/iomap.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 4d8ff0f5ecc9..98a1fdd5c091 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -1450,6 +1450,33 @@ iomap_dio_hole_actor(loff_t length, struct iomap_dio *dio)
>         return length;
>  }
>
> +static loff_t
> +iomap_dio_inline_actor(struct inode *inode, loff_t pos, loff_t length,
> +               struct iomap_dio *dio, struct iomap *iomap)
> +{
> +       struct iov_iter *iter = dio->submit.iter;
> +       size_t copied;
> +
> +       BUG_ON(pos + length > PAGE_SIZE - offset_in_page(iomap->inline_data));
> +
> +       if (dio->flags & IOMAP_DIO_WRITE) {
> +               loff_t size = inode->i_size;
> +
> +               if (pos > size)
> +                       memset(iomap->inline_data + size, 0, pos - size);
> +               copied = copy_from_iter(iomap->inline_data + pos, length, iter);
> +               if (copied) {
> +                       if (pos + copied > size)
> +                               i_size_write(inode, pos + copied);
> +                       mark_inode_dirty(inode);
> +               }
> +       } else {
> +               copied = copy_to_iter(iomap->inline_data + pos, length, iter);
> +       }
> +       dio->size += copied;
> +       return copied;
> +}
> +
>  static loff_t
>  iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
>                 void *data, struct iomap *iomap)
> @@ -1467,6 +1494,8 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
>                 return iomap_dio_bio_actor(inode, pos, length, dio, iomap);
>         case IOMAP_MAPPED:
>                 return iomap_dio_bio_actor(inode, pos, length, dio, iomap);
> +       case IOMAP_INLINE:
> +               return iomap_dio_inline_actor(inode, pos, length, dio, iomap);
>         default:
>                 WARN_ON_ONCE(1);
>                 return -EIO;
> --
> 2.18.0
>

Thanks,
Andreas
