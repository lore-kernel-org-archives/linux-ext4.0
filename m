From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/5] quota: decouple fs reserved space from quota
 reservation
Date: Mon, 11 Jan 2010 19:00:00 +0100
Message-ID: <20100111175959.GG3184@quack.suse.cz>
References: <1261589276-1380-1-git-send-email-jack@suse.cz>
 <1261589276-1380-3-git-send-email-jack@suse.cz>
 <4B4B658F.3020801@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="+g7M9IMkV8truYOl"
Cc: Jan Kara <jack@suse.cz>, stable@kernel.org,
	linux-ext4@vger.kernel.org, tytso@mit.edu,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55564 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab0AKR76 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jan 2010 12:59:58 -0500
Content-Disposition: inline
In-Reply-To: <4B4B658F.3020801@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 11-01-10 11:53:19, Eric Sandeen wrote:
> Jan Kara wrote:
> > From: Dmitry Monakhov <dmonakhov@openvz.org>
> > 
> > Currently inode_reservation is managed by fs itself and this
> > reservation is transfered on dquot_transfer(). This means what
> > inode_reservation must always be in sync with
> > dquot->dq_dqb.dqb_rsvspace. Otherwise dquot_transfer() will result
> > in incorrect quota(WARN_ON in dquot_claim_reserved_space() will be
> > triggered)
> > This is not easy because of complex locking order issues
> > for example http://bugzilla.kernel.org/show_bug.cgi?id=14739
> > 
> > The patch introduce quota reservation field for each fs-inode
> > (fs specific inode is used in order to prevent bloating generic
> > vfs inode). This reservation is managed by quota code internally
> > similar to i_blocks/i_bytes and may not be always in sync with
> > internal fs reservation.
> > 
> > Also perform some code rearrangement:
> > - Unify dquot_reserve_space() and dquot_reserve_space()
> > - Unify dquot_release_reserved_space() and dquot_free_space()
> > - Also this patch add missing warning update to release_rsv()
> >   dquot_release_reserved_space() must call flush_warnings() as
> >   dquot_free_space() does.
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> 
> ...
> 
> > @@ -1734,7 +1761,7 @@ int dquot_transfer(struct inode *inode, struct
> iattr *iattr)
> >  	}
> >  	spin_lock(&dq_data_lock);
> >  	cur_space = inode_get_bytes(inode);
> > -	rsv_space = dquot_get_reserved_space(inode);
> > +	rsv_space = inode_get_rsv_space(inode);
> >  	space = cur_space + rsv_space;
> >  	/* Build the transfer_from list and check the limits */
> >  	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
> 
> ...
> 
> >  /*
> > + * inode_reserved_space is managed internally by quota, and protected by
> > + * i_lock similar to i_blocks+i_bytes.
> > + */
> > +static qsize_t *inode_reserved_space(struct inode * inode)
> > +{
> > +	/* Filesystem must explicitly define it's own method in order to use
> > +	 * quota reservation interface */
> > +	BUG_ON(!inode->i_sb->dq_op->get_reserved_space);
> 
> Unless I'm missing something, this just broke quota for everyone
> except ext4 ...
> 
> sys_chown
> 	...
> 		dquot_transfer
> 			inode_get_rsv_space
> 				inode_reserved_space
> 
> will BUG_ON ext3, we get there with (rightly) no ->get_reserved_space.
> 
> Or am I missing something?
  No, you are exactly right (sadly). Linus already has a pull request with
the fix in his mailbox.
  The fix is attached if you need it for something.


									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--+g7M9IMkV8truYOl
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-quota-Fix-dquot_transfer-for-filesystems-different-f.patch"

>From 05b5d898235401c489c68e1f3bc5706a29ad5713 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 6 Jan 2010 18:03:36 +0100
Subject: [PATCH] quota: Fix dquot_transfer for filesystems different from ext4

Commit fd8fbfc1 modified the way we find amount of reserved space
belonging to an inode. The amount of reserved space is checked
from dquot_transfer and thus inode_reserved_space gets called
even for filesystems that don't provide get_reserved_space callback
which results in a BUG.

Fix the problem by checking get_reserved_space callback and return 0 if
the filesystem does not provide it.

CC: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index dea86ab..3fc62b0 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1377,6 +1377,9 @@ static void inode_sub_rsv_space(struct inode *inode, qsize_t number)
 static qsize_t inode_get_rsv_space(struct inode *inode)
 {
 	qsize_t ret;
+
+	if (!inode->i_sb->dq_op->get_reserved_space)
+		return 0;
 	spin_lock(&inode->i_lock);
 	ret = *inode_reserved_space(inode);
 	spin_unlock(&inode->i_lock);
-- 
1.6.4.2


--+g7M9IMkV8truYOl--
