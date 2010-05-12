From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: INFO: task umount:1524 blocked for more than 120 seconds
Date: Wed, 12 May 2010 17:16:01 +0200
Message-ID: <4BEAC631.4070405@s5r6.in-berlin.de>
References: <h2xdd18b0c31005101446pf8201153vaed5b38afe72d7ad@mail.gmail.com> <20100512150404.GB29867@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Justin Mattock <justinmattock@gmail.com>,
	linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:52164 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab0ELPQH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 May 2010 11:16:07 -0400
In-Reply-To: <20100512150404.GB29867@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
>   I guess your are hitting a variant of
> https://bugzilla.kernel.org/show_bug.cgi?id=15906
>   Does the fix there make things better for you?

The question to me is whether or not Justin sees an (additional)
hardware/firmware bug for which we need to add a quirks list entry.
-- 
Stefan Richter
-=====-==-=- -=-= -==--
http://arcgraph.de/sr/
