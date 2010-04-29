From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] Prevent creation of files larger than RLIMIT_FSIZE using fallocate
Date: Thu, 29 Apr 2010 03:23:03 -0600
Message-ID: <C2C810F4-3244-427B-A537-DDA443D2D1ED@sun.com>
References: <201004281854.49730.knikanth@suse.de> <4BD85F1F.7030100@suse.de> <201004291014.07194.knikanth@suse.de> <4BD9239D.6060907@suse.de>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Nikanth Karthikesan <knikanth@suse.de>,
	Nick Piggin <npiggin@suse.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Eelis <opensuse.org@contacts.eelis.net>
To: coly.li@suse.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet14.oracle.com ([141.146.126.236]:30951 "EHLO
	acsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758889Ab0D3RiB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Apr 2010 13:38:01 -0400
In-Reply-To: <4BD9239D.6060907@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-04-29, at 00:13, Coly Li wrote:
>> +		/*
>> +		 * Let individual file system decide if it supports
>> +		 * preallocation for directories or not.
>> +		 */
>> +		if (offset > inode->i_sb->s_maxbytes)
>> +			return -EFBIG;
> 
> For file systems support online-resize, like ext4 and ocfs2, should we also need a locking to protect inode->i_sb->s_mabytes ?

s_maxbytes is the maximum theoretical single file size, and has nothing to do with the size of the filesystem.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

