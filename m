From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 14/23] ext4: teach ext4_statfs() to deal with clusters
 if bigalloc is enabled
Date: Fri, 8 Jul 2011 18:40:11 -0400
Message-ID: <20110708224011.GG3331@thunk.org>
References: <1309970166-11770-1-git-send-email-tytso@mit.edu>
 <1309970166-11770-15-git-send-email-tytso@mit.edu>
 <4C67AF4F-BA01-4396-B78F-E13264EEE617@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49616 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab1GHWkP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jul 2011 18:40:15 -0400
Content-Disposition: inline
In-Reply-To: <4C67AF4F-BA01-4396-B78F-E13264EEE617@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 06, 2011 at 04:58:13PM -0600, Andreas Dilger wrote:
> > 
> > 	if (test_opt(sb, MINIX_DF)) {
> 
> Should we change this check to unlikely()?

It's unrelated to this commit, so it should probably separated out to
a different commit.  It's not clear to me that statfs() is a common
enough code path that it would really matter, though.

       	    	      	       	      	      - Ted
