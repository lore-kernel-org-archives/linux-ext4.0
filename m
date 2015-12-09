From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] common: Improve _link_output_file to be more
 versatile
Date: Wed, 9 Dec 2015 13:27:07 +0100
Message-ID: <20151209122707.GE3137@quack.suse.cz>
References: <1448361598-28438-1-git-send-email-jack@suse.cz>
 <1448361598-28438-3-git-send-email-jack@suse.cz>
 <20151207232619.GC3094@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151207232619.GC3094@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 07-12-15 18:26:19, Ted Tso wrote:
> On Tue, Nov 24, 2015 at 11:39:57AM +0100, Jan Kara wrote:
> > From: Jan Kara <jack@suse.com>
> > 
> > Currently _link_output_file() selects output file suffix based on the
> > current operating system. Make it more versatile by allowing selection
> > of output file suffix based on any feature string. The idea is that
> > in config file ($seq.cfg) there are several lines like:
> > 
> > feat1,feat2: suffix
> > 
> > The function is passed a feature string (or uses os_name,MOUNT_OPTIONS
> > if no argument is passed) and selects output file with a suffix for
> > which all features are present in the feature string. If there is no
> > matching line, output with 'default' suffix is selected.
> > 
> > Update all tests using _link_out_file to the new calling convention.
> > 
> > Signed-off-by: Jan Kara <jack@suse.com>
> 
> I made a slight change so that if $seqfull.cfg doesn't exist, we use
> ./common/default.cfg instead.  This avoids the need to create a large
> number of identical files:
> 
> >  tests/generic/088.cfg       |   2 +
> >  tests/xfs/018.cfg           |   2 +
> >  tests/xfs/022.cfg           |   2 +
> >  tests/xfs/023.cfg           |   2 +
> >  tests/xfs/030.cfg           |   2 +
> >  tests/xfs/031.cfg           |   2 +
> >  tests/xfs/035.cfg           |   2 +
> >  tests/xfs/036.cfg           |   2 +
> >  tests/xfs/039.cfg           |   2 +
> >  tests/xfs/043.cfg           |   2 +
> >  tests/xfs/082.cfg           |   2 +
> >  tests/xfs/146.cfg           |   2 +
> 
> What do you think?

So I'm somewhat undecided whether this is better or not ;). It certainly
saves us some churn with identical .cfg files for linux vs irix configs
but OTOH I don't expect there to be much more .cfg files selecting between
irix and linux so this is mostly one-time issue. So I guess I'll leave it
upto Dave and his taste to decide what he finds better.

								Honza

