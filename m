From: Chris Wedgwood <cw@f00f.org>
Subject: Re: Interface for the new fallocate() system call
Date: Thu, 29 Mar 2007 09:35:20 -0700
Message-ID: <20070329163520.GA16632@tuatara.stupidest.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: torvalds@osdl.org, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com,
	cmm@us.ibm.com
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp112.sbc.mail.mud.yahoo.com ([68.142.198.211]:21658 "HELO
	smtp112.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030344AbXC2QfY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Mar 2007 12:35:24 -0400
Content-Disposition: inline
In-Reply-To: <20070329115126.GB7374@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Mar 29, 2007 at 05:21:26PM +0530, Amit K. Arora wrote:

>    int fallocate(int fd, loff_t offset, loff_t len, int mode)

Right now there are only two possible values for mode --- it's not
clear what additional values there will be in the future.

How about two syscalls?  If we decide later on we need something more
complicated we can revisit this and *THEN* add another system call
which may end up being a superset of the other two.

I know that sounds somewhat icky but:

  * it's fairly simple

  * we get nice argument handling on all arches by dropping u32 mode
    (don't we?)

  * syscalls don't really cost a lot to keep about, they do cost in
    terms on maintenance though, but in this case i don't see it being
    all that much of a problem

  * IMO badly/over designed syscalls are going to be a bigger problem
    long term

Given that *NO* single fs in mainline right now can *reliably* use
this functionality for a while maybe whatever solution people come up
with next should sit in -mm for a while?  At least that gives people
exposure to it and a chance to make some changes as once it's merged
to mainline it's pretty hard to change.
