From: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Ext4 tree stable patches backports for 2.6.27 and 2.6.28
Date: Wed, 8 Apr 2009 15:55:15 -0400
Message-ID: <20090408155515.4193d090@dhcp-100-2-144.bos.redhat.com>
References: <E1Lmh5L-0004oH-Mp@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47880 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759774AbZDHTzn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Apr 2009 15:55:43 -0400
In-Reply-To: <E1Lmh5L-0004oH-Mp@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 26 Mar 2009 00:20:55 -0400
"Theodore Ts'o" <tytso@mit.edu> wrote:

> I've updated the for-stable and for-stable-2.6.27 branches in the ext4
> git tree that were merged into mainline right before 2.6.29.  In
> addition, there is a build fix for ocfs2 if CONFIG_OFS2_COMPAT_JBD is
> enabled.
> 
> The ext4 git tree can be found here:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
>    http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git
> 
> The new patches in the for-stable and for-stable-2.6.27 branches can be
> found below.
> 
> If folks can test out the for-stable and/or the for-stable-2.6.27
> branches, I would appreciate it before I send these patches to
> stable@kernel.org.
> 

The patches for 2.6.27 apply and build fine, but I haven't gotten any testing
yet.

The real problem with 2.6.27 now is that the vm cyclic writeback changes went
into 2.6.27-stable and there has been no backport of the corresponding ext4
fix for the problems it exposed. That code has changed radically since 2.6.27
and it looks like it would be very difficult to backport what went into 2.6.29,
but without that fix users of 2.6.27 hit stalls and need to reboot.
