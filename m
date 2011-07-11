From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/5] ext4: Speed up FITRIM by recording flags in
 ext4_group_info.
Date: Mon, 11 Jul 2011 00:07:27 -0400
Message-ID: <20110711040727.GH28763@thunk.org>
References: <4E0DE63A.7030103@tao.ma>
 <1309534076-2784-1-git-send-email-tm@tao.ma>
 <1309534076-2784-4-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55481 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab1GKEHa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jul 2011 00:07:30 -0400
Content-Disposition: inline
In-Reply-To: <1309534076-2784-4-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 01, 2011 at 11:27:55PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In ext4, when FITRIM is called every time, we iterate all the
> groups and do trim one by one. It is a bit time wasting if the
> group has been trimmed and there is no change since the last
> trim.
> 
> So this patch adds a new flag in ext4_group_info->bb_state to
> indicate that the group has been trimmed, and it will be cleared
> if some blocks is freed(in release_blocks_on_commit). Another
> trim_minlen is added in ext4_sb_info to record the last minlen
> we use to trim the volume, so that if the caller provide a small
> one, we will go on the trim regardless of the bb_state.

Added to the ext4 tree, thanks.

					- Ted
