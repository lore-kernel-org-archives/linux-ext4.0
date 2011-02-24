From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/5] mballoc: don't change cpa if cur_distance is equal
 to new_distance
Date: Thu, 24 Feb 2011 14:10:52 -0500
Message-ID: <20110224191052.GY2924@thunk.org>
References: <4D4E297A.8090801@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Alex Tomas <alex@clusterfs.com>,
	Theodore Tso <tytso@google.com>
To: Coly Li <i@coly.li>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48406 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755909Ab1BXTKy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Feb 2011 14:10:54 -0500
Content-Disposition: inline
In-Reply-To: <4D4E297A.8090801@coly.li>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Added to the ext4 patch queue, albeit with a rewritten patch
description.

					- Ted

commit 5a54b2f199fdf19533f96c3e285b70c6729e1e4a
Author: Coly Li <colyli@gmail.com>
Date:   Thu Feb 24 14:10:05 2011 -0500

    ext4: mballoc: don't replace the current preallocation group unnecessarily
    
    In ext4_mb_check_group_pa(), the current preallocation space is
    replaced with a new preallocation space when the two have the same
    distance from the goal block.
    
    This doesn't actually gain us anything, so change things so that the
    function only switches to the new preallocation group if its distance
    from the goal block is strictly smaller than the current preallocaiton
    group's distance from the goal block.
    
    Signed-off-by: Coly Li <bosong.ly@taobao.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
