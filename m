Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040D3299937;
	Sat,  9 May 2026 17:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778346337; cv=none; b=eTqNp8+GvmobEWehyuwvrgt4yJnb05nDhCGbuOWPVlMpx0uafCps2XDEY2WXq+9pP2wPjeOaTtPLKtKJln4/wg71mI7EV7niQ0Mmg+g6GdVAkhLaSdD5IYWn8ImWRVNBUW2WSTFROpwWQ2IJsQyKSrUBgXEVw2gXOn29944nLf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778346337; c=relaxed/simple;
	bh=fTjtKK93RaIn2Aq8wTAJ2irXQaQaK+oYRBKDVp1/12U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DI+2z64ZSsf5KYz56/hQHpWiefyI+T1gJakg2LcQAg+lgIvKnTqCcXtpSQX+pf5Z0IejjV7iCOzAIvUdux/86rEc9FNNgL5FHyPIfW4GcU+YdHRVpAIhfN3TxEIBm8g0kGhE+yJuLUSwQeDoKOPI7lTSpgAD43DIXR8Y5TeTzFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zggbia31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zggbia31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4BEC2BCB2;
	Sat,  9 May 2026 17:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778346336;
	bh=fTjtKK93RaIn2Aq8wTAJ2irXQaQaK+oYRBKDVp1/12U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zggbia31qAX0IFsNaMNsX4efLjrCiGTbRhJBoqV1DRJ3Kjbc0V176ieBSrYT5jLF2
	 agXKrgax4UEPCD9F13nKGDWpnCayKsfSF7Bdg3vil7YyetsoZXaD+Q6YKUMfeBdzCk
	 NcY0xJduI8WWH5wcU4aWVxUygmW03TakN4wSfRLeCQVbq0gve8jPmeASQ4FXLHz+SF
	 I5VdjiCkp+9YkDOmLMdN/ltOlwqJIACFSRWaQg9tqMBjKKLOp3ReI9ECNNKvAHPiu0
	 DrOWAuLA1jtwkmme2YGUMozwtv7OV4IIn45JBlnyrcMsK5qB3i9oks5jpFOhFd8irv
	 sfsFQbrn7Cq0g==
Date: Sun, 10 May 2026 01:05:27 +0800
From: Zorro Lang <zlang@kernel.org>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Cc: fstests@vger.kernel.org, adilger.kernel@dilger.ca, tytso@mit.edu, 
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/2] ext4/064 encryption + casefold feature combination
 WITHOUT dirdata
Message-ID: <af9o1mt0mE4RAOWj@zlang-mailbox>
Mail-Followup-To: Artem Blagodarenko <artem.blagodarenko@gmail.com>, 
	fstests@vger.kernel.org, adilger.kernel@dilger.ca, tytso@mit.edu, 
	linux-ext4@vger.kernel.org
References: <20260419185209.4526-1-ablagodarenko@ddn.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260419185209.4526-1-ablagodarenko@ddn.com>

On Sun, Apr 19, 2026 at 02:52:08PM -0400, Artem Blagodarenko wrote:
> From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> 
> This test verifies that files created in directories with both
> encryption and case-insensitive (casefold) attributes work correctly.
> See ext4/065 for the same test WITH dirdata feature enabled.
> 
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> ---
>  tests/ext4/064     | 154 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/ext4/064.out |  17 +++++
>  2 files changed, 171 insertions(+)
>  create mode 100755 tests/ext4/064
>  create mode 100644 tests/ext4/064.out
> 
> diff --git a/tests/ext4/064 b/tests/ext4/064
> new file mode 100755
> index 00000000..6ad865a9
> --- /dev/null
> +++ b/tests/ext4/064
> @@ -0,0 +1,154 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Copyright (c) 2026 The Lustre Collective.  All Rights Reserved.
> +# Author: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
> +#
> +# FS QA Test ext4/064
> +#
> +# Test ext4 encryption + casefold feature combination WITHOUT dirdata.
> +# This test verifies that files created in directories with both
> +# encryption and case-insensitive (casefold) attributes work correctly.
> +# See ext4/065 for the same test WITH dirdata feature enabled.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick encrypt casefold
> +
> +# get standard environment and checks
> +. ./common/filter
> +. ./common/encrypt
> +. ./common/casefold
> +. ./common/attr
> +
> +_exclude_fs ext2
> +_exclude_fs ext3
> +
> +_require_scratch_nocheck
> +_require_encrypted_casefold

