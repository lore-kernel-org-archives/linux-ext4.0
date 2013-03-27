From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: introduce ext4_get_group_number()
Date: Tue, 26 Mar 2013 23:12:07 -0400
Message-ID: <20130327031207.GC5861@thunk.org>
References: <1364207051-27037-1-git-send-email-lczerner@redhat.com>
 <1364207051-27037-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56183 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab3C0DMK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Mar 2013 23:12:10 -0400
Content-Disposition: inline
In-Reply-To: <1364207051-27037-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 25, 2013 at 11:24:11AM +0100, Lukas Czerner wrote:
> Currently on many places in ext4 we're using
> ext4_get_group_no_and_offset() even though we're only interested in
> knowing the block group of the particular block, not the offset within
> the block group so we can use more efficient way to compute block group.
> 
> This patch introduces ext4_get_group_number() which computes block group
> for a givem block much more efficiently. Use this function instead of
> ext4_get_group_no_and_offset() everywhere where we're only interested in
> knowing the block group.

Again, we have the same problem as the previous patch.  I could
imagine setting a flag which uses the shift-instead-of-div
optimization, but that will reduce the optimization somewhat.  OTOH,
an 64-bit division is pretty expensive, especially on older/simpler
CPU's, so perhaps it's worth it.

   	  	      		    	    - Ted
