From: Nick Bowler <nbowler@draconx.ca>
Subject: Re: ext3: massive latencies for some write operations
Date: Sat, 27 Jun 2009 17:07:57 -0400
Message-ID: <97c719fa0906271407u3b53b252qf371561d37f62e6b@mail.gmail.com>
References: <97c719fa0906251918i5b047943yde752774c686f301@mail.gmail.com>
	 <20090626045403.GS3385@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, calvin.walton@gmail.com
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f193.google.com ([209.85.221.193]:55270 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbZF0VHy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Jun 2009 17:07:54 -0400
Received: by qyk31 with SMTP id 31so3824485qyk.33
        for <linux-ext4@vger.kernel.org>; Sat, 27 Jun 2009 14:07:57 -0700 (PDT)
In-Reply-To: <20090626045403.GS3385@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/26/09, Andreas Dilger <adilger@sun.com> wrote:
> This is a relatively well-known problem with ext3.

<snip>

> If you use ext4 this problem should go away.  I would recommend the
> FC11 2.6.29 kernel, since it has all of the latest ext4 fixes in it.

Okay, I have switched to ext4 (although with 2.6.30).  Hopefully I
won't have any major issues, thanks!
