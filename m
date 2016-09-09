From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Fwd: [STABLE CHERRYPICK] ext4: avoid modifying checksum fields
 directly during checksum verification
Date: Fri, 9 Sep 2016 16:11:23 +0200
Message-ID: <20160909141123.GA13328@kroah.com>
References: <20160906022955.qopdwuznvtqlwofq@thunk.org>
 <40811621-e317-fecc-8052-56b88fd5ce35@etorok.net>
 <20160908085615.GA21050@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: stable@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwin@etorok.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36112 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbcIIOLS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Sep 2016 10:11:18 -0400
Content-Disposition: inline
In-Reply-To: <20160908085615.GA21050@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 08, 2016 at 10:56:15AM +0200, Greg KH wrote:
> On Thu, Sep 08, 2016 at 10:21:34AM +0300, Török Edwin wrote:
> > Hi,
> > 
> > Not sure if this was sent to the right place: stable@kernel.org
> > doesn't seem to exist, I can't find this message in the ML archives,
> > or the 4.7.3 changelog.  Could you please include this in 4.7.4, I've
> > been waiting for this patch to get included ever since 4.7.1...
> 
> Yeah, I never saw it.
> 
> Will add it to the queue, it's long, might take a release or two to make
> it...
> 
> Were there any objections from the ext4 maintainers in taking the patch
> below?

Now applied, thanks.

greg k-h
