From: Andrew Morton <akpm@osdl.org>
Subject: Re: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Tue, 10 Oct 2006 01:14:34 -0700
Message-ID: <20061010011434.e8e2f76b.akpm@osdl.org>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
	<20061005173933.f54555fb.akpm@osdl.org>
	<20061009232927.77b667c2.akpm@osdl.org>
	<20061010075402.GA23992@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@austin.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:11502 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965095AbWJJIUL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Oct 2006 04:20:11 -0400
To: suparna@in.ibm.com
In-Reply-To: <20061010075402.GA23992@in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 10 Oct 2006 13:24:02 +0530
Suparna Bhattacharya <suparna@in.ibm.com> wrote:

> On Mon, Oct 09, 2006 at 11:29:27PM -0700, Andrew Morton wrote:
> > On Thu, 5 Oct 2006 17:39:33 -0700
> > Andrew Morton <akpm@osdl.org> wrote:
> > 
> > > Could we please have a few nice words about ext4 for the record?  Like,
> > > what its features are, how one creates an instance, where to get the
> > > correct userspace tools from, stability level, any known shortcomings,
> > > issues, etc?
> > 
> > So I guess I get to write this.
> 
> Hopefully not :) 
> We should be able to put something together for a start. Where should this
> reside ? Under Documentation/filesystems/ext4.txt ?

That sounds appropriate.  And in the patch changelog.

> However, since this is still very clearly a "development" branch at the moment,
> with lots of ongoing work both on the kernel and even more so on the
> tools side, how much detail are you looking for ?

We should make it as easy as possible for our testers to get up and running
and using all available features.  They're skilled, so a simple user guide
which tells them what the features are and how to access them should
suffice, thanks.

