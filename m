From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH] ext4: Ensure zeroout blocks have no dirty metadata
Date: Tue, 29 Dec 2009 15:23:38 -0800
Message-ID: <6601abe90912291523g9c31912oa64254d88e49ae4@mail.gmail.com>
References: <6601abe90912100928v747671dat489aeee5dabf2c03@mail.gmail.com>
	 <20091218114946.GD9437@skywalker.linux.vnet.ibm.com>
	 <6601abe90912290956s6837803ck76e8c36e96f225ae@mail.gmail.com>
	 <20091229185318.GJ4429@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:55214 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZL2XXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Dec 2009 18:23:40 -0500
Received: from wpaz37.hot.corp.google.com (wpaz37.hot.corp.google.com [172.24.198.101])
	by smtp-out.google.com with ESMTP id nBTNNdNd023639
	for <linux-ext4@vger.kernel.org>; Tue, 29 Dec 2009 15:23:39 -0800
Received: from qw-out-2122.google.com (qwh8.prod.google.com [10.241.194.200])
	by wpaz37.hot.corp.google.com with ESMTP id nBTNNcoQ004177
	for <linux-ext4@vger.kernel.org>; Tue, 29 Dec 2009 15:23:39 -0800
Received: by qw-out-2122.google.com with SMTP id 8so136091qwh.41
        for <linux-ext4@vger.kernel.org>; Tue, 29 Dec 2009 15:23:38 -0800 (PST)
In-Reply-To: <20091229185318.GJ4429@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted:

On Tue, Dec 29, 2009 at 10:53 AM,  <tytso@mit.edu> wrote:
> On Tue, Dec 29, 2009 at 09:56:29AM -0800, Curt Wohlgemuth wrote:
>>
>> Thanks for pointing out the arithmetic problems in my patch. =A0Your=
s
>> below looks good to me.
>
> Hi Curt,
>
> Can you do me a favor and send out a full patch with Aneesh's
> correction?

Here it is.  This is against 2.6.33-rc2, if that makes a difference.  T=
hanks!

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

This fixes a bug in which new blocks returned from an extent created wi=
th
ext4_ext_zeroout() can have dirty metadata still associated with them.

This patch was originally by Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.=
com>.

       Signed-off-by: Curt Wohlgemuth <curtw@google.com>

---


diff -uprN orig/fs/ext4/extents.c new/fs/ext4/extents.c
--- orig/fs/ext4/extents.c	2009-12-29 14:59:12.000000000 -0800
+++ new/fs/ext4/extents.c	2009-12-29 15:18:43.000000000 -0800
@@ -3023,6 +3023,14 @@ out:
 	return err;
 }

+static void unmap_underlying_metadata_blocks(struct block_device *bdev=
,
+			sector_t block, int count)
+{
+	int i;
+	for (i =3D 0; i < count; i++)
+                unmap_underlying_metadata(bdev, block + i);
+}
+
 static int
 ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *=
inode,
 			ext4_lblk_t iblock, unsigned int max_blocks,
@@ -3098,6 +3106,18 @@ out:
 	} else
 		allocated =3D ret;
 	set_buffer_new(bh_result);
+	/*
+	 * if we allocated more blocks than requested
+	 * we need to make sure we unmap the extra block
+	 * allocated. The actual needed block will get
+	 * unmapped later when we find the buffer_head marked
+	 * new.
+	 */
+	if (allocated > max_blocks) {
+		unmap_underlying_metadata_blocks(inode->i_sb->s_bdev,
+					newblock + max_blocks,
+					allocated - max_blocks);
+	}
 map_out:
 	set_buffer_mapped(bh_result);
 out1:
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
