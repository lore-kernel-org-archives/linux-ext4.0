From: "Abhishek Rai" <abhishekrai@google.com>
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.24-rc6 -mm patch]
Date: Thu, 24 Jan 2008 08:14:21 -0500
Message-ID: <d9885f0f0801240514u76d8922bn1a2cdd5a75ad6639@mail.gmail.com>
References: <200801230412.16992.abhishekrai@google.com>
	 <20080123234905.35664ed6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	rohitseth@google.com
To: "Andrew Morton" <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:25495 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbYAXNO3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2008 08:14:29 -0500
Received: from zps78.corp.google.com (zps78.corp.google.com [172.25.146.78])
	by smtp-out.google.com with ESMTP id m0ODELCj000880
	for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2008 13:14:22 GMT
Received: from rv-out-0910.google.com (rvbk15.prod.google.com [10.140.87.15])
	by zps78.corp.google.com with ESMTP id m0ODEI4O016775
	for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2008 05:14:21 -0800
Received: by rv-out-0910.google.com with SMTP id k15so214488rvb.2
        for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2008 05:14:21 -0800 (PST)
In-Reply-To: <20080123234905.35664ed6.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

No, it didn't. I measured read from a 10GB sequentially laid out file
with standard benchmarking practices (cold cache, multiple runs, low
std. deviation in results, etc.) and here are the results:

File created by vanilla Ext3 being read by vanilla Ext3:
Total: 3m16.1s
User: 0.0.5s
Sys: 13.9

File created by mc Ext3 being read by mc Ext3 (with the buffer
boundary logic disabled):
Total: 3m15.5s
User: 0.05s
Sys: 13.6s

Thanks,
Abhishek

On Jan 24, 2008 2:49 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 23 Jan 2008 04:12:16 -0500 Abhishek Rai <abhishekrai@google.com> wrote:
> > > I'm wondering about the interaction between this code and the
> > > buffer_boundary() logic.  I guess we should disable the buffer_boundary()
> > > handling when this code is in effect.  Have you reviewed and tested that
> > > aspect?
> >
> > Thanks for pointing this out, I had totally missed this issue in my change. I've now made the call to set_buffer_boundary() in ext3_get_blocks_handle() subject to metacluster option being set.
> >
>
> Did it make any performance difference?  iirc the buffer_boundary stuff was
> worth around 10% on a single linear read of a large, well-laid-out file.
>
