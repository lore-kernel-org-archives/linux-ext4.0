From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 3/3] ext4: Use separate super_operations structure for
	no_journal filesystems
Date: Fri, 01 May 2009 04:42:53 -0600
Message-ID: <20090501104253.GC3209@webber.adilger.int>
References: <1241152637-11986-1-git-send-email-tytso@mit.edu>
 <1241152637-11986-2-git-send-email-tytso@mit.edu>
 <1241152637-11986-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63955 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbZEAKnS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 May 2009 06:43:18 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n41Ah5YO025933
	for <linux-ext4@vger.kernel.org>; Fri, 1 May 2009 03:43:18 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KIY00400OEBYM00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 01 May 2009 03:43:05 -0700 (PDT)
In-reply-to: <1241152637-11986-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 01, 2009  00:37 -0400, Theodore Ts'o wrote:
> @@ -3923,6 +3911,12 @@ static int __init init_ext4_fs(void)
> +	ext4_nojournal_sops = ext4_sops;
> +	ext4_nojournal_sops.write_super = ext4_write_super;
> +	ext4_nojournal_sops.sync_fs = 0;
> +	ext4_nojournal_sops.freeze_fs = 0;
> +	ext4_nojournal_sops.unfreeze_fs = 0;

I thought the general policy these days was to make a static const
ops struct so that it cannot be changed (correctly or incorrectly)?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

