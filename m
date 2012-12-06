From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: RFC: remove CONFIG_EXT4_FS_XATTR
Date: Wed, 5 Dec 2012 22:48:42 -0500
Message-ID: <20121206034842.GA21009@thunk.org>
References: <nsxsj7kw2jq.fsf@closure.thunk.org>
 <50BFF5D6.7050804@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37039 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab2LFDss (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Dec 2012 22:48:48 -0500
Content-Disposition: inline
In-Reply-To: <50BFF5D6.7050804@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 06, 2012 at 09:33:10AM +0800, Tao Ma wrote:
> To be frank, I didn't try the inline data test without xattr support. So
> that would be great if we remove it. :)
> 
> btw, does any distribution disable xattr support during kernel build? As
> Eric said on behalf of redhat, and in my ubuntu box xattr is enabled.
> Would Jan confirm that SUSE also use it by default?

I'm pretty sure SuSE enables it, since SELinux requires it, and SuSE
supports it.

I'm more concerned with various embedded use cases, which is why I
measured how much additional text/data space xattr support enables
(which was only 27k, so I doubt that would be an issue in most
embedded use cases --- hmm.... I've just checked a Nexus 4 kernel
config and it enables CONFIG_FS_EXT4_XATTR; I'm not sure Android is
actually using xattrs at all at the moment, but it's certainly
enabled).

						- Ted
