From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] JBD2: fix debug config option
Date: Wed, 13 Jun 2007 16:22:45 -0700
Message-ID: <1181776965.13428.7.camel@dyn9047017103.beaverton.ibm.com>
References: <20070607234524.345d404d@gara>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:52666 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280AbXFMXWs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jun 2007 19:22:48 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5DNMl7p000480
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jun 2007 19:22:47 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5DNMlBl250908
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jun 2007 17:22:47 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5DNMkcn024221
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jun 2007 17:22:47 -0600
In-Reply-To: <20070607234524.345d404d@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-06-07 at 23:45 -0500, Jose R. Santos wrote: 
> When the JBD code was forked to create the new JBD2 code base, the
> references to CONFIG_JBD_DEBUG where never changed to
> CONFIG_JBD2_DEBUG.  This patch fixes that.
> 

We need to fix ext4 to reference CONFIG_JBD2_DEBUG as well. The ext4
patch queue fail to compile with this if CONFIG_JBD_DEBUG is on but
CONFIG_JBD2_DEBUG is off. Can you send a quick fix?

Thanks,
Mingming
