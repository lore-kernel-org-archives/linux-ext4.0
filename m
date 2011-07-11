From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/5] ext4: Change the wrong param comment for
 ext4_trim_all_free.
Date: Mon, 11 Jul 2011 00:07:42 -0400
Message-ID: <20110711040742.GI28763@thunk.org>
References: <4E0DE63A.7030103@tao.ma>
 <1309534076-2784-1-git-send-email-tm@tao.ma>
 <1309534076-2784-5-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55485 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab1GKEHp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jul 2011 00:07:45 -0400
Content-Disposition: inline
In-Reply-To: <1309534076-2784-5-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 01, 2011 at 11:27:56PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> at ext4_trim_all_free() comment, there is no longer an @e4b parameter,
> instead it is @group.
> 
> Reported-by: Andreas Dilger <adilger@dilger.ca>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Added to the ext4 tree, thanks.

					- Ted
