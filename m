From: Greg KH <gregkh@suse.de>
Subject: [patch 098/114] ext4: Fix deadlock in ext4_write_begin() and ext4_da_write_begin()
Date: Fri, 13 Mar 2009 18:11:15 -0700
Message-ID: <20090314011045.914471586@mini.kroah.org>
References: <20090314010937.416083662@mini.kroah.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:35729 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755269AbZCNBVU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:20 -0400
Content-Disposition: inline; filename=ext4-fix-deadlock-in-ext4_write_begin-and-ext4_da_write_begin.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kara <jack@suse.cz>

(cherry picked from commit ebd3610b110bbb18ea6f9f2aeed1e1068c537227)

Functions ext4_write_begin() and ext4_da_write_begin() call
grab_cache_page_write_begin() without AOP_FLAG_NOFS. Thus it
can happen that page reclaim is triggered in that function
and it recurses back into the filesystem (or some other filesystem).
But this can lead to various problems as a transaction is already
started at that point. Add the necessary flag.

http://bugzilla.kernel.org/show_bug.cgi?id=11688

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1347,6 +1347,10 @@ retry:
 		goto out;
 	}
 
+	/* We cannot recurse into the filesystem as the transaction is already
+	 * started */
+	flags |= AOP_FLAG_NOFS;
+
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page) {
 		ext4_journal_stop(handle);
@@ -1356,7 +1360,7 @@ retry:
 	*pagep = page;
 
 	ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
-							ext4_get_block);
+				ext4_get_block);
 
 	if (!ret && ext4_should_journal_data(inode)) {
 		ret = walk_page_buffers(handle, page_buffers(page),
@@ -2603,6 +2607,9 @@ retry:
 		ret = PTR_ERR(handle);
 		goto out;
 	}
+	/* We cannot recurse into the filesystem as the transaction is already
+	 * started */
+	flags |= AOP_FLAG_NOFS;
 
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page) {


