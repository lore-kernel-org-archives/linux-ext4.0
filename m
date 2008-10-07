From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] ext4: Rename ext4dev to ext4
Date: Tue, 07 Oct 2008 05:07:52 -0600
Message-ID: <20081007110752.GV2009@webber.adilger.int>
References: <1223356130-22006-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:65113 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYJGLIG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2008 07:08:06 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m97B84SV014780
	for <linux-ext4@vger.kernel.org>; Tue, 7 Oct 2008 04:08:05 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K8D00G01833K600@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 07 Oct 2008 04:08:04 -0700 (PDT)
In-reply-to: <1223356130-22006-1-git-send-email-tytso@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Oct 07, 2008  01:08 -0400, Theodore Ts'o wrote:
> +	  This is the next generation of the ext3 filesystem.
>  
>  	  Unlike the change from ext2 filesystem to ext3 filesystem,
> +	  the on-disk format of ext4 is not backwardscompatible with

Actually, it is not _forwards_ compatible with ext2/ext3 drivers, but
it is most certainly _backwards_ compatible with older ext3 filesystems.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

