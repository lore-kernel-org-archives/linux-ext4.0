From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [Bug 13232] ext3/4 with synchronous writes gets wedged by
	Postfix
Date: Wed, 13 May 2009 19:13:40 +0100
Message-ID: <20090513181340.GA8128@ZenIV.linux.org.uk>
References: <bug-13232-13602@http.bugzilla.kernel.org/> <200905121656.n4CGu5Fl003852@demeter.kernel.org> <20090513134802.GA7212@atrey.karlin.mff.cuni.cz> <20090513165254.GR8633@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090513165254.GR8633@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 13, 2009 at 05:52:54PM +0100, Al Viro wrote:
> On Wed, May 13, 2009 at 03:48:02PM +0200, Jan Kara wrote:
> > >   Here, we have started a transaction in ext3_create() and then wait in
> > > find_inode_fast() for I_FREEING to be cleared (obviously we have
> > > reallocated the inode and squeezed the allocation before journal_stop()
> > > from the delete was called).
> > >   Nasty deadlock and I don't see how to fix it now - have to go home for
> > > today... Tomorrow I'll have a look what we can do about it.
> >   OK, the deadlock has been introduced by ext3 variant of
> > 261bca86ed4f7f391d1938167624e78da61dcc6b (adding Al to CC). The deadlock
> > is really tough to avoid - we have to first allocate inode on disk so
> > that we know the inode number. For this we need transaction open but we
> > cannot afford waiting for old inode with same INO to be freed when we have
> > transaction open because of the above deadlock. So we'd have to wait for
> > inode release only after everything is done and we closed the transaction. But
> > that would mean reordering a lot of code in ext3/namei.c so that all the
> > dcache handling is done after all the IO is done.
> >   Hmm, maybe we could change the delete side of the deadlock but that's
> > going to be tricky as well :(.
> >   Al, any idea if we could somehow get away without waiting on
> > I_FREEING?
> 
> At which point do we actually run into deadlock on delete side?  We could,
> in principle, skip everything like that in insert_inode_locked(), but
> I would rather avoid the "two inodes in icache at the same time, with the
> same inumber" situations completely.  We might get away with that, since
> everything else *will* wait, so we can afford a bunch of inodes past the
> point in foo_delete_inode() that has cleared it in bitmap + new locked
> one, but if it's at all possible to avoid, I'd rather avoid it.

OK, that's probably the easiest way to do that, as much as I don't like it...
Since iget() et.al. will not accept I_FREEING (will wait to go away
and restart), and since we'd better have serialization between new/free
on fs data structures anyway, we can afford simply skipping I_FREEING
et.al. in insert_inode_locked().

We do that from new_inode, so it won't race with free_inode in any interesting
ways and it won't race with iget (of any origin; nfsd or in case of fs
corruption a lookup) since both still will wait for I_LOCK.

Tentative patch follow; folks, I would very much like review on that one,
since I'm far too low on caffeine and the area is nasty.

diff --git a/fs/inode.c b/fs/inode.c
index 9d26490..4406952 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1053,13 +1053,22 @@ int insert_inode_locked(struct inode *inode)
 	struct super_block *sb = inode->i_sb;
 	ino_t ino = inode->i_ino;
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
-	struct inode *old;
 
 	inode->i_state |= I_LOCK|I_NEW;
 	while (1) {
+		struct hlist_node *node;
+		struct inode *old = NULL;
 		spin_lock(&inode_lock);
-		old = find_inode_fast(sb, head, ino);
-		if (likely(!old)) {
+		hlist_for_each_entry(old, node, head, i_hash) {
+			if (old->i_ino != ino)
+				continue;
+			if (old->i_sb != sb)
+				continue;
+			if (old->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE))
+				continue;
+			break;
+		}
+		if (likely(!node)) {
 			hlist_add_head(&inode->i_hash, head);
 			spin_unlock(&inode_lock);
 			return 0;
@@ -1081,14 +1090,24 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 {
 	struct super_block *sb = inode->i_sb;
 	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
-	struct inode *old;
 
 	inode->i_state |= I_LOCK|I_NEW;
 
 	while (1) {
+		struct hlist_node *node;
+		struct inode *old = NULL;
+
 		spin_lock(&inode_lock);
-		old = find_inode(sb, head, test, data);
-		if (likely(!old)) {
+		hlist_for_each_entry(old, node, head, i_hash) {
+			if (old->i_sb != sb)
+				continue;
+			if (!test(old, data))
+				continue;
+			if (old->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE))
+				continue;
+			break;
+		}
+		if (likely(!node)) {
 			hlist_add_head(&inode->i_hash, head);
 			spin_unlock(&inode_lock);
 			return 0;
