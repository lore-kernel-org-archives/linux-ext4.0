From: Ted Ts'o <tytso@mit.edu>
Subject: Re: errors in ext4_mb_generate_buddy and ext4_remount
Date: Wed, 1 Jun 2011 00:15:02 -0400
Message-ID: <20110601041502.GB4172@thunk.org>
References: <f93bc5d54d25e080b5438bcdc3af8f84@imap.dd24.net>
 <20110509010112.GC4138@thunk.org>
 <1306881493.3275.5.camel@fermat.scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43843 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab1FAEPJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Jun 2011 00:15:09 -0400
Content-Disposition: inline
In-Reply-To: <1306881493.3275.5.camel@fermat.scientia.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 01, 2011 at 12:38:13AM +0200, Christoph Anton Mitterer wrote:
> Hi Ted.
> 
> On Sun, 2011-05-08 at 21:01 -0400, Ted Ts'o wrote:
> > The debian packages of e2fsprogs version 1.41.14-1 in experimental, or
> > 1.41.12-4 in unstable, has the necessary new code in e2fsck.  I'm
> > working on getting the patch pushed to Debian obsolete^H^H^H^H^H^H^H
> > stable; hopefully that will happen in the next week or two.
> The problem at least persists in the 1.41.12-4 version.

Um, are you sure?  Try forcing an fsck run on the file systems in question.

    	    	       	       	       - Ted
