From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] tests: skip large filesystem tests on MacOS
Date: Fri, 22 May 2015 16:45:59 -0600
Message-ID: <F0EE3948-8478-49D4-BBBD-89FB96A27C4A@dilger.ca>
References: <1432334358-6035-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:36377 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946049AbbEVWqD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 May 2015 18:46:03 -0400
Received: by pdfh10 with SMTP id h10so29471892pdf.3
        for <linux-ext4@vger.kernel.org>; Fri, 22 May 2015 15:46:02 -0700 (PDT)
In-Reply-To: <1432334358-6035-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 22, 2015, at 4:39 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> 
> Skip tests that create large filesystem on MacOS, since HFS doesn't
> have sparse file support and this causes testing to be uninterruptible
> for minutes while mke2fs is writing to some large non-zero offset and
> filling up the test filesystem.  Since most testing is done on Linux
> this shouldn't cause a significant gap in testing coverage.
> 
> Tests skipped are d_dumpe2fs_group_only, m_bigjournal, m_hugefile,
> t_iexpand_full, t_iexpand_mcsum, and t_uninit_bg_rm.

This patch only applies on master, since these tests are mostly from Darrick's
patchbomb.  The other two patches can apply equally well to maint and master.

Cheers, Andreas

> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> ---
> tests/d_dumpe2fs_group_only/script |    6 ++++++
> tests/m_bigjournal/script          |    1 +
> tests/m_hugefile/script            |    6 ++++++
> tests/t_iexpand_full/script        |    6 ++++++
> tests/t_iexpand_mcsum/script       |    5 +++++
> tests/t_uninit_bg_rm/script        |    6 ++++++
> 6 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/tests/d_dumpe2fs_group_only/script b/tests/d_dumpe2fs_group_only/script
> index 127502f..50481f0 100644
> --- a/tests/d_dumpe2fs_group_only/script
> +++ b/tests/d_dumpe2fs_group_only/script
> @@ -1,3 +1,9 @@
> +if [ $(uname -s) = "Darwin" ]; then
> +	# creates a 4GB filesystem
> +	echo "$test_name: $DESCRIPTION: skipped for HFS+ (no sparse files)"
> +	return 0
> +fi
> +
> if test -x $DEBUGFS_EXE; then
> 
> FSCK_OPT=-fy
> diff --git a/tests/m_bigjournal/script b/tests/m_bigjournal/script
> index 576d99e..96ea082 100644
> --- a/tests/m_bigjournal/script
> +++ b/tests/m_bigjournal/script
> @@ -4,6 +4,7 @@ DUMPE2FS_IGNORE_80COL=1
> export DUMPE2FS_IGNORE_80COL
> MKE2FS_OPTS="-t ext4 -G 512 -N 1280 -J size=5000 -q -E lazy_journal_init,lazy_itable_init,nodiscard"
> if [ $(uname -s) = "Darwin" ]; then
> +	# creates a 44GB filesystem
> 	echo "$test_name: $DESCRIPTION: skipped for HFS+ (no sparse files)"
> 	return 0
> fi
> diff --git a/tests/m_hugefile/script b/tests/m_hugefile/script
> index 72af8b8..5619f64 100644
> --- a/tests/m_hugefile/script
> +++ b/tests/m_hugefile/script
> @@ -3,6 +3,12 @@ OUT=$test_name.log
> EXP=$test_dir/expect
> CONF=$TMPFILE.conf
> 
> +if [ $(uname -s) = "Darwin" ]; then
> +	# creates a 4TB filesystem
> +	echo "$test_name: $DESCRIPTION: skipped for HFS+ (no sparse files)"
> +	return 0
> +fi
> +
> #gzip -d < $EXP.gz > $EXP
> 
> cat > $CONF << ENDL
> diff --git a/tests/t_iexpand_full/script b/tests/t_iexpand_full/script
> index 779c66d..f8565a7 100644
> --- a/tests/t_iexpand_full/script
> +++ b/tests/t_iexpand_full/script
> @@ -1,5 +1,11 @@
> if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
> 
> +if [ $(uname -s) = "Darwin" ]; then
> +	# creates a 3GB filesystem
> +	echo "$test_name: $DESCRIPTION: skipped for HFS+ (no sparse files)"
> +	return 0
> +fi
> +
> FSCK_OPT=-fn
> OUT=$test_name.log
> EXP=$test_dir/expect
> diff --git a/tests/t_iexpand_mcsum/script b/tests/t_iexpand_mcsum/script
> index 3057dba..4b584d3 100644
> --- a/tests/t_iexpand_mcsum/script
> +++ b/tests/t_iexpand_mcsum/script
> @@ -1,4 +1,9 @@
> if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
> +if [ $(uname -s) = "Darwin" ]; then
> +	# creates a 3GB filesystem
> +	echo "$test_name: $DESCRIPTION: skipped for HFS+ (no sparse files)"
> +	return 0
> +fi
> 
> FSCK_OPT=-fn
> OUT=$test_name.log
> diff --git a/tests/t_uninit_bg_rm/script b/tests/t_uninit_bg_rm/script
> index cd397c5..308ef25 100644
> --- a/tests/t_uninit_bg_rm/script
> +++ b/tests/t_uninit_bg_rm/script
> @@ -3,6 +3,12 @@ OUT=$test_name.log
> FSCK_OPT=-yf
> EXP=$test_dir/expect
> 
> +if [ $(uname -s) = "Darwin" ]; then
> +	# creates a 10GB filesystem
> +	echo "$test_name: $DESCRIPTION: skipped for HFS+ (no sparse files)"
> +	return 0
> +fi
> +
> cp /dev/null $TMPFILE
> rm -f $OUT.new
> 
> -- 
> 1.7.3.4
> 


Cheers, Andreas





