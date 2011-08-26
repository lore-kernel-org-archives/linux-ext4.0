From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: question about punch hole
Date: Fri, 26 Aug 2011 15:35:31 -0700
Message-ID: <4E581FB3.3020504@linux.vnet.ibm.com>
References: <CAGBYx2abeJQBuZDV11WtrprmareZWSNkv-HGdLMvYoMB36mqZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:39797 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab1HZWfe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Aug 2011 18:35:34 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7QMFUbl017630
	for <linux-ext4@vger.kernel.org>; Fri, 26 Aug 2011 16:15:30 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7QMZW3j166354
	for <linux-ext4@vger.kernel.org>; Fri, 26 Aug 2011 16:35:32 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7QMfHN9021965
	for <linux-ext4@vger.kernel.org>; Fri, 26 Aug 2011 16:41:18 -0600
In-Reply-To: <CAGBYx2abeJQBuZDV11WtrprmareZWSNkv-HGdLMvYoMB36mqZA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/25/2011 07:53 PM, Yongqiang Yang wrote:
> Hi Allison,
>
> Currently, punch hole flushes all pages to disk and releases pages in
> page cache, and then calls ext4_ext_map_blocks.
>
> Assume that if a new page in the punching's range is mapped after
> releasing pages and before down_write i_data_sem,
> then ext4_ext_map_blocks will release map info of the page in extent
> tree.  However, up layers does not know this, and they think the page
> is mapped.
>
> I can not find how punch hole handle the situation above.  Could you
> shed a light on it?
>
>
Hi Yongqiang

This is a really good question and at the moment Im still looking into 
it.  :)  The calling sequence in punch hole was modeled after truncate, 
which also only locks i_data_sem when modifying the extent tree. 
ext4_ext_map_blocks when called with the punch hole flag, only releases 
blocks in the extent tree, using the same routines truncate does, but it 
does not modify the state of the pages. Though that still does not 
prevent the race condition you describe, so I am still investigating it.
I've found that I can catch a lot of race conditions by simply running 
the stress test over night, and so far I havnt had anything like this 
come up, but that certainly doesnt mean its not there.  I will let you 
know what I find.  Thx!

Allison Henderson
