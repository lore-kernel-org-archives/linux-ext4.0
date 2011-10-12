From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4/xattr_security.c: local functions should be static
Date: Tue, 11 Oct 2011 23:09:22 -0400
Message-ID: <20111012030922.GD11548@thunk.org>
References: <201109231538.22933.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
To: H Hartley Sweeten <hartleys@visionengravers.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60000 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab1JLDJZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Oct 2011 23:09:25 -0400
Content-Disposition: inline
In-Reply-To: <201109231538.22933.hartleys@visionengravers.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 23, 2011 at 03:38:22PM -0700, H Hartley Sweeten wrote:
> Quiets the sparse noise:
> 
> warning: symbol 'ext4_initxattrs' was not declared. Should it be static?

What version of the kernel was this from?  I can't find
ext4_initxattrs in any kernel version that I can find in git...

		       	      	      	     - Ted
