From: Steve Brown <sbrown25@gmail.com>
Subject: Re: ext4 benchmark questions
Date: Fri, 23 Apr 2010 10:49:04 -0500
Message-ID: <i2g1f4ef0971004230849jb7635a1fg3c3060262d957fb0@mail.gmail.com>
References: <x2m1f4ef0971004221438n76bbc32bu6835dfe17dd702d8@mail.gmail.com>
	 <4BD0C50A.5050508@redhat.com>
	 <m2h1f4ef0971004221511wa0ea3d3fteb90ad1c38c9511d@mail.gmail.com>
	 <4BD0CBBF.1060300@redhat.com> <4BD1B1CA.5050502@redhat.com>
	 <k2n1f4ef0971004230838w8bfe6b2w41d9a68bf6bda9ee@mail.gmail.com>
	 <4BD1C0A4.6070102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50004 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757754Ab0DWPtI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Apr 2010 11:49:08 -0400
Received: by gyg13 with SMTP id 13so5204714gyg.19
        for <linux-ext4@vger.kernel.org>; Fri, 23 Apr 2010 08:49:04 -0700 (PDT)
In-Reply-To: <4BD1C0A4.6070102@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Also note that having battery backed RAID cards does not mean that your
> drive's write cache will survive a power outage. You need to use vendor
> specific tools usually to poke at the drives and make sure that the write
> cache on the S-ATA disks is properly disabled (unless the LSI firmware does
> something to manage the write cache on the drives).

The server is fully battery backed for up to 45 minutes.  Also, LSI
does provide tools to disable the cache when the BBU fails.  Its one
of the array config parameters.
