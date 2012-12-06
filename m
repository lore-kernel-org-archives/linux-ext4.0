From: David Brown <davidb@codeaurora.org>
Subject: Re: RFC: remove CONFIG_EXT4_FS_XATTR
Date: Thu, 6 Dec 2012 11:28:04 -0800
Message-ID: <20121206192804.GA15506@codeaurora.org>
References: <nsxsj7kw2jq.fsf@closure.thunk.org>
 <50BFF5D6.7050804@tao.ma>
 <20121206034842.GA21009@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15041 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423225Ab2LFT2G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2012 14:28:06 -0500
Content-Disposition: inline
In-Reply-To: <20121206034842.GA21009@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 05, 2012 at 10:48:42PM -0500, Theodore Ts'o wrote:
> On Thu, Dec 06, 2012 at 09:33:10AM +0800, Tao Ma wrote:
> > To be frank, I didn't try the inline data test without xattr support. So
> > that would be great if we remove it. :)
> > 
> > btw, does any distribution disable xattr support during kernel build? As
> > Eric said on behalf of redhat, and in my ubuntu box xattr is enabled.
> > Would Jan confirm that SUSE also use it by default?
> 
> I'm pretty sure SuSE enables it, since SELinux requires it, and SuSE
> supports it.
> 
> I'm more concerned with various embedded use cases, which is why I
> measured how much additional text/data space xattr support enables
> (which was only 27k, so I doubt that would be an issue in most
> embedded use cases --- hmm.... I've just checked a Nexus 4 kernel
> config and it enables CONFIG_FS_EXT4_XATTR; I'm not sure Android is
> actually using xattrs at all at the moment, but it's certainly
> enabled).

As far as I know, it's enabled in all Android kernels that use ext4.
(at least once I grepped for CONFIG_EXT4_FS_XATTR)

Arch linux has started using capabilities in some packages, which will
also require this.

David

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
