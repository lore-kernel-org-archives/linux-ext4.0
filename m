From: Ted Ts'o <tytso@mit.edu>
Subject: Re: hang in xfstest 204 with dev branch
Date: Wed, 25 May 2011 17:31:17 -0400
Message-ID: <20110525213117.GA9520@thunk.org>
References: <BANLkTik66Fj7_uHmjsL65j+5s3VQ1_VdoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39046 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378Ab1EYVbd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2011 17:31:33 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTik66Fj7_uHmjsL65j+5s3VQ1_VdoQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 25, 2011 at 10:01:38PM +0300, Amir Goldstein wrote:
> 
> When running xfstests with 4K blocksize, test 204 (Test out ENOSPC
> flushing on small filesystems)
> hangs in an interruptible sleep (I can release it with ctrl-C).
> 
> git bisect points at commit fc0d5c38963ed655e974025c63290563c172038a
>     ext4: add flag to ext4_has_free_blocks
> as the offender.

I found and fixed it.  It was a bug I accidently introduced when I was
cleaning up that patches.  Try the latest dev branch from the ext4.git
tree....

					- Ted
