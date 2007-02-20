From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC: 2.6.16 patch] ext3: fix ext3 block bitmap leakage
Date: Tue, 20 Feb 2007 11:08:37 -0600
Message-ID: <45DB2B15.70603@redhat.com>
References: <45DA2CB2.4080507@redhat.com> <20070220151950.GV13958@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Chuck Ebbert <cebbert@redhat.com>,
	Kirill Korotaev <dev@openvz.org>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030301AbXBTRNT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Feb 2007 12:13:19 -0500
In-Reply-To: <20070220151950.GV13958@stusta.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Adrian Bunk wrote:
> On Mon, Feb 19, 2007 at 06:03:14PM -0500, Chuck Ebbert wrote:
> 
>> This was dropped from 2.6.16-stable somehow:
>>
>> http://lkml.org/lkml/2006/6/30/54
> 
> Thanks for forwarding it.
> 
> This patch didn't went in this form into Linus' tree, I'd therefore like 
> to get an ACK from the ext3 maintainers (Cc'ed) before applying it.

Yep, ACK from me for 2.6.16-stable.

-Eric
