From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: printk stack trace on ext4_error, ext4_abort and
	ext4_warning.
Date: Thu, 15 May 2008 09:55:29 +0530
Message-ID: <20080515042529.GB15128@skywalker>
References: <1210790832-20680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <482B3862.6040809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:55597 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbYEOE0H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 May 2008 00:26:07 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m4F4PM9o015473
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 14:25:22 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4F4Pp8S3764398
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 14:25:51 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4F4Q24D005136
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 14:26:02 +1000
Content-Disposition: inline
In-Reply-To: <482B3862.6040809@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 14, 2008 at 02:07:14PM -0500, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > This helps in better debugging of the problem reported.
> 
> ext4_error happens potentially often in some scenarios, and if I chose
> errors=continue I'm not sure I'd want to dump this much.
> 
> Would it be worth limiting how often this goes off (maybe just once per fs?)
> 

I actually thought of doing that. But won't rate limiting hide different
scenarios in which we can hit the error ? What we would like to know is
what system call actually caused the file system error. So that we can
try to reproduce the same. Rate limiting would prevent multiple possible
errors.

As Ted mentioned the right fix would be audit all the
ext4_error/warning/abort call sites and add a WARN_ON or WARN_ON_ONCE
where ever we find it useful.

-aneesh

