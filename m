From: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 19/19] fs: handle inode->i_version more efficiently
Date: Wed, 20 Dec 2017 09:03:06 -0500
Message-ID: <1513778586.4513.18.camel@kernel.org>
References: <20171218151156.14565-1-jlayton@kernel.org>
         <20171218151156.14565-20-jlayton@kernel.org>
         <20171218163418.GF30350@quack2.suse.cz>
         <1513617740.3422.30.camel@kernel.org> <20171218173651.GB12454@fieldses.org>
         <1513625720.3422.68.camel@kernel.org> <20171218220759.GF4094@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
        linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org,
        jack-l3A5Bk7waGM@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org,
        adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org,
        jbacik-b10kYP2dOMg@public.gmane.org, dsterba-IBi9RG/b67k@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
        linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        jaltman-hRzEac23uH1Wk0Htik3J/w@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171218220759.GF4094@dastard>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2017-12-19 at 09:07 +1100, Dave Chinner wrote:
> On Mon, Dec 18, 2017 at 02:35:20PM -0500, Jeff Layton wrote:
> > [PATCH] SQUASH: add memory barriers around i_version accesses
> 
> Why explicit memory barriers rather than annotating the operations
> with the required semantics and getting the barriers the arch
> requires automatically?  I suspect this should be using
> atomic_read_acquire() and atomic_cmpxchg_release(), because AFAICT
> the atomic_cmpxchg needs to have release semantics to match the
> acquire semantics needed for the load of the current value.
> 
> From include/linux/atomics.h:
> 
>  * For compound atomics performing both a load and a store, ACQUIRE
>  * semantics apply only to the load and RELEASE semantics only to the
>  * store portion of the operation. Note that a failed cmpxchg_acquire
>  * does -not- imply any memory ordering constraints.
> 
> Memory barriers hurt my brain. :/
> 
> At minimum, shouldn't the atomic op specific barriers be used rather
> than full memory barriers? i.e:
> 

They hurt my brain too. Yes, definitely atomic-specific barriers should
be used here instead, since this is an atomic64_t now.

After going over the docs again...my understanding has always been that
you primarily need memory barriers to order accesses to different areas
of memory.

As Jan and I were discussing in the other thread, i_version is not
synchronized with anything else. In this code, we're only dealing with a
single 64-bit word. I don't think there are any races there wrt the API
itself.

The "legacy" inode_inc_iversion() however _does_ have implied memory
barriers from the i_lock. There could be some subtle de-facto ordering
there, so I think we probably do want some barriers in here if only to
preserve that. It's not likely to cost much, and may save us tracking
down some fiddly bugs.

What about this patch? Note that I've only added barriers to
inode_maybe_inc_iversion. I don't see that we need it for the other
functions, but please do tell me if I'm wrong there:

--------------------8<---------------------------

[PATCH] SQUASH: add memory barriers around i_version accesses

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/iversion.h | 53 +++++++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 21 deletions(-)

diff --git a/include/linux/iversion.h b/include/linux/iversion.h
index a9fbf99709df..02187a3bec3b 100644
--- a/include/linux/iversion.h
+++ b/include/linux/iversion.h
@@ -89,6 +89,23 @@ inode_set_iversion_raw(struct inode *inode, const u64 val)
 	atomic64_set(&inode->i_version, val);
 }
 
+/**
+ * inode_peek_iversion_raw - grab a "raw" iversion value
+ * @inode: inode from which i_version should be read
+ *
+ * Grab a "raw" inode->i_version value and return it. The i_version is not
+ * flagged or converted in any way. This is mostly used to access a self-managed
+ * i_version.
+ *
+ * With those filesystems, we want to treat the i_version as an entirely
+ * opaque value.
+ */
+static inline u64
+inode_peek_iversion_raw(const struct inode *inode)
+{
+	return atomic64_read(&inode->i_version);
+}
+
 /**
  * inode_set_iversion - set i_version to a particular value
  * @inode: inode to set
@@ -152,7 +169,16 @@ inode_maybe_inc_iversion(struct inode *inode, bool force)
 {
 	u64 cur, old, new;
 
-	cur = (u64)atomic64_read(&inode->i_version);
+	/*
+	 * The i_version field is not strictly ordered with any other inode
+	 * information, but the legacy inode_inc_iversion code used a spinlock
+	 * to serialize increments.
+	 *
+	 * This code adds full memory barriers to ensure that any de-facto
+	 * ordering with other info is preserved.
+	 */
+	smp_mb__before_atomic();
+	cur = inode_peek_iversion_raw(inode);
 	for (;;) {
 		/* If flag is clear then we needn't do anything */
 		if (!force && !(cur & I_VERSION_QUERIED))
@@ -162,8 +188,10 @@ inode_maybe_inc_iversion(struct inode *inode, bool force)
 		new = (cur & ~I_VERSION_QUERIED) + I_VERSION_INCREMENT;
 
 		old = atomic64_cmpxchg(&inode->i_version, cur, new);
-		if (likely(old == cur))
+		if (likely(old == cur)) {
+			smp_mb__after_atomic();
 			break;
+		}
 		cur = old;
 	}
 	return true;
@@ -183,23 +211,6 @@ inode_inc_iversion(struct inode *inode)
 	inode_maybe_inc_iversion(inode, true);
 }
 
-/**
- * inode_peek_iversion_raw - grab a "raw" iversion value
- * @inode: inode from which i_version should be read
- *
- * Grab a "raw" inode->i_version value and return it. The i_version is not
- * flagged or converted in any way. This is mostly used to access a self-managed
- * i_version.
- *
- * With those filesystems, we want to treat the i_version as an entirely
- * opaque value.
- */
-static inline u64
-inode_peek_iversion_raw(const struct inode *inode)
-{
-	return atomic64_read(&inode->i_version);
-}
-
 /**
  * inode_iversion_need_inc - is the i_version in need of being incremented?
  * @inode: inode to check
@@ -248,7 +259,7 @@ inode_query_iversion(struct inode *inode)
 {
 	u64 cur, old, new;
 
-	cur = atomic64_read(&inode->i_version);
+	cur = inode_peek_iversion_raw(inode);
 	for (;;) {
 		/* If flag is already set, then no need to swap */
 		if (cur & I_VERSION_QUERIED)
@@ -256,7 +267,7 @@ inode_query_iversion(struct inode *inode)
 
 		new = cur | I_VERSION_QUERIED;
 		old = atomic64_cmpxchg(&inode->i_version, cur, new);
-		if (old == cur)
+		if (likely(old == cur))
 			break;
 		cur = old;
 	}
-- 
2.14.3



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
