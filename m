From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
Subject: Re: another ext3 kernel BUG
Date: Thu, 16 Jun 2011 10:02:57 +0300
Message-ID: <4DF9AAA1.5030002@gmail.com>
References: <20110614024307.GA3039@gamma.logic.tuwien.ac.at> <20110614032111.GA5392@redhat.com> <4DF6D644.3010109@redhat.com> <20110611021732.GA18768@gamma.logic.tuwien.ac.at> <20110614011904.GA32521@gamma.logic.tuwien.ac.at> <4DF6C541.5050805@redhat.com> <201106140 <20110616055125.GB23083@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@redhat.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Norbert Preining <preining@logic.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37485 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab1FPHDD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jun 2011 03:03:03 -0400
In-Reply-To: <20110616055125.GB23083@gamma.logic.tuwien.ac.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/16/2011 08:51 AM, Norbert Preining wrote:
> On Mi, 15 Jun 2011, Norbert Preining wrote:
>> CONFIG_LIST_DEBUG is compiled in.
>> vbox modules are *not* loaded
> 
> new instance, this time again in fs/inode.c, but coming from fsnotify,
> and one from ntfs3g.
> 
> When I go to 3.0-rc1 all is fine.
> 
> I will try to get a git bisect running, but that is a pain because
> it is not easy to trigger.
> 
> Any suggestion what could be the culprit? 3cebde241 ?

e6bc45d65df8599fdbae73be9cec4ceed274db53

See here for a patch:
https://lkml.org/lkml/2011/6/15/341

Does that help?

Best regards,
--Edwin
