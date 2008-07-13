From: Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: 5% diskspace used for ext4?
Date: Sun, 13 Jul 2008 19:45:41 -0400
Message-ID: <20080713234541.GA4633@phobos.i.cabal.ca>
References: <alpine.DEB.1.10.0807140054000.4469@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:37830 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbYGMXyp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jul 2008 19:54:45 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0807140054000.4469@sheep.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 14, 2008 at 01:04:20AM +0200, Christian Kujau wrote:
> Hi,
>
> I suspect this being a FAQ already, but I could not find[0] it:
> does ext4 really use 5% of available space for internal housekeeping?  
> After formatting and mounting a ~917GB partition I see:
>

5% of your space is being reserved for root. You can disable this with
the "-m" argument to mkfs.

regards, Kyle
