From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v2] ext4: fix hole punch failure when depth is greater
 than 0
Date: Wed, 4 Jul 2012 19:33:26 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1207041926290.29222@localhost>
References: <1339638836-19990-1-git-send-email-ashish.sangwan2@gmail.com> <CAKYAXd_g_vgAmyD4jyUqz0u=vaSTAKFqZz0sqhM+2+hy1Z85ug@mail.gmail.com> <CAOiN93=BKyGKtpLng-ddX0RFUOdHCaxHi2O26GFokdT19xad2g@mail.gmail.com> <alpine.LFD.2.00.1207021110530.24050@dhcp-1-248.brq.redhat.com>
 <CAOiN93kzvKVDzSJ13HJZDh9ANt3UaBy0o_QHNKCSHHTizjtY0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-206302476-1341423215=:29222"
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	sandeen@redhat.com, Ted Tso <tytso@mit.edu>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Namjae Jeon <linkinjeon@gmail.com>
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab2GDRdj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jul 2012 13:33:39 -0400
In-Reply-To: <CAOiN93kzvKVDzSJ13HJZDh9ANt3UaBy0o_QHNKCSHHTizjtY0w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-206302476-1341423215=:29222
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

So I've finally has some time to look at the patch and reproduce the
problem. Thanks for noticing the problem, the patch seems good,
though I have one question. Is the p_block setting really necessary
? I do not think so, but I might be missing something. Here is
updated patch I've tested, bellow.

Note: there are some indent problems in your patch, like for example
this:

+                       path[k].p_block =
+                       le16_to_cpu(path[k].p_hdr->eh_entries)+1;


Anyway, what do you think about the modification ?

Thanks!
-Lukas


diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index b3300eb..94bc1bd 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2570,7 +2570,7 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 {
 	struct super_block *sb = inode->i_sb;
 	int depth = ext_depth(inode);
-	struct ext4_ext_path *path;
+	struct ext4_ext_path *path = NULL;
 	ext4_fsblk_t partial_cluster = 0;
 	handle_t *handle;
 	int i, err;
@@ -2606,8 +2606,12 @@ again:
 		}
 		depth = ext_depth(inode);
 		ex = path[depth].p_ext;
-		if (!ex)
+		if (!ex) {
+			ext4_ext_drop_refs(path);
+			kfree(path);
+			path = NULL;
 			goto cont;
+		}
 
 		ee_block = le32_to_cpu(ex->ee_block);
 
@@ -2637,8 +2641,6 @@ again:
 			if (err < 0)
 				goto out;
 		}
-		ext4_ext_drop_refs(path);
-		kfree(path);
 	}
 cont:
 
@@ -2646,20 +2648,26 @@ cont:
 	 * We start scanning from right side, freeing all the blocks
 	 * after i_size and walking into the tree depth-wise.
 	 */
-	depth = ext_depth(inode);
-	path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 1), GFP_NOFS);
-	if (path == NULL) {
-		ext4_journal_stop(handle);
-		return -ENOMEM;
-	}
-	path[0].p_depth = depth;
-	path[0].p_hdr = ext_inode_hdr(inode);
+	if (path)
+		i = depth;
+	else {
+		depth = ext_depth(inode);
+		path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 1),
+			       GFP_NOFS);
+		if (path == NULL) {
+			ext4_journal_stop(handle);
+			return -ENOMEM;
+		}
+		path[0].p_depth = depth;
+		path[0].p_hdr = ext_inode_hdr(inode);
 
-	if (ext4_ext_check(inode, path[0].p_hdr, depth)) {
-		err = -EIO;
-		goto out;
+		if (ext4_ext_check(inode, path[0].p_hdr, depth)) {
+			err = -EIO;
+			goto out;
+		}
+		i = 0;
 	}
