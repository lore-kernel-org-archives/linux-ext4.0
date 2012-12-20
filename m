From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix extent tree corruption that incurred by hole
 punch [V2]
Date: Thu, 20 Dec 2012 00:39:15 -0500
Message-ID: <20121220053914.GB22145@thunk.org>
References: <CAJSVwFM3vq9wsq0Mn5L1bh-WHoP1g3VMJAOg_ruavZFednsjVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ashish Sangwan <ashishsangwan2@gmail.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Forrest Liu <forrestl@synology.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39446 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab2LTFjW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Dec 2012 00:39:22 -0500
Content-Disposition: inline
In-Reply-To: <CAJSVwFM3vq9wsq0Mn5L1bh-WHoP1g3VMJAOg_ruavZFednsjVw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 13, 2012 at 11:32:22PM +0800, Forrest Liu wrote:
> When depth of extent tree is greater than 1, logical start value
> of interior node didn't updated correctly in ext4_ext_rm_idx.
> 
> Signed-off-by: Forrest Liu <forrestl@synology.com>

Applied.  

BTW, your reproduction case also results in a file system which isn't
noticed as being broken by e2fsck.  Eric's patch "e2fsck: Fix
incorrect interior node logical start values" fixes e2fsck so it
handles this.  Unfortunately applying his patch seems to uncover a bug
in e2fsck when clearing a bad extent node (f_extent_bad_node) which we
need to fix so the regression test suite is passing.

     	       	   	      	   	    - Ted
