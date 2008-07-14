From: "Christian Kujau" <lists@nerdbynature.de>
Subject: Re: 5% diskspace used for ext4?
Date: Mon, 14 Jul 2008 11:49:42 +0200 (CEST)
Message-ID: <620f96feb01d15a6a836a1a11715ee8e.squirrel@housecafe.dyndns.org>
References: <alpine.DEB.1.10.0807140054000.4469@sheep.housecafe.de>
    <20080713234541.GA4633@phobos.i.cabal.ca>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org
To: "Kyle McMartin" <kyle@mcmartin.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:56176 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311AbYGNJtu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jul 2008 05:49:50 -0400
In-Reply-To: <20080713234541.GA4633@phobos.i.cabal.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, July 14, 2008 01:45, Kyle McMartin wrote:
> 5% of your space is being reserved for root. You can disable this with
> the "-m" argument to mkfs.

Ah, the reserve for root, of course. It did cross my mind that this was
where the 5% came from and if I had read the mkfs printout more carefully
I'd have seen it (thanks, Eric!). I shall use -m to specify a different
value then.

With filesystems getting bigger and bigger, values like "5% of the
available diskspace" are actually becoming more and more visible. Although
they shouldn't, as diskspace gets cheaper and cheaper :-)

Thanks!
Christian.
-- 
BOFH excuse #442:

Trojan horse ran out of hay

