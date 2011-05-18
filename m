From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 4/4] mm: vmscan: If kswapd has been running too long,
 allow it to sleep
Date: Wed, 18 May 2011 10:05:50 +0900
Message-ID: <4DD31B6E.8040502@jp.fujitsu.com>
References: <1305295404-12129-1-git-send-email-mgorman@suse.de>	<1305295404-12129-5-git-send-email-mgorman@suse.de>	<4DCFAA80.7040109@jp.fujitsu.com>	<1305519711.4806.7.camel@mulgrave.site>	<BANLkTi=oe4Ties6awwhHFPf42EXCn2U4MQ@mail.gmail.com>	<20110516084558.GE5279@suse.de>	<BANLkTinW4s6aT2bZ79sHNgdh5j8VYyJz2w@mail.gmail.com>	<20110516102753.GF5279@suse.de> <BANLkTi=5ON_ttuwFFhFObfoP8EBKPdFgAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: mgorman@suse.de, James.Bottomley@hansenpartnership.com,
	akpm@linux-foundation.org, colin.king@canonical.com,
	raghu.prabhu13@gmail.com, jack@suse.cz, chris.mason@oracle.com,
	cl@linux.com, penberg@kernel.org, riel@redhat.com,
	hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: minchan.kim@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=5ON_ttuwFFhFObfoP8EBKPdFgAA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> It would be better to put cond_resched after balance_pgdat?
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 292582c..61c45d0 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2753,6 +2753,7 @@ static int kswapd(void *p)
>                  if (!ret) {
>                          trace_mm_vmscan_kswapd_wake(pgdat->node_id, order);
>                          order = balance_pgdat(pgdat, order,&classzone_idx);
> +                       cond_resched();
>                  }
>          }
>          return 0;
>
>>>> While it appears unlikely, there are bad conditions which can result
>> in cond_resched() being avoided.

Every reclaim priority decreasing or every shrink_zone() calling makes more
fine grained preemption. I think.
