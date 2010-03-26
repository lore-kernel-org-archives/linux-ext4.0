From: tytso@mit.edu
Subject: Re: Should journaled quota be default for ext4?
Date: Fri, 26 Mar 2010 10:26:26 -0400
Message-ID: <20100326142626.GI21658@thunk.org>
References: <4BAC3860.7010905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44904 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab0CZPDA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Mar 2010 11:03:00 -0400
Content-Disposition: inline
In-Reply-To: <4BAC3860.7010905@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 25, 2010 at 11:30:24PM -0500, Eric Sandeen wrote:
> Ted's email about quotacheck made me think:
> 
> Is there a reason that journaled quota is not default for ext4?
> (or ext3 for that matter, but we're not messing with that now)
> 
> IOW - if we do mount -o quota, is there any reason that we should
> also need more options to journal that quota?  When would we not
> want journaled quota?
> 
> (Forgive me if it's a dumb question, I'm not as well versed in
> extN quota as I probably should be).

Part of the problem is that these mount options matter to various init
scripts (and possibly to quotatools?).  So for example, the usrquota
and grpquota mount options are complete no-ops as far as the kernel
code is concerned.  But they are there so they show up in
/proc/mounts, just in case /etc/mtab is a symlink to /proc/mounts (as
it is in some setups), because userspace scripts/tools care about
knowing whether the user wanted user or group quotas.  (And I think
the reason for that is because if someone only wants user or group
quotas, it's cheaper/faster if we only do the form of quota that is
required by the sysadmin....)

Worse yet, not all the distributions are standardized using the same
init scripts.

I *think* ditching non-journal quota does simplify things immensely,
but we will need to collect init scripts (and possibly private patches
to quotatools) across multiple distributions in order to be sure.

(I was looking at this, as well as the documentation out there on the
net about how to use quotas, and it's a bit of a mess.  :-/ )

    	      	     	     	      - Ted
