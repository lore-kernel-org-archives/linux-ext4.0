From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] unexport journal_update_superblock
Date: Wed, 27 Feb 2008 23:20:56 +0200
Message-ID: <20080227212056.GO29269@cs181133002.pp.htv.fi>
References: <20080217081935.GN3848@cs181133002.pp.htv.fi> <20080218070439.GG3029@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: sct@redhat.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:41773 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759681AbYB0VWH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Feb 2008 16:22:07 -0500
Content-Disposition: inline
In-Reply-To: <20080218070439.GG3029@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 18, 2008 at 12:04:39AM -0700, Andreas Dilger wrote:
> On Feb 17, 2008  10:19 +0200, Adrian Bunk wrote:
> > This patch contains the following cleanups:
> > - make the following needlessly global function static:
> >   - journal_check_used_features()
> > - remove the following unused EXPORT_SYMBOL's:
> >   - journal_set_features
> >   - journal_update_superblock
> 
> Nack.  I don't object to un-exporting journal_update_superblock(), because
> that is pretty internal, but the other functions are intended specifically
> for use by code outside of JBD.  For example, the journal checksum patch for
> ext3/4 uses journal_set_features() to turn on features in the JBD superblock.
>...

A patch that only unexports journal_update_superblock is below.

> Cheers, Andreas

cu
Adrian


<--  snip  -->


This patch removes the unused EXPORT_SYMBOL(journal_update_superblock).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
66cbc7390d66cdeb83a3f81d7ec1ea71d6f6e2c8 foobar
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 3943a89..5c2ebb7 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -68,7 +68,6 @@ EXPORT_SYMBOL(journal_set_features);
 EXPORT_SYMBOL(journal_create);
 EXPORT_SYMBOL(journal_load);
 EXPORT_SYMBOL(journal_destroy);
-EXPORT_SYMBOL(journal_update_superblock);
 EXPORT_SYMBOL(journal_abort);
 EXPORT_SYMBOL(journal_errno);
 EXPORT_SYMBOL(journal_ack_err);
