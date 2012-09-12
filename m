From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Ongoing data reorganization/defragmentation?
Date: Wed, 12 Sep 2012 14:15:17 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.1209121411410.2222@new-host-2>
References: <5050BA08.80709@bytefortress.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: norritt@t-online.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761061Ab2ILSPV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Sep 2012 14:15:21 -0400
In-Reply-To: <5050BA08.80709@bytefortress.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 12 Sep 2012, norritt@t-online.de wrote:

> Date: Wed, 12 Sep 2012 18:36:24 +0200
> From: norritt@t-online.de
> To: linux-ext4@vger.kernel.org
> Subject: Ongoing data reorganization/defragmentation?
> 
> Ongoing data reorganization/defragmentation?
> 
> In my efforts to optimize an ext4 for usage on SSDs, I have found information
> on the web about ext4 I've not been able to verify.
> 
> From what I've found out it's a good idea to:
> - mount with noatime, discard (if drive supports trim)

The -o discard option might be tricky since some devices still
handles it quite badly and you can experience big performance drops
(http://people.redhat.com/lczerner/discard/ although it is somewhat
outdated already). But you might to try to see yourself if it does
not hurt your performance.

The other option would be to use batched discard with fstrim (see
fstrim from util-linux) and run it once per (day, week, month).

Thanks!
-Lukas

