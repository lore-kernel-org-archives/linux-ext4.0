From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] block: Add Kconfig help which notes that ext4 needs
	CONFIG_LSF
Date: Thu, 08 Jan 2009 04:39:15 -0700
Message-ID: <20090108113915.GL13721@webber.adilger.int>
References: <1231262490-15594-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:63542 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbZAHLjS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Jan 2009 06:39:18 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n08BdHQI000208
	for <linux-ext4@vger.kernel.org>; Thu, 8 Jan 2009 03:39:17 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KD500H01HKQJE00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 08 Jan 2009 03:39:17 -0800 (PST)
In-reply-to: <1231262490-15594-1-git-send-email-tytso@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 06, 2009  12:21 -0500, Theodore Ts'o wrote:
> @@ -64,6 +64,12 @@ config LSF
> +	  The ext4 filesystem requires that this feature be enabled in
> +	  order to support filesystems that have the huge_file feature
> +	  enabled.    Otherwise, it will refuse to mount any filesystems
> +	  that use the huge_file feature, which is enabled by default
> +	  by mke2fs.ext4.

Wouldn't it make sense to just enable this by default if ext4 is enabled?

On a related note, I wonder if we need to re-examine the use of the COMPAT
flags in ext4.  We went from a usage of "kernel enables flag when feature
is used" (e.g. LARGE_FILE) to "admin must set flag in order to use feature"
(e.g HUGE_FILE).

The former system was recording the state of currently-used features in the
filesystem, and maximized portability of the filesystem if the feature
was NOT used.  The newer system makes a filesystem somewhat less portable
even if the feature is not being used at all (e.g. files > 2TB in size).

I wonder if we should split the s_feature_*compat fields in the superblock
to "present feature" and "allowed feature" so that e.g. HUGE_FILE count
be put into "allowed feature" and would only appear in "present feature"
if a file > 2TB in size arrives.  That ensures the filesystem remains
maximally compatible, while allowing the admin to select which features
are permissible.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

