From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: use module parameters instead of debugfs for
 mballoc_debug
Date: Mon, 11 Feb 2013 10:54:28 -0500
Message-ID: <20130211155428.GA6001@thunk.org>
References: <1360460534-818-1-git-send-email-tytso@mit.edu>
 <51191010.50402@redhat.com>
 <511912B1.9070407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47879 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757660Ab3BKPyc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 10:54:32 -0500
Content-Disposition: inline
In-Reply-To: <511912B1.9070407@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 11, 2013 at 09:48:01AM -0600, Eric Sandeen wrote:
> 
> As another thought, did you consider using dynamic debug for this, or is that
> too much trickiness?  Might be nice since usually a bug reporter won't have
> a kernel built with CONFIG_EXT4_DEBUG . . .

I had assumed that the long term direction was to use tracepoints,
which also has the advantage of not requiring kernels built with
CONFIG_EXT4_DEBUG.

Hmm.... one thing though is if we want bug reporters to use
tracepoints (as opposed to just developers), we'll need to have some
pre-made shell scripts to make it easy for non-developers to enable
tracepoints for various problems.

     	 		   	  	      	  - Ted
