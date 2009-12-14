From: Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH RHEL6 4/4] ext4: Support for 64-bit quota format
Date: Mon, 14 Dec 2009 15:22:42 +0100
Message-ID: <4B264A32.4070904@redhat.com>
References: <20091214141123.439793308@dhcp-0-151.brq.redhat.com> <20091214141155.632491131@dhcp-0-151.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757382AbZLNOWr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2009 09:22:47 -0500
In-Reply-To: <20091214141155.632491131@dhcp-0-151.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Please disregard that email. I just made a "quilt mail" mistake.

Sorry for the noise,
Jerome

On 12/14/2009 03:11 PM, jmarchan@redhat.com wrote:
> Bugzilla:
> https://bugzilla.redhat.com/show_bug.cgi?id=546311
> 
> Description:
> Add support for new 64-bit quota format. It is enough to add proper
> mount options handling. The rest is done by the generic code.
> 
> CC: tytso@mit.edu
> CC: linux-ext4@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/super.c |   30 ++++++++++++++++++++++++------
>  1 file changed, 24 insertions(+), 6 deletions(-)
> 
> Index: rhel6/fs/ext4/super.c
> ===================================================================
> --- rhel6.orig/fs/ext4/super.c
> +++ rhel6/fs/ext4/super.c
> @@ -743,9 +743,22 @@ static inline void ext4_show_quota_optio
>  #if defined(CONFIG_QUOTA)
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>  
> -	if (sbi->s_jquota_fmt)
> -		seq_printf(seq, ",jqfmt=%s",
> -		(sbi->s_jquota_fmt == QFMT_VFS_OLD) ? "vfsold" : "vfsv0");
> +	if (sbi->s_jquota_fmt) {
> +		char *fmtname = "";
> +
> +		switch (sbi->s_jquota_fmt) {
> +		case QFMT_VFS_OLD:
> +			fmtname = "vfsold";
> +			break;
> +		case QFMT_VFS_V0:
> +			fmtname = "vfsv0";
> +			break;
> +		case QFMT_VFS_V1:
> +			fmtname = "vfsv1";
> +			break;
> +		}
> +		seq_printf(seq, ",jqfmt=%s", fmtname);
> +	}
>  
>  	if (sbi->s_qf_names[USRQUOTA])
>  		seq_printf(seq, ",usrjquota=%s", sbi->s_qf_names[USRQUOTA]);
> @@ -1052,9 +1065,9 @@ enum {
>  	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
>  	Opt_data_err_abort, Opt_data_err_ignore, Opt_mb_history_length,
>  	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
> -	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
> -	Opt_ignore, Opt_barrier, Opt_nobarrier, Opt_err, Opt_resize,
> -	Opt_usrquota, Opt_grpquota, Opt_i_version,
> +	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
> +	Opt_noquota, Opt_ignore, Opt_barrier, Opt_nobarrier, Opt_err,
> +	Opt_resize, Opt_usrquota, Opt_grpquota, Opt_i_version,
>  	Opt_stripe, Opt_delalloc, Opt_nodelalloc,
>  	Opt_block_validity, Opt_noblock_validity,
>  	Opt_inode_readahead_blks, Opt_journal_ioprio
> @@ -1104,6 +1117,7 @@ static const match_table_t tokens = {
>  	{Opt_grpjquota, "grpjquota=%s"},
>  	{Opt_jqfmt_vfsold, "jqfmt=vfsold"},
>  	{Opt_jqfmt_vfsv0, "jqfmt=vfsv0"},
> +	{Opt_jqfmt_vfsv1, "jqfmt=vfsv1"},
>  	{Opt_grpquota, "grpquota"},
>  	{Opt_noquota, "noquota"},
>  	{Opt_quota, "quota"},
> @@ -1411,6 +1425,9 @@ clear_qf_name:
>  			goto set_qf_format;
>  		case Opt_jqfmt_vfsv0:
>  			qfmt = QFMT_VFS_V0;
> +			goto set_qf_format;
> +		case Opt_jqfmt_vfsv1:
> +			qfmt = QFMT_VFS_V1;
>  set_qf_format:
>  			if (sb_any_quota_loaded(sb) &&
>  			    sbi->s_jquota_fmt != qfmt) {
> @@ -1453,6 +1470,7 @@ set_qf_format:
>  		case Opt_offgrpjquota:
>  		case Opt_jqfmt_vfsold:
>  		case Opt_jqfmt_vfsv0:
> +		case Opt_jqfmt_vfsv1:
>  			ext4_msg(sb, KERN_ERR,
>  				"journaled quota options not supported");
>  			break;
> 

