From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: grub / ext4 compatibility problem?
Date: Wed, 17 Jun 2009 09:46:57 -0500
Message-ID: <4A3901E1.5080104@redhat.com>
References: <200906171648.59573.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35390 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbZFQOq7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jun 2009 10:46:59 -0400
In-Reply-To: <200906171648.59573.bzolnier@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> I've run into a really peculiar problem today..

...

> This is on Fedora 11 system (I upgraded from Fedora 10 few days ago) with
> all updates and ext3 migrated (per HOWTO on ext4 wiki) to ext4 yesterday.
> 
> Is this something worth people's attention or should I just try to run fsck
> manually?


is /boot ext4?  F11's grub doesn't yet understand ext4, as mentioned in
the releasenotes.  I hope to remedy that soon but in the F11 devel
cycle, other bugs of the oopsing & corrupting kind were more pressing...

-Eric
