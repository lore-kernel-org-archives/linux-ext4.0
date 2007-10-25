From: Jan Kara <jack@suse.cz>
Subject: Re: + ext3-change-the-default-behaviour-on-error.patch added to -mm tree
Date: Thu, 25 Oct 2007 23:52:08 +0200
Message-ID: <20071025215208.GA23395@atrey.karlin.mff.cuni.cz>
References: <200710252133.l9PLXSVq025088@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: aneesh.kumar@linux.vnet.ibm.com, cebbert@redhat.com,
	davej@codemonkey.org.uk, jack@ucw.cz, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:57970 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbXJYVwK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2007 17:52:10 -0400
Content-Disposition: inline
In-Reply-To: <200710252133.l9PLXSVq025088@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> 
> The patch titled
>      ext3: change the default behaviour on error
> has been added to the -mm tree.  Its filename is
>      ext3-change-the-default-behaviour-on-error.patch
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: ext3: change the default behaviour on error
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> ext3 file system was by default ignoring errors and continuing.  This is
> not a good default as continuing on error could lead to file system
> corruption.  Change the default to mark the file system readonly.  Debian
> and ubuntu already does this as the default in their fstab.
  The change is fine as such but looking at it I just wonder
whether it would not make sence to write in /proc/mounts options
corresponding to the real state of mount options and not what we
guess user has specified... Or does anybody see a sane usecase where
userspace would rather want to see the current output? ... maybe
when user wants to inspect /proc/mounts by himself.

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Cc: <linux-ext4@vger.kernel.org>
> Cc: Eric Sandeen <sandeen@redhat.com>
> Cc: Jan Kara <jack@ucw.cz>
> Cc: Dave Jones <davej@codemonkey.org.uk>
> Cc: Chuck Ebbert <cebbert@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ext3/super.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff -puN fs/ext3/super.c~ext3-change-the-default-behaviour-on-error fs/ext3/super.c
> --- a/fs/ext3/super.c~ext3-change-the-default-behaviour-on-error
> +++ a/fs/ext3/super.c
> @@ -575,16 +575,16 @@ static int ext3_show_options(struct seq_
>  	    le16_to_cpu(es->s_def_resgid) != EXT3_DEF_RESGID) {
>  		seq_printf(seq, ",resgid=%u", sbi->s_resgid);
>  	}
> -	if (test_opt(sb, ERRORS_CONT)) {
> +	if (test_opt(sb, ERRORS_RO)) {
>  		int def_errors = le16_to_cpu(es->s_errors);
>  
>  		if (def_errors == EXT3_ERRORS_PANIC ||
> -		    def_errors == EXT3_ERRORS_RO) {
> -			seq_puts(seq, ",errors=continue");
> +		    def_errors == EXT3_ERRORS_CONTINUE) {
> +			seq_puts(seq, ",errors=remount-ro");
>  		}
>  	}
> -	if (test_opt(sb, ERRORS_RO))
> -		seq_puts(seq, ",errors=remount-ro");
> +	if (test_opt(sb, ERRORS_CONT))
> +		seq_puts(seq, ",errors=continue");
>  	if (test_opt(sb, ERRORS_PANIC))
>  		seq_puts(seq, ",errors=panic");
>  	if (test_opt(sb, NO_UID32))
> @@ -1559,10 +1559,10 @@ static int ext3_fill_super (struct super
>  
>  	if (le16_to_cpu(sbi->s_es->s_errors) == EXT3_ERRORS_PANIC)
>  		set_opt(sbi->s_mount_opt, ERRORS_PANIC);
> -	else if (le16_to_cpu(sbi->s_es->s_errors) == EXT3_ERRORS_RO)
> -		set_opt(sbi->s_mount_opt, ERRORS_RO);
> -	else
> +	else if (le16_to_cpu(sbi->s_es->s_errors) == EXT3_ERRORS_CONTINUE)
>  		set_opt(sbi->s_mount_opt, ERRORS_CONT);
> +	else
> +		set_opt(sbi->s_mount_opt, ERRORS_RO);
>  
>  	sbi->s_resuid = le16_to_cpu(es->s_def_resuid);
>  	sbi->s_resgid = le16_to_cpu(es->s_def_resgid);
> _
> 
> Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are
> 
> ext2-return-after-ext2_error-in-case-of-failures.patch
> ext2-change-the-default-behaviour-on-error.patch
> ext4-return-after-ext4_error-in-case-of-failures.patch
> ext3-return-after-ext3_error-in-case-of-failures.patch
> ext3-change-the-default-behaviour-on-error.patch
> ext2-fix-the-max-file-size-for-ext2-file-system.patch
> ext3-fix-the-max-file-size-for-ext3-file-system.patch

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
