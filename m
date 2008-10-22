From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH] stable - ext[234]: Avoid printk floods in the
	face of directory corruption (CVE-2008-3528)
Date: Wed, 22 Oct 2008 09:14:33 -0700
Message-ID: <20081022161433.GB29489@kroah.com>
References: <48FF42B8.3030606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@kernel.org, ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:51640 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754471AbYJVQRx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Oct 2008 12:17:53 -0400
Content-Disposition: inline
In-Reply-To: <48FF42B8.3030606@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 22, 2008 at 10:11:52AM -0500, Eric Sandeen wrote:
> This is a trivial backport of the following upstream commits:
> 
> - bd39597cbd42a784105a04010100e27267481c67 (ext2)
> - cdbf6dba28e8e6268c8420857696309470009fd9 (ext3)
> - 9d9f177572d9e4eba0f2e18523b44f90dd51fe74 (ext4)
> 
> This addresses CVE-2008-3528
> 
> ext[234]: Avoid printk floods in the face of directory corruption

For what kernel releases is this applicable?  .27? .26? .25?  Earlier?

thanks,

greg k-h
