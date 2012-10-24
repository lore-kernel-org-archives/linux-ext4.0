From: "George Spelvin" <linux@horizon.com>
Subject: Re: metadata_csum set but no space in dir leaf for checksum
Date: 24 Oct 2012 00:12:18 -0400
Message-ID: <20121024041218.24709.qmail@science.horizon.com>
References: <20121024014309.GA25755@blackbox.djwong.org>
Cc: adilger.kernel@dilger.ca, linux@horizon.com,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:30975 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750731Ab2JXEMU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2012 00:12:20 -0400
In-Reply-To: <20121024014309.GA25755@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Any more errors/corruption to report?

Thanks for the nudge.  Indeed, no more complaints since the 17th when
I installed your patch.

So it seems that you've figured out the problem, modiulo only figuring
why the fallback code path is being taken in the first place.

Thank you very much!

(BTW, your e-mail and Reply-To: set to you only; was that intentional?
I've ignored it and sent to the whole mailing list, since it seems
relevant.)
