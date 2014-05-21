From: Giedrius Rekasius <giedrius.rekasius@gmail.com>
Subject: Re: [PATCH] ext4: remove unused local variable "store" from
 ext4_readdir(...)
Date: Wed, 21 May 2014 14:41:58 +0100
Message-ID: <20140521134158.GB4719@vaio>
References: <20140520144113.GB13333@vaio>
 <20140520200827.GM15585@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140520200827.GM15585@mwanda>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 20, 2014 at 11:08:27PM +0300, Dan Carpenter wrote:
> On Tue, May 20, 2014 at 03:41:13PM +0100, Giedrius Rekasius wrote:
> > From: Giedrius Rekasius <giedrius.rekasius@gmail.com>
> > 
> > Remove unused local variable "store" from ext4_readdir(...)
> > 
> > Local variable "stored" is initialized however never used inside the function.
> > 
> > Signed-off-by: Giedrius Rekasius <giedrius.rekasius@gmail.com>
> 
> You email client is corrupting the patch so it doesn't apply.
> 
> Read Documentation/email-clients.txt (linux-next version).

Indeed the patch was corrupt, my apologies for that. Patch resubmission 
below.

From: Giedrius Rekasius <giedrius.rekasius@gmail.com>

Remove unused local variable "store" from ext4_readdir(...)

Local variable "stored" is initialized however never used inside the function.

Signed-off-by: Giedrius Rekasius <giedrius.rekasius@gmail.com>
---
 fs/ext4/dir.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index d638c57..ef1bed6 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -105,7 +105,7 @@ int __ext4_check_dir_entry(const char *function, unsigned int line,
 static int ext4_readdir(struct file *file, struct dir_context *ctx)
 {
 	unsigned int offset;
-	int i, stored;
+	int i;
 	struct ext4_dir_entry_2 *de;
 	int err;
 	struct inode *inode = file_inode(file);
@@ -133,7 +133,6 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 			return ret;
 	}
 
-	stored = 0;
 	offset = ctx->pos & (sb->s_blocksize - 1);
 
 	while (ctx->pos < inode->i_size) {
