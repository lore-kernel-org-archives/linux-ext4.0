From: Greg KH <gregkh@suse.de>
Subject: [patch 86/87] ext4: Clear the unwritten buffer_head flag after the extent is initialized
Date: Tue, 09 Jun 2009 02:40:14 -0700
Message-ID: <20090609094112.555068937@blue.kroah.org>
References: <20090609093848.204935043@blue.kroah.org>
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
	alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:32930 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758235AbZFIKWb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2009 06:22:31 -0400
Content-Disposition: inline; filename=ext4-clear-the-unwritten-buffer_head-flag-after-the-extent-is-initialized.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit 2a8964d63d50dd2d65d71d342bc7fb6ef4117614)

The BH_Unwritten flag indicates that the buffer is allocated on disk
but has not been written; that is, the disk was part of a persistent
preallocation area.  That flag should only be set when a get_blocks()
function is looking up a inode's logical to physical block mapping.

When ext4_get_blocks_wrap() is called with create=1, the uninitialized
extent is converted into an initialized one, so the BH_Unwritten flag
is no longer appropriate.  Hence, we need to make sure the
BH_Unwritten is not left set, since the combination of BH_Mapped and
BH_Unwritten is not allowed; among other things, it will result ext4's
get_block() to be called over and over again during the write_begin
phase of write(2).

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1076,6 +1076,7 @@ int ext4_get_blocks_wrap(handle_t *handl
 	int retval;
 
 	clear_buffer_mapped(bh);
+	clear_buffer_unwritten(bh);
 
 	/*
 	 * Try to see if we can get  the block without requesting
@@ -1106,6 +1107,18 @@ int ext4_get_blocks_wrap(handle_t *handl
 		return retval;
 
 	/*
+	 * When we call get_blocks without the create flag, the
+	 * BH_Unwritten flag could have gotten set if the blocks
+	 * requested were part of a uninitialized extent.  We need to
+	 * clear this flag now that we are committed to convert all or
+	 * part of the uninitialized extent to be an initialized
+	 * extent.  This is because we need to avoid the combination
+	 * of BH_Unwritten and BH_Mapped flags being simultaneously
+	 * set on the buffer_head.
+	 */
+	clear_buffer_unwritten(bh);
+
+	/*
 	 * New blocks allocate and/or writing to uninitialized extent
 	 * will possibly result in updating i_data, so we take
 	 * the write lock of i_data_sem, and call get_blocks()


