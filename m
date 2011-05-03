From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Factor common code from convert and split-unwritten.
Date: Tue, 3 May 2011 18:25:40 -0400
Message-ID: <20110503222540.GA2831@thunk.org>
References: <1304388301-9452-1-git-send-email-xiaoqiangnk@gmail.com>
 <BANLkTi=R+3NhsykOhHrmhVEOsuS5uf4BoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com,
	cmm@us.ibm.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58153 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab1ECWZn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 May 2011 18:25:43 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTi=R+3NhsykOhHrmhVEOsuS5uf4BoQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 03, 2011 at 10:35:42AM +0800, Yongqiang Yang wrote:
> Hi Ted,
> 
> The patch series has been tested by Allison with punch hole patch series.

Hi Yongqiang,

I've committed your patches, and doing a lot of testing, I've promoted
them to the ext4 master branch on the ext4 tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git

As we discussed on the two last ext4 conference calls, the master
branch is now stable (I'm not going to ever rewind that branch), so
it's a stable point for people to develop against.

The ext4 patch queue is now exported on the "dev" branch, as well as
(as a quilt tree) at:

git://repo.or.cz/ext4-patch-queue.git

Many thanks for your patches!

						- Ted
