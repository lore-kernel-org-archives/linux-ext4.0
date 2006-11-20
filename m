From: Hugh Dickins <hugh@veritas.com>
Subject: Re: Boot failure with ext2 and initrds
Date: Mon, 20 Nov 2006 20:54:14 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0611202031370.5912@blonde.wat.veritas.com>
References: <20061114014125.dd315fff.akpm@osdl.org> <20061114184919.GA16020@skynet.ie>
 <Pine.LNX.4.64.0611141858210.11956@blonde.wat.veritas.com>
 <20061114113120.d4c22b02.akpm@osdl.org> <Pine.LNX.4.64.0611142111380.19259@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0611151404260.11929@blonde.wat.veritas.com>
 <20061115214534.72e6f2e8.akpm@osdl.org> <455C0B6F.7000201@us.ibm.com>
 <20061115232228.afaf42f2.akpm@osdl.org> <1163666960.4310.40.camel@localhost.localdomain>
 <20061116011351.1401a00f.akpm@osdl.org> <1163708116.3737.12.camel@dyn9047017103.beaverton.ibm.com>
 <20061116132724.1882b122.akpm@osdl.org> <Pine.LNX.4.64.0611201544510.16530@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: cmm@us.ibm.com, Mel Gorman <mel@skynet.ie>,
	"Martin J. Bligh" <mbligh@mbligh.org>,
	linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:23503 "EHLO
	extu-mxob-1.symantec.com") by vger.kernel.org with ESMTP
	id S966707AbWKTUyD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Nov 2006 15:54:03 -0500
Received: from balaton.wat.veritas.com([10.10.97.7]) (2364 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1GmG9R-0000MTC@megami.veritas.com>
	for <linux-ext4@vger.kernel.org>; Mon, 20 Nov 2006 12:54:01 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
To: Andrew Morton <akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0611201544510.16530@blonde.wat.veritas.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 20 Nov 2006, Hugh Dickins wrote:
> 
> I'll do a little staring at the code myself: I'm unlikely to notice
> anything you've missed, but there's just a chance staring at it will
> direct me to some detail I've jotted down from before.

Not found anything relevant, but I keep noticing these lines
in ext2_try_to_allocate_with_rsv(), ext3 and ext4 similar:

		} else if (grp_goal > 0 &&
				(my_rsv->rsv_end - grp_goal + 1) < *count)
			try_to_extend_reservation(my_rsv, sb,
					*count-my_rsv->rsv_end + grp_goal - 1);

They're wrong, a no-op in most groups, aren't they?  rsv_end is an
absolute block number, whereas grp_goal is group-relative, so the
calculation ought to bring in group_first_block?  Or I'm confused.

(Whereas in my hang the grp_goal to ext2_try_to_allocate was -1
when I looked, with group 0 and num 1.)

Hugh
