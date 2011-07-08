From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 18/23] ext4: Rename ext4_free_blks_{count,set}() to
 refer to clusters
Date: Fri, 8 Jul 2011 18:42:20 -0400
Message-ID: <20110708224220.GI3331@thunk.org>
References: <1309970166-11770-1-git-send-email-tytso@mit.edu>
 <1309970166-11770-19-git-send-email-tytso@mit.edu>
 <BC2E91B2-7E48-47F4-B978-B90ACC7B0ADC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49622 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab1GHWmW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jul 2011 18:42:22 -0400
Content-Disposition: inline
In-Reply-To: <BC2E91B2-7E48-47F4-B978-B90ACC7B0ADC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 06, 2011 at 05:06:37PM -0600, Andreas Dilger wrote:
> On 2011-07-06, at 10:36 AM, Theodore Ts'o wrote:
> > The field bg_free_free_blocks_count_{lo,high} in the block group
> 
> s/free_free/free_/

Thanks, fixed.

					- Ted
