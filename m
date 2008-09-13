From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Update for patches in patch queue
Date: Sat, 13 Sep 2008 13:09:05 -0400
Message-ID: <20080913170905.GD26128@mit.edu>
References: <1221210148-26329-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1221210148-26329-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080912090723.GB8405@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61660 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127AbYIMRJV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Sep 2008 13:09:21 -0400
Content-Disposition: inline
In-Reply-To: <20080912090723.GB8405@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 12, 2008 at 02:37:23PM +0530, Aneesh Kumar K.V wrote:
> 
> I guess git send-email did something wrong. I had these two patches as 
> followup for the compose mail with this subject. Any how i am attaching
> the patches below. The patches update
> ext4_truncate_block_allocated_on_a_failed_ext4_write_begin.patch and 
> ext4_i_disksize_lock_race_fix.patch by moving some changes from 
> ext4_i_disksize_lock_race_fix.patch to the other.

Thanks, applied.  I merged back in the patch description improvements
I had made, and made a few more to improve the English description of
these two patches.

						- Ted
