From: Andrew Morton <akpm@osdl.org>
Subject: Re: [RFC] [PATCH] Documentation/filesystems/ext4.txt
Date: Tue, 10 Oct 2006 13:56:40 -0700
Message-ID: <20061010135640.f82061f9.akpm@osdl.org>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
	<20061005173933.f54555fb.akpm@osdl.org>
	<20061009232927.77b667c2.akpm@osdl.org>
	<20061010075402.GA23992@in.ibm.com>
	<20061010011434.e8e2f76b.akpm@osdl.org>
	<1160510555.28923.15.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: suparna@in.ibm.com, ext4 development <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:62858 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030358AbWJJU47 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Oct 2006 16:56:59 -0400
To: Dave Kleikamp <shaggy@austin.ibm.com>
In-Reply-To: <1160510555.28923.15.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 10 Oct 2006 15:02:35 -0500
Dave Kleikamp <shaggy@austin.ibm.com> wrote:

> > > Hopefully not :) 
> > > We should be able to put something together for a start. Where should this
> > > reside ? Under Documentation/filesystems/ext4.txt ?
> 
> Suparna put this together and I updated it a bit.

Great, thanks.

> > That sounds appropriate.  And in the patch changelog.
> 
> How do you want to handle the patch set?  I could resend it with more
> comments, put it into git, or do you just want to plug the comments into
> the patches you are carrying?  I can do whatever works best for you.

I'll just send what I have now in the next batch, probably this evening.

> +  - Grab updated e2fsprogs from
> +    ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs-interim/
> +    This is a patchset on top of e2fsprogs-1.39, which can be found at
> +    ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/

Could we please get a patched tarball up there?  The easier we make it for
our testers, the more we get.

