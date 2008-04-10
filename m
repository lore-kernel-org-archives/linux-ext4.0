From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ext4 patch queue needs a patch removed
Date: Wed, 09 Apr 2008 20:45:45 -0700
Message-ID: <1207799145.3616.1.camel@localhost.localdomain>
References: <20080404180638.GF22429@unused.rdu.redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35650 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbYDJDps (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Apr 2008 23:45:48 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3A3jiPH023416
	for <linux-ext4@vger.kernel.org>; Wed, 9 Apr 2008 23:45:44 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3A3jit1272472
	for <linux-ext4@vger.kernel.org>; Wed, 9 Apr 2008 23:45:44 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3A3jh6S025579
	for <linux-ext4@vger.kernel.org>; Wed, 9 Apr 2008 23:45:43 -0400
In-Reply-To: <20080404180638.GF22429@unused.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-04-04 at 14:06 -0400, Josef Bacik wrote:
> Hello,
> 
> It looks like
> 
> jbd2-sparse-warnings-in-revokec-journalc.patch
> 
> has already been pulled into mainline, when I went to do a quilt push -a from
> -rc8 the above patch failed to apply since it was already there.  Thanks much,
> 

Sorry for the late response, I just back from vacation. 

The patch queue has already updated to linux-2.6.25-rc8. Thanks for the
note.

Mingming

