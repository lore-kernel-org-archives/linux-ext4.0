From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 4/4] mm: vmscan: If kswapd has been running too long,
 allow it to sleep
Date: Thu, 19 May 2011 08:54:33 +0900
Message-ID: <4DD45C39.5030803@jp.fujitsu.com>
References: <1305295404-12129-5-git-send-email-mgorman@suse.de>	<4DCFAA80.7040109@jp.fujitsu.com>	<1305519711.4806.7.camel@mulgrave.site>	<BANLkTi=oe4Ties6awwhHFPf42EXCn2U4MQ@mail.gmail.com>	<20110516084558.GE5279@suse.de>	<BANLkTinW4s6aT2bZ79sHNgdh5j8VYyJz2w@mail.gmail.com>	<20110516102753.GF5279@suse.de>	<BANLkTi=5ON_ttuwFFhFObfoP8EBKPdFgAA@mail.gmail.com>	<4DD31B6E.8040502@jp.fujitsu.com>	<BANLkTikLuWPEt7MitUYdJtzqyBSOkz2zxg@mail.gmail.com>	<20110518095859.GR5279@suse.de> <BANLkTin6HJSrxcJYB3Y6XYgs8xuDWaQ15Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: mgorman@suse.de, James.Bottomley@hansenpartnership.com,
 akpm@linux-foundation.org, colin.king@canonical.com,
 raghu.prabhu13@gmail.com, jack@suse.cz, chris.mason@oracle.com,
 cl@linux.com, penberg@kernel.org, riel@redhat.com, hannes@cmpxchg.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: minchan.kim@gmail.com
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <BANLkTin6HJSrxcJYB3Y6XYgs8xuDWaQ15Q@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

>> I've already submitted a pair of patches for option 1. I don't think
>> option 2 gains us anything. I think it's more likely we should worry
>> about all_unreclaimable being set when shrink_slab is returning 0 and we
>> are encountering so many dirty pages that pages_scanned is high enough.
>
> Okay.
>
> Colin reported he had no problem with patch 1 in this series and
> mine(ie, just cond_resched right after balance_pgdat call without no
> patch of shrink_slab).
>
> If Colin's test is successful, I don't insist on mine.
> (I don't want to drag on for days :( )
> If KOSAKI agree, let's ask the test to Colin and confirm our last test.
>
> KOSAKI. Could you post a your opinion?

Yeah.
I also don't have any motivation to ignore Colin's test result.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
