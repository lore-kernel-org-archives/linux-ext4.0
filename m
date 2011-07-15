From: Felipe Wilhelms Damasio - Taghos <felipewd@taghos.com.br>
Subject: Re: Ext4 flush blocked
Date: Thu, 14 Jul 2011 22:27:50 -0300
Message-ID: <4E1F9796.5020107@taghos.com.br>
References: <4E1F95B8.4050005@taghos.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gateway07.websitewelcome.com ([69.56.236.22]:59922 "HELO
	gateway07.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932677Ab1GOBiR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jul 2011 21:38:17 -0400
Received: from gator1481.hostgator.com (gator1481.hostgator.com [184.173.199.228])
	by ham.websitewelcome.com (Postfix) with ESMTP id 87D8C7D804500
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jul 2011 20:28:00 -0500 (CDT)
In-Reply-To: <4E1F95B8.4050005@taghos.com.br>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

    Hi Again,

Em 14/07/2011 22:19, Felipe Wilhelms Damasio - Taghos escreveu:
>      After a while using (about an hour) I get a lot of:
>
> INFO: task flush-8:16:6650 blocked for more than 120 seconds.

    I also saw this:

INFO: task jbd2/sdb1-8:1672 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
jbd2/sdb1-8   D 0000000000000004     0  1672      2 0x00000000
 ffff88042e171aa0 0000000000000046 0000000000012500 ffff88042e171fd8
 ffff88042e171fd8 ffff88042c2eadf0 0000000000012500 0000000000012500
 0000000000012500 ffff88042c2eadf0 ffff88042e0d0690 ffff88042c2eb098
Call Trace:
 [<ffffffff8151c837>] io_schedule+0x7b/0xc2
 [<ffffffff8108fceb>] sync_page+0x41/0x45
 [<ffffffff8151cc1a>] __wait_on_bit+0x47/0x79
 [<ffffffff8108fcaa>] ? sync_page+0x0/0x45
 [<ffffffff8108fea1>] wait_on_page_bit+0x6e/0x75
 [<ffffffff8104ed1c>] ? wake_bit_function+0x0/0x2a
 [<ffffffff81097a36>] ? pagevec_lookup_tag+0x22/0x2b
 [<ffffffff810965cb>] write_cache_pages+0x1d5/0x2e9
 [<ffffffff81095ee0>] ? __writepage+0x0/0x2f
 [<ffffffff810966fe>] generic_writepages+0x1f/0x25
 [<ffffffff8114251d>] jbd2_journal_commit_transaction+0x35b/0x10b2
 [<ffffffff81035288>] ? get_parent_ip+0x11/0x41
 [<ffffffff811468bf>] kjournald2+0xd2/0x22b
 [<ffffffff8104ece4>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8151dbdf>] ? _raw_spin_unlock_irqrestore+0x2c/0x37
 [<ffffffff811467ed>] ? kjournald2+0x0/0x22b
 [<ffffffff8104e892>] kthread+0x7d/0x85
 [<ffffffff810037d4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8104e815>] ? kthread+0x0/0x85
 [<ffffffff810037d0>] ? kernel_thread_helper+0x0/0x10


    Don't know if this helps, though.

    Is there something I can try to fix this?

    Cheers,

-- 
Felipe Wilhelms Damasio
TAGHOS - Tecnologia
Rua Prof. Alvaro Alvim, 211
Porto Alegre - RS - (51) 3239-3180
www.taghos.com.br <http://www.taghos.com.br/>



