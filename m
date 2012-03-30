From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Commit c1a1e7fc24d6 causes segfault in ext2fs_new_inode
Date: Fri, 30 Mar 2012 14:38:42 -0500
Message-ID: <4F760BC2.4070401@redhat.com>
References: <20120330125726.GA26221@amd.home.annexia.org> <20120330131936.GB26221@amd.home.annexia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Sami Liedes <sami.liedes@iki.fi>
To: "Richard W.M. Jones" <rjones@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933962Ab2C3Tix (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Mar 2012 15:38:53 -0400
In-Reply-To: <20120330131936.GB26221@amd.home.annexia.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/30/12 8:19 AM, Richard W.M. Jones wrote:
> On Fri, Mar 30, 2012 at 01:57:26PM +0100, Richard W.M. Jones wrote:
>> [I'm tracking this issue here:
>> https://bugzilla.redhat.com/show_bug.cgi?id=808421]
> 
> A bit of further investigation:
> 
> I'm currently not passing EXT2_FLAG_64BITS when opening the
> filesystem.  Passing this flag fixes the issue, so I'm going to do
> that (are there any downsides?)
> 
> It seems like a non-64-bit-compatible bitmap was being created, and
> that doesn't have the bitmap->bitmap_ops field initialized because
> gen_bitmap.c doesn't use this field.  Somehow, though, we end up
> calling a function in gen_bitmap64.c which requires that this field be
> defined.
> 
> Rich.
> 

Well here's what's busted:

        if (bitmap->bitmap_ops->find_first_zero)
                return bitmap->bitmap_ops->find_first_zero(bitmap, start, end, out);

        if (!bitmap || !EXT2FS_IS_64_BITMAP(bitmap) || bitmap->cluster_bits)
                return EINVAL;

bitmap->bitmap_ops->find_first_zero only exists for a 64-bit bitmap, which
gets tested after we try to deref it :(

I wonder if this fixes it:

diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index b57df54..ce6c23d 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -768,7 +768,7 @@ errcode_t ext2fs_find_first_zero_generic_bmap(ext2fs_generic_bitmap bitmap,
 {
 	int b;
 
-	if (bitmap->bitmap_ops->find_first_zero)
+	if (EXT2FS_IS_64_BITMAP(bitmap) && bitmap->bitmap_ops->find_first_zero)
 		return bitmap->bitmap_ops->find_first_zero(bitmap, start, end, out);
 
 	if (!bitmap || !EXT2FS_IS_64_BITMAP(bitmap) || bitmap->cluster_bits)


But then the next conditional would give us EINVAL since !EXT2FS_IS_64_BITMAP,
and I don't think things would go well after that either.

I am a little confused by the existence of two different
struct ext2fs_struct_generic_bitmap's in the code.  But treating one as the
other looks doomed to failure ;)

I haven't wrapped my head around this yet.

-Eric
