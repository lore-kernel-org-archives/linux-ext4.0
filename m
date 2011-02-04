From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [LSF/FS TOPIC] Ext4 snapshots status update
Date: Thu, 3 Feb 2011 16:20:44 -0800
Message-ID: <20110204002043.GA15658@noexit>
References: <AANLkTink6o249JivXiETT6JnANNcikNqGGfr8+McDQsM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lsf-pc@lists.linuxfoundation.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:57872 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab1BDAUw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Feb 2011 19:20:52 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTink6o249JivXiETT6JnANNcikNqGGfr8+McDQsM@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 04, 2011 at 12:33:39AM +0200, Amir Goldstein wrote:
> I have been working on porting Next3 snapshots to Ext4
> with a group of 4 CS students.
> 
> This is where it all happens:
> https://github.com/amir73il/ext4-snapshots
> 
> Ext4 snapshots prototype is already working!
> Would you like to see a demo?
> 
> I would like to present the progress of our work
> and discuss the remaining issues and how they should be best addressed.
> 
> Additionally, I would like to discuss the need for a unified snapshots API that
> would serve both Ext4 and Btrfs.
> This could be useful for someone that wants to implement a generic
> snapshots management system.

	ocfs2 definitely wants to be a part of that discussion, as we
already do snapshots and thin clones.  ocfs2 snapshots are actually just
thin clones marked readonly.  They can be placed anywhere in the
filesystem and are first-class inodes.  They do not live in a hidden
space like Next3 snapshots seem to.
	I've already got a design for a front-end snapshot program that
implements a policy on top this generic behavior.  This design would
cover both first-class and hidden style snapshots, because it assume
snapshots are in a distinct namespace.  I haven't gotten around to
implementing it yet, but btrfs and other snapshottable filesystems were
part of the design goal.

Joel

-- 

"Sometimes one pays most for the things one gets for nothing."
        - Albert Einstein

			http://www.jlbec.org/
			jlbec@evilplan.org
