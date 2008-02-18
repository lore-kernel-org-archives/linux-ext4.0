From: Andreas Dilger <adilger@sun.com>
Subject: Re: [2.6 patch] fs/jbd/journal.c: cleanups
Date: Mon, 18 Feb 2008 00:04:39 -0700
Message-ID: <20080218070439.GG3029@webber.adilger.int>
References: <20080217081935.GN3848@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: sct@redhat.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:52426 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYBRHEn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Feb 2008 02:04:43 -0500
In-reply-to: <20080217081935.GN3848@cs181133002.pp.htv.fi>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 17, 2008  10:19 +0200, Adrian Bunk wrote:
> This patch contains the following cleanups:
> - make the following needlessly global function static:
>   - journal_check_used_features()
> - remove the following unused EXPORT_SYMBOL's:
>   - journal_set_features
>   - journal_update_superblock

Nack.  I don't object to un-exporting journal_update_superblock(), because
that is pretty internal, but the other functions are intended specifically
for use by code outside of JBD.  For example, the journal checksum patch for
ext3/4 uses journal_set_features() to turn on features in the JBD superblock.

Similarly, for 64-bit support in ext4 uses journal_set_features() to set
a 64-bit feature flag in the journal superblock.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
