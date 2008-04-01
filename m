From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [PATCH] fix file system corruption [ was Re: mballoc errors ]
Date: Tue, 01 Apr 2008 11:46:01 +0200
Message-ID: <47F20459.1010801@bull.net>
References: <47EAC302.5040109@redhat.com> <47ECFAC7.3050404@bull.net> <20080331065802.GA19456@skywalker> <47F0FBFE.7060404@bull.net> <20080331201819.GA30646@skywalker> <20080331205030.GB30646@skywalker> <47F1F49A.7020102@bull.net> <20080401090149.GB9121@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45714 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbYDAJpg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Apr 2008 05:45:36 -0400
In-Reply-To: <20080401090149.GB9121@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> Regarding the test case that you have i am not yet sure what is causing
> the file system corruption. It cannot be ext4_ext_zeroout or 
> ext4_ext_convert_to_initialized because they are used only when we are
> writing to falloc area and you are not preallocating anything in your
> test. Did you make sure you are not using delalloc ? All my tests are
> run with stable branch.

Oh I'm sorry, I was not enough precise in my previous mails.
When I disable the delalloc feature, I don't reproduce the problem.
So, there is another problem. I will look into the delalloc code.
   Valerie
