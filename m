From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 09/37] mke2fs: set error behavior at initialization
 time
Date: Fri, 2 May 2014 14:13:24 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405021413070.2154@localhost.localdomain>
References: <20140501231222.31890.82860.stgit@birch.djwong.org> <20140501231321.31890.79574.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbaEBMNb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 May 2014 08:13:31 -0400
In-Reply-To: <20140501231321.31890.79574.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 1 May 2014, Darrick J. Wong wrote:

> Date: Thu, 01 May 2014 16:13:21 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: tytso@mit.edu, darrick.wong@oracle.com
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 09/37] mke2fs: set error behavior at initialization time
> 
> Port tune2fs' -e flag to mke2fs so that we can set error behavior at
> format time, and introduce the equivalent errors= setting into
> mke2fs.conf.

Looks good. Thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  misc/mke2fs.8.in             |   23 +++++++++
>  misc/mke2fs.c                |   57 +++++++++++++++++++++-
>  misc/mke2fs.conf.5.in        |   19 +++++++
>  tests/t_mke2fs_errors/expect |   24 +++++++++
>  tests/t_mke2fs_errors/script |  110 ++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 231 insertions(+), 2 deletions(-)
>  create mode 100644 tests/t_mke2fs_errors/expect
>  create mode 100755 tests/t_mke2fs_errors/script
> 
> 
> diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
> index bf17eae..bad76bb 100644
> --- a/misc/mke2fs.8.in
> +++ b/misc/mke2fs.8.in
> @@ -113,6 +113,10 @@ mke2fs \- create an ext2/ext3/ext4 filesystem
>  [
>  .B \-V
>  ]
> +[
> +.B \-e
> +.I errors-behavior
> +]
>  .I device
>  [
>  .I blocks-count
> @@ -206,6 +210,25 @@ lot of buffer cache memory, which may impact other applications running
>  on a busy server.  This option will cause mke2fs to run much more
>  slowly, however, so there is a tradeoff to using direct I/O.
>  .TP
> +.BI \-e " error-behavior"
> +Change the behavior of the kernel code when errors are detected.
> +In all cases, a filesystem error will cause
> +.BR e2fsck (8)
> +to check the filesystem on the next boot.
> +.I error-behavior
> +can be one of the following:
> +.RS 1.2i
> +.TP 1.2i
> +.B continue
> +Continue normal execution.
> +.TP
> +.B remount-ro
> +Remount filesystem read-only.
> +.TP
> +.B panic
> +Cause a kernel panic.
> +.RE
> +.TP
>  .BI \-E " extended-options"
>  Set extended options for the filesystem.  Extended options are comma
>  separated, and may take an argument using the equals ('=') sign.  The
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index fd6259d..a794689 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -112,6 +112,8 @@ static profile_t	profile;
>  static int sys_page_size = 4096;
>  static int linux_version_code = 0;
>  
> +static int errors_behavior = 0;
> +
>  static void usage(void)
>  {
>  	fprintf(stderr, _("Usage: %s [-c|-l filename] [-b block-size] "
> @@ -123,7 +125,7 @@ static void usage(void)
>  	"\t[-g blocks-per-group] [-L volume-label] "
>  	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
>  	"[-r fs-revision] [-E extended-option[,...]]\n"
> -	"\t[-t fs-type] [-T usage-type ] [-U UUID] "
> +	"\t[-t fs-type] [-T usage-type ] [-U UUID] [-e errors_behavior]"
>  	"[-jnqvDFKSV] device [blocks-count]\n"),
>  		program_name);
>  	exit(1);
> @@ -1524,7 +1526,7 @@ profile_error:
>  	}
>  
>  	while ((c = getopt (argc, argv,
> -		    "b:cg:i:jl:m:no:qr:s:t:d:vC:DE:FG:I:J:KL:M:N:O:R:ST:U:V")) != EOF) {
> +		    "b:ce:g:i:jl:m:no:qr:s:t:d:vC:DE:FG:I:J:KL:M:N:O:R:ST:U:V")) != EOF) {
>  		switch (c) {
>  		case 'b':
>  			blocksize = parse_num_blocks2(optarg, -1);
> @@ -1567,6 +1569,20 @@ profile_error:
>  		case 'E':
>  			extended_opts = optarg;
>  			break;
> +		case 'e':
> +			if (strcmp(optarg, "continue") == 0)
> +				errors_behavior = EXT2_ERRORS_CONTINUE;
> +			else if (strcmp(optarg, "remount-ro") == 0)
> +				errors_behavior = EXT2_ERRORS_RO;
> +			else if (strcmp(optarg, "panic") == 0)
> +				errors_behavior = EXT2_ERRORS_PANIC;
> +			else {
> +				com_err(program_name, 0,
> +					_("bad error behavior - %s"),
> +					optarg);
> +				usage();
> +			}
> +			break;
>  		case 'F':
>  			force++;
>  			break;
> @@ -2577,6 +2593,38 @@ static int create_quota_inodes(ext2_filsys fs)
>  	return 0;
>  }
>  
> +static errcode_t set_error_behavior(ext2_filsys fs)
> +{
> +	char	*arg = NULL;
> +	short	errors = fs->super->s_errors;
> +
> +	arg = get_string_from_profile(fs_types, "errors", NULL);
> +	if (arg == NULL)
> +		goto try_user;
> +
> +	if (strcmp(arg, "continue") == 0)
> +		errors = EXT2_ERRORS_CONTINUE;
> +	else if (strcmp(arg, "remount-ro") == 0)
> +		errors = EXT2_ERRORS_RO;
> +	else if (strcmp(arg, "panic") == 0)
> +		errors = EXT2_ERRORS_PANIC;
> +	else {
> +		com_err(program_name, 0,
> +			_("bad error behavior in profile - %s"),
> +			arg);
> +		free(arg);
> +		return EXT2_ET_INVALID_ARGUMENT;
> +	}
> +	free(arg);
> +
> +try_user:
> +	if (errors_behavior)
> +		errors = errors_behavior;
> +
> +	fs->super->s_errors = errors;
> +	return 0;
> +}
> +
>  int main (int argc, char *argv[])
>  {
>  	errcode_t	retval = 0;
> @@ -2641,6 +2689,11 @@ int main (int argc, char *argv[])
>  	}
>  	fs->progress_ops = &ext2fs_numeric_progress_ops;
>  
> +	/* Set the error behavior */
> +	retval = set_error_behavior(fs);
> +	if (retval)
> +		usage();
> +
>  	/* Check the user's mkfs options for metadata checksumming */
>  	if (!quiet &&
>  	    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
> index 02efdce..18a003a 100644
> --- a/misc/mke2fs.conf.5.in
> +++ b/misc/mke2fs.conf.5.in
> @@ -302,6 +302,25 @@ whose subsections define the
>  relation, only the last will be used by
>  .BR mke2fs (8).
>  .TP
> +.I errors
> +Change the behavior of the kernel code when errors are detected.
> +In all cases, a filesystem error will cause
> +.BR e2fsck (8)
> +to check the filesystem on the next boot.
> +.I errors
> +can be one of the following:
> +.RS 1.2i
> +.TP 1.2i
> +.B continue
> +Continue normal execution.
> +.TP
> +.B remount-ro
> +Remount filesystem read-only.
> +.TP
> +.B panic
> +Cause a kernel panic.
> +.RE
> +.TP
>  .I features
>  This relation specifies a comma-separated list of features edit
>  requests which modify the feature set
> diff --git a/tests/t_mke2fs_errors/expect b/tests/t_mke2fs_errors/expect
> new file mode 100644
> index 0000000..78514bd
> --- /dev/null
> +++ b/tests/t_mke2fs_errors/expect
> @@ -0,0 +1,24 @@
> +error default
> +Errors behavior:          Continue
> +error continue
> +Errors behavior:          Continue
> +error panic
> +Errors behavior:          Panic
> +error remount-ro
> +Errors behavior:          Remount read-only
> +error garbage
> +error default profile continue
> +Errors behavior:          Continue
> +error default profile panic
> +Errors behavior:          Panic
> +error default profile remount-ro
> +Errors behavior:          Remount read-only
> +error default profile broken
> +error fs_types profile continue
> +Errors behavior:          Continue
> +error fs_types profile panic
> +Errors behavior:          Panic
> +error fs_types profile remount-ro
> +Errors behavior:          Remount read-only
> +error fs_types profile remount-ro
> +Errors behavior:          Panic
> diff --git a/tests/t_mke2fs_errors/script b/tests/t_mke2fs_errors/script
> new file mode 100755
> index 0000000..d09e926
> --- /dev/null
> +++ b/tests/t_mke2fs_errors/script
> @@ -0,0 +1,110 @@
> +test_description="mke2fs with error behavior"
> +
> +conf=$TMPFILE.conf
> +write_defaults_conf()
> +{
> +	errors="$1"
> +	cat > $conf << ENDL
> +[defaults]
> +	errors = $errors
> +ENDL
> +}
> +
> +write_section_conf()
> +{
> +	errors="$1"
> +	cat > $conf << ENDL
> +[defaults]
> +	errors = broken
> +
> +[fs_types]
> +	test_suite = {
> +		errors = $errors
> +	}
> +ENDL
> +}
> +
> +trap "rm -rf $TMPFILE $TMPFILE.conf" EXIT INT QUIT
> +dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
> +OUT=$test_name.log
> +EXP=$test_dir/expect
> +rm -rf $OUT
> +
> +# Test command line option
> +echo "error default" >> $OUT
> +$MKE2FS -F $TMPFILE > /dev/null 2>&1
> +$DUMPE2FS $TMPFILE 2>&1 | grep 'Errors behavior' >> $OUT
> +
> +echo "error continue" >> $OUT
> +$MKE2FS -e continue -F $TMPFILE > /dev/null 2>&1
> +$DUMPE2FS $TMPFILE 2>&1 | grep 'Errors behavior' >> $OUT
> +
> +echo "error panic" >> $OUT
> +$MKE2FS -e panic -F $TMPFILE > /dev/null 2>&1
> +$DUMPE2FS $TMPFILE 2>&1 | grep 'Errors behavior' >> $OUT
> +
> +echo "error remount-ro" >> $OUT
> +$MKE2FS -e remount-ro -F $TMPFILE > /dev/null 2>&1
> +$DUMPE2FS $TMPFILE 2>&1 | grep 'Errors behavior' >> $OUT
> +
> +echo "error garbage" >> $OUT
> +dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
> +$MKE2FS -e broken -F $TMPFILE > /dev/null 2>&1
> +$DUMPE2FS $TMPFILE 2>&1 | grep 'Errors behavior' >> $OUT
> +
> +# Test errors= in default
> +echo "error default profile continue" >> $OUT
> +write_defaults_conf continue
> +MKE2FS_CONFIG=$conf $MKE2FS -F $TMPFILE > /dev/null 2>&1
> +$DUMPE2FS $TMPFILE 2>&1 | grep 'Errors behavior' >> $OUT
> +
> +echo "error default profile panic" >> $OUT
> +write_defaults_conf panic
> +MKE2FS_CONFIG=$conf $MKE2FS -F $TMPFILE > /dev/null 2>&1
> +$DUMPE2FS $TMPFILE 2>&1 | grep 'Errors behavior' >> $OUT
> +
> +echo "error default profile remount-ro" >> $OUT
> +write_defaults_conf remount-ro
> +MKE2FS_CONFIG=$conf $MKE2FS -F $TMPFILE > /dev/null 2>&1
> +$DUMPE2FS $TMPFILE 2>&1 | grep 'Errors behavior' >> $OUT
> +
> +echo "error default profile broken" >> $OUT
> +write_defaults_conf broken
> +dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
> +MKE2FS_CONFIG=$conf $MKE2FS -F $TMPFILE > /dev/null 2>&1
> +$DUMPE2FS $TMPFILE 2>&1 | grep 'Errors behavior' >> $OUT
> +
> +# Test errors= in a fs type
> +echo "error fs_types profile continue" >> $OUT
> +write_section_conf continue
> +MKE2FS_CONFIG=$conf $MKE2FS -F $TMPFILE -T test_suite > /dev/null 2>&1
> +$DUMPE2FS $TMPFILE 2>&1 | grep 'Errors behavior' >> $OUT
> +
> +echo "error fs_types profile panic" >> $OUT
> +write_section_conf panic
> +MKE2FS_CONFIG=$conf $MKE2FS -F $TMPFILE -T test_suite > /dev/null 2>&1
> +$DUMPE2FS $TMPFILE 2>&1 | grep 'Errors behavior' >> $OUT
> +
> +echo "error fs_types profile remount-ro" >> $OUT
> +write_section_conf remount-ro
> +MKE2FS_CONFIG=$conf $MKE2FS -F $TMPFILE -T test_suite > /dev/null 2>&1
> +$DUMPE2FS $TMPFILE 2>&1 | grep 'Errors behavior' >> $OUT
> +
> +# Test command line override
> +echo "error fs_types profile remount-ro" >> $OUT
> +write_section_conf remount-ro
> +MKE2FS_CONFIG=$conf $MKE2FS -F $TMPFILE -T test_suite -e panic > /dev/null 2>&1
> +$DUMPE2FS $TMPFILE 2>&1 | grep 'Errors behavior' >> $OUT
> +
> +cmp -s $OUT $EXP
> +status=$?
> +
> +if [ "$status" = 0 ] ; then
> +	echo "$test_name: $test_description: ok"
> +	touch $test_name.ok
> +else
> +	echo "$test_name: $test_description: failed"
> +	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
> +	rm -f $test_name.tmp
> +fi
> +
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
