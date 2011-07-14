From: Alex Elder <aelder@sgi.com>
Subject: Re: [PATCH 1/2 v7] XFS TESTS: ENOSPC Punch Hole: Move su routines
 in 123 to common.rc
Date: Thu, 14 Jul 2011 13:21:55 -0500
Message-ID: <1310667715.2067.42.camel@doink>
References: <1309272301-5742-1-git-send-email-achender@linux.vnet.ibm.com>
	 <1309272301-5742-2-git-send-email-achender@linux.vnet.ibm.com>
Reply-To: <aelder@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <xfs@oss.sgi.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:48773 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755400Ab1GNSWC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jul 2011 14:22:02 -0400
In-Reply-To: <1309272301-5742-2-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2011-06-28 at 07:45 -0700, Allison Henderson wrote:
> This patch moves the su routines in test 123 to common.rc
> so that they can also be used in the new test 255
> 
> Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>

This looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


