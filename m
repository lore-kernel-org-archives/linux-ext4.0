From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 crash? on rsyn action
Date: Wed, 13 Jan 2010 10:57:08 +0100
Message-ID: <20100113095708.GA3255@quack.suse.cz>
References: <4B4B8AB8.5040907@zackbummfertig.de>
 <20100112194414.GB24833@atrey.karlin.mff.cuni.cz>
 <4B4D048D.1000306@zackbummfertig.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>
To: Marko Weber <weber@zackbummfertig.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab0AMJ5H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Jan 2010 04:57:07 -0500
Content-Disposition: inline
In-Reply-To: <4B4D048D.1000306@zackbummfertig.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Marko,

On Wed 13-01-10 00:23:57, Marko Weber wrote:
> heres my vmlinux file.
  What you've sent me is a vmlinuz file ('z' in the end instead of 'x')
and gdb cannot work with that. If you use self-compiled kernel, vmlinux
file (from which vmlinuz is created) is in the root of the directory where
you compile the kernel.
  I've now realized that you might have ext4/jbd2 compiled as a module. In
that case, sending me those two modules should be enough. Thanks.

> Am 12.01.2010 20:44, schrieb Jan Kara:
> >If you can send your vmlinux file, we
> >can find out where exactly in jbd2_journal_commit_transaction we wait.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
