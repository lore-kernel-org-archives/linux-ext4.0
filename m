From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Please help: Is ext4 counting trims as writes, or is something
 killing my SSD?
Date: Thu, 12 Sep 2013 10:33:18 -0500
Message-ID: <5231DEBE.1010400@redhat.com>
References: <20130912141856.GA17640@jak-x230>  <1378997643.28638.53.camel@hp-a6734f> <5231DB33.9090104@redhat.com> <1378999765.28638.59.camel@hp-a6734f>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Julian Andres Klode <jak@jak-linux.org>, linux-ext4@vger.kernel.org
To: Calvin Walton <calvin.walton@kepstin.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab3ILPdY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Sep 2013 11:33:24 -0400
In-Reply-To: <1378999765.28638.59.camel@hp-a6734f>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/12/13 10:29 AM, Calvin Walton wrote:

...

> Having this all integrated into the filesystem itself is quite a nice
> change for the better - the old way was definitely a hack! I suppose
> this was added sometime in the 2011 timeframe?

commit 367a51a339020ba4d9edb0ce0f21d65bd50b00c9
Author: Lukas Czerner <lczerner@redhat.com>
Date:   Wed Oct 27 21:30:11 2010 -0400

    fs: Add FITRIM ioctl
    
    Adds an filesystem independent ioctl to allow implementation of file
    system batched discard support.

the userspace tool came around that time as well.

-Eric

