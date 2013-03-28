From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: [PATCH, RFC] ext4: add ioctl to force 32-bit hashes from indexed
 dirs
Date: Thu, 28 Mar 2013 18:37:49 +0100
Message-ID: <51547FED.6010508@itwm.fraunhofer.de>
References: <51546C4E.9010903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Anand Avati <avati@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:56276 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab3C1Rhy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Mar 2013 13:37:54 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id r2SHbp2m008928
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 28 Mar 2013 18:37:52 +0100
In-Reply-To: <51546C4E.9010903@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Eric,

thanks, I'm going to review it thouroughly tomorrow again. Just noticed 
a small typo in a comment.

On 03/28/2013 05:14 PM, Eric Sandeen wrote:
> +		/* Have we already started readir on this dx dir? */
                                            ^^^^^^


Cheers,
Bernd
