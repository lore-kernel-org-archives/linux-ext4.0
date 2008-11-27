From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC 1/2] ext4 resize: Mark the added group with
	EXT4_BG_INODE_ZEROED flag
Date: Thu, 27 Nov 2008 16:09:44 -0700
Message-ID: <20081127230944.GO3186@webber.adilger.int>
References: <20081121102309.182113793@bull.net>
 <20081121102309.507553245@bull.net> <20081127045047.GF14101@mit.edu>
 <18734.26807.381726.82414@frecb006361.adech.frec.bull.fr>
 <20081127223511.GA10909@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Solofo.Ramangalahy@bull.net, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:50760 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbYK0XJ5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Nov 2008 18:09:57 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mARN9tpc005817
	for <linux-ext4@vger.kernel.org>; Thu, 27 Nov 2008 15:09:55 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KB000201LFQA800@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 27 Nov 2008 15:09:55 -0800 (PST)
In-reply-to: <20081127223511.GA10909@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 27, 2008  17:35 -0500, Theodore Ts'o wrote:
> Unfortunately, we've been shipping mke2fs in e2fsprogs that sets the
> EXT4_BG_INODE_ZERO for newly created filesystem, and if the
> lazy_itable_init configuration parameter is set, it doesn't initialize
> the inode table and leaves bg_flags set to EXT2_BG_INODE_UNINIT and
> EXT2_BG_BLOCK_UNINIT. 
> 
> Distributions are already shipping e2fsprogs with this, and there are
> ext4 filesystems out there in the wild, so it is indeed probably way
> too late to change this.

I suppose it would be possible to add a new flag and deprecate the old
INODE_ZERO usage after a couple of years.  Until we start doing anything
with the kernel we've done everything with mke2fs to zero the inode table,
so that would be a reasonable assumption for the kernel to make.

I agree that having the flag with the opposite meaning would have been
better, but hindsight is 20-20.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

