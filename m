From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: directory blocks must be treated as metadata by
 ext4_forget()
Date: Sun, 15 Nov 2009 12:46:53 +0530
Message-ID: <20091115071653.GB26614@skywalker.linux.vnet.ibm.com>
References: <20091114232912.GF4221@mit.edu>
 <1258245059-17687-1-git-send-email-tytso@mit.edu>
 <20091115070447.GA26614@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:60088 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbZKOHQ4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Nov 2009 02:16:56 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.31.245])
	by e23smtp01.au.ibm.com (8.14.3/8.13.1) with ESMTP id nAF7FQ8R018114
	for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2009 18:15:26 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nAF7Gwx11658888
	for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2009 18:17:00 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nAF7Gwep001199
	for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2009 18:16:58 +1100
Content-Disposition: inline
In-Reply-To: <20091115070447.GA26614@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 15, 2009 at 12:34:48PM +0530, Aneesh Kumar K.V wrote:
> On Sat, Nov 14, 2009 at 07:30:59PM -0500, Theodore Ts'o wrote:
> > When a directory gets unlinked, ext4_forget() is called on any buffer
> > heads corresponding to its data blocks.  Data blocks from directories
> > must be treated as metadata, so that they are revoked by
> > jbd2_journal_revoke, and not just forgotten via ext4_journal_forget().
> > 
> > Thanks to Curt Wohlgemuth for pointing out potential problems in this
> > area.
> > 
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > ---
> >  fs/ext4/inode.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 13de1dd..639bb84 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -97,6 +97,10 @@ int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
> >  		  bh, is_metadata, inode->i_mode,
> >  		  test_opt(inode->i_sb, DATA_FLAGS));
> > 
> > +	/* Directory blocks must be treated as metadata */
> > +	if (S_ISDIR(inode->i_mode))
> > +		is_metadata = 1;
> > +
> >  	/* Never use the revoke function if we are doing full data
> >  	 * journaling: there is no need to, and a V1 superblock won't
> >  	 * support it.  Otherwise, only skip the revoke on un-journaled
> 
> I guess we need to make sure we call ext4_forget with correct is_metadata values. I
> did the below patch. The xattr changes in the patch should be split as a separate one.
> I am not sure why we do a get_bh there.

The callers of ext4_xattr_release_block is also doing a brelse on the buffer_head.
So we need that get_bh.

-aneesh
