From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC 10/12] ext4: teach ext4_statfs() to deal with
 clusters if bigalloc is enabled
Date: Tue, 22 Mar 2011 18:09:21 -0400
Message-ID: <20110322220921.GD3907@thunk.org>
References: <1300570117-24048-1-git-send-email-tytso@mit.edu>
 <1300570117-24048-11-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1103212115360.3724@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53488 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab1CVWJZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Mar 2011 18:09:25 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103212115360.3724@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 21, 2011 at 09:17:30PM +0100, Lukas Czerner wrote:
> 
> overhead is in clusters units, but
> 
> >  		smp_wmb();
> >  		sbi->s_blocks_last = ext4_blocks_count(es);
> > @@ -4489,6 +4499,7 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
> >  	buf->f_blocks = ext4_blocks_count(es) - sbi->s_overhead_last;
> 
> here it seems to be treated as blocks if I am not missing something.

Oops, good point!  Thanks for catching that.

					- Ted
