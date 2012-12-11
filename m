From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: Add EXT4_ZERO_XATTR_VALUE to init inline data directly.
Date: Tue, 11 Dec 2012 03:33:33 -0500
Message-ID: <20121211083333.GA19937@thunk.org>
References: <1355207989-4823-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37944 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab2LKIdh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Dec 2012 03:33:37 -0500
Content-Disposition: inline
In-Reply-To: <1355207989-4823-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, applied with a somewhat edited commit description:

    ext4: zero out inline data using memset() instead of empty_zero_page
    
    Not all architectures (in particular, sparc64) have empty_zero_page.
    So instead of copying from empty_zero_page, use memset to clear the
    inline data by signalling to ext4_xattr_set_entry() via a magic
    pointer value, EXT4_ZERO_ATTR_VALUE, which is defined by casting -1 to
    a pointer.
    
    This fixes a build failure on sparc64, and the memset() should be more
    efficient than using memcpy() anyway.
    
    Signed-off-by: Tao Ma <boyu.mt@taobao.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
