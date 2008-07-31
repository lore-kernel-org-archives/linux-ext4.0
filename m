From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: i_size error with the latest patchqueue
Date: Thu, 31 Jul 2008 11:51:33 -0500
Message-ID: <4891ED95.7050604@redhat.com>
References: <20080731161058.GA20838@skywalker> <20080731164728.GF11632@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbYGaQyl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jul 2008 12:54:41 -0400
In-Reply-To: <20080731164728.GF11632@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> Do you have a quickie program that calls fallocate to preallocate
> space for a particular program easily to hand?  If not, I can write
> one in about 5-10 minutes, but if you have one written already, it'll
> save me the effort.  Thanks!!

Ted, I hacked up:
http://sandeen.fedorapeople.org/utilities/fallocate.c
a while ago, I think it still works, at least on x86/x86_64

-Eric
