From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: [PATCH 1/3] ext4: Fix compilation with -DDX_DEBUG v2
Date: Tue, 19 Jul 2011 17:02:18 +0200
Message-ID: <4E259C7A.5030506@itwm.fraunhofer.de>
References: <20110620202631.2473133.4166.stgit@localhost.localdomain> <20110620202849.2473133.84386.stgit@localhost.localdomain> <20110716234106.GB2717@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, adilger@whamcloud.com,
	colyli@gmail.com, Jan Kara <jack@suse.cz>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:33989 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab1GSPCW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jul 2011 11:02:22 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id p6JF2J3P009153
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jul 2011 17:02:20 +0200
In-Reply-To: <20110716234106.GB2717@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/17/2011 01:41 AM, Ted Ts'o wrote:
> On Mon, Jun 20, 2011 at 10:28:49PM +0200, Bernd Schubert wrote:
>> changes from v1 ->  v2:
>> Use %p as suggested by Coly Li
> 
> The problem with %p:
> 
>      1)  It prints numbers that will never be larger than 4096 with as
>          "00000012"
>      2)  It prints the number 0 as "  (null)".
> 
> These two things mean that we get messages like this:
> 
> names: foo:7141e93c.  (null) bar:745c4a06.00000012 baz:79817344.00000024 quux:7e85a800.00000036 ...
> 
> instead of:
> 
> names: foo:7141e93c.0 bar:745c4a06.12 baz:79817344.24 quux:7e85a800.36 ...
> 
> (did anyone even try this and check to see what would happen with %p?)
> 
> I've applied this patch, with a change so that we print the number
> with %u and with an explicit cast to unsigned.
> 
> 						- Ted

Ooops, sorry, I should have checked %p output more thoroughly.

Could you please also apply almost the same patch for ext3? 


ext3: Fix compilation with -DDX_DEBUG v2

From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

Compilation of ext3/namei.c brought up an error and warning messages
when compiled with -DDX_DEBUG.

Signed-off-by: Bernd Schubert<bernd.schubert@itwm.fraunhofer.de>
---
 fs/ext3/namei.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 34b6d9b..e54e87a 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -287,7 +287,7 @@ static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct ext3_dir_ent
 				while (len--) printk("%c", *name++);
 				ext3fs_dirhash(de->name, de->name_len, &h);
 				printk(":%x.%u ", h.hash,
-				       ((char *) de - base));
+				       (unsigned) ((char *) de - base));
 			}
 			space += EXT3_DIR_REC_LEN(de->name_len);
 			names++;
@@ -1013,7 +1013,7 @@ static struct buffer_head * ext3_dx_find_entry(struct inode *dir,
 
 	*err = -ENOENT;
 errout:
-	dxtrace(printk("%s not found\n", name));
+	dxtrace(printk("%s not found\n", entry->name));
 	dx_release (frames);
 	return NULL;
 }



Thanks,
Bernd
