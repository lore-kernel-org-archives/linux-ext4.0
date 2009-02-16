From: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Ext4 tree backports for 2.6.27.13 and 2.6.28.2
Date: Mon, 16 Feb 2009 16:35:07 -0500
Message-ID: <20090216163507.1e73f452@dhcp-100-2-144.bos.redhat.com>
References: <E1LT8MN-0003Ps-Ur@closure.thunk.org>
	<20090211075914.GC20842@skywalker>
	<20090211153328.37ef255f@dhcp-100-2-144.bos.redhat.com>
	<20090212211935.GE6922@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55984 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbZBPVhm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Feb 2009 16:37:42 -0500
In-Reply-To: <20090212211935.GE6922@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 12 Feb 2009 16:19:35 -0500
Theodore Tso <tytso@mit.edu> wrote:

> 
> I've updated the for-stable and for-stable-2.6.27 branches against the
> latest stable releases, and I've updated the two flawed backports in
> the for-stable-2.6.27 branch.  Could you do a quick double-check and
> make sure the fixes are as you expect, before I send a pull request to
> stable@kernel.org?

The 2.6.27 branch looks good to me.
