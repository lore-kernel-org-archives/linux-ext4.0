From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2 V2] e2fsprogs: enable user namespace xattrs by
 default
Date: Sun, 20 Feb 2011 18:31:08 -0500
Message-ID: <20110220233108.GB4001@thunk.org>
References: <4D5C1380.2020602@redhat.com>
 <4D5C15C6.5000802@redhat.com>
 <4D5D9981.1020300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38161 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab1BTXbK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Feb 2011 18:31:10 -0500
Content-Disposition: inline
In-Reply-To: <4D5D9981.1020300@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 17, 2011 at 03:56:17PM -0600, Eric Sandeen wrote:
> User namespace xattrs are generally useful, and I think extN
> is the only filesystem requiring a special mount option to
> enable them, when xattrs are otherwise available.  So this
> change sets that mount option into the defaults, via a
> mke2fs.conf option.
> 
> Note that if xattrs are config'd off, this will lead to a
> mostly-harmless:
> 
>    EXT4-fs (sdc1): (no)user_xattr options not supported
> 
> message at mount time... 
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

You didn't run "make check" before submitting these patches.  Please
do so in the future!  :-)

I'll fix up the expected test commit results for these two commits.

     	    		      	     	     - Ted
