From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: ext4 and creation time
Date: Fri, 25 May 2007 16:11:17 +0530
Message-ID: <1180089677.27539.4.camel@garfield>
References: <Pine.LNX.4.64.0705102134030.3570@lancer.cnet.absolutedigital.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	extfs Mailing List <linux-ext4@vger.kernel.org>
To: Cal Peake <cp@absolutedigital.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:41341 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbXEYKhe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 May 2007 06:37:34 -0400
In-Reply-To: <Pine.LNX.4.64.0705102134030.3570@lancer.cnet.absolutedigital.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-05-25 at 06:13 -0400, Cal Peake wrote:
> Hi Ted,
> 
> I found this had already been brought up in the past but couldn't find if 
> a definitive decision was made.
> 
> Will ext4 include a creation time field?

Yes, the creation time field will be in ext4. It has already been
included in Ted's e2fsprogs tree and will be included in the kernel when
the nanosecond patch is sent upstream.

Thanks,
Kalpak.
> 
> thanks,
