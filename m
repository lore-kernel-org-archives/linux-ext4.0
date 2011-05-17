From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: xfstests: device busy when umount
Date: Tue, 17 May 2011 09:32:05 -0500
Message-ID: <4DD286E5.8090105@redhat.com>
References: <BANLkTimQW+kyqjmzpAHH_W5x2v1EWW2AZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, xfs-oss <xfs@oss.sgi.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139Ab1EQOcJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2011 10:32:09 -0400
In-Reply-To: <BANLkTimQW+kyqjmzpAHH_W5x2v1EWW2AZA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/17/11 4:03 AM, Yongqiang Yang wrote:
> Hi,
> 
> I noticed that all tests which contain 'device busy' errors have
> falloc operations.  Does the error have something to do with falloc?
> 

cc'ing xfs list since xfs devs maintain xfstests.

What tests have "device busy" errors?  What do the usual investigative
steps such as "lsof" and "fuser" tell you when this happens?

Are there loop devices that didn't get cleaned up, or processes that
have not terminated?

What tests have these problems?

-Eric
