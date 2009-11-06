From: Theodore Tso <tytso@mit.edu>
Subject: Re: Formatted/repartitioned wrong disk, arrgh!
Date: Fri, 6 Nov 2009 09:04:15 -0500
Message-ID: <20091106140415.GA26342@mit.edu>
References: <4AF3F82D.50105@elector.dk> <87a8dc10911060249i16b6da5t21e916811938e5b5@mail.gmail.com> <4AF40D60.1080503@elector.dk> <87a8dc10911060357r27131f36r3351497b38e18a39@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jesper Jensen <linux-ext4_mailinglist@elector.dk>,
	linux-ext4@vger.kernel.org
To: Alexey Salmin <alexey.salmin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56528 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbZKFOEO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Nov 2009 09:04:14 -0500
Content-Disposition: inline
In-Reply-To: <87a8dc10911060357r27131f36r3351497b38e18a39@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 06, 2009 at 05:57:14PM +0600, Alexey Salmin wrote:
> I think the only thing I can recommend to you is to "grep for your
> files and hope for the best" (c)
> I don't know any automated way to restore files after complete
> destroying of fs, but there always is grep and hexdump :)

Unfortunately, there isn't much else that can be done, since the inode
table has been zero'ed out.

Sorry.  :-(

						- Ted
