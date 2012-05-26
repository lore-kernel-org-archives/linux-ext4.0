From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: nouser_xattr
Date: Sat, 26 May 2012 10:52:54 -0600
Message-ID: <B31D6A1E-507D-454B-88CF-E488153588BD@dilger.ca>
References: <1338030586.2093.4.camel@dauntless.royles.co>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Brett M. Royles" <brett@royles.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail121c7-2520.megamailservers.com ([69.49.98.23]:35521 "EHLO
	mail121c7.megamailservers.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753984Ab2EZQwu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 May 2012 12:52:50 -0400
In-Reply-To: <1338030586.2093.4.camel@dauntless.royles.co>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-05-26, at 5:09, "Brett M. Royles" <brett@royles.co.uk> wrote:
> 
> I have just spotted in my log files that nouser_xattr will be removed.
> 
> I think it should be kept in as I currently use that option to ensure
> that my / partition (which is on a ssd) is mounted without user_xattr to
> stop some writes to it.  If I don't specify nouser_xattr the / partition
> automatically gets mounted with user_xattr. 
> 
> Will there be any other way to ensure that a partition is mounted
> without user_xattr?

This is a permanent mount option stored in the superblock. It should be possible to change this at format time or via tune2fs for existing filesystems.

Please check the man pages, I don't have them handy at the moment. 

Cheers, Andreas