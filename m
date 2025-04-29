Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D65246786
	for <linux-ext4@vger.kernel.org>; Tue, 29 Apr 2025 23:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745971184; cv=none; b=J0OGeZ8m5u/RJw2XwpDJiQ9loO7ui4SB5Kln7DjQ9RyyrbrFGh5ptQMQKZWJ9IDlEU+KTCw0bnSaIQMHMzqrltpz+Nj5UlFiX976B6l8w0PWPEtlyhtxNF7aju9hm8TyIIDm0taaBeV8/3+NOnQknTdbNlMfwGnnTItUwCtfyqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745971184; c=relaxed/simple;
	bh=zYPtI3bHKiFeKZGAqAvYP78ecZbSnxjIXDnbtWFJEDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VxtyF71ZUCNkaoVDsd+cAAj8JJbEnUOuJWmLyedQCwpfLAQ9mNOratbh6bgoU57EA/Ly9Fgm1x2e0JKRnPAi8dyA0Tuju/RnzsbJgAh9ZCm+Ckyrx02meRXHl5OqC+FpSOvdosCzFrF0HYaEjumyZu0qiploE8rbwU1PS8f+LM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=QK6NHCjD; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="QK6NHCjD"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2295d78b433so72245435ad.2
        for <linux-ext4@vger.kernel.org>; Tue, 29 Apr 2025 16:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1745971181; x=1746575981; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YVw92qdDBpSeLoYhqTmkn3e/ekyDNEnwi+AVc5uI+WE=;
        b=QK6NHCjDhStnGLgzRBbAyQTE8qrCPrUFIQK7pniEq+JR9DwHxRrPrffCGJBUtMt6DZ
         9/sECpe6dQqK5X29j69YcAXT3KI7FaTmsNPzfxDE69FHZq8+YapYtsLHSD0e0CTezjSF
         HYWHexF1BMulVF8YbVbIao9XnR/IxcMZoOVW3nEBjyfJS3zTClj8QjZezY8SbHIZE+Y0
         /Ts5V3KbVLcMrFZ04reW+3WUUwi442J326XnfP7VL8AluQ/oKpKiJorKdk4x/LGNgvQp
         nl1n2j16tpy4FJ43rWI41IH8bH8NC1fCXfg4vk5u4nFmemz9CH+sPZp0/Xq36iCq7JMY
         MvnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745971181; x=1746575981;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YVw92qdDBpSeLoYhqTmkn3e/ekyDNEnwi+AVc5uI+WE=;
        b=DJHnEP+CCVn2zb+ZcSbhUUMxR3WAFwmQ8gDfJCHVHL/2QPwIQDHZsJxIOAn0yl/cwE
         gbVt8iv04VBUeeqFnVqR/gPu0FlHx+3kTR1hOI+99jTnRG1FmhmdMG5ZToiWiS/NcTwB
         VW8eDa2x3puQEZfndo4oJIegGDXrEOqw2+w+T+8R+JgqjiKqUMN8wshkiNFKGKJTGjd7
         5ltuH5IVkhylj6AW9CCS4Ec2Q+rnOVUu7OyMXfsKfnnYfq50sSQBec5nPIM/OsQSH/Qu
         QPvFjQEjRHhnO4z1OufRT/aqgjFPCR/EWz4qXzlsDdpvQNFCCdxHNA9gFQH45gPheMox
         rzlw==
X-Forwarded-Encrypted: i=1; AJvYcCUSD32KpJyS8M/dVeSx3EOtJQsG492YU9yZWBT1Z46H2dNqx7Av875pga15poVEvbvVx2yakH0/Vsid@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ5r/Zyn9S/IaPKGLYXMJNwoHgi/WVgRrpY8tYxFIsZpjy83Hg
	HqkqEbd6xcc4CYZt3vc1KIrX56uxZakAfxbKw4/AKp//dTvSBt8QCaN5ybkWTrU=
