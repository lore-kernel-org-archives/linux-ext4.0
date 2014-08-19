From: Gioh Kim <gioh.kim@lge.com>
Subject: Re: [PATCHv2 1/3] fs/buffer.c: allocate buffer cache with user specific
 flag
Date: Wed, 20 Aug 2014 08:37:07 +0900
Message-ID: <53F3DFA3.6040303@lge.com>
References: <53F2F3E6.1030901@lge.com> <53F2F436.4070307@lge.com> <20140819130324.GB27553@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
	Joonsoo Kim <js1304@gmail.com>,
	=?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lgeamrelo01.lge.com ([156.147.1.125]:49531 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaHSXhT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Aug 2014 19:37:19 -0400
In-Reply-To: <20140819130324.GB27553@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



2014-08-19 =EC=98=A4=ED=9B=84 10:03, Jan Kara =EC=93=B4 =EA=B8=80:
>    Hello,
>
> On Tue 19-08-14 15:52:38, Gioh Kim wrote:
>> A buffer cache is allocated from movable area
>> because it is referred for a while and released soon.
>> But some filesystems are taking buffer cache for a long time
>> and it can disturb page migration.
>>
>> A new API should be introduced to allocate buffer cache
>> with user specific flag.
>> For instance if user set flag to zero, buffer cache is allocated fro=
m
>> non-movable area.
>>
>> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
>> ---
>>   fs/buffer.c                 |   52 +++++++++++++++++++++++++++++--=
------------
>>   include/linux/buffer_head.h |   12 +++++++++-
>>   2 files changed, 46 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/buffer.c b/fs/buffer.c
>> index 8f05111..14f2f21 100644
>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -993,7 +993,7 @@ init_page_buffers(struct page *page, struct bloc=
k_device *bdev,
>>    */
>>   static int
>>   grow_dev_page(struct block_device *bdev, sector_t block,
>> -               pgoff_t index, int size, int sizebits)
>> +             pgoff_t index, int size, int sizebits, gfp_t gfp)
>>   {
>>          struct inode *inode =3D bdev->bd_inode;
>>          struct page *page;
>> @@ -1002,10 +1002,10 @@ grow_dev_page(struct block_device *bdev, sec=
tor_t block,
>>          int ret =3D 0;            /* Will call free_more_memory() *=
/
>>          gfp_t gfp_mask;
>>
>> -       gfp_mask =3D mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS;
>> -       gfp_mask |=3D __GFP_MOVABLE;
>> +       gfp_mask =3D (mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS=
) | gfp;
>> +
>    Hum, it seems a bit misleading that the 'gfp' flags are just or-ed=
 to
> mapping_gfp_mask(inode->i_mapping). Usually, passed gfp mask is just
> directly used. There are also interfaces like pagecache_get_page() wh=
ich
> play more complex tricks with mapping_gfp_mask(). This would be yet a=
nother
> convention which I don't think is desirable. I know Andrew suggested =
what
> you wrote so I guess I have to settle this with him. Andrew?

I don't know mapping_gfp_mask(). I just add gfp at the original code.
Whould you tell me why it is undesirable?

>
>>          /*
>> -        * XXX: __getblk_slow() can not really deal with failure and
>> +        * XXX: __getblk_gfp() can not really deal with failure and
>>           * will endlessly loop on improvised global reclaim.  Prefe=
r
>>           * looping in the allocator rather than here, at least that
>>           * code knows what it's doing.
>> @@ -1058,7 +1058,7 @@ failed:
>>    * that page was dirty, the buffers are set dirty also.
>>    */
>>   static int
>> -grow_buffers(struct block_device *bdev, sector_t block, int size)
>> +grow_buffers(struct block_device *bdev, sector_t block, int size, g=
fp_t gfp)
>>   {
>>          pgoff_t index;
>>          int sizebits;
>> @@ -1085,11 +1085,12 @@ grow_buffers(struct block_device *bdev, sect=
or_t block, int size)
>>          }
>>
>>          /* Create a page with the proper size buffers.. */
>> -       return grow_dev_page(bdev, block, index, size, sizebits);
>> +       return grow_dev_page(bdev, block, index, size, sizebits, gfp=
);
>>   }
>>
>> -static struct buffer_head *
>> -__getblk_slow(struct block_device *bdev, sector_t block, int size)
>> +struct buffer_head *
>> +__getblk_gfp(struct block_device *bdev, sector_t block,
>> +            unsigned size, gfp_t gfp)
>>   {
>>          /* Size must be multiple of hard sectorsize */
>>          if (unlikely(size & (bdev_logical_block_size(bdev)-1) ||
>> @@ -1111,13 +1112,14 @@ __getblk_slow(struct block_device *bdev, sec=
tor_t block, int size)
>>                  if (bh)
>>                          return bh;
>>
>> -               ret =3D grow_buffers(bdev, block, size);
>> +               ret =3D grow_buffers(bdev, block, size, gfp);
>>                  if (ret < 0)
>>                          return NULL;
>>                  if (ret =3D=3D 0)
>>                          free_more_memory();
>>          }
>>   }
>> +EXPORT_SYMBOL(__getblk_gfp);
>>
>>   /*
>>    * The relationship between dirty buffers and dirty pages:
>> @@ -1381,12 +1383,7 @@ EXPORT_SYMBOL(__find_get_block);
>>   struct buffer_head *
>>   __getblk(struct block_device *bdev, sector_t block, unsigned size)
>>   {
>> -       struct buffer_head *bh =3D __find_get_block(bdev, block, siz=
e);
>> -
>> -       might_sleep();
>> -       if (bh =3D=3D NULL)
>> -               bh =3D __getblk_slow(bdev, block, size);
>> -       return bh;
>> +       return __getblk_gfp(bdev, block, size, __GFP_MOVABLE);
>>   }
>>   EXPORT_SYMBOL(__getblk);
>    Why did you remove the __find_get_block() call? That looks like a =
bug.
>
>> @@ -1410,18 +1407,39 @@ EXPORT_SYMBOL(__breadahead);
>>    *  @size: size (in bytes) to read
>>    *
>>    *  Reads a specified block, and returns buffer head that contains=
 it.
>> + *  The page cache is allocated from movable area so that it can be=
 migrated.
>>    *  It returns NULL if the block was unreadable.
>>    */
>>   struct buffer_head *
>>   __bread(struct block_device *bdev, sector_t block, unsigned size)
>>   {
>> -       struct buffer_head *bh =3D __getblk(bdev, block, size);
>> +       return __bread_gfp(bdev, block, size, __GFP_MOVABLE);
>> +}
>> +EXPORT_SYMBOL(__bread);
>> +
>> +/**
>> + *  __bread_gfp() - reads a specified block and returns the bh
>> + *  @bdev: the block_device to read from
>> + *  @block: number of block
>> + *  @size: size (in bytes) to read
>> + *  @gfp: page allocation flag
>> + *
>> + *  Reads a specified block, and returns buffer head that contains =
it.
>> + *  The page cache can be allocated from non-movable area
>> + *  not to prevent page migration if you set gfp to zero.
>> + *  It returns NULL if the block was unreadable.
>> + */
>> +struct buffer_head *
>> +__bread_gfp(struct block_device *bdev, sector_t block,
>> +                  unsigned size, gfp_t gfp)
>> +{
>> +       struct buffer_head *bh =3D __getblk_gfp(bdev, block, size, g=
fp);
>>
>>          if (likely(bh) && !buffer_uptodate(bh))
>>                  bh =3D __bread_slow(bh);
>>          return bh;
>>   }
>> -EXPORT_SYMBOL(__bread);
>> +EXPORT_SYMBOL(__bread_gfp);
>>
>>   /*
>>    * invalidate_bh_lrus() is called rarely - but not only at unmount=
=2E
>> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head=
=2Eh
>> index 324329c..a1d73fd 100644
>> --- a/include/linux/buffer_head.h
>> +++ b/include/linux/buffer_head.h
>> @@ -177,10 +177,14 @@ struct buffer_head *__find_get_block(struct bl=
ock_device *bdev, sector_t block,
>>                          unsigned size);
>>   struct buffer_head *__getblk(struct block_device *bdev, sector_t b=
lock,
>>                          unsigned size);
>> +struct buffer_head *__getblk_gfp(struct block_device *bdev, sector_=
t block,
>> +                                unsigned size, gfp_t gfp);
>>   void __brelse(struct buffer_head *);
>>   void __bforget(struct buffer_head *);
>>   void __breadahead(struct block_device *, sector_t block, unsigned =
int size);
>>   struct buffer_head *__bread(struct block_device *, sector_t block,=
 unsigned size);
>> +struct buffer_head *__bread_gfp(struct block_device *,
>> +                               sector_t block, unsigned size, gfp_t=
 gfp);
>>   void invalidate_bh_lrus(void);
>>   struct buffer_head *alloc_buffer_head(gfp_t gfp_flags);
>>   void free_buffer_head(struct buffer_head * bh);
>> @@ -295,7 +299,13 @@ static inline void bforget(struct buffer_head *=
bh)
>>   static inline struct buffer_head *
>>   sb_bread(struct super_block *sb, sector_t block)
>>   {
>> -       return __bread(sb->s_bdev, block, sb->s_blocksize);
>> +       return __bread_gfp(sb->s_bdev, block, sb->s_blocksize, __GFP=
_MOVABLE);
>> +}
>> +
>> +static inline struct buffer_head *
>> +sb_bread_gfp(struct super_block *sb, sector_t block, gfp_t gfp)
>> +{
>> +       return __bread_gfp(sb->s_bdev, block, sb->s_blocksize, gfp);
>>   }
>    I think Andrew was suggesting to provide sb_bread_unmovable() and
> sb_getblk_unmovable() which would set appropriately. It is then more
> obvious what are filesystems trying to do when using those functions.=
=2E.


I think the common interface is important.

If sb_getblk_unmovable() is obvious for the filesystem,
I will add some codes for getblk_unmovable() which calling __getblk_gfp=
(),
and sb_bread_unmovable() calling __bread_gfp().
If so, sb_bread_gfp is not necessary.

It might be like followings:

diff --git a/fs/buffer.c b/fs/buffer.c
index 14f2f21..35caf77 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1088,7 +1088,7 @@ grow_buffers(struct block_device *bdev, sector_t =
block, int siz
         return grow_dev_page(bdev, block, index, size, sizebits, gfp);
  }

-struct buffer_head *
+static struct buffer_head *
  __getblk_gfp(struct block_device *bdev, sector_t block,
              unsigned size, gfp_t gfp)
  {
@@ -1119,7 +1119,13 @@ __getblk_gfp(struct block_device *bdev, sector_t=
 block,
                         free_more_memory();
         }
  }
-EXPORT_SYMBOL(__getblk_gfp);
+
+struct buffer_head *getblk_unmovable(struct block_device *bdev, sector=
_t block,
+            unsigned size)
+{
+       return __getblk_gfp(bdev, block, size, 0);
+}
+EXPORT_SYMBOL(getblk_unmovable);

  /*
   * The relationship between dirty buffers and dirty pages:
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index a1d73fd..c5fb4fc 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -177,8 +177,8 @@ struct buffer_head *__find_get_block(struct block_d=
evice *bdev, s
                         unsigned size);
  struct buffer_head *__getblk(struct block_device *bdev, sector_t bloc=
k,
                         unsigned size);
-struct buffer_head *__getblk_gfp(struct block_device *bdev, sector_t b=
lock,
-                                unsigned size, gfp_t gfp);
+struct buffer_head *getblk_unmovable(struct block_device *bdev, sector=
_t block,
+                                    unsigned size);
  void __brelse(struct buffer_head *);
  void __bforget(struct buffer_head *);
  void __breadahead(struct block_device *, sector_t block, unsigned int=
 size);
@@ -303,9 +303,9 @@ sb_bread(struct super_block *sb, sector_t block)
  }

  static inline struct buffer_head *
-sb_bread_gfp(struct super_block *sb, sector_t block, gfp_t gfp)
+sb_bread_unmovable(struct super_block *sb, sector_t block)
  {
-       return __bread_gfp(sb->s_bdev, block, sb->s_blocksize, gfp);
+       return __bread_gfp(sb->s_bdev, block, sb->s_blocksize, 0);
  }

  static inline void



Is it better?

Thank you for your advice.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
