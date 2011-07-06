From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 18/23] ext4: Rename ext4_free_blks_{count,set}() to refer to clusters
Date: Wed, 6 Jul 2011 17:06:37 -0600
Message-ID: <BC2E91B2-7E48-47F4-B978-B90ACC7B0ADC@dilger.ca>
References: <1309970166-11770-1-git-send-email-tytso@mit.edu> <1309970166-11770-19-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:46907 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab1GFXGi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jul 2011 19:06:38 -0400
In-Reply-To: <1309970166-11770-19-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-06, at 10:36 AM, Theodore Ts'o wrote:
> The field bg_free_free_blocks_count_{lo,high} in the block group

s/free_free/free_/

> descriptor has been repurposed to hold the number of free clusters for
> bigalloc functions.  So rename the functions so it makes it easier to
> read and audit the block allocation and block freeing code.
> 
> Note: at this point in bigalloc development we doesn't support
> online-resize, so this also makes it really obvious all of the places
> we need to fix up to add support for online resize.

Cheers, Andreas





