From: Badari Pulavarty <pbadari@gmail.com>
Subject: Re: which kernel version should I submit patch ?
Date: Wed, 02 May 2007 16:16:52 -0700
Message-ID: <1178147812.24273.26.camel@dyn9047017100.beaverton.ibm.com>
References: <1178129628.30661.1.camel@colyT43.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: coly <colyli@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:43653 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767201AbXEBXQU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 May 2007 19:16:20 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l42NGKBj022805
	for <linux-ext4@vger.kernel.org>; Wed, 2 May 2007 19:16:20 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l42NGJFP184802
	for <linux-ext4@vger.kernel.org>; Wed, 2 May 2007 17:16:19 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l42NGJPc021403
	for <linux-ext4@vger.kernel.org>; Wed, 2 May 2007 17:16:19 -0600
In-Reply-To: <1178129628.30661.1.camel@colyT43.site>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-05-03 at 02:13 +0800, coly wrote:
> Hi, list.
> 
> I find these days 2.6.21 released. If I will submit patches for ext4dev,
> should I generate the patch against 2.6.21 ?


If you find a bug in ext4 on 2.6.21 - yes, generate against 2.6.21.

Make sure its not already fixed in -mm or Ted's ext4 tree.

http://www2.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/

Thanks,
Badari
