From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] mke2fs: fix hugefile creation so the hugefile(s) are
 contiguous
Date: Mon, 19 Jun 2017 16:40:39 -0700
Message-ID: <20170619234039.GA4728@birch.djwong.org>
References: <20170619224927.3176-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28363 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752801AbdFSXk6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Jun 2017 19:40:58 -0400
Content-Disposition: inline
In-Reply-To: <20170619224927.3176-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 19, 2017 at 06:49:27PM -0400, Theodore Ts'o wrote:
> Commit 4f868703f6f2: "libext2fs: use fallocate for creating journals
> and hugefiles" introduced a regression for the mke2fs hugefile
> feature.  The problem is that the fallocate library function
> intersperses the extent tree metadata blocks with the data blocks, and
> this violates the hugefile guarantee that the created files should be
> physically contiguous on disk.
> 
> Unfortuantely the m_hugefile regression test was flawed, and didn't
> pick up the regression.
> 
> This commit fixes the regression test so that it detects the problem
> before fixing mke2fs, and also fixes the mke2fs hugefile by reverting
> the mke2fs hugefile portion of commit 4f868703f6f2.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  misc/mk_hugefiles.c     |  99 +++++++++++++++++++++++++++++++++++------
>  tests/m_hugefile/expect | 114 ++++++++++++++++++++++++++++++++++++++++--------
>  tests/m_hugefile/script |   4 +-
>  3 files changed, 185 insertions(+), 32 deletions(-)
> 
> diff --git a/misc/mk_hugefiles.c b/misc/mk_hugefiles.c
> index 5882394d..ec4e0470 100644
> --- a/misc/mk_hugefiles.c
> +++ b/misc/mk_hugefiles.c
> @@ -262,8 +262,12 @@ static errcode_t mk_hugefile(ext2_filsys fs, blk64_t num,
>  
>  {
>  	errcode_t		retval;
> +	blk64_t			lblk, bend = 0;
> +	__u64			size;
> +	blk64_t			left;
> +	blk64_t			count = 0;
>  	struct ext2_inode	inode;
> -	int			falloc_flags;
> +	ext2_extent_handle_t	handle;
>  
>  	retval = ext2fs_new_inode(fs, 0, LINUX_S_IFREG, NULL, ino);
>  	if (retval)
> @@ -283,20 +287,85 @@ static errcode_t mk_hugefile(ext2_filsys fs, blk64_t num,
>  
>  	ext2fs_inode_alloc_stats2(fs, *ino, +1, 0);
>  
> -	if (ext2fs_has_feature_extents(fs->super))
> -		inode.i_flags |= EXT4_EXTENTS_FL;
> -
> -	falloc_flags = EXT2_FALLOCATE_FORCE_INIT;
> -	if (zero_hugefile)
> -		falloc_flags |= EXT2_FALLOCATE_ZERO_BLOCKS;
> -	retval = ext2fs_fallocate(fs, falloc_flags, *ino, &inode, goal, 0, num);
> +	retval = ext2fs_extent_open2(fs, *ino, &inode, &handle);

/me wonders if it'd be better just to teach ext2fs_fallocate to allocate
one huge chunk of space and then cut up the chunk into max_{,un}init_len
pieces for inserting into the extent tree, rather than re-open-coding the
_fallocate and _new_range library functions into mkfs.

OTOH "Yes Darrick, whenever you come up with a patch" is a fairly valid
counterargument. :P

--D

>  	if (retval)
>  		return retval;
> -	retval = ext2fs_inode_size_set(fs, &inode, num * fs->blocksize);
> +
> +	lblk = 0;
> +	left = num ? num : 1;
> +	while (left) {
> +		blk64_t pblk, end;
> +		blk64_t n = left;
> +
> +		retval =  ext2fs_find_first_zero_block_bitmap2(fs->block_map,
> +			goal, ext2fs_blocks_count(fs->super) - 1, &end);
> +		if (retval)
> +			goto errout;
> +		goal = end;
> +
> +		retval =  ext2fs_find_first_set_block_bitmap2(fs->block_map, goal,
> +			       ext2fs_blocks_count(fs->super) - 1, &bend);
> +		if (retval == ENOENT) {
> +			bend = ext2fs_blocks_count(fs->super);
> +			if (num == 0)
> +				left = 0;
> +		}
> +		if (!num || bend - goal < left)
> +			n = bend - goal;
> +		pblk = goal;
> +		if (num)
> +			left -= n;
> +		goal += n;
> +		count += n;
> +		ext2fs_block_alloc_stats_range(fs, pblk, n, +1);
> +
> +		if (zero_hugefile) {
> +			blk64_t ret_blk;
> +			retval = ext2fs_zero_blocks2(fs, pblk, n,
> +						     &ret_blk, NULL);
> +
> +			if (retval)
> +				com_err(program_name, retval,
> +					_("while zeroing block %llu "
> +					  "for hugefile"), ret_blk);
> +		}
> +
> +		while (n) {
> +			blk64_t l = n;
> +			struct ext2fs_extent newextent;
> +
> +			if (l > EXT_INIT_MAX_LEN)
> +				l = EXT_INIT_MAX_LEN;
> +
> +			newextent.e_len = l;
> +			newextent.e_pblk = pblk;
> +			newextent.e_lblk = lblk;
> +			newextent.e_flags = 0;
> +
> +			retval = ext2fs_extent_insert(handle,
> +					EXT2_EXTENT_INSERT_AFTER, &newextent);
> +			if (retval)
> +				return retval;
> +			pblk += l;
> +			lblk += l;
> +			n -= l;
> +		}
> +	}
> +
> +	retval = ext2fs_read_inode(fs, *ino, &inode);
>  	if (retval)
> -		return retval;
> +		goto errout;
> +
> +	retval = ext2fs_iblk_add_blocks(fs, &inode,
> +					count / EXT2FS_CLUSTER_RATIO(fs));
> +	if (retval)
> +		goto errout;
> +	size = (__u64) count * fs->blocksize;
> +	retval = ext2fs_inode_size_set(fs, &inode, size);
> +	if (retval)
> +		goto errout;
>  
> -	retval = ext2fs_write_inode(fs, *ino, &inode);
> +	retval = ext2fs_write_new_inode(fs, *ino, &inode);
>  	if (retval)
>  		goto errout;
>  
> @@ -314,7 +383,13 @@ retry:
>  		goto retry;
>  	}
>  
> +	if (retval)
> +		goto errout;
> +
>  errout:
> +	if (handle)
> +		ext2fs_extent_free(handle);
> +
>  	return retval;
>  }
>  
> @@ -499,8 +574,6 @@ errcode_t mk_hugefiles(ext2_filsys fs, const char *device_name)
>  			printf(_("with %llu blocks each"), num_blocks);
>  		fputs(": ", stdout);
>  	}
> -	if (num_blocks == 0)
> -		num_blocks = ext2fs_blocks_count(fs->super) - goal;
>  	for (i=0; i < num_files; i++) {
>  		ext2_ino_t ino;
>  
> diff --git a/tests/m_hugefile/expect b/tests/m_hugefile/expect
> index 82a60319..aee63f90 100644
> --- a/tests/m_hugefile/expect
> +++ b/tests/m_hugefile/expect
> @@ -14,23 +14,103 @@ Pass 4: Checking reference counts
>  Pass 5: Checking group summary information
>  
>  Exit status is 0
> -debugfs -R "extents /store/big-data" test.img | head
> +debugfs -R "extents /store/big-data" test.img
>  Level Entries                 Logical                Physical Length Flags
>   0/ 2   1/  1          0 - 1073610751     131070              1073610752
>   1/ 2   1/ 97          0 -   11108351     131071              11108352
> - 2/ 2   1/339          0 -      32767     131072 -     163839  32768 
> - 2/ 2   2/339      32768 -      65535     163840 -     196607  32768 
> - 2/ 2   3/339      65536 -      98303     196608 -     229375  32768 
> - 2/ 2   4/339      98304 -     131071     229376 -     262143  32768 
> - 2/ 2   5/339     131072 -     163839     262144 -     294911  32768 
> - 2/ 2   6/339     163840 -     196607     294912 -     327679  32768 
> - 2/ 2   7/339     196608 -     229375     327680 -     360447  32768 
> - 2/ 2   8/339     229376 -     262143     360448 -     393215  32768 
> - 2/ 2   9/339     262144 -     294911     393216 -     425983  32768 
> - 2/ 2  10/339     294912 -     327679     425984 -     458751  32768 
> - 2/ 2  11/339     327680 -     360447     458752 -     491519  32768 
> - 2/ 2  12/339     360448 -     393215     491520 -     524287  32768 
> - 2/ 2  13/339     393216 -     425983     524288 -     557055  32768 
> - 2/ 2  14/339     425984 -     458751     557056 -     589823  32768 
> - 2/ 2  15/339     458752 -     491519     589824 -     622591  32768 
> - 2/ 2  16/339     491520 -     524287     622592 -     655359  32768 
> + 1/ 2   2/ 97   11108352 -   22216703      98567              11108352
> + 1/ 2   3/ 97   22216704 -   33325055      98568              11108352
> + 1/ 2   4/ 97   33325056 -   44433407      98569              11108352
> + 1/ 2   5/ 97   44433408 -   55541759      98570              11108352
> + 1/ 2   6/ 97   55541760 -   66650111      98571              11108352
> + 1/ 2   7/ 97   66650112 -   77758463      98572              11108352
> + 1/ 2   8/ 97   77758464 -   88866815      98573              11108352
> + 1/ 2   9/ 97   88866816 -   99975167      98574              11108352
> + 1/ 2  10/ 97   99975168 -  111083519      98575              11108352
> + 1/ 2  11/ 97  111083520 -  122191871      98576              11108352
> + 1/ 2  12/ 97  122191872 -  133300223      98577              11108352
> + 1/ 2  13/ 97  133300224 -  144408575      98578              11108352
> + 1/ 2  14/ 97  144408576 -  155516927      98579              11108352
> + 1/ 2  15/ 97  155516928 -  166625279      98580              11108352
> + 1/ 2  16/ 97  166625280 -  177733631      98581              11108352
> + 1/ 2  17/ 97  177733632 -  188841983      98582              11108352
> + 1/ 2  18/ 97  188841984 -  199950335      98583              11108352
> + 1/ 2  19/ 97  199950336 -  211058687      98584              11108352
> + 1/ 2  20/ 97  211058688 -  222167039      98585              11108352
> + 1/ 2  21/ 97  222167040 -  233275391      98586              11108352
> + 1/ 2  22/ 97  233275392 -  244383743      98587              11108352
> + 1/ 2  23/ 97  244383744 -  255492095      98588              11108352
> + 1/ 2  24/ 97  255492096 -  266600447      98589              11108352
> + 1/ 2  25/ 97  266600448 -  277708799      98590              11108352
> + 1/ 2  26/ 97  277708800 -  288817151      98591              11108352
> + 1/ 2  27/ 97  288817152 -  299925503      98592              11108352
> + 1/ 2  28/ 97  299925504 -  311033855      98593              11108352
> + 1/ 2  29/ 97  311033856 -  322142207      98594              11108352
> + 1/ 2  30/ 97  322142208 -  333250559      98595              11108352
> + 1/ 2  31/ 97  333250560 -  344358911      98596              11108352
> + 1/ 2  32/ 97  344358912 -  355467263      98597              11108352
> + 1/ 2  33/ 97  355467264 -  366575615      98598              11108352
> + 1/ 2  34/ 97  366575616 -  377683967      98599              11108352
> + 1/ 2  35/ 97  377683968 -  388792319      98600              11108352
> + 1/ 2  36/ 97  388792320 -  399900671      98601              11108352
> + 1/ 2  37/ 97  399900672 -  411009023      98602              11108352
> + 1/ 2  38/ 97  411009024 -  422117375      98603              11108352
> + 1/ 2  39/ 97  422117376 -  433225727      98604              11108352
> + 1/ 2  40/ 97  433225728 -  444334079      98605              11108352
> + 1/ 2  41/ 97  444334080 -  455442431      98606              11108352
> + 1/ 2  42/ 97  455442432 -  466550783      98607              11108352
> + 1/ 2  43/ 97  466550784 -  477659135      98608              11108352
> + 1/ 2  44/ 97  477659136 -  488767487      98609              11108352
> + 1/ 2  45/ 97  488767488 -  499875839      98610              11108352
> + 1/ 2  46/ 97  499875840 -  510984191      98611              11108352
> + 1/ 2  47/ 97  510984192 -  522092543      98612              11108352
> + 1/ 2  48/ 97  522092544 -  533200895      98613              11108352
> + 1/ 2  49/ 97  533200896 -  544309247      98614              11108352
> + 1/ 2  50/ 97  544309248 -  555417599      98615              11108352
> + 1/ 2  51/ 97  555417600 -  566525951      98616              11108352
> + 1/ 2  52/ 97  566525952 -  577634303      98617              11108352
> + 1/ 2  53/ 97  577634304 -  588742655      98618              11108352
> + 1/ 2  54/ 97  588742656 -  599851007      98619              11108352
> + 1/ 2  55/ 97  599851008 -  610959359      98620              11108352
> + 1/ 2  56/ 97  610959360 -  622067711      98621              11108352
> + 1/ 2  57/ 97  622067712 -  633176063      98622              11108352
> + 1/ 2  58/ 97  633176064 -  644284415      98623              11108352
> + 1/ 2  59/ 97  644284416 -  655392767      98624              11108352
> + 1/ 2  60/ 97  655392768 -  666501119      98625              11108352
> + 1/ 2  61/ 97  666501120 -  677609471      98626              11108352
> + 1/ 2  62/ 97  677609472 -  688717823      98627              11108352
> + 1/ 2  63/ 97  688717824 -  699826175      98628              11108352
> + 1/ 2  64/ 97  699826176 -  710934527      98629              11108352
> + 1/ 2  65/ 97  710934528 -  722042879      98630              11108352
> + 1/ 2  66/ 97  722042880 -  733151231      98631              11108352
> + 1/ 2  67/ 97  733151232 -  744259583      98632              11108352
> + 1/ 2  68/ 97  744259584 -  755367935      98633              11108352
> + 1/ 2  69/ 97  755367936 -  766476287      98634              11108352
> + 1/ 2  70/ 97  766476288 -  777584639      98635              11108352
> + 1/ 2  71/ 97  777584640 -  788692991      98636              11108352
> + 1/ 2  72/ 97  788692992 -  799801343      98637              11108352
> + 1/ 2  73/ 97  799801344 -  810909695      98638              11108352
> + 1/ 2  74/ 97  810909696 -  822018047      98639              11108352
> + 1/ 2  75/ 97  822018048 -  833126399      98640              11108352
> + 1/ 2  76/ 97  833126400 -  844234751      98641              11108352
> + 1/ 2  77/ 97  844234752 -  855343103      98642              11108352
> + 1/ 2  78/ 97  855343104 -  866451455      98643              11108352
> + 1/ 2  79/ 97  866451456 -  877559807      98644              11108352
> + 1/ 2  80/ 97  877559808 -  888668159      98645              11108352
> + 1/ 2  81/ 97  888668160 -  899776511      98646              11108352
> + 1/ 2  82/ 97  899776512 -  910884863      98647              11108352
> + 1/ 2  83/ 97  910884864 -  921993215      98648              11108352
> + 1/ 2  84/ 97  921993216 -  933101567      98649              11108352
> + 1/ 2  85/ 97  933101568 -  944209919      98650              11108352
> + 1/ 2  86/ 97  944209920 -  955318271      98651              11108352
> + 1/ 2  87/ 97  955318272 -  966426623      98652              11108352
> + 1/ 2  88/ 97  966426624 -  977534975      98653              11108352
> + 1/ 2  89/ 97  977534976 -  988643327      98654              11108352
> + 1/ 2  90/ 97  988643328 -  999751679      98655              11108352
> + 1/ 2  91/ 97  999751680 - 1010860031      98656              11108352
> + 1/ 2  92/ 97 1010860032 - 1021968383      98657              11108352
> + 1/ 2  93/ 97 1021968384 - 1033076735      98658              11108352
> + 1/ 2  94/ 97 1033076736 - 1044185087      98659              11108352
> + 1/ 2  95/ 97 1044185088 - 1055293439      98660              11108352
> + 1/ 2  96/ 97 1055293440 - 1066401791      98661              11108352
> + 1/ 2  97/ 97 1066401792 - 1073610751      98662              7208960
> diff --git a/tests/m_hugefile/script b/tests/m_hugefile/script
> index 2750d538..317deabf 100644
> --- a/tests/m_hugefile/script
> +++ b/tests/m_hugefile/script
> @@ -44,9 +44,9 @@ $FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
>  status=$?
>  echo Exit status is $status >> $OUT
>  
> -echo 'debugfs -R "extents /store/big-data" test.img | head' >> $OUT
> +echo 'debugfs -R "extents /store/big-data" test.img' >> $OUT
>  
> -$DEBUGFS -R "extents /store/big-data" $TMPFILE 2>&1 | head -n 20 >> $OUT 2>&1
> +$DEBUGFS -R "extents -n /store/big-data" $TMPFILE 2>&1 >> $OUT 2>&1
>  
>  rm $TMPFILE
>  
> -- 
> 2.11.0.rc0.7.gbe5a750
> 
