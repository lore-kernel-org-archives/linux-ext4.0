From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] new INCOMPAT flag for extended directory data
Date: Wed, 19 Aug 2009 19:40:58 -0600
Message-ID: <20090820014058.GY5931@webber.adilger.int>
References: <20090505202524.GL3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Pravin Shelar <Pravin.Shelar@sun.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:60606 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbZHTBk5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Aug 2009 21:40:57 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7K1ev7a012526
	for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2009 18:40:59 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KON00G00JBXCZ00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Wed,
 19 Aug 2009 18:40:57 -0700 (PDT)
In-reply-to: <20090505202524.GL3209@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 05, 2009  14:25 -0600, Andreas Dilger wrote:
> we're looking to store some extended data in each directory entry
> for Lustre, to hold a 128-bit filesystem-unique file identifier
> in the dirent.  If we ever wanted to look at 64-bit or larger
> inode numbers we would need to do the same.
> 
> In order to detect the presence of this extra data in the dirent, we
> would want to use the high bits in d_type (say bits 0xf0).  This part
> of d_type could be a flag for the presence of 4 different types of
> data (which limits the number of different kinds of data).  The d_type
> would mask off the high bits in get_dtype() so as not to confuse filldir.

Ted,
could we at least reserve the INCOMPAT_DIRDATA flag to avoid conflicts:

#define EXT4_FEATURE_INCOMPAT_DIRDATA 0x1000

reserve the high 4 bits of d_type:

#define EXT4_DIRENT_LUFID 0x10	/* Lustre 128-bit unique file identifier */

0x20, 0x40, and 0x80 would be available for future expansion (e.g. high
32 bits of inode number).  If needed, type 0x80 can be extended by adding
a 1-byte subtype after the length byte, though I doubt this would be needed.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

