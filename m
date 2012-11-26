From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Ext4 file corruption using cp
Date: Mon, 26 Nov 2012 09:24:21 -0500
Message-ID: <20121126142421.GE31891@thunk.org>
References: <CAH3VSLyZvtHC5G_Hx6oHr_jR43+vYz46nXLkifuD3gXGLd21yQ@mail.gmail.com>
 <CAH3VSLw_spHkb27VbRUG-81Rc=hwPDnhfGOe9LqExs0bFveujQ@mail.gmail.com>
 <61093A2B-5AEA-4ED8-B43D-AB6217B405AC@dilger.ca>
 <CAH3VSLwhe7ZHfuc1+RatWvrvAOAS3HakYoRr5+PNnvvrue9BmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Roger Niva <rogerniva@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34829 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab2KZOYZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 09:24:25 -0500
Content-Disposition: inline
In-Reply-To: <CAH3VSLwhe7ZHfuc1+RatWvrvAOAS3HakYoRr5+PNnvvrue9BmA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 26, 2012 at 09:48:10AM +0100, Roger Niva wrote:
> 
> We have now been running a newer coreutils (/bin/cp) for about a week
> without seeing this pop up again, so we're reasonably sure it fixed
> the issue for us.

Thanks for confirming that this fixed your issue!

       	   	      	   	      	   - Ted