Do you want to write a new helper names _require_encrypted_casefold? Or do you
mean _require_scratch_casefold at here?

CC ext4-list to get more review points.

Thanks,
Zorro

> +_require_command "$CHATTR_PROG" chattr
> +_require_command "$LSATTR_PROG" lsattr
> +_require_xfs_io_command "set_encpolicy"
> +_require_xfs_io_command "add_enckey"
> +
> +# Helper to add a v2 encryption key and set policy on a directory
> +_setup_encrypted_casefold_dir()
> +{
> +	local dir=$1
> +	local raw_key=$(_generate_raw_encryption_key)
> +	local keyspec=$(_add_enckey $SCRATCH_MNT "$raw_key" | awk '{print $NF}')
> +	_set_encpolicy $dir $keyspec
> +	_casefold_set_attr $dir
> +	echo $keyspec
> +}
> +
> +# Create a filesystem with both encrypt and casefold features
> +_scratch_mkfs -O encrypt,casefold &>>$seqres.full
> +_scratch_mount
> +
> +# Test 1: Create an encrypted + casefolded directory and verify lookups work
> +echo "Test 1: Basic encrypted casefold lookup"
> +mkdir $SCRATCH_MNT/test1
> +_setup_encrypted_casefold_dir $SCRATCH_MNT/test1 > /dev/null
> +
> +# Create file with lowercase, lookup with uppercase
> +echo "hello" > $SCRATCH_MNT/test1/testfile.txt
> +if [ -f "$SCRATCH_MNT/test1/TESTFILE.TXT" ]; then
> +	echo "Case-insensitive lookup works in encrypted dir"
> +else
> +	echo "FAIL: Case-insensitive lookup failed in encrypted dir"
> +fi
> +
> +# Verify the exact name on disk is preserved
> +if _casefold_check_exact_name "$SCRATCH_MNT/test1" "testfile.txt"; then
> +	echo "Original filename preserved"
> +else
> +	echo "FAIL: Original filename not preserved"
> +fi
> +
> +# Test 2: Create files with different case variations
> +echo "Test 2: Conflicting names in encrypted casefold dir"
> +mkdir $SCRATCH_MNT/test2
> +_setup_encrypted_casefold_dir $SCRATCH_MNT/test2 > /dev/null
> +
> +echo "first" > $SCRATCH_MNT/test2/MyFile.txt
> +# This should fail or overwrite since "MYFILE.TXT" is equivalent
> +echo "second" > $SCRATCH_MNT/test2/MYFILE.TXT 2>/dev/null
> +content=$(cat $SCRATCH_MNT/test2/myfile.txt)
> +echo "Content after writes: $content"
> +
> +# Test 3: Unicode normalization in encrypted casefold dir
> +echo "Test 3: Unicode in encrypted casefold dir"
> +mkdir $SCRATCH_MNT/test3
> +_setup_encrypted_casefold_dir $SCRATCH_MNT/test3 > /dev/null
> +
> +# Test with UTF-8 characters
> +fr_file1=$(echo -e "cafe\xcc\x81.txt")
> +fr_file2=$(echo -e "caf\xc3\xa9.txt")
> +echo "french" > "$SCRATCH_MNT/test3/$fr_file1"
> +if [ -f "$SCRATCH_MNT/test3/$fr_file2" ]; then
> +	echo "Unicode normalization works in encrypted dir"
> +else
> +	echo "FAIL: Unicode normalization failed in encrypted dir"
> +fi
> +
> +# Test 4: Directory operations in encrypted casefold dir
> +echo "Test 4: Directory operations in encrypted casefold dir"
> +mkdir $SCRATCH_MNT/test4
> +_setup_encrypted_casefold_dir $SCRATCH_MNT/test4 > /dev/null
> +
> +mkdir $SCRATCH_MNT/test4/SubDir
> +if [ -d "$SCRATCH_MNT/test4/SUBDIR" ]; then
> +	echo "Directory case-insensitive lookup works"
> +else
> +	echo "FAIL: Directory case-insensitive lookup failed"
> +fi
> +
> +# Test 5: Verify inheritance of casefold+encryption in subdirectories
> +echo "Test 5: Inheritance of attributes"
> +mkdir $SCRATCH_MNT/test5
> +_setup_encrypted_casefold_dir $SCRATCH_MNT/test5 > /dev/null
> +
> +mkdir $SCRATCH_MNT/test5/child
> +echo "data" > $SCRATCH_MNT/test5/child/file.txt
> +if [ -f "$SCRATCH_MNT/test5/CHILD/FILE.TXT" ]; then
> +	echo "Attributes inherited correctly"
> +else
> +	echo "FAIL: Attributes not inherited"
> +fi
> +
> +# Test 6: Remove and recreate with different case
> +echo "Test 6: Remove and recreate with different case"
> +mkdir $SCRATCH_MNT/test6
> +_setup_encrypted_casefold_dir $SCRATCH_MNT/test6 > /dev/null
> +
> +echo "original" > $SCRATCH_MNT/test6/RemoveMe.txt
> +rm $SCRATCH_MNT/test6/REMOVEME.TXT
> +echo "recreated" > $SCRATCH_MNT/test6/REMOVEME.TXT
> +if _casefold_check_exact_name "$SCRATCH_MNT/test6" "REMOVEME.TXT"; then
> +	echo "Recreated file has new case"
> +else
> +	echo "FAIL: Recreated file case incorrect"
> +fi
> +
> +# Test 7: Hard links in encrypted casefold dir
> +echo "Test 7: Hard links in encrypted casefold dir"
> +mkdir $SCRATCH_MNT/test7
> +_setup_encrypted_casefold_dir $SCRATCH_MNT/test7 > /dev/null
> +
> +echo "linkdata" > $SCRATCH_MNT/test7/original.txt
> +ln $SCRATCH_MNT/test7/original.txt $SCRATCH_MNT/test7/hardlink.txt
> +if [ -f "$SCRATCH_MNT/test7/HARDLINK.TXT" ]; then
> +	echo "Hard link case-insensitive lookup works"
> +else
> +	echo "FAIL: Hard link case-insensitive lookup failed"
> +fi
> +
> +# Cleanup and verify filesystem
> +_scratch_unmount
> +_check_scratch_fs
> +
> +echo "Encrypted casefold tests completed"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/ext4/064.out b/tests/ext4/064.out
> new file mode 100644
> index 00000000..0197e51e
> --- /dev/null
> +++ b/tests/ext4/064.out
> @@ -0,0 +1,17 @@
> +QA output created by 064
> +Test 1: Basic encrypted casefold lookup
> +Case-insensitive lookup works in encrypted dir
> +Original filename preserved
> +Test 2: Conflicting names in encrypted casefold dir
> +Content after writes: second
> +Test 3: Unicode in encrypted casefold dir
> +Unicode normalization works in encrypted dir
> +Test 4: Directory operations in encrypted casefold dir
> +Directory case-insensitive lookup works
> +Test 5: Inheritance of attributes
> +Attributes inherited correctly
> +Test 6: Remove and recreate with different case
> +Recreated file has new case
> +Test 7: Hard links in encrypted casefold dir
> +Hard link case-insensitive lookup works
> +Encrypted casefold tests completed
> -- 
> 2.43.5
> 
> 
