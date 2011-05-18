From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4 v4] e2image: Support for conversion QCOW2 image
 into raw
Date: Wed, 18 May 2011 12:18:23 -0400
Message-ID: <20110518161823.GD29368@thunk.org>
References: <1305718615-5991-3-git-send-email-lczerner@redhat.com>
 <1305721247-9598-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60001 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756756Ab1ERQSZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 12:18:25 -0400
Content-Disposition: inline
In-Reply-To: <1305721247-9598-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 18, 2011 at 02:20:47PM +0200, Lukas Czerner wrote:
> This commit adds support for converting QCOW2 image created previously
> with e2image into raw image. The QCOW2 image is detected automatically,
> so there is not new option. Just use following command:
> 
>   e2image -r image.qcow image.raw
> 
> No that this tool is aimed to quickly convert qcow2 image created with
> e2image into raw image. In order to improve speed we are doing some
> assumption I believe might not be true for regular qcow2 images. So it
> was not tested with regular QCOW2 images and it might not work with
> them. The intention of this tool is only convert images previously
> created by e2image.
> 
> Note that there is nothing special with QCOW2 images created by e2images
> and it can be used with tools like qemu-img, or qemu-nbd without any
> problems.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Applied to the e2fsprogs next branch.

						- Ted
