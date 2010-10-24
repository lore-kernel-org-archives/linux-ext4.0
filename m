From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: ext4_clear_journal_err: Filesystem error recorded from previous
 mount: IO failure
Date: Sun, 24 Oct 2010 11:49:36 -0400
Message-ID: <4CC45590.80608@redhat.com>
References: <201010221533.29194.bs_lists@aakef.fastmail.fm> <20101022172536.GP3127@thunk.org> <AANLkTi=jYWSKwz1=pHQyaVq22bjgO-EF5xC53x9mGdvN@mail.gmail.com> <20101023221714.GB24650@thunk.org> <4CC43AC9.8000409@redhat.com> <4CC44304.1050409@ddn.com> <4CC44EAF.3090507@redhat.com> <4CC45318.3080002@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
	Amir Goldstein <amir73il@gmail.com>,
	Bernd Schubert <bs_lists@aakef.fastmail.fm>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>
To: Bernd Schubert <bschubert@ddn.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932885Ab0JXPs0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Oct 2010 11:48:26 -0400
In-Reply-To: <4CC45318.3080002@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  On 10/24/2010 11:39 AM, Bernd Schubert wrote:
> On 10/24/2010 05:20 PM, Ric Wheeler wrote:
>> This still sounds more like a Lustre issue than an ext4 one, Andreas can fill in
>> the technical details.
> The underlying device handling is unrelated to Lustre. In that sense it
> is just a local filesystem.
>
>> What ever shared storage sits under ext4 is irrelevant to the fail over case.
>>
>> Unless Lustre does other magic, they still need to obey the basic cluster rules
>> - one mount per cluster.
> Yes, one mount per cluster.
>
>> If Lustre is doing the same trick you would do with active/passive failure over
>> clusters that export ext4 via NFS, you would still need to clean up the file
>> system before being able to re-export it from a fail over node.
> What exactly is your question here? We use pacemaker/stonith to do the
> fencing job.
> What exactly do you want to clean up? The device is recovered by
> journals, Lustre goes into recovery mode, clients reconnect, locks are
> updated and incomplete transactions resend.
>
>
> Cheers,
> Bernd
>

What I don't get (certainly might just be me) is why this is a unique issue when 
used by lustre. Normally, any similar type of fail over will clean up the local 
file system normally before trying to re-export from the second node.

Why exactly can't you use the same type of recovery here? Is it the fencing 
agent killing nodes on detection of the file system errors?

Ric

