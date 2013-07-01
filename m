From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Beginner questions about ext4
Date: Mon, 1 Jul 2013 12:55:24 -0400
Message-ID: <20130701165524.GB23896@thunk.org>
References: <loom.20130612T140739-743@post.gmane.org>
 <loom.20130623T082353-563@post.gmane.org>
 <20130623115953.GA16193@thunk.org>
 <CACyNnZNQ00D=hKHZ_wvfwJx3CWt7iELrbgUf_41AzzSAJmxGUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34324 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab3GAQz1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Jul 2013 12:55:27 -0400
Content-Disposition: inline
In-Reply-To: <CACyNnZNQ00D=hKHZ_wvfwJx3CWt7iELrbgUf_41AzzSAJmxGUw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 01, 2013 at 05:23:13PM +0200, Felipe Monteiro de Carvalho wrote:
> On Sun, Jun 23, 2013 at 1:59 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > Historically, before flex_bg, the allocation bitmaps and inode tables
> > for a particular block group had to be located within that block
> > group, per the image that you've referenced above.
> 
> Thanks, but I'm still not sure: Are all groups flexible groups when
> FLEX_BG feature is activated?

I'm not sure whant you mean by "flexible groups".  There is no such
concept.

> If not, I wonder how a reader will recognize which groups were merged ...

And block groups don't get merged.

You should think of a flex block group as a collection of block
groups.  (Just as a number of provinces make up country, or a
collection of towns make up a county, and a number of counties make up
a province.)

	       	    	      		- Ted
