From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC][Patch 1/1] Persistent preallocation in ext4
Date: Wed, 13 Dec 2006 07:54:31 -0800
Message-ID: <45802237.2060304@us.ibm.com>
References: <20061205134338.GA1894@amitarora.in.ibm.com>	<20061206055822.GA6182@amitarora.in.ibm.com>	<1165886895.3939.18.camel@dyn9047017103.beaverton.ibm.com>	<20061212062302.GA8280@amitarora.in.ibm.com>	<1165969238.3771.34.camel@dyn9047017103.beaverton.ibm.com>	<20061213100158.GA6517@amitarora.in.ibm.com> <1166016989.5059.13.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, suzuki@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:60625 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965006AbWLMPyl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Dec 2006 10:54:41 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e36.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kBDFseaS022988
	for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2006 10:54:40 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kBDFsYr7154238
	for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2006 08:54:40 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kBDFsXPB030381
	for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2006 08:54:34 -0700
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
In-Reply-To: <1166016989.5059.13.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Dave Kleikamp wrote:
> 
> If anything, the block-based preallocation could initialize all of the
> data to zero.  It would be slow, but it would still provide the correct
> function and result in contiguous allocation.
> 
Agree. That seems goood enough.


Mingming
