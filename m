From: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH v2] ext3, ext4: do_split() fix loop, with obvious	unsigned
 wrap
Date: Tue, 02 Dec 2008 20:47:38 +0100
Message-ID: <493590DA.1090504@gmail.com>
References: <49343AD9.4020606@gmail.com> <20081202132441.GC16172@mit.edu> <49356B96.7070900@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, adilger@sun.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:16715 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbYLBTrj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Dec 2008 14:47:39 -0500
Received: by ug-out-1314.google.com with SMTP id 39so3163100ugf.37
        for <linux-ext4@vger.kernel.org>; Tue, 02 Dec 2008 11:47:37 -0800 (PST)
In-Reply-To: <49356B96.7070900@tmr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bill Davidsen wrote:

> the value inside the loop is
> correct (or at least is the same as the original patch).

I agree, this can be shown with:

#include <stdio.h>

int main()
{
	unsigned int i, count = 10;

	printf ("The original loop:\n");
        for (i = count-1; i >= 0; i--) {
		printf ("%u, ", i);
		if (i == -1) {
			printf ("which is wrong.\n");
			break;
		}
	}

        printf ("As suggested by Bill:\n");
	for (i = count; i--; )
		printf ("%u, ", i);
	printf ("...After the loop i=%u\n");

	printf ("Your suggestion:\n");
	i = count;
	while (i--)
		printf ("%u, ", i);
	printf ("...After the loop i=%u\n");

	return 0;
}
> Theodore Tso wrote:
>> probably
>> the best way of handling this is to recast it not as a for loop, but
>> as a while loop.

Ok, with me. As also shown this will give the same results:
-----------8<--------------->8-------------
Fix loop, with obvious unsigned wrap

Signed-off-by: Roel Kluin <roel.kluin@gmail.com> 
---
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 3e5edc9..0e574d4 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1188,7 +1188,8 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	/* Split the existing block in the middle, size-wise */
 	size = 0;
 	move = 0;
-	for (i = count-1; i >= 0; i--) {
+	i = count;
+	while (i--) {
 		/* is more than half of this entry in 2nd half of the block? */
 		if (size + map[i].size/2 > blocksize/2)
 			break;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 63adcb7..b8903d4 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1198,7 +1198,8 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	/* Split the existing block in the middle, size-wise */
 	size = 0;
 	move = 0;
-	for (i = count-1; i >= 0; i--) {
+	i = count;
+	while (i--) {
 		/* is more than half of this entry in 2nd half of the block? */
 		if (size + map[i].size/2 > blocksize/2)
 			break;
