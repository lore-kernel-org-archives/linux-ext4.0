From: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: ext4_lazyinit_thread: 'ret' may be used uninitialized in this
 function
Date: Tue, 2 Nov 2010 15:31:50 -0400
Message-ID: <20101102193150.GA14504@elliptictech.com>
References: <tkrat.ba371a0ea018042b@s5r6.in-berlin.de>
 <alpine.LFD.2.00.1011011551001.2876@dhcp-lab-213.englab.brq.redhat.com>
 <20101102182911.GE25614@thunk.org>
 <AANLkTim9JbCk29oPjrYMSfhtHL4tL4uHtDq_xZoe7tzg@mail.gmail.com>
 <alpine.LFD.2.00.1011021516470.16869@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kevin granade <kevin.granade@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:37122 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752732Ab0KBTcK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Nov 2010 15:32:10 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011021516470.16869@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-11-02 15:19 -0400, Lukas Czerner wrote:
> Hmm this relies on the fact that if the first part of the condition
> would not be true, the second part (after and) would never be invoked,
> however I am not really sure that we can rely on that on every
> architecture, or can we ?

This behaviour of the && operator is guaranteed by the C standard.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
