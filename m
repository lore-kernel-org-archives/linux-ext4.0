From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC][PATCH 2/3] ext4 online defrag (ver 0.7)
Date: Wed, 05 Mar 2008 22:25:52 -0700
Message-ID: <20080306052552.GL3616@webber.adilger.int>
References: <200803060001.AA00324@TNESG9526.rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: tytso@mit.edu, cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:63525 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760477AbYCFF0e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Mar 2008 00:26:34 -0500
In-reply-to: <200803060001.AA00324@TNESG9526.rs.jp.nec.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 06, 2008  09:01 +0900, Akira Fujita wrote:
> Change the name of functions (ext4_ext_xxx -> ext4_defrag_xxx)
> and some cleanups.
>
> -int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
> -			ext4_lblk_t num, ext_prepare_callback func,
> -			void *cbdata)
> -{

We were just going to be using this function for the FIEMAP support.
I think there are several other functions which are not specific
to defrag, so they shouldn't be renamed to be defrag specific.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

