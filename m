From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Mounting Ext3 with Ext4
Date: Wed, 20 May 2009 23:53:18 -0500
Message-ID: <4A14DE3E.3000900@redhat.com>
References: <baab8ccb0905201624j56767f59mff537ab8767ffc8d@mail.gmail.com>	 <4A14ABAC.7040901@redhat.com>	 <baab8ccb0905201828i7ad6536ele72157b3e2d223c1@mail.gmail.com> <baab8ccb0905202137v426c8568k8fc6f53fc095c351@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Matt LaPlante <cybrmatt@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48225 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbZEUExU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 May 2009 00:53:20 -0400
In-Reply-To: <baab8ccb0905202137v426c8568k8fc6f53fc095c351@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Matt LaPlante wrote:

> It looks likes the magic touch was to add rootfstype=ext4 to the
> kernel command line.  Prior to this the ext4 only kernel wasn't
> finding the disk, but with it attached it now appears to boot
> successfully.  Maybe worth adding a note to the wiki?


Ah, that makes sense.  Sure, please do add it.  :)

-Eric
