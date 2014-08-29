From: Gioh Kim <gioh.kim@lge.com>
Subject: Re: [PATCHv3 1/3] fs/buffer.c: allocate buffer cache with user specific
 flag
Date: Fri, 29 Aug 2014 13:48:27 +0900
Message-ID: <5400061B.7060709@lge.com>
References: <53FE9357.6000505@lge.com> <53FE9492.1030909@lge.com> <20140828105909.GE5961@quack.suse.cz>
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
Received: from lgeamrelo04.lge.com ([156.147.1.127]:48797 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaH2Esb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Aug 2014 00:48:31 -0400
In-Reply-To: <20140828105909.GE5961@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



2014-08-28 =EC=98=A4=ED=9B=84 7:59, Jan Kara =EC=93=B4 =EA=B8=80:
> On Thu 28-08-14 11:31:46, Gioh Kim wrote:
>>
>> A buffer cache is allocated from movable area
>> because it is referred for a while and released soon.
>> But some filesystems are taking buffer cache for a long time
>> and it can disturb page migration.
>>
>> New APIs are introduced to allocate buffer cache
>> with user specific flag.
>> *_gfp APIs are for user want to set page allocation flag for page ca=
che
>> allocation.
>> And *_unmovable APIs are for the user wants to allocate page cache f=
rom
>> non-movable area.
>>
>> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
>    Still a few nits below.
>> ---
>>   fs/buffer.c                 |   54 +++++++++++++++++++++++++++++++=
++----------
>>   include/linux/buffer_head.h |   14 ++++++++++-
>>   2 files changed, 55 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/buffer.c b/fs/buffer.c
>> index 8f05111..ee29bc4 100644
>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -993,7 +993,7 @@ init_page_buffers(struct page *page, struct bloc=
k_device *bdev,
>>    */
>>   static int
>>   grow_dev_page(struct block_device *bdev, sector_t block,
>> -               pgoff_t index, int size, int sizebits)
>> +             pgoff_t index, int size, int sizebits, gfp_t gfp)
>    I've noticed that whitespace got damaged in your patches (tabs rep=
laced
> with spaces). Please use email client that doesn't do this or use
> attachments. Otherwise patch doesn't apply.

I'm sorry, it's my mistake.
I'm using Thunderbird but looking for another client.

