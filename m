From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: trace punch_hole correctly in
 ext4_ext_map_blocks
Date: Sat, 29 Oct 2011 09:51:08 -0400
Message-ID: <20111029135108.GH19536@thunk.org>
References: <1319613112-16807-1-git-send-email-xiaoqiangnk@gmail.com>
 <1319613112-16807-4-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40627 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933729Ab1J2SMj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Oct 2011 14:12:39 -0400
Content-Disposition: inline
In-Reply-To: <1319613112-16807-4-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 26, 2011 at 03:11:52PM +0800, Yongqiang Yang wrote:
> When ext4_ext_map_blocks() is called by punch_hole, trace should
> trace blocks punched out.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks for catching this; applied.

						- Ted
