From: Dmitriy Monakhov <dmonakhov@sw.ru>
Subject: Re: [PATCH] ext3: dirindex error pointer issues (b)
Date: Mon, 12 Mar 2007 10:20:26 +0300
Message-ID: <87ird7q66d.fsf@sw.ru>
References: <87lkidf5y0.fsf@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	devel@openvz.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:22537 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932495AbXCLHUE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Mar 2007 03:20:04 -0400
In-Reply-To: <87lkidf5y0.fsf@sw.ru> (Dmitriy Monakhov's message of "Sun, 04 Mar 2007 17:18:15 +0300")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Dmitriy Monakhov <dmonakhov@sw.ru> writes:

>  - ext3_dx_find_entry() exit with out setting proper error pointer
>  - do_split() exit with out setting proper error pointer
>    it is realy painful because many callers contain folowing code:
>            de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
>            if (!(de))
>                         return retval;
>            <<< WOW retval wasn't changed by do_split(), so caller failed
>            <<< but return SUCCESS :)
>  - Rearrange do_split() error path. Current error path is realy ugly, all
>    this up and down jump stuff doesn't make code easy to understand.
Ohh my first patch change error message semantics in do_split(). Initially when 
ext3_append() failed we just exit without printing error. In fact ext3_append()
may fail, it is legal and it's happens qite often (ENOSPC for example). This 
cause annoying fake error message. So restore this semantic as it was before
patch.
Andrew please apply incremental patch what fix it:

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 1a52586..7edb617 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1197,8 +1197,8 @@ journal_error:
 	brelse(*bh);
 	brelse(bh2);
 	*bh = NULL;
-errout:
 	ext3_std_error(dir->i_sb, err);
+errout:
 	*error = err;
 	return NULL;
 }
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index f0a6c26..02a75db 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1195,8 +1195,8 @@ journal_error:
 	brelse(*bh);
 	brelse(bh2);
 	*bh = NULL;
-errout:
 	ext4_std_error(dir->i_sb, err);
+errout:
 	*error = err;
 	return NULL;
 }
