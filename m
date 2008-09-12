From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] Add extent conversion support to chattr
Date: Fri, 12 Sep 2008 03:17:13 -0600
Message-ID: <20080912091713.GY3086@webber.adilger.int>
References: <1221210249-26484-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:55165 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbYILJRZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Sep 2008 05:17:25 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8C9HGts006965
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 02:17:24 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7200101SDDQR00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 12 Sep 2008 02:17:16 -0700 (PDT)
In-reply-to: <1221210249-26484-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 12, 2008  14:34 +0530, Aneesh Kumar wrote:
> -		_("Usage: %s [-RVf] [-+=AacDdijsSu] [-v version] files...\n"),
> +		_("Usage: %s [-RVf] [-+=AacDdijsSue] [-v version] files...\n"),

Please keep options in alphabetical order.

> @@ -105,6 +105,7 @@ static const struct flags_char flags_array[] = {
>  	{ EXT2_UNRM_FL, 'u' },
>  	{ EXT2_NOTAIL_FL, 't' },
>  	{ EXT2_TOPDIR_FL, 'T' },
> +	{ EXT4_EXTENTS_FL, 'e'},

I'd also prefer to keep these in alphabetical order, which they almost are.

> @@ -199,7 +201,22 @@ static int change_attributes(const char * name)
>  	if (set) {
> +		if (extent_file && !(sf & EXT4_EXTENTS_FL)) {
> +			if (!silent)
> +				com_err(program_name, 0,
> +				_("Clearing extent flag not supported on %s"),
> +					name);
> +			return -1;
> +		}

Why not just try to set this flag and let the kernel decide what is
possible?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

