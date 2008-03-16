From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] jbd2: Add commit time into the commit block
Date: Sun, 16 Mar 2008 09:23:31 +0800
Message-ID: <20080316012331.GY3542@webber.adilger.int>
References: <1205629144-25994-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:37059 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbYCPBYF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Mar 2008 21:24:05 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2G1O3JY010650
	for <linux-ext4@vger.kernel.org>; Sat, 15 Mar 2008 18:24:03 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JXS00F01UH4ST00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 15 Mar 2008 18:24:03 -0700 (PDT)
In-reply-to: <1205629144-25994-1-git-send-email-tytso@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 15, 2008  20:59 -0400, Theodore Ts'o wrote:
> Carlo Wood has demonstrated that it's possible to recover deleted
> files from the journal.  Something that will make this easier is if we
> can put the time of the commit into commit block.
> 
> @@ -170,6 +170,8 @@ struct commit_header {
>  	unsigned char   h_chksum_size;
>  	unsigned char 	h_padding[2];
>  	__be32 		h_chksum[JBD2_CHECKSUM_BYTES];
> +	__be32		h_commit_sec;
> +	__be32		h_commit_nsec;
>  };

We should probably use a 64-bit seconds field, after we just told
someone on #ext4 that it would work until at least 2242 :-).

struct commit_header {
	unsigned char   h_chksum_size;
	unsigned char 	h_padding[2];
	__be32 		h_chksum[JBD2_CHECKSUM_BYTES];
	__be64		h_commit_sec;
	__be32		h_commit_nsec;
};

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

