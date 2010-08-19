From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: buggy EOFBLOCKS_FL handling
Date: Wed, 18 Aug 2010 23:13:00 -0600
Message-ID: <FB932B24-52F7-4C97-9BF6-58A78DFA5FBF@dilger.ca>
References: <E1OlvNi-00063m-09@tytso-glaptop>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:40989 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab0HSFNB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Aug 2010 01:13:01 -0400
In-Reply-To: <E1OlvNi-00063m-09@tytso-glaptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-18, at 21:01, Theodore Ts'o wrote:
> It looks like how we handle the EOFBLOCKS_FL flag is buggy.  This means
> that when we fallocate a file to have 128k using the KEEP_SIZE flag, and
> then write exactly 128k, the EOFBLOCKS_FL isn't getting cleared
> correctly.
> 
> This is bad, because e2fsck will then complain about that inode.  If you
> have a large number of inodes that are written with fallocate using
> KEEP_SIZE, and then fill them up to their expected size, e2fsck will
> potentially complain about a _huge_ number of inodes.

Probably e2fsck also shouldn't complain if EOFBLOCKS_FL is set, but the i_size is within the range implied by i_blocks.

Cheers, Andreas





