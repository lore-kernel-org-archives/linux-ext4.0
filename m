From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: lifetime_write_kbytes isn't preserved during unclean shutdown
Date: Tue, 29 Jun 2010 23:46:57 -0600
Message-ID: <519E1F03-CD95-41F4-B2EE-93983A4CC08A@dilger.ca>
References: <4C2782A7.7040301@gmail.com> <20100628195739.GB6094@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Nebojsa Trpkovic <trx.lists@gmail.com>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:31382 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab0F3Fq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jun 2010 01:46:58 -0400
In-Reply-To: <20100628195739.GB6094@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-06-28, at 13:57, tytso@mit.edu wrote:
> On Sun, Jun 27, 2010 at 06:56:07PM +0200, Nebojsa Trpkovic wrote:
>> I've noticed that lifetime_write_kbytes isn't preserved during unclean
>> shutdown.
> 
> Yes, right now we are only updating the superblock's lifetime write
> kbytes at unmount time.  It should be possible to do a better job; but
> I don't want to increase writes to the disk just to keep the
> s_lifetime value up-to-date.  So what we should probably do is update
> it when we are going to be updating the superblock anyway (i.e., when
> we update the orphaned inode linked list)

Could we also update the superblock blocks/inodes free counters at that time as well?

> and maybe on some periodic basis (say once an hour) otherwise.

I don't think that is the right thing to do, unless the filesystem is still active for other reasons.  We don't necessarily want to spin up the disks every hour if the filesystem is inactive, I'd rather write out the superblock for an existing transaction while it is still active than generate a new transaction for no particular reason.

One way to do this would be to have a JBD transaction pre-commit callback, and if the superblock has not been written in N seconds then it can be added as part of that transaction (if it will fit).  If it is already in the transaction it can be updated via the existing bh callbacks that OCFS2 is using.

Cheers, Andreas