X-Gm-Gg: ASbGncuG3uNaO5UmrdFuFR/aoSB/vK8egL+MoDJXC7csNSG4cT6ej8xnQo9v67Ce8FE
	I4tWFngYnv2kYcMW70lgTlTEvNeSKZG0w5QyC069DEI6nzoasSQSDi7Imx/k3sqrQ3rT80Ctt5J
	N7hJAKBIaxfXSZpGdbJT+wI6kgWSg0NUyo2Fk9m8cGgW4u9Bhq5WtSz7OB9PH1XehWEvm59EwSi
	D+rQwuA/xwFf2BVAlQP8egJOYEzS8QgUbvFEpcoKUl6m2DwTRl3KoX8SAtsV6DfOVF3MqQC42R+
	SZDHqXq9hxlo5nxeEZQMHA5xoyhRolJ6WG1pYKjzCfWFYR/dLQtlw5Gc1qZzr69ITP0xU6VVMJf
	0PvUX32YEwpzGZg==
X-Google-Smtp-Source: AGHT+IHsH/8X6UP9tikizlY4psmrzOQStlrdrC7h0vwhF7x6aWzUfoYr97UdhdbC1d7CvYyLD0W2VQ==
X-Received: by 2002:a17:902:ccc3:b0:215:9bc2:42ec with SMTP id d9443c01a7336-22df5838ce0mr5785565ad.47.1745971180608;
        Tue, 29 Apr 2025 16:59:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4dbbf8dsm109681655ad.65.2025.04.29.16.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 16:59:40 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1u9urR-0000000F0ny-2iHa;
	Wed, 30 Apr 2025 09:59:37 +1000
Date: Wed, 30 Apr 2025 09:59:37 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org
Subject: Re: [PATCH v2 2/2] check: Replace exit with _exit in check
Message-ID: <aBFn6YL3vHpb09yB@dread.disaster.area>
References: <cover.1745908976.git.nirjhar.roy.lists@gmail.com>
 <de352e171003ab91fab2328652f8b1990a2d8cce.1745908976.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de352e171003ab91fab2328652f8b1990a2d8cce.1745908976.git.nirjhar.roy.lists@gmail.com>

On Tue, Apr 29, 2025 at 06:52:54AM +0000, Nirjhar Roy (IBM) wrote:
> Some of the "status=<val>;exit" and "exit <val>" were not
> replace with _exit <val>. Doing it now.
> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  check | 44 ++++++++++++++++++--------------------------
>  1 file changed, 18 insertions(+), 26 deletions(-)
> 
> diff --git a/check b/check
> index 9451c350..99d38492 100755
> --- a/check
> +++ b/check
> @@ -47,6 +47,7 @@ export DIFF_LENGTH=${DIFF_LENGTH:=10}
>  # by default don't output timestamps
>  timestamp=${TIMESTAMP:=false}
>  
> +. common/exit
>  rm -f $tmp.list $tmp.tmp $tmp.grep $here/$iam.out $tmp.report.* $tmp.arglist
>  
>  SRC_GROUPS="generic"
> @@ -121,7 +122,7 @@ examples:
>   check -X .exclude -g auto
>   check -E ~/.xfstests.exclude
>  '
> -	    exit 1
> +	    _exit 1
>  }
>  
>  get_sub_group_list()
> @@ -231,7 +232,7 @@ _prepare_test_list()
>  			list=$(get_group_list $group)
>  			if [ -z "$list" ]; then
>  				echo "Group \"$group\" is empty or not defined?"
> -				exit 1
> +				_exit 1
>  			fi
>  
>  			for t in $list; do

This is now:

	_fatal "Group \"$group\" is empty or not defined?"

> @@ -316,14 +317,14 @@ while [ $# -gt 0 ]; do
>  	-r)
>  		if $exact_order; then
>  			echo "Cannot specify -r and --exact-order."
> -			exit 1
> +			_exit 1
>  		fi
>  		randomize=true
>  		;;
>  	--exact-order)
>  		if $randomize; then
>  			echo "Cannnot specify --exact-order and -r."
> -			exit 1
> +			_exit 1
>  		fi
>  		exact_order=true
>  		;;

Same.

