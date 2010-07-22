From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [BUG] ext4 trace events cause NULL pointer dereferences
Date: Thu, 22 Jul 2010 13:45:08 +0800
Message-ID: <4C47DAE4.1030707@cn.fujitsu.com>
References: <4C401CE3.7010004@cn.fujitsu.com>	 <20100721222508.8704.A69D9226@jp.fujitsu.com> <1279721766.4818.39.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55593 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab0GVFk0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Jul 2010 01:40:26 -0400
In-Reply-To: <1279721766.4818.39.camel@gandalf.stny.rr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Steven Rostedt wrote:
> On Wed, 2010-07-21 at 22:31 +0900, KOSAKI Motohiro wrote:
>> Hi Steven,
> 
>>         if (ac)
>> 	        trace_ext4_mb_release_group_pa(ac, pa);
>>
>> But, I don't think this is proper fix because we don't want any overhead
>> if the tracepoint is disabled.
>>
>> So, How do we check NULL in TP_fast_assign()?
> 
> You could do:
> 
> 	TP_fast_assign(
> 		if (ac) {
> 	                __entry->dev            = ac->ac_sb->s_dev;
>         	        __entry->ino            = ac->ac_inode->i_ino;
>         	        __entry->pa_pstart      = pa->pa_pstart;
>         	        __entry->pa_len         = pa->pa_len;
> 		}

This leaves __entry->dev etc as arbitrary value, since the entry returned
by the ring buffer is not zeroed, so I think better add an else branch to
zero those values.

>         ),
> 
> But this just makes the __entry null and wastes the ring buffer.
> 
> I may be able to add a __discard_entry that may help. Then we could do
> something like this:
> 
> 	if (ac) {
>                 __entry->dev            = ac->ac_sb->s_dev;
>                 __entry->ino            = ac->ac_inode->i_ino;
>                 __entry->pa_pstart      = pa->pa_pstart;
>                 __entry->pa_len         = pa->pa_len;
> 	} else
> 		__discard_entry;
> 
> Does this seem reasonable?
> 
> But for now, the wasting the entry seems to be the only choice we have,
> or to do as you suggested and have the "if (ac) trace_...", but I don't
> like that.
> 

As I was (and still am) not sure what is the best fix, I decided
to send out a bug report instead of a patch..
