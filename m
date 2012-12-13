From: Forrest Liu <forrestl@synology.com>
Subject: Re: [PATCH] ext4: fix extent tree corruption that incurred by hole
 punch [V2]
Date: Fri, 14 Dec 2012 00:04:58 +0800
Message-ID: <CAJSVwFMW-pG4ca+EnnqTP2wXn8_zi5C+CihgrS-pvbkn9gnjmQ@mail.gmail.com>
References: <CAJSVwFM3vq9wsq0Mn5L1bh-WHoP1g3VMJAOg_ruavZFednsjVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	"Synology/Forrest Liu" <forrestl@synology.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57798 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab2LMQE7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Dec 2012 11:04:59 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so4152826ieb.19
        for <linux-ext4@vger.kernel.org>; Thu, 13 Dec 2012 08:04:59 -0800 (PST)
In-Reply-To: <CAJSVwFM3vq9wsq0Mn5L1bh-WHoP1g3VMJAOg_ruavZFednsjVw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

@Ashish
   I have modified the patch with your suggestion, could you help to review.

@Ted
   I wrote a script to verify this problem.
   This script needs tst_extents and fallocate executables from e2fsprogs, and
fallocate needs your patch with bug fix to do hole punch.

   Steps to run the script
1) assign variable blkdev to path of block device that filesystem mount on
2) cd to mount point
3) run script

Thanks,
Forrest

# verify hole punch bug
#
blkdev=/dev/sda1
file=punch_test
cmdfile=cmds
filesize=`expr 1024 \* 1024 \* 1024`
blksize=`tst_extents -R "stats" $blkdev | grep "Block size" | cut -d
':'  -f 2 | tr -d ' '`
maxlblks=`expr $filesize \/ $blksize`

rm $file
touch $file
fallocate -l $filesize $file
sync

inode=`tst_extents -R "stat ${file}" $blkdev | grep Inode | cut -d ' ' -f 2`
echo "Inode number: $inode"

# punch every even blocks
echo "Punch out every even blocks"
i=0
while [ "${i}" -lt "${maxlblks}" ]
do
	offset=`expr $i \* $blksize`
	fallocate -p -o $offset -l $blksize $file
	i=$(($i+2))
done

# get lblk from root->ns->down
echo "inode <$inode>" > cmds
echo "root" >> cmds
echo "ns" >> cmds

a=`tst_extents -f $cmdfile $blkdev`
echo "down" >> cmds
b=`tst_extents -f $cmdfile $blkdev`

