From: Andreas Dilger <adilger@sun.com>
Subject: Re: [E2FSPROGS, RFC] mke2fs: New bitmap and inode table allocation	for
 FLEX_BG
Date: Wed, 23 Apr 2008 15:01:56 -0600
Message-ID: <20080423210156.GB3095@webber.adilger.int>
References: <1208868379-17580-1-git-send-email-tytso@mit.edu>
 <1208868379-17580-2-git-send-email-tytso@mit.edu>
 <1208868379-17580-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, "Jose R. Santos" <jrs@us.ibm.com>,
	Valerie Clement <valerie.clement@bull.net>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:37356 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbYDWVCO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 17:02:14 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3NL2EjS005604
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 14:02:14 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZS00801OAMX400@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 23 Apr 2008 14:02:14 -0700 (PDT)
In-reply-to: <1208868379-17580-3-git-send-email-tytso@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 22, 2008  08:46 -0400, Theodore Ts'o wrote:
> Change the way we allocate bitmaps and inode tables if the FLEX_BG
> feature is used at mke2fs time.  It places calculates a new offset for
> bitmaps and inode table base on the number of groups that the user
> wishes to pack together using the new "-G" option.  Creating a
> filesystem with 64 block groups in a flex group can be done by:
> 
> mke2fs -j -I 256 -O flex_bg -G 32 /dev/sdX
> 
> @@ -1638,6 +1654,19 @@ static void PRS(int argc, char *argv[])
>  
>  	if (inode_size == 0)
>  		inode_size = get_int_from_profile(fs_types, "inode_size", 0);
> +	if (!flex_bg_size && (fs_param.s_feature_incompat &
> +			      EXT4_FEATURE_INCOMPAT_FLEX_BG))
> +		flex_bg_size = get_int_from_profile(fs_types, "flex_bg_size",8);
> +	if (flex_bg_size) {
> +		if (!(fs_param.s_feature_incompat &
> +		      EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
> +			com_err(program_name, 0,
> +				_("Flex_bg feature not enabled, so "
> +				  "flex_bg size may not be specified"));
> +			exit(1);
> +		}
> +		fs_param.s_log_groups_per_flex = int_log2(flex_bg_size);
> +	}

Should specifying "-G" enable FLEX_BG, like specifying "-j" or "-J size"
will enable HAS_JOURNAL instead of requiring that "-O has_journal" needs
to be explicitly given?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