> commit 37c2d44b6cc6772f0daa10761fb532b5662dc6fc
> Author: Jan Kara <jack@suse.com>
> Date:   Tue Nov 24 11:39:57 2015 +0100
> 
>     common: Improve _link_output_file to be more versatile
>     
>     Currently _link_output_file() selects output file suffix based on the
>     current operating system. Make it more versatile by allowing selection
>     of output file suffix based on any feature string. The idea is that
>     in config file ($seq.cfg) there are several lines like:
>     
>     feat1,feat2: suffix
>     
>     The function is passed a feature string (or uses os_name,MOUNT_OPTIONS
>     if no argument is passed) and selects output file with a suffix for
>     which all features are present in the feature string. If there is no
>     matching line, output with 'default' suffix is selected.
>     
>     Update all tests using _link_out_file to the new calling convention.
>     
>     Signed-off-by: Jan Kara <jack@suse.com>
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> diff --git a/common/default.cfg b/common/default.cfg
> new file mode 100644
> index 0000000..7ffdfc0
> --- /dev/null
> +++ b/common/default.cfg
> @@ -0,0 +1,2 @@
> +irix: irix
> +linux: linux
> diff --git a/common/rc b/common/rc
> index 62216f4..3b4cbe0 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2205,15 +2205,60 @@ _get_os_name()
>  	fi
>  }
>  
> +_link_out_file_named()
> +{
> +	local cfg_file
> +	export FEATURES=$2
> +
> +	if test -f $seqfull.cfg; then
> +		cfg_file=$seqfull.cfg
> +	else
> +		cfg_file=./common/default.cfg
> +	fi
> +
> +	SUFFIX=$(perl -e '
> +		my %feathash;
> +		my $feature, $result, $suffix, $opts;
> +
> +		foreach $feature (split(/,/, $ENV{"FEATURES"})) {
> +			$feathash{$feature} = 1;
> +		}
> +		$result = "default";
> +		while (<>) {
> +			my $found = 1;
> +
> +			chomp;
> +			($opts, $suffix) = split(/ *: */);
> +			foreach my $opt (split(/,/, $opts)) {
> +				if (!exists($feathash{$opt})) {
> +					$found = 0;
> +					last;
> +				}
> +			}
> +			if ($found == 1) {
> +				$result = $suffix;
> +				last;
> +			}
> +		}
> +		print $result
> +		' <$cfg_file)
> +	rm -f $1
> +	SRC=$(basename $1)
> +	ln -fs $SRC.$SUFFIX $1
> +}
> +
>  _link_out_file()
>  {
> -	if [ -z "$1" -o -z "$2" ]; then
> -		echo Error must pass src and dst.
> -		exit
> +	if [ $# -eq 0 ]; then
> +		FEATURES="$(_get_os_name)"
> +		if [ -n "$MOUNT_OPTIONS" ]; then
> +			FEATURES=$FEATURES,${MOUNT_OPTIONS##"-o "}
> +		fi
> +	else
> +		FEATURES=$1
>  	fi
> -	rm -f $2
> -	SUFFIX=$(_get_os_name())
> -	ln -s $1.$SUFFIX $2
> +
> +	_link_out_file_named $seqfull.out "$FEATURES"
>  }
>  
>  _die()
> diff --git a/tests/generic/088 b/tests/generic/088
> index 983de98..46ce6ae 100755
> --- a/tests/generic/088
> +++ b/tests/generic/088
> @@ -43,7 +43,7 @@ _filter()
>  }
>  
>  # link correct .out file
> -_link_out_file $seq.out $seqfull.out
> +_link_out_file
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/xfs/018 b/tests/xfs/018
> index f097b28..848981f 100755
> --- a/tests/xfs/018
> +++ b/tests/xfs/018
> @@ -54,7 +54,7 @@ _require_scratch
>  _require_v2log
>  
>  # link correct .out file
> -_link_out_file $seq.op $seqfull.op
> +_link_out_file_named $seqfull.op $(_get_os_name)
>  
>  echo "*** init FS"
>  umount $SCRATCH_DEV >/dev/null 2>&1
> diff --git a/tests/xfs/022 b/tests/xfs/022
> index cd9b9ec..b2b6142 100755
> --- a/tests/xfs/022
> +++ b/tests/xfs/022
> @@ -39,7 +39,7 @@ trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
>  . ./common/dump
>  
>  # link correct .out file
> -_link_out_file $seq.out $seqfull.out
> +_link_out_file
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/023 b/tests/xfs/023
> index 120be64..9a899a8 100755
> --- a/tests/xfs/023
> +++ b/tests/xfs/023
> @@ -38,7 +38,7 @@ trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
>  . ./common/dump
>  
>  # link correct .out file
> -_link_out_file $seq.out $seqfull.out
> +_link_out_file
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/030 b/tests/xfs/030
> index a43455f..d2f5ed1 100755
> --- a/tests/xfs/030
> +++ b/tests/xfs/030
> @@ -46,7 +46,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  . ./common/repair
>  
>  # link correct .out file
> -_link_out_file $seq.out $seqfull.out
> +_link_out_file
>  
>  # nuke the superblock, AGI, AGF, AGFL; then try repair the damage
>  #
> diff --git a/tests/xfs/031 b/tests/xfs/031
> index 48a97e1..59d68c3 100755
> --- a/tests/xfs/031
> +++ b/tests/xfs/031
> @@ -39,7 +39,7 @@ rm -f $seqres.full
>  . ./common/filter
>  
>  # link correct .out file
> -_link_out_file $seq.out $seqfull.out
> +_link_out_file
>  
>  _check_repair()
>  {
> diff --git a/tests/xfs/033 b/tests/xfs/033
> index 576d437..dab111a 100755
> --- a/tests/xfs/033
> +++ b/tests/xfs/033
> @@ -84,11 +84,11 @@ _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
>  	_scratch_mkfs_xfs -isize=512 | _filter_mkfs >/dev/null 2>&1
>  
>  # link correct .out file
> +FEATURES=$(_get_os_name)
>  if [ $_fs_has_crcs -eq 1 ]; then
> -	_link_out_file $seq.crc.out $seqfull.out
> -else
> -	_link_out_file $seq.out $seqfull.out
> +	FEATURES=$FEATURES,crc
>  fi
> +_link_out_file_named $seqfull.out "$FEATURES"
>  
>  `xfs_db -r -c sb -c p $SCRATCH_DEV | grep 'ino = ' | \
>  	sed -e 's/ //g' -e 's/^/export /'`
> diff --git a/tests/xfs/033.cfg b/tests/xfs/033.cfg
> new file mode 100644
> index 0000000..88e90e5
> --- /dev/null
> +++ b/tests/xfs/033.cfg
> @@ -0,0 +1,3 @@
> +irix: irix
> +linux,crc: crc.linux
> +linux: linux
> diff --git a/tests/xfs/033.crc.out.linux b/tests/xfs/033.out.crc.linux
> similarity index 100%
> rename from tests/xfs/033.crc.out.linux
> rename to tests/xfs/033.out.crc.linux
> diff --git a/tests/xfs/035 b/tests/xfs/035
> index 70eac93..25f2f69 100755
> --- a/tests/xfs/035
> +++ b/tests/xfs/035
> @@ -37,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  . ./common/dump
>  
>  # link correct .out file
> -_link_out_file $seq.out $seqfull.out
> +_link_out_file
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/036 b/tests/xfs/036
> index 32b8c87..280d036 100755
> --- a/tests/xfs/036
> +++ b/tests/xfs/036
> @@ -37,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  . ./common/dump
>  
>  # link correct .out file
> -_link_out_file $seq.out $seqfull.out
> +_link_out_file
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/039 b/tests/xfs/039
> index 9747923..2f765b8 100755
> --- a/tests/xfs/039
> +++ b/tests/xfs/039
> @@ -37,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  . ./common/dump
>  
>  # link correct .out file
> -_link_out_file $seq.out $seqfull.out
> +_link_out_file
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/043 b/tests/xfs/043
> index 55a5225..59eeff6 100755
> --- a/tests/xfs/043
> +++ b/tests/xfs/043
> @@ -39,7 +39,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  . ./common/dump
>  
>  # link correct .out file
> -_link_out_file $seq.out $seqfull.out
> +_link_out_file
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/055 b/tests/xfs/055
> index cc747d3..920ba28 100755
> --- a/tests/xfs/055
> +++ b/tests/xfs/055
> @@ -37,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  . ./common/dump
>  
>  # link correct .out file
> -_link_out_file $seq.out $seqfull.out
> +_link_out_file
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/082 b/tests/xfs/082
> index fff1d6b..f1178fd 100755
> --- a/tests/xfs/082
> +++ b/tests/xfs/082
> @@ -55,7 +55,7 @@ _require_scratch
>  _require_v2log 
>  
>  # link correct .out file
> -_link_out_file $seq.op $seqfull.op
> +_link_out_file_named $seqfull.op $(_get_os_name)
>  
>  echo "*** init FS"
>  umount $SCRATCH_DEV >/dev/null 2>&1
> diff --git a/tests/xfs/146 b/tests/xfs/146
> index c6343f8..f6cd3f3 100755
> --- a/tests/xfs/146
> +++ b/tests/xfs/146
> @@ -48,7 +48,7 @@ _supported_fs xfs
>  _supported_os Linux IRIX
>  
>  # link correct .out file
> -_link_out_file $seq.out $seqfull.out
> +_link_out_file
>  
>  _require_scratch
>  _scratch_mkfs_xfs >/dev/null 2>&1
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
