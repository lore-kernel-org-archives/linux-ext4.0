From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/12] ext4: Disable merging of uninitialized extents
Date: Mon, 28 Jan 2013 10:38:36 -0500
Message-ID: <20130128153836.GH22711@thunk.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-5-git-send-email-jack@suse.cz>
 <87vcamdi6e.fsf@openvz.org>
 <20130128143647.GD22711@thunk.org>
 <871ud5fizk.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45878 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab3A1Pis (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 10:38:48 -0500
Content-Disposition: inline
In-Reply-To: <871ud5fizk.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 28, 2013 at 07:02:55PM +0400, Dmitry Monakhov wrote:
> Actually this patch consists of two peaces
> 1) disable merging of uninitialized extents. (1 line change) I'm
> absolutely agree with it.

To be clear, that's this patch chunk (one line change not including
comments :-), right?

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1579,11 +1576,13 @@ int
 ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 				struct ext4_extent *ex2)
 {
 
 	/*
-	 * Make sure that either both extents are uninitialized, or
-	 * both are _not_.
+	 * Make sure that both extents are initialized. We don't merge
+	 * uninitialized extents so that we can be sure that end_io code has
+	 * the extent that was written properly split out and conversion to
+	 * initialized is trivial.
 	 */
-	if (ext4_ext_is_uninitialized(ex1) ^ ext4_ext_is_uninitialized(ex2))
+	if (ext4_ext_is_uninitialized(ex1) || ext4_ext_is_uninitialized(ex2))
 		return 0;
 

The one thing I'm a bit worried about is how much worse will extent
fragmentation be once we do this, but it's clear we need to strive for
correctness first.

							- Ted
