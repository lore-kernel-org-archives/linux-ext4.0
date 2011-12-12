From: Seiji Aguchi <seiji.aguchi@hds.com>
Subject: RE: [PATCH]tracepoint: add drop_transaction/update_superblock_end
 to jbd2
Date: Mon, 12 Dec 2011 17:32:57 -0500
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C57EE47D9@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C57C90585@USINDEVS01.corp.hds.com>
 <alpine.LFD.2.00.1111301227200.4662@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"fweisbec@gmail.com" <fweisbec@gmail.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"jiayingz@google.com" <jiayingz@google.com>,
	"dle-develop@lists.sourceforge.net"
	<dle-develop@lists.sourceforge.net>,
	Satoru Moriya <satoru.moriya@hds.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from usindpps03.hds.com ([207.126.252.16]:56094 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab1LLWd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Dec 2011 17:33:28 -0500
In-Reply-To: <alpine.LFD.2.00.1111301227200.4662@dhcp-27-109.brq.redhat.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>> This patch adds trace_jbd2_drop_transaction and trace_jbd2_update_superblock_end
>> because there are similar tracepoints in jbd and they are needed in jbd2 as well.
>>
>> Seiji
>
>Looks good, thanks.
>
>Reviewed-by: Lukas Czerner <lczerner@redhat.com>
>
>>
>>
>>  Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

Are there anyone else who can review my patch?

Seiji