> @@ -361,7 +362,7 @@ done
>  # after processing args, overlay needs FSTYP set before sourcing common/config
>  if ! . ./common/rc; then
>  	echo "check: failed to source common/rc"
> -	exit 1
> +	_exit 1
>  fi
>  
>  init_rc

Same.

> @@ -373,8 +374,7 @@ if [ -n "$SOAK_DURATION" ]; then
>  		sed -e 's/^\([.0-9]*\)\([a-z]\)*/\1 \2/g' | \
>  		$AWK_PROG -f $here/src/soak_duration.awk)"
>  	if [ $? -ne 0 ]; then
> -		status=1
> -		exit 1
> +		_exit 1
>  	fi
>  fi
>  
> @@ -385,8 +385,7 @@ if [ -n "$FUZZ_REWRITE_DURATION" ]; then
>  		sed -e 's/^\([.0-9]*\)\([a-z]\)*/\1 \2/g' | \
>  		$AWK_PROG -f $here/src/soak_duration.awk)"
>  	if [ $? -ne 0 ]; then
> -		status=1
> -		exit 1
> +		_exit 1
>  	fi
>  fi
>  
> @@ -404,8 +403,7 @@ if $have_test_arg; then
>  	while [ $# -gt 0 ]; do
>  		case "$1" in
>  		-*)	echo "Arguments before tests, please!"
> -			status=1
> -			exit $status
> +			_exit 1

_fatal

>  			;;
>  		*)	# Expand test pattern (e.g. xfs/???, *fs/001)
>  			list=$(cd $SRC_DIR; echo $1)
> @@ -438,7 +436,7 @@ fi
>  if [ `id -u` -ne 0 ]
>  then
>      echo "check: QA must be run as root"
> -    exit 1
> +    _exit 1
>  fi

Same

>  
>  _wipe_counters()
> @@ -721,9 +719,9 @@ _prepare_test_list
>  fstests_start_time="$(date +"%F %T")"
>  
>  if $OPTIONS_HAVE_SECTIONS; then
> -	trap "_summary; exit \$status" 0 1 2 3 15
> +	trap "_summary; _exit" 0 1 2 3 15
>  else
> -	trap "_wrapup; exit \$status" 0 1 2 3 15
> +	trap "_wrapup; _exit" 0 1 2 3 15
>  fi

Please add a comment explaining that _exit will capture $status
that has been previously set as the exit value.

Realistically, though, I think 'exit $status' is much better here
because it clearly documents that we are capturing $status as the
exit value from the trap rather than having to add a comment to make
it clear that $status is the exit value of the trap...

>  function run_section()
> @@ -767,8 +765,7 @@ function run_section()
>  	mkdir -p $RESULT_BASE
>  	if [ ! -d $RESULT_BASE ]; then
>  		echo "failed to create results directory $RESULT_BASE"
> -		status=1
> -		exit
> +		_exit 1
>  	fi

_fatal

>  	if $OPTIONS_HAVE_SECTIONS; then
> @@ -784,8 +781,7 @@ function run_section()
>  			echo "our local _test_mkfs routine ..."
>  			cat $tmp.err
>  			echo "check: failed to mkfs \$TEST_DEV using specified options"
> -			status=1
> -			exit
> +			_exit 1
>  		fi
>  		# Previous FSTYP derived from TEST_DEV could be changed, source
>  		# common/rc again with correct FSTYP to get FSTYP specific configs,
> @@ -829,8 +825,7 @@ function run_section()
>  	      echo "our local _scratch_mkfs routine ..."
>  	      cat $tmp.err
>  	      echo "check: failed to mkfs \$SCRATCH_DEV using specified options"
> -	      status=1
> -	      exit
> +	      _exit 1
>  	  fi
>  
>  	  # call the overridden mount - make sure the FS mounts with
> @@ -840,8 +835,7 @@ function run_section()
>  	      echo "our local mount routine ..."
>  	      cat $tmp.err
>  	      echo "check: failed to mount \$SCRATCH_DEV using specified options"
> -	      status=1
> -	      exit
> +	      _exit 1
>  	  else
>  	      _scratch_unmount
>  	  fi

Same for all these.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
