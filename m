From: Mingming <cmm@us.ibm.com>
Subject: Re: ext4 preallocation corruption with truncate
Date: Wed, 10 Jun 2009 17:39:44 -0700
Message-ID: <1244680784.5256.28.camel@mingming-laptop>
References: <1244676537.5256.27.camel@mingming-laptop>
	 <20090611001729.GA7170@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	sandeen@redhat.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:35296 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZFKAjr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jun 2009 20:39:47 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e39.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n5B0ZkNl011034
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2009 18:35:46 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5B0dl52199280
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2009 18:39:47 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5B0dkUB030960
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2009 18:39:47 -0600
In-Reply-To: <20090611001729.GA7170@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-06-10 at 20:17 -0400, Theodore Tso wrote:
> On Wed, Jun 10, 2009 at 04:28:57PM -0700, Mingming wrote:
> > We have seen data lost issue after a file being preallocated, write,
> > then truncated. 
> > 
> > Ted could we send this fix to stable asap? Thanks.
> 
> Aneesh had already sent this patch to linux-ext4, and I've already
> sent a pull request of all of the accumulated ext4 fixes to Linus.
> Once Linus pulls it into mainline, I'll assemble the set of fixes that
> that need to go to stable, and send it off to stable@kernel.org.
> 
> 						- Ted

Thanks, I overlooked Aneesh's post.

Mingming

