From: Ted Ts'o <tytso@mit.edu>
Subject: Re: new ext4 filesystem vs. converted ext3
Date: Fri, 3 Jun 2011 23:09:49 -0400
Message-ID: <20110604030949.GB2614@thunk.org>
References: <87tyc6pov6.fsf@algae.riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Micah Anderson <micah@riseup.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46517 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab1FDDJy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jun 2011 23:09:54 -0400
Content-Disposition: inline
In-Reply-To: <87tyc6pov6.fsf@algae.riseup.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 03, 2011 at 05:49:17PM -0400, Micah Anderson wrote:
> However, ever since I did that change, I've noticed an increase in I/O
> wait state on the CPUs. I've been trying to determine why, and if there
> were some things I should tune on this ext4 filesystem.

How are you measuring this?

						- Ted
