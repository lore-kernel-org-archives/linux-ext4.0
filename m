From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: something's using space, can't figure out what - how to debug?
Date: Wed, 10 Apr 2013 20:26:43 -0400
Message-ID: <20130411002643.GA10594@thunk.org>
References: <20130410195606.22a9eff3@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33333 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934997Ab3DKA0s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Apr 2013 20:26:48 -0400
Content-Disposition: inline
In-Reply-To: <20130410195606.22a9eff3@wpkg.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 10, 2013 at 07:56:06PM +0900, Tomasz Chmielewski wrote:
> # lsof -n|grep /srv
> # 
> 
> 
> So df says 134 GB is used, while du says 60 GB is used.
> No removed but used files, according to lsof.
> 
> How do I best debug what happened to ~70 GB?

Well, nothing is using /srv, so why don't you unmount it and run
"e2fsck -f /dev/xvdf", and see e2fsck reports in terms of the number
of blocks in use, i.e:

/dev/lambda/backup: 581320/4915200 files (0.1% non-contiguous), 6837767/19660800 blocks

		    		   	       - Ted
