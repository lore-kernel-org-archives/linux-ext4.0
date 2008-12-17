From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Patch/BUG] (ext4) s_mb_maxs[] of ext4_sb_info is too small
	size
Date: Wed, 17 Dec 2008 00:59:25 -0500
Message-ID: <20081217055925.GJ10590@mit.edu>
References: <20081216170409.34EA.E1E9C6FF@jp.fujitsu.com> <4947DE30.2090903@redhat.com> <20081217114124.2011.E1E9C6FF@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, adilger@sun.com,
	Li Zefan <lizf@cn.fujitsu.com>, linux-ext4@vger.kernel.org,
	Miao Xie <miaox@cn.fujitsu.com>,
	Linux Kernel ML <linux-kernel@vger.kernel.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:46801 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751047AbYLQF7g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Dec 2008 00:59:36 -0500
Content-Disposition: inline
In-Reply-To: <20081217114124.2011.E1E9C6FF@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, I've added this to the ext4 patch queue and updated the
bugzilla entry.

						- Ted
