From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Issue with bad file system
Date: Mon, 19 Nov 2012 15:24:53 -0500
Message-ID: <20121119202453.GC30091@thunk.org>
References: <CAPAnFc9axLdcQ0xsGKsqQ5jMVs13JjYv7JdJkc_Q6Kdwa56JiQ@mail.gmail.com>
 <20121119083245.18044.qmail@science.horizon.com>
 <CAPAnFc_BdHCOB0iPwPdfPt_aiJ1PLNgnCAGaZwmOEX32j5LM7Q@mail.gmail.com>
 <50AA6913.2090104@redhat.com>
 <20121119184107.GA29487@thunk.org>
 <CAPAnFc-N43cZ44tr5XSLxrgdZgOmQDjSr7b-x8LMxm+5BA8+MA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	George Spelvin <linux@horizon.com>, linux-ext4@vger.kernel.org
To: Drew Reusser <dreusser@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33632 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827Ab2KSUY6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Nov 2012 15:24:58 -0500
Content-Disposition: inline
In-Reply-To: <CAPAnFc-N43cZ44tr5XSLxrgdZgOmQDjSr7b-x8LMxm+5BA8+MA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 19, 2012 at 07:53:13PM +0000, Drew Reusser wrote:
> 
> mint mnt # debugfs -s 32768 -b 4096 /dev/md0
> debugfs 1.42.5 (29-Jul-2012)
> /dev/md0: Bad magic number in super-block while opening filesystem
> debugfs:
> debugfs:  ls
> ls: Filesystem not open
> debugfs:

Sorry, I didn't realize that you weren't able to find *any* backup
super blocks.  In that case, either you got really unlucky and you had
some failure which has taken out a very large number of blocks, spread
out across the file system --- or I'd have to agree with Eric, I'd
want to be really, really sure that the Raid array hadn't gotten
assembled incorrectly somehow....

							- Ted
