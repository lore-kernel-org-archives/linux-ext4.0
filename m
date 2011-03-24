From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH] ext3: skip orphan cleanup on rocompat fs
Date: Thu, 24 Mar 2011 09:07:05 -0700
Message-ID: <20110324160705.GA18723@kroah.com>
References: <AANLkTimLAL7hPL+Yb392hyVAWEfHtObv7WwjzKt2awur@mail.gmail.com>
 <20110228180950.GD20805@quack.suse.cz>
 <AANLkTi=xJNKei5Q_kvEMQ6usLhE6jgy6pmbGBq93gALU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@kernel.org, Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:40992 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab1CXQHw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Mar 2011 12:07:52 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTi=xJNKei5Q_kvEMQ6usLhE6jgy6pmbGBq93gALU@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 24, 2011 at 12:34:05PM +0200, Amir Goldstein wrote:
> Hi,
> 
> Please apply commit ce654b37 to any stable kernel out there.

Now applied, thanks.

greg k-h