# get output form command "down"
c=${b:${#a}}
echo "Out put from command \"down\""
echo $c

a=`echo ${c#*lblk} | cut -d ',' -f 1`
lblk_low=`echo $a | cut -d '-' -f 1`
lblk_hi=`echo $a | cut -d '-' -f 3`

echo ""
echo "Punch out blocks $lblk_hi, ..., $lblk_low"

i=$lblk_hi
while [ $i -ge $lblk_low ]
do
	offset=`expr $i \* $blksize`
	fallocate -p -o $offset -l $blksize $file
	i=$(($i-1))
done

# verify logical start value is correct or not
echo "inode <$inode>" > cmds
echo "root" >> cmds
a=`tst_extents -f $cmdfile $blkdev`
echo "ns" >> cmds
b=`tst_extents -f $cmdfile $blkdev`

c=${b:${#a}}
c=`echo ${c#*lblk} | cut -d ',' -f 1`
lblk_start0=`echo $c | cut -d '-' -f 1`

echo "down" >> cmds
c=`tst_extents -f $cmdfile $blkdev`
c=${c:${#b}}
c=`echo ${c#*lblk} | cut -d ',' -f 1`
lblk_start1=`echo $c | cut -d '-' -f 1`

if [ $lblk_start0 -eq $lblk_start1 ]
then
	echo "logical start valie is consistency:$lblk_start0,$lblk_start1"
else
	echo "logical start valie is not consistency:$lblk_start0,$lblk_start1"
fi



diff --git a/contrib/fallocate.c b/contrib/fallocate.c
index 0e8319f..c1c08e1 100644
--- a/contrib/fallocate.c
+++ b/contrib/fallocate.c
@@ -35,10 +35,11 @@

 // #include <linux/falloc.h>
 #define FALLOC_FL_KEEP_SIZE	0x01
+#define FALLOC_FL_PUNCH_HOLE	0x02 /* de-allocates range */

 void usage(void)
 {
-	printf("Usage: fallocate [-nt] [-o offset] -l length filename\n");
+	printf("Usage: fallocate [-npt] [-o offset] -l length filename\n");
 	exit(EXIT_FAILURE);
 }

@@ -56,6 +57,7 @@ cvtnum(char *s)
 	char		*sp;
 	int		c;

+
 	i = strtoll(s, &sp, 0);
 	if (i == 0 && sp == s)
 		return -1LL;
@@ -94,12 +96,18 @@ int main(int argc, char **argv)
 	int	error;
 	int	tflag = 0;

-	while ((opt = getopt(argc, argv, "nl:ot")) != -1) {
+	while ((opt = getopt(argc, argv, "npl:o:t")) != -1) {
 		switch(opt) {
 		case 'n':
 			/* do not change filesize */
 			falloc_mode = FALLOC_FL_KEEP_SIZE;
 			break;
+		case 'p':
+			/* punch mode */
+			falloc_mode = (FALLOC_FL_PUNCH_HOLE |
+				FALLOC_FL_KEEP_SIZE);
+			break;
+
 		case 'l':
 			length = cvtnum(optarg);
 			break;

2012/12/13 Forrest Liu <forrestl@synology.com>:
> When depth of extent tree is greater than 1, logical start value
> of interior node didn't updated correctly in ext4_ext_rm_idx.
>
> Signed-off-by: Forrest Liu <forrestl@synology.com>
> ---
>  fs/ext4/extents.c |   22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index d3dd618..496952e 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2190,13 +2190,14 @@ errout:
>   * removes index from the index block.
>   */
>  static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
> -                       struct ext4_ext_path *path)
> +                       struct ext4_ext_path *path, int depth)
>  {
>         int err;
>         ext4_fsblk_t leaf;
>
>         /* free index block */
> -       path--;
> +       depth--;
> +       path = path + depth;
>         leaf = ext4_idx_pblock(path->p_idx);
>         if (unlikely(path->p_hdr->eh_entries == 0)) {
>                 EXT4_ERROR_INODE(inode, "path->p_hdr->eh_entries == 0");
> @@ -2221,6 +2222,19 @@ static int ext4_ext_rm_idx(handle_t *handle,
> struct inode *inode,
>
>         ext4_free_blocks(handle, inode, NULL, leaf, 1,
>                          EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET);
> +
> +       while (--depth >= 0) {
> +               if (path->p_idx != EXT_FIRST_INDEX(path->p_hdr))
> +                       break;
> +               path--;
> +               err = ext4_ext_get_access(handle, inode, path);
> +               if (err)
> +                       break;
> +               path->p_idx->ei_block = (path+1)->p_idx->ei_block;
> +               err = ext4_ext_dirty(handle, inode, path);
> +               if (err)
> +                       break;
> +       }
>         return err;
>  }
>
> @@ -2557,7 +2571,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>         /* if this leaf is free, then we should
>          * remove it from index block above */
>         if (err == 0 && eh->eh_entries == 0 && path[depth].p_bh != NULL)
> -               err = ext4_ext_rm_idx(handle, inode, path + depth);
> +               err = ext4_ext_rm_idx(handle, inode, path, depth);
>
>  out:
>         return err;
> @@ -2760,7 +2774,7 @@ again:
>                                 /* index is empty, remove it;
>                                  * handle must be already prepared by the
>                                  * truncatei_leaf() */
> -                               err = ext4_ext_rm_idx(handle, inode, path + i);
> +                               err = ext4_ext_rm_idx(handle, inode, path, i);
>                         }
>                         /* root level has p_bh == NULL, brelse() eats this */
>                         brelse(path[i].p_bh);
> --
> 1.7.9.5
