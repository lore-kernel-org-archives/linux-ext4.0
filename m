From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: [PATCH] ext4: add support for multiple mount protection
Date: Tue, 12 Apr 2011 21:20:03 +0200
Message-ID: <4DA4A5E3.4080803@itwm.fraunhofer.de>
References: <1302631493-9778-1-git-send-email-johann@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>
To: Johann Lombardi <johann@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:50704 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab1DLT0O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Apr 2011 15:26:14 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id p3CJK6kR023710
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 12 Apr 2011 21:20:06 +0200
In-Reply-To: <1302631493-9778-1-git-send-email-johann@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Johann,

> +/*
> + * Default interval in seconds to update the MMP sequence number.
> + */
> +#define EXT4_MMP_UPDATE_INTERVAL   1

this define is nowhere used (e2fsprogs already sets the update-interval 
in the superblock). And it is also too small, which may cause a huge 
performance issue (please remember my corresponding lustre bugzilla...).

Once you are going to post the e2fsprogs patch, could you please also 
take care of the 2TiB mmp-block read limitation bug (please see another 
Lustre bugzilla )?

It also would be nice to explain somewhere (and not hidden in the code) 
what is the difference between "update interval" and "check interval". 
For example something like this:

The 'mmp update interval' is the frequency how often the mmp is is 
supposed to be written. Values smaller than 5s may reduce performance.
The 'mmp check interval' is used to verify if the mmp block has been 
updated on the device. The value is updated based on the maximum time to 
write the mmp-block during an update-cycle. Its minimum is
5 * mmp-update-interval



Thanks,
Bernd



