From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: breaking ext4 to test recovery
Date: Sat, 2 Apr 2011 08:50:38 -1000
Message-ID: <A5567907-0FC9-4552-9282-F7B4B7E1113D@whamcloud.com>
References: <25B374CC0D9DFB4698BB331F82CD0CF20D61B8@wdscexbe08.sc.wdc.com> <4D91E39A.3000800@redhat.com> <6617927D-7C9C-4D02-97FD-C9CC75609448@dilger.ca> <4D9503C0.8080804@redhat.com> <06ABAED6-3569-4A30-816B-6A7A53A652D1@dilger.ca> <4D9718BB.2070005@gmail.com>
Mime-Version: 1.0 (iPhone Mail 8F190)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	Daniel Taylor <Daniel.Taylor@wdc.com>,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>,
	Johann Lombardi <johann@whamcloud.com>
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51980 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066Ab1DCAqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Apr 2011 20:46:55 -0400
Received: by pwi15 with SMTP id 15so974323pwi.19
        for <linux-ext4@vger.kernel.org>; Sat, 02 Apr 2011 17:46:54 -0700 (PDT)
In-Reply-To: <4D9718BB.2070005@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-02, at 2:38 AM, Ric Wheeler <ricwheeler@gmail.com> wrote:
> The device mapper developers are looking at having a device mapper target that can be used as a hot block cache - say given a S-ATA disk and a PCI-e SSD, you would store the hot blocks on the PCI-e card.

There was a patch posted around December called bcache which did this same thing. I don't recall if it was a DM  target or not. 

> What might be a great simulation would be to have a way to destroy that cache, assuming we could get a cache policy that simulates some reasonable, disk like caching policy :)

The one difficulty with DM targets is that they cannot be used with non DM devices. That was one of the advantages of EVMS (if anyone remembers that) - it could work with any existing block device. 

Cheers, Andreas
