From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Call trace in ext4_es_lru_add on 3.10 stable
Date: Thu, 18 Sep 2014 15:21:31 -0400
Message-ID: <20140918192131.GD19520@thunk.org>
References: <541AD93A.70203@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"p.herz@profihost.ag >> Philipp Herz - Profihost AG"
	<p.herz@profihost.ag>, stable@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36199 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756533AbaIRTVg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Sep 2014 15:21:36 -0400
Content-Disposition: inline
In-Reply-To: <541AD93A.70203@profihost.ag>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 18, 2014 at 03:08:10PM +0200, Stefan Priebe - Profihost AG wrote:
> Hi List,
> 
> I'm seeing this error pretty often at a vanilla 3.10.53 kernel.
> 
> Can anybody point me to a patch or tell me if this is a known bug?

This is just call trace; can you send the complete set of kernel
messages?  Please send  everything starting a few lines before the

---------------- [ cut here ] ----------

line, and then going all the way to the 

----------- [ end trace XXXXXXXXXX ] --------

line.

Cheers,

				- Ted
