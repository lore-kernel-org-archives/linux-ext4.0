From: Benno Schulenberg <bensberg@justemail.net>
Subject: Re: [PATCH] Update ext3/4 mount options
Date: Thu, 09 Jan 2014 21:30:55 +0100
Message-ID: <1389299455.29292.68757293.7B539718@webmail.messagingengine.com>
References: <1389288890-17282-1-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Util-Linux" <util-linux@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42993 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbaAIUa4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Jan 2014 15:30:56 -0500
In-Reply-To: <1389288890-17282-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Thu, Jan 9, 2014, at 18:34, Carlos Maiolino wrote:
> -have changed, this option allows the user to specify
> +have changed, these options allows the user to specify

s/allows/allow/

> +identified through euther its new major/minor numbers encoded
> +in devnum, or via a path to the device.

s/through euther/either through/
(swapped, otherwise the "via" needs to be dropped)

> +Abort the journal if an error occurs in a file data buffer in ordered mode.

"Abort loading the journal..." maybe?

> +The lazy itable init code will wait n times the number of milliseconds it took
> +to zero out the previous block group's inode table. This minimizes the impact on
> +the system performance while filesystem's inode table is being initialized.

s/the system/system/
s/while/while the/

> +useful in memory constrained environments, where a very large directory can

better: memory-constrained

> +cause severe performance problems or even provoke the Out Of Memory killer. (For
> +example, if there is only 512mb memory available, a 176mb directory may
> +seriously cramp the system's style).

s/)./.)/

Benno

-- 
http://www.fastmail.fm - Choose from over 50 domains or use your own

