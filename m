From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/2] new API to allocate buffer-cache for superblock in
 non-movable area
Date: Fri, 1 Aug 2014 11:15:39 +0200
Message-ID: <20140801091539.GA27281@quack.suse.cz>
References: <53CDF437.4090306@lge.com>
 <20140722073005.GT3935@laptop>
 <20140722093838.GA22331@quack.suse.cz>
 <53D8A258.7010904@lge.com>
 <20140730101143.GB19205@quack.suse.cz>
 <53D985C0.3070300@lge.com>
 <20140731000355.GB25362@quack.suse.cz>
 <53D98FBB.6060700@lge.com>
 <20140731122114.GA5240@quack.suse.cz>
 <20140801083446.GA2613@js1304-P5Q-DELUXE>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: Jan Kara <jack@suse.cz>, Gioh Kim <gioh.kim@lge.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140801083446.GA2613@js1304-P5Q-DELUXE>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Fri 01-08-14 17:34:46, Joonsoo Kim wrote:
> On Thu, Jul 31, 2014 at 02:21:14PM +0200, Jan Kara wrote:
> > On Thu 31-07-14 09:37:15, Gioh Kim wrote:
> > >=20
> > >=20
> > > 2014-07-31 =EC=98=A4=EC=A0=84 9:03, Jan Kara =EC=93=B4 =EA=B8=80:
> > > >On Thu 31-07-14 08:54:40, Gioh Kim wrote:
> > > >>2014-07-30 =EC=98=A4=ED=9B=84 7:11, Jan Kara =EC=93=B4 =EA=B8=80:
> > > >>>On Wed 30-07-14 16:44:24, Gioh Kim wrote:
> > > >>>>2014-07-22 =EC=98=A4=ED=9B=84 6:38, Jan Kara =EC=93=B4 =EA=B8=80=
:
> > > >>>>>On Tue 22-07-14 09:30:05, Peter Zijlstra wrote:
> > > >>>>>>On Tue, Jul 22, 2014 at 02:18:47PM +0900, Gioh Kim wrote:
> > > >>>>>>>Hello,
> > > >>>>>>>
> > > >>>>>>>This patch try to solve problem that a long-lasting page cac=
he of
> > > >>>>>>>ext4 superblock disturbs page migration.
> > > >>>>>>>
> > > >>>>>>>I've been testing CMA feature on my ARM-based platform
> > > >>>>>>>and found some pages for page caches cannot be migrated.
> > > >>>>>>>Some of them are page caches of superblock of ext4 filesyste=
m.
> > > >>>>>>>
> > > >>>>>>>Current ext4 reads superblock with sb_bread(). sb_bread() al=
locates page
> > > >>>>>>>from movable area. But the problem is that ext4 hold the pag=
e until
> > > >>>>>>>it is unmounted. If root filesystem is ext4 the page cannot =
be migrated forever.
> > > >>>>>>>
> > > >>>>>>>I introduce a new API for allocating page from non-movable a=
rea.
> > > >>>>>>>It is useful for ext4 and others that want to hold page cach=
e for a long time.
> > > >>>>>>
> > > >>>>>>There's no word on why you can't teach ext4 to still migrate =
that page.
> > > >>>>>>For all I know it might be impossible, but at least mention w=
hy.
> > > >>>>
> > > >>>>I am very sorry for lacking of details.
> > > >>>>
> > > >>>>In ext4_fill_super() the buffer-head of superblock is stored in=
 sbi->s_sbh.
> > > >>>>The page belongs to the buffer-head is allocated from movable a=
rea.
> > > >>>>To migrate the page the buffer-head should be released via brel=
se().
> > > >>>>But brelse() is not called until unmount.
> > > >>>   Hum, I don't see where in the code do we check buffer_head us=
e count. Can
> > > >>>you please point me? Thanks.
> > > >>
> > > >>Filesystem code does not check buffer_head use count.  sb_bread()=
 returns
> > > >>the buffer_head that is included in bh_lru and has non-zero use c=
ount.
> > > >>You can see the bh_lru code in buffer.c: __find_get_clock() and
> > > >>lookup_bh_lru().  bh_lru_install() inserts the buffer_head into t=
he
> > > >>bh_lru().  It first calls get_bh() to increase the use count and =
insert
> > > >>bh into the lru array.
> > > >>
> > > >>The buffer_head use count is non-zero until brelse() is called.
> > > >   So I probably didn't phrase the question precisely enough. What=
 I was
> > > >asking about is where exactly *migration* code checks buffer use c=
ount?
> > > >Because as I'm looking at buffer_migrate_page() we lock the buffer=
s on a
> > > >migrated page but we don't look at buffer use counts... So it seem=
s to me
> > > >that migration of a page with buffers should succeed even if buffe=
r head
> > > >has an elevated use count. Now I think that it *should* check the =
buffer
> > > >use counts (it is dangerous to migrate buffers someone holds refer=
ence to)
> > > >but I just cannot find that place. Or does CMA use some other migr=
ation
> > > >function for buffer pages than buffer_migrate_page()?
> > >=20
> > > CMA allocation function is cma_alloc().
> > > Function flow is alloc_contig_range() -> __alloc_contig_migrate_ran=
ge() -> migrate_pages -> unmap_and_move
> > > -> __unmap_and_move -> try_to_free_buffers -> drop_buffers -> buffe=
r_busy.
> > >=20
> > > The buffer_busy() is checking b_count.
> > > If buffer is busy buffer-cache cannot be removed.
> > > So the page that includes buffer_head and the page that is refered =
by
> > > buffer_head are not movable.
> > >=20
> > > Is this what you need?
> >   Yes, this is what I was asking about. Thanks! But as I'm looking in=
to
> > __unmap_and_move() it calls try_to_free_buffers() only if page->mappi=
ng =3D=3D
> > NULL. As the comment before that test states, this can happen only fo=
r swap
> > cache (not our case) or for pagecache pages that were truncated and n=
ot yet
> > fully cleaned up. But superblock page cannot really be truncated. So =
I
> > somewhat doubt you can hit the above path for a page holding superblo=
ck...
>=20
> Hello,
>=20
> Although page->mapping !=3D NULL, mapping->a_ops->migratepage could be
> NULL. This is the case of block_device. See def_blk_aops in
> fs/block_dev.c. In this case, fallback_migrate_page() is called and
> then try_to_release_page() and try_to_free_buffers() would be called.
  Aaah, right! Finally I understand what happens and why I couldn't see
buffer_migrate_page() being called for blkdev buffers. I didn't realize
blkdev mappings end up with NULL ->migratepage callback. Thanks a lot for
clearing this up.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
