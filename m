From: Tao Ma <tm@tao.ma>
Subject: Re: Ext4 flush blocked
Date: Fri, 15 Jul 2011 11:31:30 +0800
Message-ID: <4E1FB492.4070300@tao.ma>
References: <4E1F95B8.4050005@taghos.com.br> <4E1F9796.5020107@taghos.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org
To: Felipe Wilhelms Damasio - Taghos <felipewd@taghos.com.br>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:57253 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932617Ab1GODiP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jul 2011 23:38:15 -0400
In-Reply-To: <4E1F9796.5020107@taghos.com.br>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Felipe,
On 07/15/2011 09:27 AM, Felipe Wilhelms Damasio - Taghos wrote:
>     Hi Again,
> 
> Em 14/07/2011 22:19, Felipe Wilhelms Damasio - Taghos escreveu:
>>      After a while using (about an hour) I get a lot of:
>>
>> INFO: task flush-8:16:6650 blocked for more than 120 seconds.
> 
>     I also saw this:
> 
> INFO: task jbd2/sdb1-8:1672 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> jbd2/sdb1-8   D 0000000000000004     0  1672      2 0x00000000
>  ffff88042e171aa0 0000000000000046 0000000000012500 ffff88042e171fd8
>  ffff88042e171fd8 ffff88042c2eadf0 0000000000012500 0000000000012500
>  0000000000012500 ffff88042c2eadf0 ffff88042e0d0690 ffff88042c2eb098
> Call Trace:
>  [<ffffffff8151c837>] io_schedule+0x7b/0xc2
>  [<ffffffff8108fceb>] sync_page+0x41/0x45
>  [<ffffffff8151cc1a>] __wait_on_bit+0x47/0x79
>  [<ffffffff8108fcaa>] ? sync_page+0x0/0x45
>  [<ffffffff8108fea1>] wait_on_page_bit+0x6e/0x75
>  [<ffffffff8104ed1c>] ? wake_bit_function+0x0/0x2a
>  [<ffffffff81097a36>] ? pagevec_lookup_tag+0x22/0x2b
>  [<ffffffff810965cb>] write_cache_pages+0x1d5/0x2e9
>  [<ffffffff81095ee0>] ? __writepage+0x0/0x2f
>  [<ffffffff810966fe>] generic_writepages+0x1f/0x25
>  [<ffffffff8114251d>] jbd2_journal_commit_transaction+0x35b/0x10b2
>  [<ffffffff81035288>] ? get_parent_ip+0x11/0x41
>  [<ffffffff811468bf>] kjournald2+0xd2/0x22b
>  [<ffffffff8104ece4>] ? autoremove_wake_function+0x0/0x38
>  [<ffffffff8151dbdf>] ? _raw_spin_unlock_irqrestore+0x2c/0x37
>  [<ffffffff811467ed>] ? kjournald2+0x0/0x22b
>  [<ffffffff8104e892>] kthread+0x7d/0x85
>  [<ffffffff810037d4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff8104e815>] ? kthread+0x0/0x85
>  [<ffffffff810037d0>] ? kernel_thread_helper+0x0/0x10
> 
> 
>     Don't know if this helps, though.
> 
>     Is there something I can try to fix this?
could you please try to change io scheduler to 'deadline'?
We have met with some similar warnings and changing to 'deadline' makes
ext4 happy.

Thanks
Tao
