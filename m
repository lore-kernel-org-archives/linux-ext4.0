From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent cache
Date: Mon, 26 Mar 2012 16:00:47 -0700
Message-ID: <4F70F51F.8030405@linux.intel.com>
References: <20120323221715.GA6712@tassilo.jf.intel.com>	<A3DE1F37-C0AB-4ACE-8D13-22DC8A21ED3C@dilger.ca>	<20120324031357.GA5690@tassilo.jf.intel.com> <CAMQXfUcH-0Krg811msFVbC25qY1mPTdrMi8Rg-qJST=6B-s_5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, tim.c.chen@linux.intel.com
To: Vivek Haldar <haldar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29931 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab2CZXAv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Mar 2012 19:00:51 -0400
In-Reply-To: <CAMQXfUcH-0Krg811msFVbC25qY1mPTdrMi8Rg-qJST=6B-s_5w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/26/2012 3:26 PM, Vivek Haldar wrote:
> Andi --
>
> I realized the problem soon after the original patch, and submitted
> another patch to make these per cpu  counters.

Is there a clear use case having these counters on every production system?

Especially given that they are racy and prone to lost updates today.

And you can still get the information if you really need it by putting a 
systemtap etc. probe.

-Andi