>
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
>> @@ -1111,13 +1112,21 @@ __getblk_slow(struct block_device *bdev, sec=
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
>> +
>> +struct buffer_head *getblk_unmovable(struct block_device *bdev, sec=
tor_t block,
>> +                                    unsigned size)
>> +{
>> +       return __getblk_gfp(bdev, block, size, 0);
>> +}
>> +EXPORT_SYMBOL(getblk_unmovable);
>    This can be just an inline function in include/linux/buffer_head.h=
=2E

OK. I agreed.

>
>>   /*
>>    * The relationship between dirty buffers and dirty pages:
>> @@ -1385,7 +1394,7 @@ __getblk(struct block_device *bdev, sector_t b=
lock, unsigned size)
>>
>>          might_sleep();
>>          if (bh =3D=3D NULL)
>> -               bh =3D __getblk_slow(bdev, block, size);
>> +               bh =3D __getblk_gfp(bdev, block, size, __GFP_MOVABLE=
);
>>          return bh;
>>   }
>>   EXPORT_SYMBOL(__getblk);
>    I'd keep __getblk_slow() internal and just add 'gfp' parameter to =
it.
> Then change __getblk() to __getblk_gfp() and pass on the 'gfp' parame=
ter.
> And finally define inline __getblk() in include/linux/buffer_head.h w=
hich
> just calls __getblk_gfp() with appropriate gfp mask.
>
> That way you keep all the interfaces completely symmetric. For exampl=
e now
> you miss might_sleep() checks from __getblk_gfp().
>
> 								Honza
>

I got it.
What about below?: add gfp for __getblk_slow, change __getblk into __ge=
tblk_gfp,
getblk_unmovable and __getblk are, I think, symmetric.

If you say OK, I'm going to send v4 with tabs ;-)


diff --git a/fs/buffer.c b/fs/buffer.c
index 8f05111..21711c78 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -993,7 +993,7 @@ init_page_buffers(struct page *page, struct block_d=
evice *bdev,
   */
  static int
  grow_dev_page(struct block_device *bdev, sector_t block,
-               pgoff_t index, int size, int sizebits)
+             pgoff_t index, int size, int sizebits, gfp_t gfp)
  {
         struct inode *inode =3D bdev->bd_inode;
         struct page *page;
@@ -1002,10 +1002,10 @@ grow_dev_page(struct block_device *bdev, sector=
_t block,
         int ret =3D 0;            /* Will call free_more_memory() */
         gfp_t gfp_mask;

-       gfp_mask =3D mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS;
-       gfp_mask |=3D __GFP_MOVABLE;
+       gfp_mask =3D (mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS) |=
 gfp;
+
         /*
-        * XXX: __getblk_slow() can not really deal with failure and
+        * XXX: __getblk_gfp() can not really deal with failure and
          * will endlessly loop on improvised global reclaim.  Prefer
          * looping in the allocator rather than here, at least that
          * code knows what it's doing.
@@ -1058,7 +1058,7 @@ failed:
   * that page was dirty, the buffers are set dirty also.
   */
  static int
-grow_buffers(struct block_device *bdev, sector_t block, int size)
+grow_buffers(struct block_device *bdev, sector_t block, int size, gfp_=
t gfp)
  {
         pgoff_t index;
         int sizebits;
@@ -1085,11 +1085,12 @@ grow_buffers(struct block_device *bdev, sector_=
t block, int size)
         }

         /* Create a page with the proper size buffers.. */
-       return grow_dev_page(bdev, block, index, size, sizebits);
+       return grow_dev_page(bdev, block, index, size, sizebits, gfp);
  }

-static struct buffer_head *
-__getblk_slow(struct block_device *bdev, sector_t block, int size)
+struct buffer_head *
+__getblk_slow(struct block_device *bdev, sector_t block,
+            unsigned size, gfp_t gfp)
  {
         /* Size must be multiple of hard sectorsize */
         if (unlikely(size & (bdev_logical_block_size(bdev)-1) ||
@@ -1111,13 +1112,14 @@ __getblk_slow(struct block_device *bdev, sector=
_t block, int size)
                 if (bh)
                         return bh;

-               ret =3D grow_buffers(bdev, block, size);
+               ret =3D grow_buffers(bdev, block, size, gfp);
                 if (ret < 0)
                         return NULL;
                 if (ret =3D=3D 0)
                         free_more_memory();
         }
  }
+EXPORT_SYMBOL(__getblk_slow);

  /*
   * The relationship between dirty buffers and dirty pages:
@@ -1371,24 +1373,25 @@ __find_get_block(struct block_device *bdev, sec=
tor_t block, unsigned size)
  EXPORT_SYMBOL(__find_get_block);

  /*
- * __getblk will locate (and, if necessary, create) the buffer_head
+ * __getblk_gfp will locate (and, if necessary, create) the buffer_hea=
d
   * which corresponds to the passed block_device, block and size. The
   * returned buffer has its reference count incremented.
   *
- * __getblk() will lock up the machine if grow_dev_page's try_to_free_=
buffers()
- * attempt is failing.  FIXME, perhaps?
+ * __getblk()_gfp will lock up the machine if grow_dev_page's
+ * try_to_free_buffers() attempt is failing.  FIXME, perhaps?
   */
  struct buffer_head *
-__getblk(struct block_device *bdev, sector_t block, unsigned size)
+__getblk_gfp(struct block_device *bdev, sector_t block,
+            unsigned size, gfp_t gfp)
  {
         struct buffer_head *bh =3D __find_get_block(bdev, block, size)=
;

         might_sleep();
         if (bh =3D=3D NULL)
-               bh =3D __getblk_slow(bdev, block, size);
+               bh =3D __getblk_slow(bdev, block, size, gfp);
         return bh;
  }
-EXPORT_SYMBOL(__getblk);
+EXPORT_SYMBOL(__getblk_gfp);

  /*
   * Do async read-ahead on a buffer..
@@ -1410,18 +1413,39 @@ EXPORT_SYMBOL(__breadahead);
   *  @size: size (in bytes) to read
   *
   *  Reads a specified block, and returns buffer head that contains it=
=2E
+ *  The page cache is allocated from movable area so that it can be mi=
grated.
   *  It returns NULL if the block was unreadable.
   */
  struct buffer_head *
  __bread(struct block_device *bdev, sector_t block, unsigned size)
  {
-       struct buffer_head *bh =3D __getblk(bdev, block, size);
+       return __bread_gfp(bdev, block, size, __GFP_MOVABLE);
+}
+EXPORT_SYMBOL(__bread);
+
+/**
+ *  __bread_gfp() - reads a specified block and returns the bh
+ *  @bdev: the block_device to read from
+ *  @block: number of block
+ *  @size: size (in bytes) to read
+ *  @gfp: page allocation flag
+ *
+ *  Reads a specified block, and returns buffer head that contains it.
+ *  The page cache can be allocated from non-movable area
+ *  not to prevent page migration if you set gfp to zero.
+ *  It returns NULL if the block was unreadable.
+ */
+struct buffer_head *
+__bread_gfp(struct block_device *bdev, sector_t block,
+                  unsigned size, gfp_t gfp)
+{
+       struct buffer_head *bh =3D __getblk_gfp(bdev, block, size, gfp)=
;

         if (likely(bh) && !buffer_uptodate(bh))
                 bh =3D __bread_slow(bh);
         return bh;
  }
-EXPORT_SYMBOL(__bread);
+EXPORT_SYMBOL(__bread_gfp);

  /*
   * invalidate_bh_lrus() is called rarely - but not only at unmount.
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 324329c..6073f5d 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -175,12 +175,14 @@ void __wait_on_buffer(struct buffer_head *);
  wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
  struct buffer_head *__find_get_block(struct block_device *bdev, secto=
r_t block,
                         unsigned size);
-struct buffer_head *__getblk(struct block_device *bdev, sector_t block=
,
-                       unsigned size);
+struct buffer_head *__getblk_gfp(struct block_device *bdev, sector_t b=
lock,
+                                 unsigned size, gfp_t gfp);
  void __brelse(struct buffer_head *);
  void __bforget(struct buffer_head *);
  void __breadahead(struct block_device *, sector_t block, unsigned int=
 size);
  struct buffer_head *__bread(struct block_device *, sector_t block, un=
signed size);
+struct buffer_head *__bread_gfp(struct block_device *,
+                               sector_t block, unsigned size, gfp_t gf=
p);
  void invalidate_bh_lrus(void);
  struct buffer_head *alloc_buffer_head(gfp_t gfp_flags);
  void free_buffer_head(struct buffer_head * bh);
@@ -295,7 +297,13 @@ static inline void bforget(struct buffer_head *bh)
  static inline struct buffer_head *
  sb_bread(struct super_block *sb, sector_t block)
  {
-       return __bread(sb->s_bdev, block, sb->s_blocksize);
+       return __bread_gfp(sb->s_bdev, block, sb->s_blocksize, __GFP_MO=
VABLE);
+}
+
+static inline struct buffer_head *
+sb_bread_unmovable(struct super_block *sb, sector_t block)
+{
+       return __bread_gfp(sb->s_bdev, block, sb->s_blocksize, 0);
  }

  static inline void
@@ -307,7 +315,7 @@ sb_breadahead(struct super_block *sb, sector_t bloc=
k)
  static inline struct buffer_head *
  sb_getblk(struct super_block *sb, sector_t block)
  {
-       return __getblk(sb->s_bdev, block, sb->s_blocksize);
+       return __getblk_gfp(sb->s_bdev, block, sb->s_blocksize, __GFP_M=
OVABLE);
  }

  static inline struct buffer_head *
@@ -344,6 +352,20 @@ static inline void lock_buffer(struct buffer_head =
*bh)
                 __lock_buffer(bh);
  }

+static inline struct buffer_head *getblk_unmovable(struct block_device=
 *bdev,
+                                                  sector_t block,
+                                                  unsigned size)
+{
+       return __getblk_gfp(bdev, block, size, 0);
+}
+
+static inline struct buffer_head *__getblk(struct block_device *bdev,
+                                          sector_t block,
+                                          unsigned size)
+{
+       return __getblk_gfp(bdev, block, size, __GFP_MOVABLE);
+}
+
  extern int __set_page_dirty_buffers(struct page *page);

  #else /* CONFIG_BLOCK */
--
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
