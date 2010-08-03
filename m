From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Add mount options in superblock
Date: Tue, 3 Aug 2010 11:55:39 -0600
Message-ID: <C270D256-EC9B-4449-9CBA-4C7DD51D0B22@dilger.ca>
References: <1280718904-7590-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:32320 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757493Ab0HCRzc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Aug 2010 13:55:32 -0400
In-Reply-To: <1280718904-7590-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-01, at 21:15, Theodore Ts'o wrote:
> Allow mount options to be stored in the superblock.  Also add default
> mount option bits for nobarrier, block_validity, discard, and nodelalloc.

Don't we already store mount options in s_default_mount_opts?  It seems more efficient to store them as binary flags instead of as a string.

Cheers, Andreas





