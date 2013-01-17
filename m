From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: add tracepoint in punching hole
Date: Wed, 16 Jan 2013 22:38:22 -0500
Message-ID: <20130117033822.GA12191@thunk.org>
References: <1345695941-15053-1-git-send-email-wenqing.lz@taobao.com>
 <1345695941-15053-4-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43897 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758362Ab3AQDia (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Jan 2013 22:38:30 -0500
Content-Disposition: inline
In-Reply-To: <1345695941-15053-4-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 23, 2012 at 12:25:41PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> This patch adds a tracepoint in ext4_punch_hole.
> 
> CC: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

I'm still waiting for the next version of the indirect punch patches
(which you said you'd work on after the extent status patches, given
that I had noted other xfstest failures that were apparently caused by
these patches), but in the mean time, adding a tracepoint for
ext4_punch_hole() seem like it would make sense, so I've applied this
patch to the ext4 tree.

						- Ted
