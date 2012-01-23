From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Question about writable ext4-snapshot
Date: Sun, 22 Jan 2012 22:21:43 -0500
Message-ID: <20120123032143.GA16363@thunk.org>
References: <CAFZ0FUWzq4GV-Xi6n+8+5R+oVi8uPBFg6XHzgwZfXVP_FbMz=w@mail.gmail.com>
 <92365222-576D-43F6-8BC0-3F7D4A663D05@mit.edu>
 <CAOQ4uxgUFqYeCWiuHn+jXSS0bD=8u1aM5ujcd9BRdpMJtHeFdQ@mail.gmail.com>
 <CAFZ0FUXK89LLOmRGuXWW1UAZo0ydTi_O=383E+nsCywQgYh6eQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@gmail.com>, Tao Ma <taoma.tm@gmail.com>,
	coly <colyli@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47309 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab2AWDVs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Jan 2012 22:21:48 -0500
Content-Disposition: inline
In-Reply-To: <CAFZ0FUXK89LLOmRGuXWW1UAZo0ydTi_O=383E+nsCywQgYh6eQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 22, 2012 at 11:31:31AM +0800, Robin Dong wrote:
> > At the end of the day, thinp target is a very powerful tool, but
> > is does not fit all use cases. In particular, it fragments the
> > on-disk layout of ext4 metadata and benchmark results for how this
> > affect performance were never published.

Amir,

Well, to be fair, your approach to snapshotting also causes
fragmentation.  If a file or a directory in the base image gets
modified while there is a read-only snapshot, the inode in the base
image gets fragmented as a result.

It is true that thin provisioning in general tends to defeat the block
placement algorithms used by a file system, but it will be possible to
create snapshots of non-thinp volumes, which will address this issue.
Hopefully in the next 3-6 months, these things will be implemented
enough so that we can benchmark them and see for certain how well or
poorly this approach will work out.  I'm sure there will be a certain
number of tradeoffs for both approaches.

Regards,

					- Ted
