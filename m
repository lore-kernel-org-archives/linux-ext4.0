From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: bio splits unnecessarily due to BH_Boundary in ext3 direct I/O
Date: Wed, 10 Apr 2013 11:59:17 +0900
Message-ID: <5164D585.6080404@sx.jp.nec.com>
References: <51385177.9030904@sx.jp.nec.com> <20130307104854.GB6723@quack.suse.cz> <51482381.7010508@sx.jp.nec.com> <20130319193132.GE5222@quack.suse.cz> <514AC848.6020104@sx.jp.nec.com> <20130329171536.GF5913@quack.suse.cz> <51594494.3070207@sx.jp.nec.com> <20130409154059.GA15214@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:35832 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab3DJDHo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Apr 2013 23:07:44 -0400
In-Reply-To: <20130409154059.GA15214@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2013/04/10 0:40, Jan Kara wrote:
>   Ah, thanks for pointing that out. It took me a while to get things
> correct but with the attached patch (on top of the first patch), I'm
> getting all the bios with maximum size. I've also checked that for direct
> IO on ramdisk, I get about 3x faster IO on ext3 with both patches applied.
> I also get a decent 10% speedup of dio reads on standard harddrive.

I made sure that the problem I reported was completely fixed.
Thank you for your help.

Regards,
Kazuya Mio