-	i = err = 0;
+	err = 0;
 
 	while (i >= 0 && err == 0) {
 		if (i == depth) {

On Mon, 2 Jul 2012, Ashish Sangwan wrote:

> Date: Mon, 2 Jul 2012 16:51:43 +0530
> From: Ashish Sangwan <ashishsangwan2@gmail.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: sandeen@redhat.com, Ted Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
>     linux-ext4@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
> Subject: Re: [PATCH v2] ext4: fix hole punch failure when depth is greater
>     than 0
> 
> I will try to elaborate more about the problem and steps to reproduce:
> Linux version 3.4.0 on X86 box.
> 
> Step1:
> First create a small partition as it would be easy to fragment quickly.
> The main intent for fragmenting the partition is to create a file with
> at least 2 extent indexes.
> You can also choose some other method to create such a file.
> I created 200Mb partition and while formating used blocksize as 4KB
> and used attached script to fragment.
> This script fragments the partition such that each extent is exactly
> 6FS blocks OR 24KB in length.
> Linux#> ./fragment.sh /mnt/
> 6+0 records in
> 6+0 records out
> 24576 bytes (24.0KB) copied, 0.087997 seconds, 272.7KB/s
> cp: write error: No space left on device
> Partition filled
> rm: can't remove '/mnt//file1.7564': No such file or directory
> fragmented partition /mnt/ with 24KB files
> 
> Step2:
> Create a file with 342 extents i.e 2 extent indexes
> [root@sputnik ashish]# dd if=linux-3.4.tar.bz2 of=check_1 bs=24576 count=342
> 342+0 records in
> 342+0 records out
> 8404992 bytes (8.4 MB) copied, 0.0913289 s, 92.0 MB/s
> [root@sputnik ashish]# cp check_1 /mnt/check_2
> [root@sputnik ashish]# debugfs  /dev/sdb1
> debugfs 1.41.14 (22-Dec-2010)
> debugfs:  dump_extents check_2
> Level Entries       Logical      Physical Length Flags
>  0/ 1   1/  2     0 -  2039 32792             2040
>  1/ 1   1/340     0 -     5  5771 -  5776       6
>  1/ 1   2/340     6 -    11  5783 -  5788      6
> <------- continue like wise till 340 ------------->
>  1/ 1 340/340  2034 -  2039  9835 -  9840   6
>  0/ 1   2/  2  2040 -  2051  5764              12
>  1/ 1   1/  2  2040 -  2045  9847 -  9852     6
>  1/ 1   2/  2  2046 -  2051  9859 -  9864     6
> 
> Step3: Punch hole at offset 4KB and length of hole is also 4KB
> There is attached fallocate.c
> [root@sputnik ashish]# ./fallacote.x86 /mnt/check_2
> ret = 0
> [root@sputnik ashish]#
> 
> Check extent tree:
> [root@sputnik ashish]# debugfs  /dev/sdb1
> debugfs 1.41.14 (22-Dec-2010)
> debugfs:  dump_extents check_2
> Level Entries       Logical      Physical Length Flags
>  0/ 1   1/  3     0 -     5 32792                 6
>  1/ 1   1/  2     0 -     1  5771 -  5772      2
>  1/ 1   2/  2     2 -     5  5773 -  5776      4
>  0/ 1   2/  3     6 -  2039  9871           2034
>  1/ 1   1/339     6 -    11  5783 -  5788    6
> <------- continue like wise till 339 ------------->
>  1/ 1 339/339  2034 -  2039  9835 -  9840   6
>  0/ 1   3/  3  2040 -  2051  5764             12
>  1/ 1   1/  2  2040 -  2045  9847 -  9852    6
>  1/ 1   2/  2  2046 -  2051  9859 -  9864    6
> 
> It is clearly visible that punching hole just split the first extent into 2
> but failed to remove the required blocks.
> 
> Step4: To cross check, take diff of 2 files.
> [root@sputnik ashish]# diff check_1 /mnt/check_2
> [root@sputnik ashish]#
> 
> The 2 files are exactly same.
> 
> After applying this patch, correct results will be observed.
> 
> On Mon, Jul 2, 2012 at 2:42 PM, Lukáš Czerner <lczerner@redhat.com> wrote:
> > On Mon, 2 Jul 2012, Ashish Sangwan wrote:
> >
> >> Date: Mon, 2 Jul 2012 11:03:26 +0530
> >> From: Ashish Sangwan <ashishsangwan2@gmail.com>
> >> To: sandeen@redhat.com, Lukáš Czerner <lczerner@redhat.com>,
> >>     Ted Tso <tytso@mit.edu>
> >> Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
> >>     Namjae Jeon <linkinjeon@gmail.com>
> >> Subject: Re: [PATCH v2] ext4: fix hole punch failure when depth is greater
> >>     than 0
> >>
> >> Hi Ted, Lukas, Eric,
> >>
> >> Did any of you get a chance to look at it?
> >
> > I am sorry for the delay. I have been trying to reproduce this
> > problem without any success so far. But is was on ppc64 machine, so
> > I'll try that on x86_64 and then review the patch.
> >
> > Thanks!
> > -Lukas
> >
> >>
> >> On Fri, Jun 22, 2012 at 6:19 AM, Namjae Jeon <linkinjeon@gmail.com> wrote:
> >> > Hi. Eric.
> >> >
> >> > This is the patch for punch hole issue.
> >> >
> >> > Thanks.
> >> >
> >>
> 
--8323328-206302476-1341423215=:29222--
